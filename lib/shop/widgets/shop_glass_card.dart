import 'dart:ui';

import 'package:flutter/material.dart';

/// The frosted "Glass Sign In Card" used all over the shop flow in Figma:
/// a 5px backdrop blur, a white 80% hairline border and a white
/// 70% -> 84% diagonal fill.
///
/// It is deliberately unopinionated about size — callers wrap it in a
/// [SizedBox] / [Positioned] and pass the radius from the spec (40 for pills
/// and avatars, 20 for the dialogue card).
class ShopGlassCard extends StatelessWidget {
  const ShopGlassCard({
    super.key,
    required this.child,
    this.radius = 40,
    this.padding = EdgeInsets.zero,
    this.blurSigma = 5,
    this.boxShadow,
  });

  final Widget child;
  final double radius;
  final EdgeInsetsGeometry padding;
  final double blurSigma;
  final List<BoxShadow>? boxShadow;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(radius);
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        boxShadow: boxShadow,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              border: Border.all(color: Colors.white.withOpacity(0.8)),
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.white.withOpacity(0.702),
                  Colors.white.withOpacity(0.839),
                ],
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

/// Drop shadow shared by the floating glass panels in the shop flow
/// (dialogue card + home pill).
const List<BoxShadow> kShopGlassShadow = [
  BoxShadow(
    color: Color(0x29000000), // black @ 16%
    blurRadius: 64,
    spreadRadius: -8,
    offset: Offset(0, 32),
  ),
  BoxShadow(
    color: Color(0x214FC3F7),
    blurRadius: 32,
    offset: Offset(0, 8),
  ),
];
