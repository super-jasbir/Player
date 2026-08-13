import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:player/leaderboard/leaderboardDetail.dart';
import 'package:player/ui/create_profile/update_profile.dart';
import 'package:player/ui/login_screen/login_controller.dart';
import 'package:player/ui/signup/signup_controller.dart';
import 'package:player/utils/app_components.dart';
import 'package:share_plus/share_plus.dart';

import '../../3dView/home_top_bar.dart';
import '../../data/local/shared_prefs.dart';
import '../../leaderboard/leaderboard.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_color.dart';
import '../../utils/app_fonts.dart';
import '../../utils/app_utils.dart';
import 'create_profileC.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _CreateProfileScreenState();
}

class _CreateProfileScreenState extends State<UpdateProfileScreen> {
  var controller = Get.put(UpdateProfileController());

  // ── New PROFILE screen state ──────────────────────────────────────────────
  // Referral details are cached locally (same source used by [Referral]).
  String referralCode = "";
  String referralPoint = "";

  // Brand blue used across the new profile UI (matches Figma #0288D1).
  static const Color _blue = Color(0xFF0288D1);

  @override
  void initState() {
    super.initState();
    _loadReferral();
    // Postal-code auto-fill listener (retained from the old form UI so the
    // underlying controller keeps working unchanged).
    controller.postalC.addListener(() {
      if (controller.postalC.text.length == 6) {
        controller.getPostalCode(controller.postalC.text, () {
          setState(() {
            controller.addressC.text = controller.addressData?.address ?? "";
          });
        });
      }
    });
  }

  Future<void> _loadReferral() async {
    final code = await SharedPref.getReferalCode();
    final point = await SharedPref.getReferalPoints();
    if (!mounted) return;
    setState(() {
      referralCode = _clean(code);
      referralPoint = _clean(point);
    });
  }

  /// Treats null / the literal string "null" as empty.
  String _clean(String? value) {
    if (value == null || value.trim().toLowerCase() == "null") return "";
    return value;
  }

  // ───────────────────────────────────────────────────────────────────────────
  //  NEW UI (from Figma "PROFILE" design)
  // ───────────────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Background — reuse the blurred home player screen artwork.
          const HomeBlurredBackground(),

          SafeArea(
            child: Column(
              children: [
                _topBar(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        _avatarWithName(context),
                        const SizedBox(height: 22),
                        _referralCard(context),
                        const SizedBox(height: 30),
                        _leaderboardButton(),
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Back button (left) + centred "PROFILE" title.
  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: () => Get.back(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.arrow_back_ios_new, color: Colors.white, size: 16),
                  SizedBox(width: 4),
                  Text("Back",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12)),
                ],
              ),
            ),
          ),
          const Text("PROFILE",
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 20,
                  letterSpacing: 1)),
        ],
      ),
    );
  }

  /// Circular profile picture with an edit badge, plus the name pill below.
  Widget _avatarWithName(BuildContext context) {
    return Column(
      children: [
        Obx(() {
          final img = controller.appController.uploadedImage.value;
          return Stack(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(color: _blue, width: 4),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 12,
                        offset: const Offset(0, 6)),
                  ],
                ),
                child: ClipOval(
                  child: img.isNotEmpty
                      ? Image.network(img,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _avatarPlaceholder())
                      : _avatarPlaceholder(),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 10,
                child: InkWell(
                  onTap: () =>
                      controller.pickImage(camera: false, context: context),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: _blue,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6)
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(9),
                      child: Image.asset("assets/images/m3/ic_edit_profile.png"),
                    ),
                  ),
                ),
              ),
            ],
          );
        }),
        const SizedBox(height: 14),
        // Name pill.
        Obx(() {
          // Touch the reactive flag so the pill rebuilds once the profile loads.
          controller.appController.hasData.value;
          final data = controller.appController.profileData;
          final name = (data?.nickName?.isNotEmpty ?? false)
              ? data!.nickName!
              : (data?.name ?? "");
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 9),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  const Color(0xFFE1F5FE).withOpacity(0.85),
                  const Color(0xFFB3E5FC).withOpacity(0.85),
                ],
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF4FC3F7).withOpacity(0.2),
                    blurRadius: 8),
              ],
            ),
            child: Text(
              name,
              style: const TextStyle(
                  color: _blue, fontWeight: FontWeight.w700, fontSize: 22),
            ),
          );
        }),
      ],
    );
  }

  Widget _avatarPlaceholder() => Container(
        color: const Color(0xFFE3E8F0),
        alignment: Alignment.center,
        child: const Icon(Icons.person, color: Color(0xFF9AA6B8), size: 90),
      );

  /// Glass "REFERRAL" card: heading, tagline, code field + copy, share button.
  Widget _referralCard(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.70),
                  Colors.white.withOpacity(0.84),
                ],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.8)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF4FC3F7).withOpacity(0.13),
                    blurRadius: 32,
                    offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Center(
                  child: Text("REFERRAL",
                      style: TextStyle(
                          color: _blue,
                          fontWeight: FontWeight.w800,
                          fontSize: 20)),
                ),
                const SizedBox(height: 14),
                Center(
                  child: Text(
                      referralPoint.isEmpty
                          ? "1 Referral"
                          : "1 Referral = \$$referralPoint",
                      style: const TextStyle(
                          color: _blue,
                          fontWeight: FontWeight.bold,
                          fontSize: 14)),
                ),
                const SizedBox(height: 2),
                const Center(
                  child: Text("Earn unlimited FREE Credits",
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                ),
                const SizedBox(height: 18),
                const Text("REFERRAL CODE",
                    style: TextStyle(
                        color: _blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 11)),
                const SizedBox(height: 8),
                _referralInput(),
                const SizedBox(height: 16),
                _shareButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Glass code field showing the referral code with a copy affordance.
  Widget _referralInput() {
    final hasCode = referralCode.isNotEmpty;
    return Container(
      height: 54,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.white.withOpacity(0.72),
            Colors.white.withOpacity(0.85),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.87), width: 1.5),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              hasCode ? referralCode : "******",
              style: TextStyle(
                  color: hasCode
                      ? const Color(0xFF37474F)
                      : const Color(0xFF90A4AE),
                  fontWeight: hasCode ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 15,
                  letterSpacing: hasCode ? 1 : 3),
            ),
          ),
          InkWell(
            onTap: () {
              if (!hasCode) return;
              Clipboard.setData(ClipboardData(text: referralCode));
              Fluttertoast.showToast(msg: "Referral code copied");
            },
            child: const Icon(Icons.copy_rounded,
                color: Color(0xFF90A4AE), size: 18),
          ),
        ],
      ),
    );
  }

  /// Blue gradient "SHARE YOUR CODE" button.
  Widget _shareButton() {
    return InkWell(
      onTap: () {
        if (referralCode.isEmpty) {
          Fluttertoast.showToast(msg: "Referral code not available yet");
          return;
        }
        SharePlus.instance.share(ShareParams(
            text:
                "$referralCode is my referral code, please use this code for registered as a player on Spendrathon App"));
      },
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB3E5FC),
              Color(0xFF29B6F6),
              Color(0xFF0288D1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.67)),
          boxShadow: [
            BoxShadow(
                color: _blue.withOpacity(0.31),
                blurRadius: 16,
                offset: const Offset(0, 4)),
          ],
        ),
        child: const Text("SHARE YOUR CODE",
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 17)),
      ),
    );
  }

  /// Glass pill button that opens the leaderboard.
  Widget _leaderboardButton() {
    return InkWell(
      onTap: () => Get.to(LeaderboardDetail()),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(40),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Colors.white.withOpacity(0.70),
                  Colors.white.withOpacity(0.84),
                ],
              ),
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: Colors.white.withOpacity(0.8)),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF4FC3F7).withOpacity(0.13),
                    blurRadius: 24,
                    offset: const Offset(0, 8)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset("assets/images/m3/ic_leader_btn.png", height: 20),
                const SizedBox(height: 2),
                const Text("LEADERBOARD",
                    style: TextStyle(
                        color: _blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 8)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ═══════════════════════════════════════════════════════════════════════════
  //  OLD UI (commented out — kept for reference)
  // ═══════════════════════════════════════════════════════════════════════════
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//           child: Stack(
//         children: [
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             child: Image.asset(
//               "assets/images/m2/start_bg.png",
//               fit: BoxFit
//                   .cover, // Adjust to BoxFit.fill, BoxFit.contain, etc., as needed
//             ),
//           ),
//
//           // Transparent Overlay
//           Container(
//             width: double.infinity,
//             height: double.infinity,
//             color: Colors.grey
//                 .withOpacity(0.2), // Adjust opacity and color as needed
//           ),
//
//           /// spend logo
//           Column(
//             children: [
//               Container(
//                 margin: EdgeInsets.only(
//                     top: 40,
//                     left: 40,
//                     right: 40),
//                 child: Image.asset(
//                   "assets/images/m2/start_bg_logo.png",
//                 ),
//               ),
//
//               Align(
//                 alignment: Alignment.topCenter,
//                 child: Container(
//
//                   margin: EdgeInsets.only(
//                       top: 20,
//                       left: 40,
//                       bottom: 20,
//                       right: 40),
//                   child: Obx(() => controller.appController.uploadedImage.isNotEmpty
//                       ? ClipOval(
//                     child: InkWell(
//                       child: Container(
//                         height: 110,
//                         width: 110,
//                         child: Image.network(
//                             controller.appController.uploadedImage.value),
//                       ),
//                       onTap: (){
//                         controller.pickImage(camera: false, context: context);
//                       },
//                     ),
//                   )
//                       : InkWell(
//                     onTap: () {
//                       controller.pickImage(camera: false, context: context);
//                     },
//                     child: SvgPicture.asset("assets/images/upload_image.svg"),
//                   )),
//                 ),
//               ),
//
//               /// main view
//               Expanded(child: SingleChildScrollView(child: Container(
//                   margin: EdgeInsets.only(
//                       left: 18,
//                       bottom: 20,
//                       right: 18),
//                   // Set the desired width
//
//                   decoration: BoxDecoration(
//                     border: Border.all(width: 1, color: AppColors.borderColor),
//                     color: Colors.white.withOpacity(0.3),
//                     // Semi-transparent color
//                     borderRadius: BorderRadius.circular(16),
//                     // Rounded corners
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black.withOpacity(0.4), // Shadow color
//                         offset: Offset(0, 4), // Shadow position
//                         blurRadius: 10, // Blur radius for softness
//                       ),
//                     ],
//                   ),
//                   child: Stack(
//                     children: [
//                       Container(
//                         decoration: BoxDecoration(
//                             color: Colors.transparent,
//                             borderRadius: BorderRadius.circular(12)),
//                         child: SingleChildScrollView(
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//
//                               Container(
//                                 margin: EdgeInsets.only(left: 18,right: 18),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     SizedBox(height: 20,),
//                                     Image.asset("assets/images/m2/barline.png"),
//
//                                     Container(
//                                         margin: EdgeInsets.only(top: 12),
//                                         child: AppComponents.text(
//                                             controller.appConstant.fullName,
//                                             size: 14,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w400)),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     AppComponents.textField(
//                                         controller.appConstant.enterFullName,
//                                         controller: controller.fullNameC, enable: false),
//
//                                     /// nick name
//                                     Container(
//                                         margin: EdgeInsets.only(top: 12),
//                                         child: AppComponents.text(
//                                             controller.appConstant.nickName,
//                                             size: 14,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w400)),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     AppComponents.textField(
//                                         controller.appConstant.nickName,
//                                         controller: controller.nickNameC),
//
//                                     /// food type
//                                     Container(
//                                         margin: EdgeInsets.only(top: 12),
//                                         child: AppComponents.text(
//                                             "Food Type",
//                                             size: 14,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w400)),
//                                     AppUtils.dropDown(context, controller.selectedFoodType, controller.foodType),
//
//                                     Container(
//                                         margin: EdgeInsets.only(top: 12),
//                                         child: AppComponents.text(
//                                             controller.appConstant.phoneNumber,
//                                             size: 14,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w400)),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     /// email
//                                     controller.mobileNumberTextField(),
//                                     Container(
//                                         margin: EdgeInsets.only(top: 12),
//                                         child: AppComponents.text(
//                                             controller.appConstant.emailAddress,
//                                             size: 14,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w400)),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     AppComponents.textField("Enter Email Address",
//                                         controller: controller.emailC, enable: false),
//
//                                     /// add dob
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     Container(
//                                         child: AppComponents.text(
//                                             controller.appConstant.dateOfBirth,
//                                             size: 14,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.white)),
//                                     InkWell(
//                                       onTap: () {
//                                         AppUtils.showDatePickerDialogWithCallback(
//                                             context,
//                                                 (date, timeStamp)
//                                             {
//
//                                               controller.dobC.text = date;
//                                               print(timeStamp.year);
//                                               controller.ageInYear.text =   AppUtils.calculateAge(timeStamp).toString();
//
//
//
//                                             },
//                                             lastDate: DateTime.now());
//                                       },
//                                       child: Container(
//                                         margin: EdgeInsets.only(top: 15),
//                                         child: AppComponents.textField(
//                                             controller.appConstant.dob,
//                                             controller: controller.dobC,
//                                             enable: false,
//                                             suffixIcon: "assets/images/date_picker.png",
//                                             onTapIcon: () {
//                                               AppUtils.showDatePickerDialogWithCallback(
//                                                   context, (date, timeStamp)
//                                               {
//                                                 controller.dobC.text = date;
//
//                                                 print(timeStamp.year+timeStamp.day+timeStamp.day);
//                                                 controller.ageInYear.text =   AppUtils.calculateAge(timeStamp).toString();
//
//                                               });
//                                             }),
//                                       ),
//                                     ),
//                                     ///age in year
//                                     Container(
//                                         margin: EdgeInsets.only(top: 15),
//                                         child: AppComponents.text(
//                                             controller.appConstant.ageInYear,
//                                             size: 14,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w400)),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     AppComponents.textField("0",controller: controller.ageInYear, enable: false),
//
//                                     /// postal code
//
//                                     Container(
//                                         margin: EdgeInsets.only(top: 15),
//                                         child: AppComponents.text(
//                                             "Postal Code",
//                                             size: 14,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w400)),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     AppComponents.textField(
//                                         "Enter Postal Code",
//                                         controller: controller.postalC),
//
//                                     ///address
//                                     Container(
//                                         margin: EdgeInsets.only(top: 15),
//                                         child: AppComponents.text(
//                                             controller.appConstant.address,
//                                             size: 14,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w400)),
//                                     SizedBox(height: 10,),
//                                     Container(
//                                       height: 80,
//                                       child
//                                           : AppComponents.textField(
//                                           controller.appConstant.address,
//                                           controller: controller.addressC,
//                                           maxLines: 3
//
//
//
//                                       ),
//                                     ),
//
//                                     /// unit number
//
//                                     Container(
//                                         margin: EdgeInsets.only(top: 15),
//                                         child: AppComponents.text(
//                                             "Unit Number",
//                                             size: 14,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w400)),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     AppComponents.textField(
//                                         "Enter Unit Number",
//                                         controller: controller.unitC),
//                                     SizedBox(
//                                       height: 4,
//                                     ),
//                                     Container(
//                                         margin: EdgeInsets.only(top: 15),
//                                         child: AppComponents.text(
//                                             controller.appConstant.originOfCountry,
//                                             size: 14,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w400)),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     Obx(() => Column(
//                                       children: [
//                                         Row(
//                                           children: [
//                                             Expanded(
//                                               child: InkWell(
//                                                 onTap: () {
//                                                   controller.appLanguage.value = "local";
//                                                   controller.selectedNation.value = "singapore";
//                                                 },
//                                                 child: Container(
//                                                   decoration: BoxDecoration(
//                                                       borderRadius: BorderRadius.circular(20),
//                                                       border: Border.all(
//                                                           color: controller.appLanguage
//                                                               .value ==
//                                                               "local"
//                                                               ? Colors.white
//                                                               : Colors.grey,
//                                                           width: controller.appLanguage
//                                                               .value ==
//                                                               "local"
//                                                               ? 1
//                                                               : 1))
//                                                   ,
//                                                   child: AppUtils.remoteImageLoader(
//                                                       boxFit: BoxFit.fill,
//                                                       "assets/images/m3/singapore_bg.png"),
//                                                   height: 130,
//                                                   width: 120,
//                                                 ),
//                                               ),
//                                             ),
//                                             const SizedBox(
//                                               width: 21,
//                                             ),
//                                             Expanded(
//                                                 child: InkWell(
//                                                   onTap: () {
//                                                     controller.appLanguage.value = "global";
//                                                     controller.selectedNation.value = "outside_singapore";
//                                                   },
//                                                   child: Container(
//
//                                                     decoration: BoxDecoration(
//                                                         borderRadius: BorderRadius.circular(20),
//                                                         border: Border.all(
//                                                             color: controller.appLanguage
//                                                                 .value ==
//                                                                 "global"
//                                                                 ? Colors.white
//                                                                 : Colors.grey,
//                                                             width: controller.appLanguage
//                                                                 .value ==
//                                                                 "global"
//                                                                 ? 2
//                                                                 : 1)),
//                                                     child: AppUtils.remoteImageLoader(
//                                                         boxFit: BoxFit.fill,
//                                                         "assets/images/m3/foreigners_bg.png"),
//                                                     height: 130,
//                                                     width: 120,
//                                                   ),
//                                                 )),
//                                           ],
//                                         ),
//                                       ],
//                                     )),
//
//                                     ///country
//                                     /* Container(
//                                     margin: EdgeInsets.only(top: 15),
//                                     child: AppComponents.text(
//                                         controller.appConstant.originOfCountry,
//                                         size: 14,
//                                         color: Colors.white,
//                                         fontWeight: FontWeight.w400)),
//                                 SizedBox(
//                                   height: 16,
//                                 ),*/
//
//                                     /* AppComponents.textField(
//                                     controller.appConstant.originOfCountry,
//                                     controller: controller.orginOfCountry),*/
//
//                                     ///user id
//                                     Container(
//                                         margin: EdgeInsets.only(top: 15),
//                                         child: AppComponents.text(
//                                             controller.appConstant.userId,
//                                             size: 14,
//                                             color: Colors.white,
//                                             fontWeight: FontWeight.w400)),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//                                     AppComponents.textField("ad22342sss",
//                                         controller: controller.userId, enable: false),
//
//                                     /// passport
//                                     Obx(()=> controller.selectedNation.value == "outside_singapore" ?
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                             margin: EdgeInsets.only(top: 15),
//                                             child: AppComponents.text(
//                                                 "Passport Number",
//                                                 size: 14,
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w700)),
//                                         SizedBox(
//                                           height: 16,
//                                         ),
//                                         AppComponents.textField("Enter Passport Number",
//                                             controller: controller.passPortC),
//                                       ],
//                                     ):
//                                     Column(
//                                       crossAxisAlignment: CrossAxisAlignment.start,
//                                       children: [
//                                         Container(
//                                             margin: EdgeInsets.only(top: 15),
//                                             child: AppComponents.text(
//                                                 "NRIC Number",
//                                                 size: 14,
//                                                 color: Colors.white,
//                                                 fontWeight: FontWeight.w700)),
//                                         SizedBox(
//                                           height: 16,
//                                         ),
//                                         AppComponents.textField("Enter NRIC Number",
//                                             controller: controller.nricC),
//                                       ],
//                                     )),
//                                     SizedBox(
//                                       height: 16,
//                                     ),
//
//                                     AppComponents.appButton(controller.appConstant.submit,
//                                         onTap: () {
//                                           if(controller.appController.uploadedImage.isEmpty){
//                                             Fluttertoast.showToast(msg: "Please select profile image");
//                                             return;
//                                           }
//                                           if(controller.fullNameC.text.isEmpty){
//                                             Fluttertoast.showToast(msg: "Please enter full name");
//                                             return;
//                                           }
//                                           if(controller.nickNameC.text.isEmpty){
//                                             Fluttertoast.showToast(msg: "Please enter nickname");
//                                             return;
//                                           }
//                                           if(controller.dobC.text.isEmpty){
//                                             Fluttertoast.showToast(msg: "Please select date of birth");
//                                             return;
//                                           }
//                                           if(controller.addressC.text.isEmpty){
//                                             Fluttertoast.showToast(msg: "Please enter address");
//                                             return;
//                                           }
//                                           if(controller.unitC.text.isEmpty){
//                                             Fluttertoast.showToast(msg: "Please enter Unit number");
//                                             return;
//                                           }
//                                           /*if(controller.orginOfCountry.text.isEmpty){
//                                         Fluttertoast.showToast(msg: "Please enter country origin");
//                                         return;
//                                       }*/
//
//                                           controller.createProfile();
//                                         }),
//                                   ],
//                                 ),
//                               ),
//
//
//                               const SizedBox(
//                                 height: 25,
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   )),)),
//             ],
//           )
//         ],
//       )),
//     );
//   }
}
