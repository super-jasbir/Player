import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/common_widgets.dart';
import 'package:player/core/theme/app_fonts.dart';
import 'package:player/core/theme/app_images.dart';
import 'package:player/generated/l10n/app_localizations.dart';
import 'package:player/ui/signup/signup_controller.dart';

import '../../routes/app_routes.dart';
import '../../utils/app_color.dart';

/// Accent purple used for labels / links on the signup UI.
const Color _accentPurple = Color(0xFF9C27B0);
const Color _fieldBorder = Color(0xFFE0D5F0);

class SignupScreen extends GetView<SignupController> {
  const SignupScreen({super.key});

  void _onSignUp() {
    if (controller.fullName.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter full name");
      return;
    }
    if (controller.mobileController.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter your phone number");
      return;
    }
    if (controller.email.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter valid email");
      return;
    }
    if (controller.passC.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter password");
      return;
    }
    if (controller.confirmPassC.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter confirm password");
      return;
    }
    if (controller.confirmPassC.text.toString() !=
        controller.passC.text.toString()) {
      Fluttertoast.showToast(msg: "Confirm password not matched");
      return;
    }
    controller.signUp(() {
      Get.toNamed(AppRoutes.otpScreen,
          arguments: {"otpType": AppRoutes.signUpScreen});
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background: office + receptionist, softly blurred.
          ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.asset(
                  AppImages.regionBackground,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) =>
                      Container(color: const Color(0xFF1A1A1A)),
                ),
                Positioned(
                  top: 114.h,
                  left: 103.w,
                  width: 165.w,
                  height: 654.h,
                  child: Image.asset(
                    AppImages.regionReceptionist,
                    fit: BoxFit.contain,
                    alignment: Alignment.bottomCenter,
                    errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                  ),
                ),
              ],
            ),
          ),
          // Light-purple frosted card with the form.
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * .08),
                child: BlurContainerWrapper(
                  showClip: true,
                blurSigma: 10,
                borderRadius:
                    const BorderRadius.all(Radius.circular(40)),
                borderColor: Colors.white.withOpacity(0.6667),
                gradientColors: [
                  const Color(0xFFF3E5F5).withOpacity(0.88),
                  const Color(0xFFE8D5F0).withOpacity(0.88),
                  const Color(0xFFF0E6F8).withOpacity(0.88),
                  const Color(0xFFE1D5F5).withOpacity(0.88),
                ],
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Center(
                      child: Column(
                        children: [
                          Text(
                            l10n.createAccountTitle,
                            style: TextStyle(
                              fontFamily: AppFonts.family,
                              fontSize: 26.sp,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          TextRegular(
                            l10n.createAccountSubtitle,
                            fontSize: 13,
                            color: AppColors.purple2,
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 22.h),

                    // Full name
                    AppFieldLabel(
                        icon: Icons.person_outline,
                        text: l10n.fullNameLabel,
                        color: _accentPurple),
                    SizedBox(height: 8.h),
                    AppInputField(
                      controller: controller.fullName,
                      hint: l10n.fullNameHint,
                      icon: Icons.person_outline,
                      borderColor: _fieldBorder,
                    ),
                    SizedBox(height: 16.h),

                    // Phone number (reuses controller's IntlPhoneField logic)
                    AppFieldLabel(
                        icon: Icons.phone_outlined,
                        text: l10n.phoneNumberLabel,
                        color: _accentPurple),
                    SizedBox(height: 8.h),
                    controller.mobileNumberTextField(),
                    SizedBox(height: 16.h),

                    // Email
                    AppFieldLabel(
                        icon: Icons.mail_outline,
                        text: l10n.emailLabel,
                        color: _accentPurple),
                    SizedBox(height: 8.h),
                    AppInputField(
                      controller: controller.email,
                      hint: l10n.emailEnterHint,
                      icon: Icons.alternate_email,
                      keyboardType: TextInputType.emailAddress,
                      borderColor: _fieldBorder,
                    ),
                    SizedBox(height: 16.h),

                    // Password
                    AppFieldLabel(
                        icon: Icons.lock_outline,
                        text: l10n.passwordLabel,
                        color: _accentPurple),
                    SizedBox(height: 8.h),
                    Obx(
                      () => AppInputField(
                        controller: controller.passC,
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        obscure: controller.obscure.value,
                        borderColor: _fieldBorder,
                        suffix: _eyeToggle(),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Confirm password
                    AppFieldLabel(
                        icon: Icons.verified_user_outlined,
                        text: l10n.confirmPasswordLabel,
                        color: _accentPurple),
                    SizedBox(height: 8.h),
                    Obx(
                      () => AppInputField(
                        controller: controller.confirmPassC,
                        hint: '••••••••',
                        icon: Icons.lock_outline,
                        obscure: controller.obscure.value,
                        borderColor: _fieldBorder,
                        suffix: _eyeToggle(),
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Referral code
                    AppFieldLabel(
                        icon: Icons.person_outline,
                        text: l10n.referralCodeLabel,
                        color: _accentPurple),
                    SizedBox(height: 8.h),
                    AppInputField(
                      controller: controller.referralCode,
                      hint: l10n.referralCodeHint,
                      icon: Icons.person_outline,
                      borderColor: _fieldBorder,
                    ),
                    SizedBox(height: 16.h),

                    // Terms
                    Row(
                      children: [
                        Obx(
                          () => SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: controller.agree.value,
                              onChanged: (v) => controller.agree.value = v!,
                              activeColor: _accentPurple,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              side: const BorderSide(
                                  width: 1.5, color: _accentPurple),
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        TextRegular(l10n.agreePrefix,
                            fontSize: 13, color: Colors.grey.shade800),
                        TextMedium(
                          l10n.termsConditions,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // Sign Up — purple gradient per Figma.
                    AppButton(
                      title: l10n.signUp,
                      onPressed: _onSignUp,
                      gradientColors: const [
                        Color(0xFFEDB3FC),
                        Color(0xFFBF29F6),
                        Color(0xFF7B02D1),
                      ],
                    ),
                    SizedBox(height: 10.h),
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

  Widget _eyeToggle() {
    return IconButton(
      onPressed: () => controller.obscure.value = !controller.obscure.value,
      icon: Icon(
        controller.obscure.value
            ? Icons.visibility_off_outlined
            : Icons.visibility_outlined,
        color: Colors.grey,
        size: 20,
      ),
    );
  }
}
