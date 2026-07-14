import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:player/common_widgets.dart';

import 'forget_pass_controller.dart';

/// Accent blue used for labels / links (matches the login screen).
const Color _accentBlue = Color(0xFF0288D1);

class ForgetPassScreen extends GetView<ForgetPassController> {
  const ForgetPassScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        'Forgot Password?',
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF1A1A1A),
                      ),
                      SizedBox(height: 6.h),
                      TextRegular(
                        'Please enter your email to receive a password reset link',
                        fontSize: 13,
                        color: Colors.grey.shade700,
                        height: 1.35,
                      ),
                      SizedBox(height: 20.h),
                      const AppFieldLabel(
                        icon: Icons.mail_outline,
                        text: 'Email',
                        color: _accentBlue,
                      ),
                      SizedBox(height: 8.h),
                      AppInputField(
                        controller: controller.mobileController,
                        hint: 'you@example.com',
                        icon: Icons.alternate_email,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(height: 14.h),
                      const InfoNote("We'll send a verification code to this email"),
                      SizedBox(height: 22.h),
                      AppButton(
                        title: 'Reset Password',
                        onPressed: () {
                          controller.forgetPassword(
                            controller.selectedDialCode,
                            controller.mobileController.text,
                          );
                        },
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
