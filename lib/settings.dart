import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/3dView/home_screen_player.dart';
import 'package:player/3dView/home_top_bar.dart';
import 'package:player/common_widgets.dart';
import 'package:player/core/services/sound_service.dart';
import 'package:local_auth/local_auth.dart';
import 'package:player/generated/l10n/app_localizations.dart';
import 'package:player/permission/permission_screen.dart';
import 'package:player/referral.dart';

import 'data/local/shared_prefs.dart';
import 'merchant/merchant_controller.dart';

/// Accent blue used for labels / links, matching the other new-UI screens.
const Color _accentBlue = Color(0xFF0288D1);

/// Yellow highlight behind the "SETTING" title.
const Color _titleHighlight = Color(0xFFFFE000);

/// Red gradient of the LOG OUT button (Figma: 3 stops, top to bottom).
const List<Color> _logoutRed = [
  Color(0xFFFCB3B4),
  Color(0xFFF6292C),
  Color(0xFFD10205),
];

/// The two languages offered for now. `code` matches the .arb locales.
enum _Language {
  english("en", "🇬🇧"),
  chinese("zh", "🇨🇳");

  const _Language(this.code, this.flag);

  final String code;
  final String flag;
}

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final MerchantController controller = Get.put(MerchantController());

  double _soundVolume = SoundService.instance.soundVolume;
  double _musicVolume = SoundService.instance.musicVolume;
  _Language _language = _Language.english;
  bool _locationEnabled = false;
  bool _biometricLock = false;

  @override
  void initState() {
    super.initState();
    // getProfile() writes an observable synchronously, so it cannot run while
    // this frame is still building — defer it until the first frame is done.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      controller.getProfileInfo();
    });
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final referral = await SharedPref.getReferalCode();
    final code = await SharedPref.getLanguageCode();
    final location = await SharedPref.getLocationEnabled();
    final biometric = await SharedPref.getBiometricLock();
    if (!mounted) return;
    setState(() {
      controller.referralCode.value = referral ?? "";
      _language = _Language.values.firstWhere(
        (l) => l.code == code,
        orElse: () => _Language.english,
      );
      _locationEnabled = location;
      _biometricLock = biometric;
    });
  }

  Future<void> _onLanguageChanged(_Language? language) async {
    if (language == null) return;
    setState(() => _language = language);
    await SharedPref.saveLanguageCode(language.code);
    // Rebuilds the whole app against the new locale.
    Get.updateLocale(Locale(language.code));
  }

  /// Switching location on opens the permission onboarding screen and requests
  /// the OS location permission. The toggle only stays on if it's granted.
  Future<void> _onLocationChanged(bool value) async {
    if (!value) {
      setState(() => _locationEnabled = false);
      await SharedPref.saveLocationEnabled(false);
      return;
    }
    final granted = await Get.to(() => PermissionScreen.location()) ?? false;
    setState(() => _locationEnabled = granted);
    await SharedPref.saveLocationEnabled(granted);
  }

  /// Switching biometric on opens the Face ID / Touch ID onboarding screen
  /// (matching what the device actually supports) and runs an authentication.
  /// The toggle only stays on if authentication succeeds.
  Future<void> _onBiometricChanged(bool value) async {
    if (!value) {
      setState(() => _biometricLock = false);
      await SharedPref.saveBiometricLock(false);
      return;
    }

    // Pick the screen that matches the device's biometric hardware.
    bool isFace = false;
    try {
      final types = await LocalAuthentication().getAvailableBiometrics();
      isFace = types.contains(BiometricType.face);
    } catch (_) {}

    final granted = await Get.to(
          () => isFace
              ? PermissionScreen.faceId()
              : PermissionScreen.touchId(),
        ) ??
        false;
    setState(() => _biometricLock = granted);
    await SharedPref.saveBiometricLock(granted);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const HomeBlurredBackground(),
          SafeArea(
            child: Column(
              children: [
                const HomeTopBar(),
                Expanded(
                  child: SingleChildScrollView(
                    // Always scrollable: without this the view ignores drags
                    // entirely on any screen tall enough to fit the panel.
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 24.h),
                    child: _panel(l10n),
                  ),
                ),
                _homeButton(l10n),
                SizedBox(height: 12.h),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _panel(AppLocalizations l10n) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 22.h, 20.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.30),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _title(l10n.settingTitle),
          SizedBox(height: 16.h),
          _sectionLabel(l10n.soundMusic),
          SizedBox(height: 10.h),
          _volumeRow(
            icon: Icons.volume_up_rounded,
            value: _soundVolume,
            onChanged: (v) => setState(() => _soundVolume = v),
            // Persist and preview the click only once the drag settles.
            onChangeEnd: (v) async {
              await SoundService.instance.setSoundVolume(v);
              SoundService.instance.playClick();
            },
          ),
          SizedBox(height: 10.h),
          _volumeRow(
            icon: Icons.music_note_rounded,
            value: _musicVolume,
            onChanged: (v) => setState(() => _musicVolume = v),
            onChangeEnd: (v) => SoundService.instance.setMusicVolume(v),
          ),
          _divider(),
          _sectionLabel(l10n.language),
          SizedBox(height: 10.h),
          _languageRow(l10n),
          _divider(),
          _toggleRow(
            label: l10n.locationSetting,
            value: _locationEnabled,
            onChanged: _onLocationChanged,
          ),
          SizedBox(height: 8.h),
          _toggleRow(
            label: l10n.biometricLock,
            value: _biometricLock,
            onChanged: _onBiometricChanged,
          ),
          _divider(),
          AppButton(
            title: l10n.contact,
            height: 48,
            onPressed: () =>
                Fluttertoast.showToast(msg: "${l10n.contact} coming soon..."),
          ),
          // Logout and referral are account actions — hidden until signed in.
          Obx(() {
            if (controller.playername.value.isEmpty) return const SizedBox();
            return Column(
              children: [
                SizedBox(height: 12.h),
                AppButton(
                  title: l10n.referral,
                  height: 48,
                  onPressed: () {
                    if (controller.referralCode.value.isNotEmpty) {
                      Get.to(Referral());
                    }
                  },
                ),
                SizedBox(height: 12.h),
                // Narrower than the full-width buttons above it, per the design.
                AppButton(
                  title: l10n.logOut,
                  width: 200.w,
                  height: 52,
                  gradientColors: _logoutRed,
                  shadowColor: const Color(0x60D10205),
                  onPressed: controller.logoutApi,
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _title(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 2.h),
      color: _titleHighlight,
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: 24.sp,
          fontWeight: FontWeight.w900,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: TextStyle(
        fontFamily: 'Inter',
        fontSize: 14.sp,
        fontWeight: FontWeight.w600,
        color: _accentBlue,
      ),
    );
  }

  Widget _divider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.h),
      child: Container(height: 1, color: _accentBlue.withOpacity(0.35)),
    );
  }

  Widget _volumeRow({
    required IconData icon,
    required double value,
    required ValueChanged<double> onChanged,
    required ValueChanged<double> onChangeEnd,
  }) {
    return Row(
      children: [
        Icon(icon, color: _accentBlue, size: 30),
        SizedBox(width: 12.w),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 26.h,
              activeTrackColor: const Color(0xFF3B9EF5),
              inactiveTrackColor: Colors.white.withOpacity(0.75),
              thumbColor: const Color(0xFFCDE8FA),
              overlayColor: _accentBlue.withOpacity(0.12),
              trackShape: const RoundedRectSliderTrackShape(),
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 13.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 22.r),
            ),
            child: Slider(
              value: value,
              onChanged: onChanged,
              onChangeEnd: onChangeEnd,
            ),
          ),
        ),
      ],
    );
  }

  Widget _languageRow(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 44.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22.r),
              gradient: const LinearGradient(
                colors: [Color(0xFF7FCBF5), Color(0xFF1565E8)],
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<_Language>(
                value: _language,
                isExpanded: true,
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
                icon: const Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.white),
                // The closed pill shows white-on-gradient; the open menu is
                // white, so its rows need dark text.
                selectedItemBuilder: (_) => _Language.values
                    .map((l) => Align(
                          child: Text(
                            _languageName(l, l10n),
                            style: TextStyle(
                              fontFamily: 'Inter',
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ))
                    .toList(),
                items: _Language.values
                    .map((l) => DropdownMenuItem<_Language>(
                          value: l,
                          child: Row(
                            children: [
                              Text(l.flag, style: TextStyle(fontSize: 16.sp)),
                              SizedBox(width: 10.w),
                              Text(
                                _languageName(l, l10n),
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF374151),
                                ),
                              ),
                            ],
                          ),
                        ))
                    .toList(),
                onChanged: _onLanguageChanged,
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          width: 46.w,
          height: 46.w,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white.withOpacity(0.9),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(_language.flag, style: TextStyle(fontSize: 22.sp)),
        ),
      ],
    );
  }

  String _languageName(_Language language, AppLocalizations l10n) {
    switch (language) {
      case _Language.english:
        return l10n.languageEnglish;
      case _Language.chinese:
        return l10n.languageChinese;
    }
  }

  Widget _toggleRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: _accentBlue,
          ),
        ),
        const Spacer(),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 6.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            color: value ? const Color(0xFF3B9EF5) : Colors.white.withOpacity(0.6),
          ),
          child: Switch(
            value: value,
            onChanged: onChanged,
            activeColor: const Color(0xFFCDE8FA),
            activeTrackColor: Colors.transparent,
            inactiveThumbColor: const Color(0xFFCDE8FA),
            inactiveTrackColor: Colors.transparent,
            trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ],
    );
  }

  Widget _homeButton(AppLocalizations l10n) {
    return InkWell(
      onTap: () => Get.offAll(HomeScreenPlayer()),
      borderRadius: BorderRadius.circular(20.r),
      child: Container(
        width: 96.w,
        padding: EdgeInsets.symmetric(vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.35),
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Colors.white.withOpacity(0.6)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.home_rounded, color: _accentBlue, size: 26),
            Text(
              l10n.home,
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 11.sp,
                fontWeight: FontWeight.w700,
                color: _accentBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
