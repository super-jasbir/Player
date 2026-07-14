import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/common_widgets.dart';

import '../../utils/common_constants.dart';
import 'create_new_pass_controller.dart';

/// Accent blue used for labels / links (matches the login screen).
const Color _accentBlue = Color(0xFF0288D1);

class CreateNewPassScreen extends GetView<CreateNewPassController> {
  const CreateNewPassScreen({super.key});

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
                      SizedBox(height: 10.h),
                      Center(
                        child: TextMedium(
                          'Reset Password',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A1A),
                        ),
                      ),
                      SizedBox(height: 20.h),
                      const AppFieldLabel(
                        icon: Icons.lock_outline,
                        text: 'Password',
                        color: _accentBlue,
                      ),
                      SizedBox(height: 8.h),
                      Obx(
                        () => AppInputField(
                          controller: controller.enterPassC,
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          obscure: controller.obscure.value,
                          suffix: _EyeToggle(
                            obscured: controller.obscure.value,
                            onTap: () => controller.obscure.value =
                                !controller.obscure.value,
                          ),
                        ),
                      ),
                      SizedBox(height: 12.h),
                      const InfoNote('Must be at least 8 characters.'),
                      SizedBox(height: 16.h),
                      const AppFieldLabel(
                        icon: Icons.lock_outline,
                        text: 'Confirm Password',
                        color: _accentBlue,
                      ),
                      SizedBox(height: 8.h),
                      Obx(
                        () => AppInputField(
                          controller: controller.enterConfirmPassC,
                          hint: '••••••••',
                          icon: Icons.lock_outline,
                          obscure: controller.obscure2.value,
                          suffix: _EyeToggle(
                            obscured: controller.obscure2.value,
                            onTap: () => controller.obscure2.value =
                                !controller.obscure2.value,
                          ),
                        ),
                      ),
                      SizedBox(height: 22.h),
                      AppButton(
                        title: 'Reset Password',
                        onPressed: () => _onSubmit(context),
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

  /// Validates and submits the new password — unchanged logic.
  void _onSubmit(BuildContext context) {
    if (controller.enterPassC.text.isEmpty) {
      Fluttertoast.showToast(msg: CommonConstants.pleaseEnterNewPassword);
      return;
    }
    if (!controller.enterPassC.text.contains(RegExp(r'[A-Z]'))) {
      Fluttertoast.showToast(msg: CommonConstants.passWordMustContainAlphaNumeric);
      return;
    }
    if (controller.enterConfirmPassC.text.isEmpty) {
      Fluttertoast.showToast(msg: CommonConstants.pleaseConfirmNewPass);
      return;
    }
    if (!controller.enterConfirmPassC.text.contains(RegExp(r'[A-Z]'))) {
      Fluttertoast.showToast(msg: CommonConstants.passWordMustContainAlphaNumeric);
      return;
    }
    if (controller.enterPassC.text != controller.enterConfirmPassC.text) {
      Fluttertoast.showToast(msg: CommonConstants.passwordDoseNotMatch);
      return;
    }
    if (controller.enterPassC.text.length < 7) {
      Fluttertoast.showToast(msg: CommonConstants.passwordMustBeGreater);
      return;
    }
    if (controller.enterConfirmPassC.text.length < 7) {
      Fluttertoast.showToast(msg: CommonConstants.passwordMustBeGreater);
      return;
    }
    controller.resetPassword(controller.appController.id, context);
  }
}

/// Show/hide password eye button used by both password fields.
class _EyeToggle extends StatelessWidget {
  const _EyeToggle({required this.obscured, required this.onTap});

  final bool obscured;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(
        obscured ? Icons.visibility_off_outlined : Icons.visibility_outlined,
        color: Colors.grey,
        size: 20,
      ),
    );
  }
}
