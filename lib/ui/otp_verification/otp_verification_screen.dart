import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/common_widgets.dart';
import 'package:player/ui/signup/signup_controller.dart';

import '../../routes/app_routes.dart';
import 'otp_verification_controller.dart';

/// Accent blue used for labels / links (matches the login screen).
const Color _accentBlue = Color(0xFF0288D1);

class OtpVerificationScreen extends GetView<OtpVerificationController> {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final otpArgument = Get.arguments as Map<String, dynamic>;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            const AuthBlurredBackground(),
            Align(
              alignment: Alignment.bottomCenter,
              child: SingleChildScrollView(
                child: BlurContainerWrapper(
                  showClip: true,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const BackToLoginButton(),
                      SizedBox(height: 12.h),
                      TextMedium(
                        'Enter Verification Code',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A),
                      ),
                      SizedBox(height: 6.h),
                      TextRegular(
                        'Please enter the code to verify',
                        fontSize: 13,
                        color: Colors.grey.shade700,
                      ),
                      SizedBox(height: 22.h),
                      controller.pinTextField(context),
                      SizedBox(height: 18.h),
                      const InfoNote("We've sent a verification code to your email"),
                      SizedBox(height: 22.h),
                      AppButton(
                        title: 'Verify Code',
                        onPressed: () => _onVerify(otpArgument),
                      ),
                      SizedBox(height: 14.h),
                      Center(
                        child: Obx(
                          () => controller.showResend.value
                              ? InkWell(
                                  onTap: () {
                                    controller.remainingTime.value = 60;
                                    controller.showResend.value = false;
                                    controller.startTimer();
                                  },
                                  child: TextMedium(
                                    'Resend code',
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: _accentBlue,
                                  ),
                                )
                              : TextRegular(
                                  'Resend code in ${controller.remainingTime.value}s',
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                ),
                        ),
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

  /// Verifies the entered OTP — unchanged routing/verification logic.
  void _onVerify(Map<String, dynamic> otpArgument) {
    if (controller.otpC.value.isEmpty) {
      Fluttertoast.showToast(
          msg: controller.appConstant.pleaseEnterTheCodeToVerify);
      return;
    }

    switch (otpArgument["otpType"]) {
      case AppRoutes.signUpScreen:
        {
          final signupC = Get.find<SignupController>();
          controller.verifyOtp(
            signupC.mobileController.text,
            signupC.selectedDialCode,
            signupC.signUpOtp,
            "1",
            "abc",
            () => Get.toNamed(AppRoutes.createProfile),
          );
        }
      case AppRoutes.createNewPassword:
        {
          controller.verifyOtp(
            otpArgument["number"],
            otpArgument["countryCode"],
            otpArgument["otp"].toString(),
            otpArgument["deviceType"],
            otpArgument["deviceToken"],
            () => Get.toNamed(AppRoutes.createNewPassword),
          );
        }
    }
  }
}
