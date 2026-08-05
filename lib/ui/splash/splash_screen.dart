import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/core/services/sound_service.dart';
import 'package:player/ui/splash/splash_screen_controller.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreen();
}

class _SplashScreen extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var controller = Get.put(SplashScreenController());

  late final AnimationController _progressController;

  @override
  void initState() {
    super.initState();

    // Splash sound, capped to 10s and faded out so it blends into the app.
    SoundService.instance.playSplash();

    controller.splashDelay();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..addListener(() {
        setState(() {});
      });
    _progressController.forward();
  }

  @override
  void dispose() {
    _progressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final progress = _progressController.value;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.asset(
              "assets/images/splash_background.jpg",
              fit: BoxFit.cover,
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.08,
              left: MediaQuery.of(context).size.width * 0.16,
              right: MediaQuery.of(context).size.width * 0.16,
              child: Image.asset(
                "assets/images/ic_spendrathon_card.png",
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: 24,
              right: 24,
              bottom: 48,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 8,
                      backgroundColor: Colors.white.withOpacity(0.35),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        Color(0xFF2F8CFF),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Loading assets",
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.85),
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        "${(progress * 100).toInt()}%",
                        style: const TextStyle(
                          color: Color(0xFF2F8CFF),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SpendrathonLogoCard extends StatelessWidget {
  final double logoHeight;

  const _SpendrathonLogoCard({required this.logoHeight});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Image.asset(
            "assets/images/spendrathonLogo.png",
            color: Colors.black,
            height: logoHeight,
            fit: BoxFit.contain,
          ),
          const _CornerDot(top: -4, left: -4),
          const _CornerDot(top: -4, right: -4),
          const _CornerDot(bottom: -4, left: -4),
          const _CornerDot(bottom: -4, right: -4),
        ],
      ),
    );
  }
}

class _CornerDot extends StatelessWidget {
  final double? top;
  final double? bottom;
  final double? left;
  final double? right;

  const _CornerDot({this.top, this.bottom, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade400, width: 0.5),
        ),
      ),
    );
  }
}
