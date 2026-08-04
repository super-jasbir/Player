import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'core/theme/app_fonts.dart';
import 'core/theme/app_images.dart';
import 'core/theme/app_text_styles.dart';

/// A frosted-glass ("blur") card that anchors to the bottom of a screen and
/// truly blurs whatever is painted behind it (the background image), matching
/// the Figma walkthrough design.
///
/// It has a [minHeight] but grows to fit its [child], and can optionally show a
/// paperclip pinned above its top edge via [showClip].
///
/// Usage:
/// ```dart
/// BlurContainerWrapper(
///   showClip: true,
///   child: Column(mainAxisSize: MainAxisSize.min, children: [...]),
/// )
/// ```
class BlurContainerWrapper extends StatelessWidget {
  /// Content rendered inside the card. Use a `Column(mainAxisSize: min, ...)`
  /// so the card can grow/shrink with the content.
  final Widget child;

  /// Show the paperclip pinned above the top-right edge of the card.
  final bool showClip;

  /// Minimum height of the card; it grows past this to fit [child].
  final double minHeight;

  /// Blur strength applied to the background behind the card.
  final double blurSigma;

  /// Inner padding around [child].
  final EdgeInsetsGeometry padding;

  /// Corner radius of the card (defaults to all four corners rounded).
  final BorderRadius borderRadius;

  /// Outer margin around the card (use a bottom margin so it floats off the
  /// screen edge and its bottom rounded corners are visible).
  final EdgeInsetsGeometry margin;

  /// Fill gradient (top -> bottom). Defaults to frosted white; pass tints for
  /// a colored card (e.g. the light-purple signup card).
  final List<Color>? gradientColors;

  /// Border color; defaults to white @ 60%.
  final Color? borderColor;

  /// Paperclip placement / size (only used when [showClip] is true).
  final double clipTopOffset;
  final double clipRightOffset;
  final double clipWidth;

  const BlurContainerWrapper({
    super.key,
    required this.child,
    this.showClip = true,
    this.minHeight = 380,
    this.blurSigma = 30,
    this.padding = const EdgeInsets.fromLTRB(32, 50, 32, 35),
    this.borderRadius = const BorderRadius.all(Radius.circular(48)),
    this.margin = EdgeInsets.zero,
    this.gradientColors,
    this.borderColor,
    this.clipTopOffset = -38,
    this.clipRightOffset = 40,
    this.clipWidth = 30,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
        ClipRRect(
          borderRadius: borderRadius,
          child: BackdropFilter(
            // Real gaussian blur of the content painted behind this card.
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(
              width: double.infinity,
              constraints: BoxConstraints(minHeight: minHeight.h),
              padding: padding,
              decoration: BoxDecoration(
                borderRadius: borderRadius,
                border: Border.all(
                  color: borderColor ?? Colors.white.withOpacity(0.60),
                  width: 1,
                ),
                // Translucent fill so the strong blur stays visible through the
                // frosted glass (top -> bottom).
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: gradientColors ??
                      [
                        Colors.white.withOpacity(0.45),
                        Colors.white.withOpacity(0.62),
                      ],
                ),
              ),
              child: child,
            ),
          ),
        ),
        if (showClip)
          Positioned(
            top: clipTopOffset,
            right: clipRightOffset,
            child: Image.asset(AppImages.paperclip, width: clipWidth),
          ),
        ],
      ),
    );
  }
}

/// Primary call-to-action button (imported/adapted from minimart).
///
/// Gradient pill button with an optional leading icon and loading state. Uses
/// the Inter typography from [AppTextStyles]. Reuse this on every new screen
/// that needs a primary CTA instead of hand-rolling a button.
class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final double? width;
  final double height;
  final EdgeInsetsGeometry? margin;

  /// Optional leading image asset (e.g. a sparkle icon).
  final String? leadingImage;

  /// Gradient colors; defaults to the Figma blue gradient.
  final List<Color> gradientColors;

  /// Corner radius (Figma: 18).
  final double radius;

  /// Colour of the drop shadow; defaults to the blue that matches
  /// [gradientColors]. Override it when the button is not blue.
  final Color shadowColor;

  /// Label style; defaults to [AppTextStyles.button]. Override it only when a
  /// screen's Figma spec uses a different weight/size (e.g. the shop CTAs).
  final TextStyle? textStyle;

  const AppButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.width,
    this.height = 56,
    this.margin,
    this.leadingImage,
    this.radius = 18,
    // Figma: light sky -> azure (top to bottom).
    this.gradientColors = const [Color(0xFFB3E5FC), Color(0xFF29B6F6)],
    this.shadowColor = const Color(0x600288D1), // #0288D1 @ ~37.65%
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = isDisabled || isLoading;
    final double r = radius.r;

    return Container(
      margin: margin,
      width: width ?? double.infinity,
      height: height.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(r),
        // Figma: 1px border, white @ 66.67%.
        border: Border.all(
          color: Colors.white.withOpacity(disabled ? 0.0 : 0.6667),
          width: 1,
        ),
        gradient: disabled
            ? null
            : LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
        color: disabled ? const Color(0xFFCED4DA) : null,
        boxShadow: disabled
            ? null
            : [
                // Top inner-ish highlight.
                const BoxShadow(
                  color: Color(0x80FFFFFF), // white @ 50.2%
                  offset: Offset(0, 1),
                ),
                // Coloured drop shadow, tinted to match the button.
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 20,
                  spreadRadius: -2,
                  offset: const Offset(0, 6),
                ),
              ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(r),
        child: InkWell(
          borderRadius: BorderRadius.circular(r),
          onTap: disabled ? null : onPressed,
          child: Center(
            child: isLoading
                ? SizedBox(
                    height: 22.h,
                    width: 22.h,
                    child: const CircularProgressIndicator(
                      strokeWidth: 2.4,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Optional leading icon; when omitted it looks like the
                      // plain Yes/No/Local/Tourist buttons.
                      if (leadingImage != null) ...[
                        Image.asset(leadingImage!, width: 20, height: 20),
                        SizedBox(width: 8.w),
                      ],
                      Text(title, style: textStyle ?? AppTextStyles.button),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

/// Inter, regular weight (w400). Preferred over raw [Text] on new screens.
class TextRegular extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;

  const TextRegular(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.color = Colors.black,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: AppFonts.family,
        fontSize: fontSize.sp,
        fontWeight: FontWeight.w400,
        color: color,
        height: height,
      ),
    );
  }
}

/// Inter, medium weight (w500). Preferred over raw [Text] on new screens.
class TextMedium extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final double? height;
  final FontWeight fontWeight;

  const TextMedium(
    this.text, {
    super.key,
    this.fontSize = 14,
    this.color = Colors.black,
    this.textAlign,
    this.maxLines,
    this.overflow,
    this.height,
    this.fontWeight = FontWeight.w500,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      style: TextStyle(
        fontFamily: AppFonts.family,
        fontSize: fontSize.sp,
        fontWeight: fontWeight,
        color: color,
        height: height,
      ),
    );
  }
}

/// Shared onboarding layout used by the "Are you new here?" and the
/// nationality (Local / Tourist) screens: a full-bleed background with a
/// frosted speech bubble and two choice buttons at the bottom.
///
/// Kept generic so both screens (and any future "pick one of two" onboarding
/// step) reuse the exact same look.
class OnboardingChoiceView extends StatelessWidget {
  /// Greeting/prompt shown inside the frosted speech bubble.
  final String message;

  final String leftLabel;
  final String rightLabel;
  final VoidCallback onLeft;
  final VoidCallback onRight;

  /// Show a back arrow in the top-left.
  final bool showBack;

  const OnboardingChoiceView({
    super.key,
    required this.message,
    required this.leftLabel,
    required this.rightLabel,
    required this.onLeft,
    required this.onRight,
    this.showBack = false,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Layer 1: office background.
        Image.asset(
          AppImages.regionBackground,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Container(color: const Color(0xFF1A1A1A)),
        ),
        // Layer 2: receptionist standing in front. Figma frame 390x844:
        // 165 x 654, top 114, left 103.
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
        // Layer 3: speech bubble + choice buttons.
        SafeArea(
          child: Column(
            children: [
              if (showBack)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 12.w, top: 4.h),
                    child: IconButton(
                      onPressed: () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_ios_new,
                          color: Colors.white),
                    ),
                  ),
                ),
              const Spacer(),
              // Frosted speech bubble.
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24.r),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 22.h),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24.r),
                        color: Colors.white.withOpacity(0.72),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.6),
                          width: 1,
                        ),
                      ),
                      child: TextMedium(
                        message,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF2F86FF),
                        height: 1.4,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              // Two choice buttons.
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 24.h),
                child: Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        title: leftLabel.toUpperCase(),
                        height: 64,
                        onPressed: onLeft,
                      ),
                    ),
                    SizedBox(width: 16.w),
                    Expanded(
                      child: AppButton(
                        title: rightLabel.toUpperCase(),
                        height: 64,
                        onPressed: onRight,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Small colored label with a leading icon, e.g. "EMAIL", "PASSWORD".
/// Used above [AppInputField] on the login / signup forms.
class AppFieldLabel extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const AppFieldLabel({
    super.key,
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        SizedBox(width: 6.w),
        Text(
          text.toUpperCase(),
          style: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 12.sp,
            fontWeight: FontWeight.w700,
            color: color,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}

/// White rounded input field with a leading icon and optional suffix, matching
/// the new login / signup design. Reuse on any new form.
class AppInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final Color borderColor;
  final int maxLines;
  final bool readOnly;
  final VoidCallback? onTap;

  const AppInputField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.suffix,
    this.keyboardType,
    this.borderColor = const Color(0xFFE5E7EB),
    this.maxLines = 1,
    this.readOnly = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        maxLines: obscure ? 1 : maxLines,
        readOnly: readOnly,
        onTap: onTap,
        style: TextStyle(
          fontFamily: AppFonts.family,
          fontSize: 15.sp,
          color: Colors.black,
        ),
        decoration: InputDecoration(
          isCollapsed: true,
          contentPadding: EdgeInsets.symmetric(vertical: 16.h),
          prefixIcon: Icon(icon, color: Colors.grey, size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: AppFonts.family,
            fontSize: 15.sp,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }
}

/// "← Back to Login" link shown at the top of the forgot / verify / reset
/// password cards. Defaults to popping the current route.
class BackToLoginButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final Color color;

  const BackToLoginButton({
    super.key,
    this.onTap,
    this.text = 'Back to Login',
    this.color = const Color(0xFF0288D1),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ?? () => Get.back(),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back, size: 18, color: color),
            SizedBox(width: 6.w),
            Text(
              text,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Small translucent light-blue info note with a leading info icon, e.g.
/// "We'll send a verification code to this email" or "Must be at least 8
/// characters." Reused on the forgot / verify / reset password screens.
class InfoNote extends StatelessWidget {
  final String text;

  const InfoNote(this.text, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: const Color(0xFF2196F3).withOpacity(0.12),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: const Color(0xFF2196F3).withOpacity(0.30)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info, size: 16, color: Color(0xFF2196F3)),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF31688E),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Heavily-blurred receptionist background used by the auth screens
/// (login / forgot / verify / reset). Matches the login screen exactly.
class AuthBlurredBackground extends StatelessWidget {
  const AuthBlurredBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return ImageFiltered(
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
    );
  }
}

