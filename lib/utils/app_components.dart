import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:player/core/services/sound_service.dart';
import 'package:player/utils/app_utils.dart';

import 'app_color.dart';
import 'app_fonts.dart';

class AppComponents {
  static Widget text(String text,
      {double size = 14.0,
      String font = AppFonts.satoshiBold,
      Color color = Colors.grey,
      FontWeight fontWeight = FontWeight.w700,
      TextAlign? textAlign,
      FontStyle? fontStyle,
      TextOverflow? textOverflow,
      int? maxLine,
      bool enableUnderLine = false}) {
    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          fontFamily: font,
          fontStyle: fontStyle,
          color: color,
          fontWeight: fontWeight,
          decoration: enableUnderLine ? TextDecoration.underline : null,
          decorationColor: Colors.blue),
      maxLines: maxLine,
      textAlign: textAlign,
      softWrap: true,
      overflow: textOverflow ?? TextOverflow.ellipsis,
    );
  }

/*
  static Widget appButton(String content, {double height = 56,VoidCallback? callback}) {
    return InkWell(
      onTap: (){
        final AudioPlayer _audioPlayer = AudioPlayer();
        _audioPlayer.play(AssetSource('click.mp3'));
        callback?.call();



      },
      child: Container(
        height: height,
        decoration: BoxDecoration(
          image: DecorationImage(image: AssetImage("assets/images/button_bg.png")),

          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2), // Shadow color
              offset: Offset(0, 4), // Shadow position (x, y)
              blurRadius: 6, // Shadow blur radius
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 2),
              blurRadius: 2,
            )
          ],
        ),
        child: Center(
          child: text(
            content.toUpperCase(),
            color: Colors.white,
            fontWeight: FontWeight.w900,
            size: 20,
          ),
        ),
      ),
    );
  }
*/

  static Widget appButton(String content,
      {double height = 56,
      VoidCallback? onTap,
      double textSize = 20,
      String image = "",
        double contentPadding = 0

      }) {
    return Material(
      color: Colors.transparent, // Ensures transparency for ripple effect
      child: Ink(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/m2/button_bg.png"),
              fit: BoxFit.fill),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Shadow color
              offset: Offset(0, 4), // Shadow position (x, y)
              blurRadius: 6, // Shadow blur radius
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              offset: Offset(0, 2),
              blurRadius: 2,
            )
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12), // Match the border radius
          splashColor: Colors.white.withOpacity(0.3), // Customize ripple color
          onTap: () {
            SoundService.instance.playClick();
            onTap?.call();
          },
          child: Container(

            height: height,
            alignment: Alignment.center, // Centers the text
            child: Padding(
              padding: EdgeInsets.all(contentPadding),
              child: Row(
                children: [
                  Spacer(),
                  image.isNotEmpty
                      ? Container(
                          height: 32,
                          width: 32,
                          child: AppUtils.remoteImageLoader(image),
                        )
                      : Container(),
                  SizedBox(
                    width: 10,
                  ),
                  text(
                    content.toUpperCase(),
                    color: Colors.black,
                    fontWeight: FontWeight.w900,
                    size: textSize,
                  ),
                  Spacer()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static Widget zoneButton(String name,{VoidCallback? onTap}) {
    return Material(
      color: Colors.transparent,
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.orange,
          borderRadius: BorderRadius.circular(12),
        ),
        child: InkWell(
          splashColor: Colors.white.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),  // Apply the same border radius to the ripple effect
          onTap: () async{
            Future.delayed(Duration(seconds: 1)).then((value) {
              onTap?.call();
            });

            // Handle tap
          },
          child: Container(

            height: 92,
            width: 127,
            alignment: Alignment.center,
            child: AppComponents.text(
              name,
              color: Colors.white,
              fontWeight: FontWeight.w900,
              size: 26,
            ),
          ),
        ),
      ),
    );
  }


  static Widget textField(String hint,
      {TextEditingController? controller,
      String? suffixIcon,
      bool obscure = false,
      VoidCallback? onTapIcon,
      bool? enable,
      double height = 52,
        int maxLines = 1,
      String keyBoardType = "",
      Color hintColor = Colors.grey}) {
    return Container(
      height: height,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: hintColor, width: 1)),
      child: Padding(
        padding: const EdgeInsets.only(left: 18),
        child: TextField(
          inputFormatters: keyBoardType == "stringOnly"
              ? [
                  FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                  // Allow only alphabets
                ]
              : null,
          enabled: enable,
          maxLines: maxLines,
          // maxLines: null,
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hint,
            hintStyle: TextStyle(color: hintColor, fontSize: 14),
            suffixIcon: suffixIcon != null
                ? InkWell(
                    onTap: () {
                      onTapIcon?.call();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      child: Image.asset(
                        suffixIcon,
                        height: 20,
                        width: 20,
                        color: AppColors.appColor,
                      ),
                    ),
                  )
                : null,
            suffixIconConstraints: const BoxConstraints(
              maxWidth: 40, // Set the maximum width
              maxHeight: 20, // Set the maximum height
            ),
          ),
          obscureText: obscure,
        ),
      ),
    );
  }
}
