import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'app_fonts.dart';

/// Typography scale built on Inter (imported from minimart), scaled with
/// ScreenUtil so sizes track the Figma design frame. Use these on new screens
/// via the [TextRegular] / [TextMedium] widgets in common_widgets.dart.
class AppTextStyles {
  const AppTextStyles._();

  static TextStyle _base({
    required double size,
    required FontWeight weight,
    Color color = Colors.black,
    double? height,
  }) {
    return TextStyle(
      fontFamily: AppFonts.family,
      fontSize: size.sp,
      fontWeight: weight,
      color: color,
      height: height,
    );
  }

  static TextStyle heading = _base(size: 24, weight: FontWeight.w700);
  static TextStyle title = _base(size: 20, weight: FontWeight.w700);
  static TextStyle subtitle = _base(size: 16, weight: FontWeight.w600);
  static TextStyle body = _base(size: 14, weight: FontWeight.w400);
  static TextStyle bodyMedium = _base(size: 14, weight: FontWeight.w500);
  static TextStyle caption = _base(size: 12, weight: FontWeight.w400);
  static TextStyle button =
      _base(size: 16, weight: FontWeight.w700, color: Colors.white);
}
