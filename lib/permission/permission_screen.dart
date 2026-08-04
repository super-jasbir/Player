import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';

import '../common_widgets.dart';
import '../core/theme/app_fonts.dart';

/// Accent blue, matching the login / settings screens.
const Color _accentBlue = Color(0xFF0288D1);

/// Dark navy used for the big titles in the walkthrough design.
const Color _navy = Color(0xFF16263F);

const Color _subtitleGrey = Color(0xFF5B6470);

/// A single permission-request onboarding screen, styled like the login /
/// walkthrough design: a heavily-blurred receptionist background with a
/// frosted card holding a title, subtitle, icon, an "Enable" button and a
/// "SKIP" link.
///
/// Pops with `true` when the permission is granted, `false` when the user
/// skips / goes back / is denied — the caller (e.g. the settings switch) uses
/// this to decide whether to keep the toggle on.
class PermissionScreen extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;

  /// Requests the underlying OS permission. Returns whether it was granted.
  final Future<bool> Function() onEnable;

  const PermissionScreen({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onEnable,
  });

  // ---- Named variants for the four walkthrough screens ----

  factory PermissionScreen.faceId() => PermissionScreen(
        title: "Face ID",
        subtitle: "Login with Face ID",
        icon: const _FaceIdIcon(size: 96, color: _accentBlue),
        onEnable: _requestBiometric,
      );

  factory PermissionScreen.touchId() => PermissionScreen(
        title: "Touch ID",
        subtitle: "Login with Touch ID",
        icon: const Icon(Icons.fingerprint, size: 108, color: _accentBlue),
        onEnable: _requestBiometric,
      );

  factory PermissionScreen.location() => PermissionScreen(
        title: "Location",
        subtitle: "Enable to show your position and nearby games",
        icon: const Icon(Icons.location_on, size: 100, color: _accentBlue),
        onEnable: _requestLocation,
      );

  factory PermissionScreen.notification() => PermissionScreen(
        title: "Notification",
        subtitle: "Please enable to receive updates and reminders",
        icon: const Icon(Icons.notifications, size: 100, color: _accentBlue),
        onEnable: () async => true,
      );

  // ---- Permission requests ----

  static Future<bool> _requestBiometric() async {
    final auth = LocalAuthentication();
    try {
      return await auth.authenticate(
        localizedReason: "Authenticate to enable biometric login",
        options: const AuthenticationOptions(
          stickyAuth: true,
          useErrorDialogs: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }

  static Future<bool> _requestLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const AuthBlurredBackground(),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: BlurContainerWrapper(
                  showClip: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: BackToLoginButton(
                          text: "Back",
                          onTap: () => Get.back(result: false),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w800,
                          color: _navy,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        subtitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: AppFonts.family,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w500,
                          color: _subtitleGrey,
                        ),
                      ),
                      SizedBox(height: 34.h),
                      SizedBox(height: 120.h, child: Center(child: icon)),
                      SizedBox(height: 34.h),
                      AppButton(
                        title: "Enable",
                        height: 58,
                        onPressed: () async {
                          final granted = await onEnable();
                          Get.back(result: granted);
                        },
                      ),
                      SizedBox(height: 14.h),
                      Center(
                        child: InkWell(
                          onTap: () => Get.back(result: false),
                          child: Text(
                            "SKIP",
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: _subtitleGrey,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// The iOS Face-ID glyph: a rounded square with four corner brackets and a
/// simple face inside. Drawn so no asset is required.
class _FaceIdIcon extends StatelessWidget {
  final double size;
  final Color color;

  const _FaceIdIcon({required this.size, required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        children: [
          _corner(topLeft: true),
          _corner(topRight: true),
          _corner(bottomLeft: true),
          _corner(bottomRight: true),
          Center(
            child: Icon(Icons.sentiment_satisfied,
                color: color, size: size * 0.52),
          ),
        ],
      ),
    );
  }

  Widget _corner({
    bool topLeft = false,
    bool topRight = false,
    bool bottomLeft = false,
    bool bottomRight = false,
  }) {
    const double len = 22;
    const double thick = 5;
    final radius = Radius.circular(8);
    return Align(
      alignment: topLeft
          ? Alignment.topLeft
          : topRight
              ? Alignment.topRight
              : bottomLeft
                  ? Alignment.bottomLeft
                  : Alignment.bottomRight,
      child: SizedBox(
        width: len,
        height: len,
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border(
              top: (topLeft || topRight)
                  ? BorderSide(color: color, width: thick)
                  : BorderSide.none,
              bottom: (bottomLeft || bottomRight)
                  ? BorderSide(color: color, width: thick)
                  : BorderSide.none,
              left: (topLeft || bottomLeft)
                  ? BorderSide(color: color, width: thick)
                  : BorderSide.none,
              right: (topRight || bottomRight)
                  ? BorderSide(color: color, width: thick)
                  : BorderSide.none,
            ),
            borderRadius: BorderRadius.only(
              topLeft: topLeft ? radius : Radius.zero,
              topRight: topRight ? radius : Radius.zero,
              bottomLeft: bottomLeft ? radius : Radius.zero,
              bottomRight: bottomRight ? radius : Radius.zero,
            ),
          ),
        ),
      ),
    );
  }
}
