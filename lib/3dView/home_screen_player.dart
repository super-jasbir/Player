import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:player/app_controller.dart';
import 'package:player/settings.dart';

import '../data/local/shared_prefs.dart';
import '../ui/game_option/game_option_screen.dart';
import 'home_top_bar.dart';

class HomeScreenPlayer extends StatefulWidget {
  const HomeScreenPlayer({super.key});

  @override
  State<HomeScreenPlayer> createState() => _HomeScreenPlayerState();
}

class _HomeScreenPlayerState extends State<HomeScreenPlayer> {
  final AppController appC = Get.find<AppController>();

  // Asset paths for the home screen design.
  static const String _bg = "assets/images/home/bg_homescreenplayer.png";
  static const String _icPlayGame = "assets/images/home/ic_play_game.png";
  static const String _icSettings = "assets/images/home/ic_setting.png";
  static const String _icQuiz = "assets/images/home/ic_quiz.png";
  static const String _icShop = "assets/images/home/ic_shop.png";

  @override
  void initState() {
    super.initState();
    // Load the profile (used for the top-left avatar) shortly after the
    // first frame — keeps the original "fetch profile on open" behaviour.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Timer(const Duration(seconds: 1), () {
        appC.getProfile(() {});
      });
    });
  }

  /// Starts the game if the user is logged in, otherwise prompts to log in.
  Future<void> _startGame() async {
    final token = await SharedPref.getAccessToken();
    if (token != null) {
      Get.to(const GameOptionScreen());
    } else {
      Fluttertoast.showToast(msg: "Please Login To Continue...");
    }
  }

  void _comingSoon(String feature) {
    Fluttertoast.showToast(msg: "$feature coming soon...");
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background city artwork (WALLET + TUTORIAL signs are baked in).
            Positioned.fill(
              child: Image.asset(_bg, fit: BoxFit.cover),
            ),

            // Interactive signboards positioned over the background.
            // Sizes/positions follow the Figma (PLAY GAME board ~129px on a
            // 390px frame => widthFactor ~0.33).
            _Signboard(
              asset: _icSettings,
              leftFactor: 0.02,
              topFactor: 0.505,
              widthFactor: 0.32,
              screen: size,
              onTap: () => Get.to(SettingScreen()),
            ),
            _Signboard(
              asset: _icPlayGame,
              leftFactor: 0.635,
              topFactor: 0.512,
              widthFactor: 0.33,
              screen: size,
              onTap: _startGame,
            ),
            _Signboard(
              asset: _icQuiz,
              leftFactor: 0.07,
              topFactor: 0.63,
              widthFactor: 0.27,
              screen: size,
              onTap: () => _comingSoon("Quiz"),
            ),
            _Signboard(
              asset: _icShop,
              leftFactor: 0.62,
              topFactor: 0.705,
              widthFactor: 0.30,
              screen: size,
              onTap: () => _comingSoon("Shop"),
            ),

            // Top bar: avatar + notifications + coin balance (shared widget).
            const Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: SafeArea(child: HomeTopBar()),
            ),

            // Bottom PLAY button with a notification badge.
            Positioned(
              left: 0,
              right: 0,
              bottom: size.height * 0.05,
              child: Center(
                child: _PlayButton(badgeCount: 3, onTap: _startGame),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// A tappable signboard image placed over the background at a relative position.
class _Signboard extends StatelessWidget {
  const _Signboard({
    required this.asset,
    required this.leftFactor,
    required this.topFactor,
    required this.widthFactor,
    required this.screen,
    required this.onTap,
  });

  final String asset;
  final double leftFactor;
  final double topFactor;
  final double widthFactor;
  final Size screen;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: screen.width * leftFactor,
      top: screen.height * topFactor,
      width: screen.width * widthFactor,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Image.asset(asset, fit: BoxFit.contain),
      ),
    );
  }
}

/// The large blue PLAY button with a red count badge.
class _PlayButton extends StatelessWidget {
  const _PlayButton({required this.badgeCount, required this.onTap});

  final int badgeCount;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 146,
            height: 56,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF6EC6FF), Color(0xFF2E9BE6)],
              ),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: const Text(
              "PLAY",
              style: TextStyle(
                fontFamily: 'Inter',
                fontWeight: FontWeight.w800,
                fontSize: 24,
                letterSpacing: 1.2,
                color: Colors.white,
                shadows: [
                  Shadow(color: Colors.black38, blurRadius: 3, offset: Offset(0, 2)),
                ],
              ),
            ),
          ),
          if (badgeCount > 0)
            Positioned(
              right: -6,
              top: -6,
              child: Container(
                width: 26,
                height: 26,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: const Color(0xFFF21C09),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
                child: Text(
                  "$badgeCount",
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
