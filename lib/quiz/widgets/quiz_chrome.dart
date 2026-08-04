import 'dart:ui';

import 'package:flutter/material.dart';

/// Asset paths for the quiz flow (registered under `assets/images/quiz/`).
class QuizAssets {
  const QuizAssets._();

  static const String _base = 'assets/images/quiz';

  /// Sharp classroom used behind the intro screen.
  static const String classroom = '$_base/ic_quiz_bg.png';

  /// Full-body quiz host (business teacher) cutout.
  static const String teacher = '$_base/ic_teacher.png';

  /// Gold starburst badge behind the score on the result screen.
  static const String congratsBadge = '$_base/ic_congratulation_bg.png';
}

/// The classroom backdrop shared by every quiz screen. The intro shows it
/// sharp; the browsing screens (question / how-to-play / result) blur it and
/// add a light wash so the glass cards stay legible.
class QuizBackground extends StatelessWidget {
  const QuizBackground({
    super.key,
    this.blurred = false,
    this.blurSigma = 16,
    this.washOpacity = 0.10,
  });

  final bool blurred;
  final double blurSigma;
  final double washOpacity;

  @override
  Widget build(BuildContext context) {
    final Widget room = Image.asset(QuizAssets.classroom, fit: BoxFit.cover);
    if (!blurred) {
      return Positioned.fill(child: room);
    }
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          room,
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Container(color: Colors.white.withOpacity(washOpacity)),
          ),
        ],
      ),
    );
  }
}
