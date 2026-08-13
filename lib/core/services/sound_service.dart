import 'package:audioplayers/audioplayers.dart';

import '../../data/local/shared_prefs.dart';

/// Central owner of the app's sound settings.
///
/// The settings screen writes the volumes here; everything that makes a noise
/// (currently the button click in `AppComponents`) reads them back through
/// [playClick] instead of spinning up its own [AudioPlayer].
class SoundService {
  SoundService._();

  static final SoundService instance = SoundService._();

  /// One reusable player — a new one per tap was never disposed.
  final AudioPlayer _clickPlayer = AudioPlayer();

  /// Separate player for the back sound so it can overlap a lingering click.
  final AudioPlayer _backPlayer = AudioPlayer();

  /// Player for the game-completion celebration sound.
  final AudioPlayer _gameCompletePlayer = AudioPlayer();

  /// Player for the leaderboard screen sound.
  final AudioPlayer _leaderboardPlayer = AudioPlayer();

  /// Looping player for the game timer sound.
  final AudioPlayer _timerPlayer = AudioPlayer();
  bool _timerPlaying = false;

  /// Looping background-music player. The clip that used to only play on the
  /// splash screen now loops for the whole session on every screen.
  final AudioPlayer _musicPlayer = AudioPlayer();

  /// Someone has asked the background music to start (so it should resume when
  /// unmuted). Stays true for the rest of the session.
  bool _musicRequested = false;

  /// `play()` has been called on the music player at least once, so [resume]
  /// is valid rather than a fresh [play].
  bool _musicPlaying = false;

  /// Where to seek to the first time the background music starts.
  Duration _musicStartAt = Duration.zero;

  double _soundVolume = 1.0;
  double _musicVolume = 1.0;
  bool _muted = false;

  /// Volume of button clicks / effects, 0.0 - 1.0.
  double get soundVolume => _soundVolume;

  /// Volume for the looping background music, 0.0 - 1.0.
  double get musicVolume => _musicVolume;

  /// Whether all app audio is currently muted by the settings toggle.
  bool get isMuted => _muted;

  /// Loads the saved volumes and mute state. Call once before `runApp`.
  Future<void> load() async {
    _soundVolume = await SharedPref.getSoundVolume();
    _musicVolume = await SharedPref.getMusicVolume();
    _muted = await SharedPref.getAudioMuted();
  }

  Future<void> setSoundVolume(double volume) async {
    _soundVolume = volume.clamp(0.0, 1.0);
    await SharedPref.saveSoundVolume(_soundVolume);
  }

  /// Applies a new music volume live to the running loop without persisting it
  /// — use while the settings slider is being dragged for instant feedback.
  Future<void> previewMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    if (_muted) return;
    try {
      await _musicPlayer.setVolume(_musicVolume);
    } catch (_) {}
  }

  /// Persists the music volume (and applies it live). Call when the slider drag
  /// settles.
  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await SharedPref.saveMusicVolume(_musicVolume);
    if (_muted) return;
    try {
      await _musicPlayer.setVolume(_musicVolume);
    } catch (_) {}
  }

  /// Toggles the global mute. When muting, the background music pauses and all
  /// effects fall silent; when un-muting, the music resumes from where it was
  /// (if it had been started) and effects play again. Persisted so the choice
  /// survives app restarts.
  Future<void> setMuted(bool muted) async {
    _muted = muted;
    await SharedPref.saveAudioMuted(muted);
    if (muted) {
      try {
        await _musicPlayer.pause();
      } catch (_) {}
    } else if (_musicRequested) {
      await _ensureMusicPlaying();
    }
  }

  /// Plays the UI click at the configured volume. Silent at zero.
  Future<void> playClick() async {
    if (_muted || _soundVolume <= 0) return;
    try {
      await _clickPlayer.stop();
      await _clickPlayer.play(
        AssetSource('button_click_sound.mp4'),
        volume: _soundVolume,
      );
    } catch (_) {
      // Audio is never worth breaking a tap over.
    }
  }

  /// Plays the back-navigation sound at the configured volume. Silent at zero.
  Future<void> playBack() async {
    if (_muted || _soundVolume <= 0) return;
    try {
      await _backPlayer.stop();
      await _backPlayer.play(
        AssetSource('button_back_sound.mp4'),
        volume: _soundVolume,
      );
    } catch (_) {
      // Audio is never worth breaking a tap over.
    }
  }

  /// Plays the game-completion celebration sound. Silent at zero volume.
  Future<void> playGameComplete() async {
    if (_muted || _soundVolume <= 0) return;
    try {
      await _gameCompletePlayer.stop();
      await _gameCompletePlayer.play(
        AssetSource('sound_game_complete.mp4'),
        volume: _soundVolume,
      );
    } catch (_) {
      // Audio is never worth breaking the completion flow over.
    }
  }

  /// Plays the leaderboard-screen sound. Silent at zero volume.
  Future<void> playLeaderboard() async {
    if (_muted || _soundVolume <= 0) return;
    try {
      await _leaderboardPlayer.stop();
      await _leaderboardPlayer.play(
        AssetSource('sound_leaderboard.mp4'),
        volume: _soundVolume,
      );
    } catch (_) {
      // Audio is never worth breaking screen navigation over.
    }
  }

  /// Starts looping the timer sound while a game timer is running. Idempotent:
  /// calling it again while already playing is a no-op (no restart blip).
  /// Silent at zero volume. Pair with [stopTimer] when leaving the screen.
  Future<void> startTimerLoop() async {
    if (_muted || _soundVolume <= 0 || _timerPlaying) return;
    _timerPlaying = true;
    try {
      await _timerPlayer.setReleaseMode(ReleaseMode.loop);
      await _timerPlayer.stop();
      await _timerPlayer.play(
        AssetSource('sound_timer.mp4'),
        volume: _soundVolume,
      );
    } catch (_) {
      // Audio is never worth breaking the timer over.
    }
  }

  /// Stops the looping timer sound. Safe to call even if it was never started.
  Future<void> stopTimer() async {
    _timerPlaying = false;
    try {
      await _timerPlayer.stop();
    } catch (_) {
      // ignore
    }
  }

  /// Starts the looping background music (the old splash clip). Call once, as
  /// early as possible — it keeps playing across every screen for the rest of
  /// the session. Idempotent: extra calls just keep the same loop going.
  /// Honours the mute toggle: if muted, the request is remembered and the music
  /// starts as soon as the user un-mutes. [startAt] skips the clip's intro on
  /// the very first play.
  Future<void> startBackgroundMusic({Duration startAt = Duration.zero}) async {
    if (!_musicRequested) {
      _musicRequested = true;
      _musicStartAt = startAt;
    }
    if (_muted) return;
    await _ensureMusicPlaying();
  }

  /// Ensures the loop is actually playing at the current volume — starting it
  /// the first time, resuming it after a mute pause thereafter.
  Future<void> _ensureMusicPlaying() async {
    try {
      await _musicPlayer.setReleaseMode(ReleaseMode.loop);
      if (!_musicPlaying) {
        _musicPlaying = true;
        await _musicPlayer.play(
          AssetSource('splash_sound.mpeg'),
          volume: _musicVolume,
        );
        if (_musicStartAt > Duration.zero) {
          await _musicPlayer.seek(_musicStartAt);
        }
      } else {
        await _musicPlayer.resume();
        await _musicPlayer.setVolume(_musicVolume);
      }
    } catch (_) {
      // Audio is never worth breaking the app over.
    }
  }

  /// Stops the background music entirely (rarely needed — mute is preferred so
  /// it can resume from the same spot).
  Future<void> stopBackgroundMusic() async {
    _musicRequested = false;
    _musicPlaying = false;
    try {
      await _musicPlayer.stop();
    } catch (_) {
      // ignore
    }
  }
}
