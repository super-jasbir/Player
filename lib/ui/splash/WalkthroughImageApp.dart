import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/ui/splash/splash_screen_controller.dart';
import '../../3dView/home_screen_player.dart';
import '../../utils/app_components.dart';
import '../../utils/app_utils.dart';

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

class _WalkthroughImageScreenState extends State<WalkthroughImageScreen>
{
  var controller = Get.find<SplashScreenController>();

  final PageController _pageController = PageController();
  int currentPage = 0;

  void _skipWalkthrough() {
    _goToHome();
  }

  void _goToHome() {
    Get.offAll(HomeScreenPlayer());
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
}
