import 'dart:async';

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

  /// Player for the splash sound (a long clip we cap and fade out).
  final AudioPlayer _splashPlayer = AudioPlayer();
  Timer? _splashCapTimer;
  Timer? _splashFadeTimer;

  double _soundVolume = 1.0;
  double _musicVolume = 1.0;

  /// Volume of button clicks / effects, 0.0 - 1.0.
  double get soundVolume => _soundVolume;

  /// Volume for background music. Stored and honoured by [setMusicVolume], but
  /// the app ships no music track yet, so nothing consumes it today.
  double get musicVolume => _musicVolume;

  /// Loads the saved volumes. Call once before `runApp`.
  Future<void> load() async {
    _soundVolume = await SharedPref.getSoundVolume();
    _musicVolume = await SharedPref.getMusicVolume();
  }

  Future<void> setSoundVolume(double volume) async {
    _soundVolume = volume.clamp(0.0, 1.0);
    await SharedPref.saveSoundVolume(_soundVolume);
  }

  Future<void> setMusicVolume(double volume) async {
    _musicVolume = volume.clamp(0.0, 1.0);
    await SharedPref.saveMusicVolume(_musicVolume);
  }

  /// Plays the UI click at the configured volume. Silent at zero.
  Future<void> playClick() async {
    if (_soundVolume <= 0) return;
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
    if (_soundVolume <= 0) return;
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
    if (_soundVolume <= 0) return;
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
    if (_soundVolume <= 0) return;
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
    if (_soundVolume <= 0 || _timerPlaying) return;
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

  /// Plays the splash sound, capped to [maxDuration] (default 10s) since the
  /// source clip is long. It fades out over the final ~1.2s so it blends into
  /// the app's music instead of cutting off abruptly. Plays independently of
  /// the splash screen's lifecycle so it can continue across the transition to
  /// the next screen. Silent at zero volume.
  Future<void> playSplash({
    Duration maxDuration = const Duration(seconds: 10),
  }) async {
    if (_soundVolume <= 0) return;
    _splashCapTimer?.cancel();
    _splashFadeTimer?.cancel();
    try {
      await _splashPlayer.setReleaseMode(ReleaseMode.stop);
      await _splashPlayer.stop();
      await _splashPlayer.play(
        AssetSource('splash_sound.mpeg'),
        volume: _soundVolume,
      );
      // Begin a short fade ~1.2s before the cap, then hard-stop at the cap.
      const fade = Duration(milliseconds: 1200);
      final fadeStart =
          maxDuration > fade ? maxDuration - fade : Duration.zero;
      _splashCapTimer = Timer(fadeStart, () => _fadeOutSplash(fade));
    } catch (_) {
      // Audio is never worth breaking the splash over.
    }
  }

  void _fadeOutSplash(Duration fade) {
    const int steps = 12;
    final double base = _soundVolume;
    final int stepMs = (fade.inMilliseconds ~/ steps).clamp(1, 1000);
    int i = 0;
    _splashFadeTimer?.cancel();
    _splashFadeTimer = Timer.periodic(Duration(milliseconds: stepMs), (t) async {
      i++;
      if (i >= steps) {
        t.cancel();
        try {
          await _splashPlayer.stop();
        } catch (_) {}
      } else {
        try {
          await _splashPlayer.setVolume((base * (1 - i / steps)).clamp(0.0, 1.0));
        } catch (_) {}
      }
    });
  }

  /// Stops the splash sound immediately (e.g. if muted mid-play).
  Future<void> stopSplash() async {
    _splashCapTimer?.cancel();
    _splashFadeTimer?.cancel();
    try {
      await _splashPlayer.stop();
    } catch (_) {
      // ignore
    }
  }
}
