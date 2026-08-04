import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/app_controller.dart';

import '../data/local/shared_prefs.dart';
import '../inventory/inventory_screen.dart';
import '../leaderboard/leaderboardDetail.dart';
import '../routes/app_routes.dart';

/// Path to the home-screen city background (used by home + sub-screens).
const String kHomeBackground = "assets/images/home/bg_homescreenplayer.png";

/// The home-screen city background with a gaussian blur and a light wash,
/// reused by the game-zone / game-list sub-screens.
class HomeBlurredBackground extends StatelessWidget {
  const HomeBlurredBackground({
    super.key,
    this.blurSigma = 18,
    this.washOpacity = 0.08,
  });

  final double blurSigma;
  final double washOpacity;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
            child: Image.asset(kHomeBackground, fit: BoxFit.cover),
          ),
        ),
        Positioned.fill(
          child: Container(color: Colors.white.withOpacity(washOpacity)),
        ),
      ],
    );
  }
}

/// Shared top bar used across the player home and its sub-screens:
/// a circular profile avatar on the left, notification icons and the coin
/// balance pill on the right. Self-contained — it resolves [AppController]
/// itself and handles the avatar / icon taps.
class HomeTopBar extends StatelessWidget {
  const HomeTopBar({
    super.key,
    this.coinAmount = "999,999",
    this.showNotifications = true,
  });

  /// Coin balance shown in the pill.
  final String coinAmount;

  /// Whether to show the briefcase / mail notification icons.
  final bool showNotifications;

  Future<void> _openProfileOrLogin() async {
    final token = await SharedPref.getAccessToken();
    if (token != null) {
      Get.toNamed(AppRoutes.updateProfile);
    } else {
      Get.toNamed(AppRoutes.loginScreen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final appC = Get.find<AppController>();
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: [
          _ProfileAvatar(appC: appC, onTap: _openProfileOrLogin),
          const Spacer(),
          if (showNotifications) ...[
            _TopIconButton(
              icon: Icons.business_center_rounded,
              color: const Color(0xFFB5651D),
              showBadge: true,
              onTap: () =>
                  Get.to(() => LeaderboardDetail(title: "Leaderboard")),
            ),
            const SizedBox(width: 14),
            _TopIconButton(
              icon: Icons.mail_rounded,
              color: const Color(0xFF2E7DDB),
              showBadge: true,
              onTap: () => Get.to(() => InventoryScreen()),
            ),
            const SizedBox(width: 12),
          ],
          _CoinPill(amount: coinAmount),
        ],
      ),
    );
  }
}

/// Circular avatar that shows the user's profile picture, or a placeholder.
class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({required this.appC, required this.onTap});

  final AppController appC;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          border: Border.all(color: Colors.white, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: Obx(() {
            final bool hasData = appC.hasData.value;
            final String pic = appC.profileData?.profilePic ?? "";
            if (hasData && pic.isNotEmpty) {
              return Image.network(
                pic,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _AvatarPlaceholder(),
              );
            }
            return const _AvatarPlaceholder();
          }),
        ),
      ),
    );
  }
}

class _AvatarPlaceholder extends StatelessWidget {
  const _AvatarPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFE3E8F0),
      alignment: Alignment.center,
      child: const Icon(Icons.person, color: Color(0xFF9AA6B8), size: 32),
    );
  }
}

/// A top-bar icon with an optional red notification dot.
class _TopIconButton extends StatelessWidget {
  const _TopIconButton({
    required this.icon,
    required this.color,
    this.showBadge = false,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final bool showBadge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Icon(icon, color: color, size: 30, shadows: const [
            Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 1)),
          ]),
          if (showBadge)
            Positioned(
              right: -2,
              bottom: -2,
              child: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: const Color(0xFFF21C09),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The star + coin-balance pill shown at the top-right.
class _CoinPill extends StatelessWidget {
  const _CoinPill({required this.amount});

  final String amount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(6, 4, 14, 4),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2)),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, color: Color(0xFFF4B400), size: 24),
          const SizedBox(width: 6),
          Text(
            amount,
            style: const TextStyle(
              fontFamily: 'Inter',
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: Color(0xFF223665),
            ),
          ),
        ],
      ),
    );
  }
}
