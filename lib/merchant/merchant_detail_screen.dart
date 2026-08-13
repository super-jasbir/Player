import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:player/common_widgets.dart';
import 'package:player/data/network/api_endpoints.dart';
import 'package:player/game/game_list_screen.dart';
import 'package:player/imagepreview/image_preview.dart';
import 'package:player/merchant/merchant_controller.dart';
import 'package:player/utils/app_utils.dart';

import '../3dView/home_top_bar.dart';
import '../utils/app_color.dart';
import '../utils/app_components.dart';
import 'package:player/core/services/tap_sound.dart';

/// Accent blue used for the title and section headings (matches the app theme).
const Color _accentBlue = Color(0xFF0288D1);

/// Body text colour used for the section content.
const Color _bodyColor = Color(0xFF374151);

class MerchantDetail extends StatefulWidget {
  const MerchantDetail({super.key});

  @override
  State<MerchantDetail> createState() => _GameScreenState();
}

class _GameScreenState extends State<MerchantDetail> {
  var controller = Get.put(MerchantController());

  // ===========================================================================
  // NEW UI (glass card over the blurred home background)
  // ===========================================================================
  @override
  Widget build(BuildContext context) {
    final data = controller.mData!;
    final String description = (data.description ?? "").toString().trim();
    final String specializing = data.specializedIn.trim();

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const HomeBlurredBackground(),
          SafeArea(
            bottom: false,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 6.h),
                  child: Row(
                    children: const [BackToLoginButton(text: 'Back')],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    padding: EdgeInsets.fromLTRB(18.w, 22.h, 18.w, 0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                      border: Border.all(color: Colors.white.withOpacity(0.6)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(bottom: 24.h),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title + address.
                          Center(
                            child: Text(
                              data.outletName,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 22.sp,
                                fontWeight: FontWeight.w800,
                                color: _accentBlue,
                              ),
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Center(
                            child: Text(
                              data.outletAddress,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ),
                          SizedBox(height: 18.h),

                          // Horizontal image gallery.
                          if (data.outletImages.isNotEmpty)
                            SizedBox(
                              height: 130.h,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: data.outletImages.length,
                                itemBuilder: (_, i) =>
                                    _thumb(data.outletImages[i]),
                              ),
                            ),
                          if (data.outletImages.isNotEmpty)
                            SizedBox(height: 22.h),

                          // Content sections.
                          if (description.isNotEmpty)
                            _section("Merchant Description", description),
                          _section(
                            "Business Hours",
                            "${data.startHours} to ${data.endHours}",
                          ),
                          if (specializing.isNotEmpty)
                            _section("Specializing", specializing, last: true),
                        ],
                      ),
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

  /// A single square thumbnail that opens the full-screen preview on tap.
  Widget _thumb(String image) {
    final url = ApiEndPoint.imageBaseUrl + "merchant/" + image;
    return Padding(
      padding: EdgeInsets.only(right: 10.w),
      child: InkWell(
        onTap: () => Get.to(ImagePreview(imageUrl: url)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12.r),
          child: SizedBox(
            width: 130.w,
            height: 130.h,
            child: AppUtils.remoteImageLoader(url, boxFit: BoxFit.cover),
          ),
        ),
      ),
    );
  }

  /// A blue heading followed by its body text.
  Widget _section(String title, String body, {bool last = false}) {
    return Padding(
      padding: EdgeInsets.only(bottom: last ? 0 : 20.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 16.sp,
              fontWeight: FontWeight.w800,
              color: _accentBlue,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            body,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              height: 1.4,
              color: _bodyColor,
            ),
          ),
        ],
      ),
    );
  }
}

// =============================================================================
// OLD UI (kept for reference — uncomment and restore the original build()
// above to revert to the previous design).
// =============================================================================
/*
  Widget buildOld(BuildContext context) {
    var data = controller.mData!;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            // Background Image
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/images/m2/game_bg.png",
                fit: BoxFit
                    .cover, // Adjust to BoxFit.fill, BoxFit.contain, etc., as needed
              ),
            ),
            // Transparent Overlay
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey
                  .withOpacity(0.2), // Adjust opacity and color as needed
            ),

            /// top navigation
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .05,
                  left: 18,
                  right: 18),
              child: Row(
                children: [
                  NoTapSound(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      )),
                  ),
                  Spacer(),
                  AppComponents.text("Merchant Details".toUpperCase(),
                      fontWeight: FontWeight.w700,
                      size: 25,
                      color: Colors.white),
                  Spacer(),
                ],
              ),
            ),

            /// spend logo
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .14,
                  left: 16,
                  right: 16),
              child: Container(
                height: 70,
                child: ListView.builder(
                    itemCount: data.outletImages.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      var image = data.outletImages[index];
                      return InkWell(
                        onTap: (){
                          Get.to(ImagePreview(imageUrl: ApiEndPoint.imageBaseUrl+"merchant/"+ image ));
                        },
                        child
                            : Container(
                          margin: EdgeInsets.only(left: 15),
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.white, width: 3),
                              borderRadius: BorderRadius.circular(0)),
                          child: AppUtils.remoteImageLoader(
                              ApiEndPoint.imageBaseUrl+"merchant/"+ image),
                        ),
                      );
                    }),
              ),
            ),

            /// glass transparent
            /// main view
            Container(
                margin: EdgeInsets.only(
                    left: 18,
                    top: MediaQuery.of(context).size.height * .27,
                    right: 18),
                // Set the desired width
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      /// merchant description
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/m3/game_detail_bg.png"),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            SizedBox(height: 5,),
                            AppUtils.outlinedText(text: "Merchant Description",fontSize: 20),
                            SizedBox(height: 12,),
                            /// description
                            Container(
                              margin: EdgeInsets.all(8),
                                child: AppComponents.text(data.description.toString(),maxLine: 10,size: 14,fontWeight: FontWeight.w500,color: Colors.black,textAlign: TextAlign.center))

                          ],
                        ),
                        padding: EdgeInsets.all(10),
                      ),
                      SizedBox(height: 15,),
                      /// bonous hours
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/m3/game_detail_bg.png"),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            AppUtils.outlinedText(text: "Business Hours",fontSize: 22),
                            SizedBox(height: 12,),
                            /// description
                            AppComponents.text("${data.startHours} - ${data.endHours} ",maxLine: 10,size: 18,fontWeight: FontWeight.w500,color: Colors.black)

                          ],
                        ),
                      ),
                      SizedBox(height: 15,),
                      /// specialising
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: AssetImage(
                                    "assets/images/m3/game_detail_bg.png"),
                                fit: BoxFit.fill),
                            borderRadius: BorderRadius.circular(12)),
                        child: Column(
                          children: [
                            AppUtils.outlinedText(text: "Specializing",fontSize: 20),
                            SizedBox(height: 12,),
                            /// description
                            Container(
                              margin: EdgeInsets.all(2),
                                child: AppComponents.text("${data.specializedIn}",maxLine: 10,size: 14,fontWeight: FontWeight.w500,color: Colors.black))

                          ],
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
*/
