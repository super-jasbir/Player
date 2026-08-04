import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/common_widgets.dart';
import 'package:player/core/theme/app_images.dart';
import 'package:player/data/local/shared_prefs.dart';
import 'package:player/generated/l10n/app_localizations.dart';
import 'package:player/routes/app_routes.dart';
import 'package:player/ui/splash/splash_screen_controller.dart';
import '../../3dView/home_screen_player.dart';

class WalkthroughImageApp extends StatelessWidget {
  const WalkthroughImageApp({super.key});

  @override
  Widget build(BuildContext context) {
    return WalkthroughImageScreen();
  }
}

class WalkthroughImageScreen extends StatefulWidget {
  @override
  State<WalkthroughImageScreen> createState() => _WalkthroughImageScreenState();
}

class _WalkthroughImageScreenState extends State<WalkthroughImageScreen> {
  var controller = Get.find<SplashScreenController>();

  void _goToHome() {
    Get.offAll(HomeScreenPlayer());
  }

  /// First-time users go through onboarding; returning users (who already
  /// picked their preferences) go straight to login.
  Future<void> _onGetStarted() async {
    final done = await SharedPref.getOnboardingDone();
    Get.toNamed(done ? AppRoutes.loginScreen : AppRoutes.newUserScreen);
  }

  /* ViewPager based walkthrough — replaced with a static "Get Started" screen.
  final PageController _pageController = PageController();
  int currentPage = 0;

  void _skipWalkthrough() {
    _goToHome();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: Container(
        child: Column(
          children: [
            Expanded(child: Container(
              child: PageView.builder(
                controller: _pageController,
                itemCount: controller.leaderList.length,
                onPageChanged: (index) {
                  setState(() {
                    currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  return Image.network(
                    fit: BoxFit.fill,
                    controller.leaderList[index].bannerImg ?? "",
                  );
                },
              ),
              margin: EdgeInsets.symmetric(vertical: 20),
            )),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.leaderList.length,
                    (index) => Container(
                  margin: const EdgeInsets.all(4),
                  width: currentPage == index ? 12 : 8,
                  height: currentPage == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? Colors.blue
                        : Colors.grey.shade400,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(left: 18, right: 18,bottom: 10),
                  height: 45,
                  width: 150,
                  child: AppComponents.appButton("Skip", onTap: () {
                        _goToHome();
                      }, textSize: 14),
                ),
                Spacer(),
                Container(
                  margin: EdgeInsets.only(left: 18, right: 18,bottom: 10),
                  height: 45,
                  width: 150,
                  child: AppComponents.appButton(currentPage == controller.leaderList.length - 1 ? "Get Started" : "Next",
                      onTap: () {
                        if (currentPage < controller.leaderList.length - 1) {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        } else {
                          _goToHome();
                        }
                      }, textSize: 14),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
        padding: EdgeInsets.only(top: 20),
      ),bottom: true,),
    );
  }
  */

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              AppImages.splashBackground,
              fit: BoxFit.cover,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              left: MediaQuery.of(context).size.width * 0.16,
              right: MediaQuery.of(context).size.width * 0.16,
              child: Image.asset(
                AppImages.spendrathonCard,
                fit: BoxFit.contain,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: BlurContainerWrapper(
                showClip: true,

                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextMedium(
                      l10n.startJourneyTitle,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      textAlign: TextAlign.center,
                      height: 1.25,
                    ),
                    const SizedBox(height: 12),
                    TextRegular(
                      l10n.walkthroughSubtitle,
                      fontSize: 14,
                      textAlign: TextAlign.center,
                      height: 1.4,
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      title: l10n.getStarted,
                      leadingImage: AppImages.sparkle,
                      onPressed: _onGetStarted,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextRegular(
                          l10n.areYouNewHere,
                          fontSize: 13,
                          color: Colors.grey.shade600,
                        ),
                        InkWell(
                          onTap: () => Get.toNamed(AppRoutes.signUpScreen),
                          child: TextMedium(
                            l10n.signUp,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF2F7FFF),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
