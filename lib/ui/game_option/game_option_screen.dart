import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/common_widgets.dart';

import '../../game/play_game_screen.dart';

/// Game mode step: "Spendrathon" vs "Tourathon". Reuses the same onboarding
/// layout as [SelectNationlityScreen] — only the button labels differ.
///
/// Choosing Spendrathon continues to the game-zone selection; Tourathon is
/// not available yet, so it simply shows a "coming soon" toast.
class GameOptionScreen extends StatelessWidget {
  const GameOptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: OnboardingChoiceView(
        showBack: true,
        message: 'Hi. Welcome to  SPENDRATHON...\nMay i know where you from...',
        leftLabel: 'Spendrathon',
        rightLabel: 'Tourathon',
        onLeft: () => Get.to(const SelectGameZone()),
        onRight: () =>
            Fluttertoast.showToast(msg: "Tourathon coming soon..."),
      ),
    );
  }
}
