import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/common_widgets.dart';
import 'package:player/core/theme/app_fonts.dart';
import 'package:player/core/theme/app_images.dart';
import 'package:player/generated/l10n/app_localizations.dart';
import 'package:player/utils/app_color.dart';

import '../../utils/app_utils.dart';
import 'create_profileC.dart';

/// Accent purple shared with the signup screen.
const Color _accentPurple = Color(0xFF9C27B0);
const Color _fieldBorder = Color(0xFFE0D5F0);

class CreateProfileScreen extends StatefulWidget {
  const CreateProfileScreen({super.key});

  @override
  State<CreateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<CreateProfileScreen> {
  final controller = Get.put(CreateProfileController());

  @override
  void initState() {
    controller.postalC.addListener(() {
      if (controller.postalC.text.length == 6) {
        controller.getPostalCode(controller.postalC.text, () {
          setState(() {
            controller.addressC.text = controller.addressData?.address ?? "";
          });
        });
      }
    });
    super.initState();
  }

  void _onVerify() {
    if (controller.appController.uploadedImage.isEmpty) {
      Fluttertoast.showToast(msg: "Please select profile image");
      return;
    }
    if (controller.fullNameC.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter full name");
      return;
    }
    if (controller.nickNameC.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter nickname");
      return;
    }
    if (controller.dobC.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please select date of birth");
      return;
    }
    if (controller.addressC.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter address");
      return;
    }
    if (controller.orginOfCountry.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter country origin");
      return;
    }
    controller.createProfile();
  }

  void _pickDob() {
    AppUtils.showDatePickerDialogWithCallback(
      context,
      (date, timeStamp) {
        controller.dobC.text = date;
        controller.ageInYear.text = AppUtils.calculateAge(timeStamp).toString();
        setState(() {});
      },
      lastDate: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFF141018),
      body: Center(
        child: SingleChildScrollView(
          child: SafeArea(
            child: BlurContainerWrapper(
              showClip: false,
              blurSigma: 10,
              minHeight: 0,
              borderRadius: const BorderRadius.all(Radius.circular(40)),
              borderColor: Colors.white.withOpacity(0.6667),
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 28),
              gradientColors: [
                const Color(0xFFF3E5F5).withOpacity(0.90),
                const Color(0xFFE8D5F0).withOpacity(0.90),
                const Color(0xFFF0E6F8).withOpacity(0.90),
                const Color(0xFFE1D5F5).withOpacity(0.90),
              ],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Title
                  Center(
                    child: Column(
                      children: [
                        Text(
                          l10n.createProfileTitle,
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
                  SizedBox(height: 20.h),

                  // Profile avatar picker
                  Center(child: _avatar()),
                  SizedBox(height: 24.h),

                  // Full name
                  _label(Icons.person_outline, l10n.fullNameLabel),
                  SizedBox(height: 8.h),
                  AppInputField(
                    controller: controller.fullNameC,
                    hint: l10n.fullNameHint,
                    icon: Icons.person_outline,
                    borderColor: _fieldBorder,
                  ),
                  SizedBox(height: 16.h),

                  // Nick name
                  _label(Icons.person_outline, l10n.nickNameLabel),
                  SizedBox(height: 8.h),
                  AppInputField(
                    controller: controller.nickNameC,
                    hint: l10n.nickNameHint,
                    icon: Icons.person_outline,
                    borderColor: _fieldBorder,
                  ),
                  SizedBox(height: 16.h),

                  // Phone number (read-only, from signup)
                  _label(Icons.phone_outlined, l10n.phoneNumberLabel),
                  SizedBox(height: 8.h),
                  _phoneField(),
                  SizedBox(height: 16.h),

                  // Date of birth
                  _label(Icons.calendar_today_outlined, l10n.dateOfBirthLabel),
                  SizedBox(height: 8.h),
                  AppInputField(
                    controller: controller.dobC,
                    hint: l10n.dobHint,
                    icon: Icons.calendar_today_outlined,
                    borderColor: _fieldBorder,
                    readOnly: true,
                    onTap: _pickDob,
                    suffix: const Icon(Icons.keyboard_arrow_down,
                        color: Colors.grey, size: 22),
                  ),
                  SizedBox(height: 16.h),

                  // Age in years
                  _label(Icons.person_outline, l10n.ageLabel),
                  SizedBox(height: 8.h),
                  AppInputField(
                    controller: controller.ageInYear,
                    hint: l10n.ageHint,
                    icon: Icons.cake_outlined,
                    keyboardType: TextInputType.number,
                    borderColor: _fieldBorder,
                  ),
                  SizedBox(height: 16.h),

                  // Postal code — entering 6 digits triggers the address lookup
                  // API which auto-fills the address field below.
                  _label(Icons.location_on_outlined, "Postal Code"),
                  SizedBox(height: 8.h),
                  AppInputField(
                    controller: controller.postalC,
                    hint: "Enter Postal Code",
                    icon: Icons.location_on_outlined,
                    keyboardType: TextInputType.number,
                    borderColor: _fieldBorder,
                  ),
                  SizedBox(height: 16.h),

                  // Address
                  _label(Icons.home_outlined, l10n.addressLabel),
                  SizedBox(height: 8.h),
                  AppInputField(
                    controller: controller.addressC,
                    hint: l10n.addressHint,
                    icon: Icons.home_outlined,
                    borderColor: _fieldBorder,
                  ),
                  SizedBox(height: 16.h),

                  // Origin of country
                  _label(Icons.public, l10n.originCountryLabel),
                  SizedBox(height: 8.h),
                  AppInputField(
                    controller: controller.orginOfCountry,
                    hint: l10n.originCountryHint,
                    icon: Icons.public,
                    borderColor: _fieldBorder,
                  ),
                  SizedBox(height: 16.h),

                  // User ID
                  _label(Icons.person_outline, l10n.userIdLabel),
                  SizedBox(height: 8.h),
                  AppInputField(
                    controller: controller.userId,
                    hint: l10n.userIdHint,
                    icon: Icons.person_outline,
                    borderColor: _fieldBorder,
                  ),
                  SizedBox(height: 16.h),

                  // NRIC (local) / Passport (tourist) — depends on the region
                  // chosen on the SelectNationlityScreen.
                  _identityField(),

                  SizedBox(height: 20.h),

                  // Food type (single selection, sent as foodType)
                  Row(
                    children: [
                      Expanded(child: _foodOption(l10n.foodCarnivorous)),
                      Expanded(child: _foodOption(l10n.foodOmnivorous)),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Expanded(child: _foodOption(l10n.foodHalal)),
                      Expanded(child: _foodOption(l10n.foodNonHalal)),
                    ],
                  ),
                  SizedBox(height: 22.h),

                  // Verify — purple gradient per design.
                  AppButton(
                    title: l10n.verify,
                    onPressed: _onVerify,
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
    );
  }

  Widget _label(IconData icon, String text) =>
      AppFieldLabel(icon: icon, text: text, color: _accentPurple);

  /// NRIC for locals, Passport for tourists — both persist to [passPortC].
  Widget _identityField() {
    final bool isTourist =
        controller.appController.selectedNation == "outside_singapore";
    final String label = isTourist ? "Passport Number" : "NRIC Number";
    final String hint =
        isTourist ? "Enter Passport Number" : "Enter NRIC Number";
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _label(Icons.badge_outlined, label),
        SizedBox(height: 8.h),
        AppInputField(
          controller: controller.passPortC,
          hint: hint,
          icon: Icons.badge_outlined,
          borderColor: _fieldBorder,
        ),
      ],
    );
  }

  Widget _avatar() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Obx(
          () => Container(
            height: 96,
            width: 96,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFBDBDBD),
            ),
            clipBehavior: Clip.antiAlias,
            child: controller.appController.uploadedImage.isNotEmpty
                ? Image.network(
                    controller.appController.uploadedImage.value,
                    fit: BoxFit.cover,
                  )
                : const Icon(Icons.person, size: 64, color: Color(0xFF757575)),
          ),
        ),
        Positioned(
          right: -2,
          bottom: -2,
          child: InkWell(
            onTap: () => controller.pickImage(camera: false, context: context),
            child: Container(
              height: 32,
              width: 32,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFF29B6F6),
              ),
              child: Image.asset(AppImages.icCamera,height: 60,width: 60,),
            ),
          ),
        ),
      ],
    );
  }

  /// Read-only phone display: dial-code box + number, sourced from signup.
  Widget _phoneField() {
    return Row(
      children: [
        Container(
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(color: _fieldBorder, width: 1),
          ),
          child: Row(
            children: [
              TextMedium(
                "+${controller.signUpC.selectedDialCode}",
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
              const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Container(
            height: 56.h,
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: _fieldBorder, width: 1),
            ),
            child: TextRegular(
              controller.signUpC.mobileController.text,
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _foodOption(String label) {
    return Obx(() {
      final selected = controller.selectedFoodType.value == label;
      return InkWell(
        onTap: () => controller.selectedFoodType.value = label,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Row(
            children: [
              Container(
                height: 22,
                width: 22,
                decoration: BoxDecoration(
                  color: selected ? _accentPurple : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _accentPurple, width: 1.5),
                ),
                child: selected
                    ? const Icon(Icons.check, size: 16, color: Colors.white)
                    : null,
              ),
              SizedBox(width: 8.w),
              TextMedium(
                label,
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF1A1A1A),
              ),
            ],
          ),
        ),
      );
    });
  }
}
