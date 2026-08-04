import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:player/common_widgets.dart';
import 'package:player/core/theme/app_images.dart';
import 'package:player/generated/l10n/app_localizations.dart';
import 'package:player/ui/login_screen/login_controller.dart';
import 'package:player/ui/signup/signup_controller.dart';

import '../../routes/app_routes.dart';

/// Accent blue used for labels / links on the new login UI.
const Color _accentBlue = Color(0xFF0288D1);

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Heavily-blurred receptionist background (reused assets).
            ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
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
            // Frosted card holding the login form.
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: BlurContainerWrapper(
                  showClip: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppFieldLabel(
                          icon: Icons.phone,
                          text: l10n.phoneNumberLabel,
                          color: _accentBlue),
                      SizedBox(height: 8.h),
                      // Country-code picker + phone number (bound to
                      // mobileController so login() stays unchanged).
                      controller.mobileNumberTextField(),
                      SizedBox(height: 16.h),
                      AppFieldLabel(
                          icon: Icons.lock_outline,
                          text: l10n.passwordLabel,
                          color: _accentBlue),
                      SizedBox(height: 8.h),
                      Obx(
                        () => AppInputField(
                          controller: controller.passwordC,
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          obscure: controller.obscure.value,
                          suffix: IconButton(
                            onPressed: () =>
                                controller.obscure.value = !controller.obscure.value,
                            icon: Icon(
                              controller.obscure.value
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: Colors.grey,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () => Get.toNamed(AppRoutes.forgetPassScreen),
                          child: TextMedium(
                            l10n.forgotPassword,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: _accentBlue,
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      AppButton(
                        title: l10n.signIn,
                        onPressed: controller.login,
                      ),
                      SizedBox(height: 18.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextRegular(
                            l10n.dontHaveAccount,
                            fontSize: 13,
                            color: Colors.grey.shade700,
                          ),
                          InkWell(
                            onTap: () {
                              Get.put(SignupController());
                              Get.toNamed(AppRoutes.signUpScreen);
                            },
                            child: TextMedium(
                              l10n.signUp,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _accentBlue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

