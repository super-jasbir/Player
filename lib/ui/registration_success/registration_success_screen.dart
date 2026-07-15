import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:player/common_widgets.dart';
import 'package:player/core/theme/app_fonts.dart';
import 'package:player/routes/app_routes.dart';
import 'package:player/utils/app_color.dart';

/// Accent purple shared with the signup / create-profile screens.
const Color _accentPurple = Color(0xFF9C27B0);

/// Shown after registration completes successfully. Confirms the account was
/// created before the user proceeds to log in — replaces the previous behaviour
/// of jumping straight to the login screen.
class RegistrationSuccessScreen extends StatelessWidget {
  const RegistrationSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF141018),
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: BlurContainerWrapper(
                showClip: false,
                blurSigma: 10,
                minHeight: 0,
                borderRadius: const BorderRadius.all(Radius.circular(40)),
                borderColor: Colors.white.withOpacity(0.6667),
                padding: const EdgeInsets.fromLTRB(24, 40, 24, 32),
                gradientColors: [
                  const Color(0xFFF3E5F5).withOpacity(0.90),
                  const Color(0xFFE8D5F0).withOpacity(0.90),
                  const Color(0xFFF0E6F8).withOpacity(0.90),
                  const Color(0xFFE1D5F5).withOpacity(0.90),
                ],
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Success check badge
                    Container(
                      height: 96,
                      width: 96,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: _accentPurple,
                      ),
                      child: const Icon(Icons.check_rounded,
                          size: 56, color: Colors.white),
                    ),
                    SizedBox(height: 24.h),
                    Text(
                      "Registration Successful",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: AppFonts.family,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    TextRegular(
                      "Your account has been created successfully. "
                      "Please log in to continue.",
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      color: AppColors.purple2,
                    ),
                    SizedBox(height: 28.h),
                    AppButton(
                      title: "Continue to Login",
                      onPressed: () =>
                          Get.offAllNamed(AppRoutes.loginScreen),
                      gradientColors: const [
                        Color(0xFFEDB3FC),
                        Color(0xFFBF29F6),
                        Color(0xFF7B02D1),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
