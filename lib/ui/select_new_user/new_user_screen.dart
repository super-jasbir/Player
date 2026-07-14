import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/common_widgets.dart';
import 'package:player/data/local/shared_prefs.dart';
import 'package:player/generated/l10n/app_localizations.dart';
import 'package:player/routes/app_routes.dart';

import 'new_user_controller.dart';

/// First onboarding step (shown after "Get Started"): asks the user whether
/// they are new here. The answer is saved to preferences for later use on the
/// signup screen, then the user proceeds to pick their region.
class NewUserScreen extends GetView<NewUserController> {
  const NewUserScreen({super.key});

  void _select(bool isNewUser) {
    SharedPref.saveIsNewUser(isNewUser);
    Get.toNamed(AppRoutes.selectNation);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: OnboardingChoiceView(
        message: '${l10n.welcomeGreeting}\n${l10n.newHereQuestion}',
        leftLabel: l10n.optionYes,
        rightLabel: l10n.optionNo,
        onLeft: () => _select(true),
        onRight: () => _select(false),
      ),
    );
  }
}
