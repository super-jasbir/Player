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

  // Getters, not fields: a static field would cache `.sp` at first access, and
  // if that happened before ScreenUtil was initialised every size would freeze
  // at 0 for the rest of the run (invisible text).
  static TextStyle get heading => _base(size: 24, weight: FontWeight.w700);
  static TextStyle get title => _base(size: 20, weight: FontWeight.w700);
  static TextStyle get subtitle => _base(size: 16, weight: FontWeight.w600);
  static TextStyle get body => _base(size: 14, weight: FontWeight.w400);
  static TextStyle get bodyMedium => _base(size: 14, weight: FontWeight.w500);
  static TextStyle get caption => _base(size: 12, weight: FontWeight.w400);
  static TextStyle get button =>
      _base(size: 16, weight: FontWeight.w700, color: Colors.white);
}
