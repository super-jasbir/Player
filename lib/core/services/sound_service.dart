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
      await _clickPlayer.play(AssetSource('click.mp3'), volume: _soundVolume);
    } catch (_) {
      // Audio is never worth breaking a tap over.
    }
  }
}
