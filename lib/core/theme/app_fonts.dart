/// Font families used across the app.
///
/// [family] (Inter) is imported from minimart and is the default family for all
/// NEW screens. Legacy screens continue to use Montserrat/Satoshi.
class AppFonts {
  const AppFonts._();

  /// Default family for new screens.
  static const String family = 'Inter';

  /// Legacy family — kept for existing screens only. Do not use on new screens.
  static const String legacyMontserrat = 'Montserrat';
}
