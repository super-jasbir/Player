import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:player/app_controller.dart';
import 'package:player/common_widgets.dart';
import 'package:player/data/network/api_endpoints.dart';
import 'package:player/game/game_controller.dart';

import '../3dView/home_top_bar.dart';
import '../core/theme/app_images.dart';
import '../routes/app_routes.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  State<GameListScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameListScreen> {
  final GameController controller = Get.put(GameController());
  final AppController appC = Get.find<AppController>();

  @override
  void initState() {
    controller.getGameList(appC.gameZone, () {
      setState(() {
        controller.getProfileInfo();
      });
    });
    super.initState();
  }

  /// Opens the selected game — unchanged logic (reset dialog if the game was
  /// already completed, otherwise navigate to the detail screen).
  void _openItem(dynamic data) {
    if (data.status == "COMPLETED") {
      _showResetDialog(data);
    } else {
      controller.gameData = data;
      Get.toNamed(AppRoutes.gameList)?.then((v) {
        controller.getGameList(appC.gameZone, () {
          setState(() {});
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const HomeBlurredBackground(),
          SafeArea(
            child: Column(
              children: [
                const HomeTopBar(showNotifications: false),
                SizedBox(height: 12.h),
                // Spendrathon logo (reused from the game detail screen).
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 32.w),
                  child:
                      Image.asset(AppImages.spendrathonCard, fit: BoxFit.contain),
                ),
                SizedBox(height: 12.h),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 6,right: 12),
                    child: BackToLoginButton(text: 'Back'),
                  ),
                ),
                SizedBox(height: 4.h),
                Expanded(child: _list()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// White signboard banner with corner screws showing the game zone name.
  Widget _signboard() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 20.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Corner screws.
            const Positioned(left: 0, top: 0, child: _Screw()),
            const Positioned(right: 0, top: 0, child: _Screw()),
            const Positioned(left: 0, bottom: 0, child: _Screw()),
            const Positioned(right: 0, bottom: 0, child: _Screw()),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 18.w),
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  (appC.gameZone).toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 34.sp,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 2,
                    color: const Color(0xFF1A1A1A),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _list() {
    return Obx(() {
      // Touch the observable so the list rebuilds when data loads.
      final _ = controller.gameList.length;
      final items = controller.gameList;
      if (items.isEmpty) {
        return Center(
          child: Text(
            "No games found",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }

      return ListView.builder(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
        itemCount: items.length,
        itemBuilder: (_, i) => _gameCard(items[i]),
      );
    });
  }

  Widget _gameCard(dynamic data) {
    final String poster = (data.gamePoster ?? "").toString();
    const String placeholder = "assets/images/ic_game_sample.png";
    final Widget bg = poster.isNotEmpty
        ? Image.network(
            ApiEndPoint.imageBaseUrl + poster,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) =>
                Image.asset(placeholder, fit: BoxFit.cover),
          )
        : Image.asset(placeholder, fit: BoxFit.cover);

    return GestureDetector(
      onTap: () => _openItem(data),
      child: Container(
        margin: EdgeInsets.only(bottom: 16.h),
        height: 178.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Blurred merchant/street background.
              Positioned.fill(child: bg),
              // Transparent overlay layer so the text stays legible (matches Figma).
              Positioned.fill(
                child: Container(color: Colors.black.withOpacity(0.30)),
              ),
              // Centered content.
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Difficulty",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    const _StarRating(rating: 2.5, size: 26),
                    SizedBox(height: 6.h),
                    Text(
                      (data.gameName ?? "").toString().toUpperCase(),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        shadows: const [
                          Shadow(
                            color: Colors.black45,
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 16.w, vertical: 7.h),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFFE1F5FE).withOpacity(0.8),
                            const Color(0xFFB3E5FC).withOpacity(0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(20.r),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF4FC3F7).withOpacity(0.1882),
                            offset: const Offset(0, 2),
                            blurRadius: 8,
                            spreadRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        "Game Complication Track",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF3AA0E3),
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                    InkWell(
                      onTap: () => _openItem(data),
                      child: Text(
                        "View Details",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          decoration: TextDecoration.underline,
                          decorationColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showResetDialog(dynamic data) {
    final name = controller.playername.value;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF2C2C2C),
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24),
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Do you really want to Restart the game? Your previously completed game data will be remain in system.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.white24),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Cancel",
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            controller.resetFromList.value = true;
                            controller.getResetGameFromList(data.gameUniqueId);
                          },
                          child: const Text(
                            "Reset",
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: -35,
              left: 0,
              right: 0,
              child: CircleAvatar(
                backgroundColor: Colors.redAccent,
                radius: 35,
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Star rating row using the Figma gold (#FFE679) with half-star support.
class _StarRating extends StatelessWidget {
  const _StarRating({required this.rating, this.size = 24});

  final double rating;
  final double size;

  static const Color _gold = Color(0xFFFFE679);
  static const Color _empty = Color(0xFFBFC4CC);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        IconData icon;
        if (rating >= i + 1) {
          icon = Icons.star_rounded;
        } else if (rating > i) {
          icon = Icons.star_half_rounded;
        } else {
          icon = Icons.star_rounded;
        }
        final bool isEmpty = rating <= i;
        return Icon(
          icon,
          size: size,
          color: isEmpty ? _empty : _gold,
        );
      }),
    );
  }
}

/// Small grey screw dot used on the signboard corners.
class _Screw extends StatelessWidget {
  const _Screw();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey.shade400,
        border: Border.all(color: Colors.grey.shade500, width: 1),
      ),
      child: Center(
        child: Container(
          width: 5,
          height: 1.4,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }
}
