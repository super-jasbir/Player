/// Central registry for image assets.
///
/// RULE (imported from minimart): every NEW image must be referenced through a
/// constant here instead of a raw string literal at the call site. This keeps
/// asset paths in one place and makes renames/refactors safe.
///
/// Legacy images scattered across the codebase as raw strings are intentionally
/// left as-is; only add NEW images here.
class AppImages {
  const AppImages._();

  static const String _base = 'assets/images';

  // ---- Walkthrough / splash (new UI) ----
  static const String splashBackground = '$_base/splash_background.jpg';
  static const String spendrathonCard = '$_base/ic_spendrathon_card.png';
  static const String paperclip = '$_base/ic_paperclip.png';
  static const String sparkle = '$_base/ic_sparkle.png';
  static const String icCamera = '$_base/ic_camera.png';

  // ---- Onboarding (new-user / nationality) ----
  // Layered: office background + the receptionist standing in front.
  static const String regionBackground = '$_base/region_bg.png';
  static const String regionReceptionist = '$_base/region_receptionist.png';
}
