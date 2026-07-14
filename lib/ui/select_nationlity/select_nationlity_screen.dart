import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/common_widgets.dart';
import 'package:player/data/local/shared_prefs.dart';
import 'package:player/generated/l10n/app_localizations.dart';
import 'package:player/ui/select_nationlity/select_nationlity_controller.dart';

import '../../app_controller.dart';
import '../../routes/app_routes.dart';

/// Region step: "Local" (singapore) vs "Tourist" (foreigner / outside
/// singapore). The choice is persisted to preferences (and the in-memory
/// AppController) for later use on the signup screen, then we go to login.
class SelectNationlityScreen extends GetView<SelectNationlity> {
  const SelectNationlityScreen({super.key});

  void _select(String nationality) {
    Get.find<AppController>().selectedNation = nationality;
    SharedPref.saveNationality(nationality);
    // Onboarding is complete once the region is chosen.
    SharedPref.saveOnboardingDone(true);
    Get.toNamed(AppRoutes.loginScreen);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: OnboardingChoiceView(
        showBack: true,
        message: '${l10n.welcomeGreeting}\n${l10n.originQuestion}',
        leftLabel: l10n.optionLocal,
        rightLabel: l10n.optionTourist,
        onLeft: () => _select("singapore"),
        onRight: () => _select("outside_singapore"),
      ),
    );
  }
}
