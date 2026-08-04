import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:player/app_controller.dart';
import 'package:player/common_widgets.dart';
import 'package:player/core/theme/app_images.dart';
import 'package:player/data/modal/game/game_list_response.dart';
import 'package:player/data/modal/leaderboard/LeaderboardResponse.dart';
import 'package:player/game/game_controller.dart';
import 'package:player/game/merchant/GameMerchantList.dart';

import '../3dView/home_top_bar.dart';
import '../ui/game_option/game_option_screen.dart';

/// Accent blue used for titles / links (matches the game list screen).
const Color _accentBlue = Color(0xFF0288D1);

/// Status of a participated game — decides which button to render.
enum _GameStatus { complete, incomplete, cont }

/// Screen shown when the player already has participated games. Lists them in
/// the shared yellow "detail card" theme; a NEW GAME button at the bottom
/// starts a fresh game via the [GameOptionScreen].
class ContinueGame extends StatelessWidget {
  const ContinueGame({super.key});

  _GameStatus _statusOf(LeaderboardList g) {
    final s = (g.status ?? "").toLowerCase();
    if (g.completeStatus == 1 || s == "completed" || s == "complete") {
      return _GameStatus.complete;
    }
    if (s == "incomplete") return _GameStatus.incomplete;
    return _GameStatus.cont;
  }

  String _formatDate(LeaderboardList g) {
    final raw = g.gameEndDate ?? g.createdAt;
    if (raw == null || raw.isEmpty) return "";
    try {
      return DateFormat("dd MMM yyyy").format(DateTime.parse(raw)).toUpperCase();
    } catch (_) {
      return raw;
    }
  }

  /// Clock value — shows "00:00:00" when no timer key is present.
  String _timerText(LeaderboardList g) {
    final t = g.endTimerCount ?? g.startTimerCount;
    if (t == null || t.isEmpty) return "00:00:00";
    if (RegExp(r'^\d{1,2}:\d{2}:\d{2}$').hasMatch(t)) return t;
    try {
      final start = DateTime.parse(g.startTimerCount ?? t);
      final end =
          g.endTimerCount != null ? DateTime.parse(g.endTimerCount!) : DateTime.now();
      final d = end.difference(start);
      String two(int n) => n.toString().padLeft(2, '0');
      return "${two(d.inHours)}:${two(d.inMinutes % 60)}:${two(d.inSeconds % 60)}";
    } catch (_) {
      return "00:00:00";
    }
  }

  /// Resumes a participated game straight in the merchant list. The merchant
  /// list only needs the game id on [GameController.gameData] — it fetches the
  /// full detail itself in initState.
  void _openGame(LeaderboardList g) {
    final appC = Get.find<AppController>();
    appC.gameName = g.gameName ?? "";
    appC.gameUniqueId = g.gameUniqueId ?? "";

    final gameC = Get.put(GameController());
    gameC.gameData = GameData(
      gameId: g.id ?? 0,
      gameUniqueId: g.gameUniqueId ?? "",
      gameName: g.gameName ?? "",
      gamePoster: g.gImage ?? "",
      gameZone: appC.gameZone,
      totalOutlet: 0,
      gameEndDate: g.gameEndDate,
      start_timer_count: g.startTimerCount,
      end_timer_count: g.endTimerCount,
      status: g.status,
    );

    Get.to(GameMerchantList());
  }

  @override
  Widget build(BuildContext context) {
    final AppController appC = Get.find<AppController>();
    final double w = MediaQuery.of(context).size.width;
    final double clipRight = ((w - 32 - 42) / 2).clamp(20, w);

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const HomeBlurredBackground(),
          SafeArea(
            child: Column(
              children: [
                const HomeTopBar(),
                SizedBox(height: 8.h),
                // Content-sized yellow card, centered vertically.
                Expanded(
                  child: Center(
                    child: SingleChildScrollView(
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Container(
                            margin: EdgeInsets.fromLTRB(16.w, 24.h, 16.w, 12.h),
                            padding:
                                EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 16.h),
                            constraints: BoxConstraints(
                              maxHeight: MediaQuery.of(context).size.height * .7,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(28.r),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.6)),
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  const Color(0xFFFDF7C0).withOpacity(0.95),
                                  const Color(0xFFFCEFA0).withOpacity(0.96),
                                ],
                              ),
                              boxShadow: const [
                                BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 14,
                                    offset: Offset(0, 6)),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Align(
                                  alignment: Alignment.centerLeft,
                                  child: BackToLoginButton(text: 'Back'),
                                ),
                                SizedBox(height: 10.h),
                                Flexible(
                                  child: Obx(() {
                                    final games = appC.participatedGames;
                                    if (games.isEmpty) {
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            vertical: 24.h),
                                        child: Center(
                                          child: Text(
                                            "No games found",
                                            style: TextStyle(
                                              fontFamily: 'Inter',
                                              fontSize: 14.sp,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF374151),
                                            ),
                                          ),
                                        ),
                                      );
                                    }
                                    return ListView.builder(
                                      shrinkWrap: true,
                                      physics:
                                          const ClampingScrollPhysics(),
                                      padding: EdgeInsets.zero,
                                      itemCount: games.length,
                                      itemBuilder: (_, i) => _gameRow(games[i]),
                                    );
                                  }),
                                ),
                              ],
                            ),
                          ),
                          // Paperclip pinned above the card's top edge.
                          Positioned(
                            top: -30.h,
                            right: clipRight,
                            child:
                                Image.asset(AppImages.paperclip, width: 42),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // NEW GAME button.
                Padding(
                  padding: EdgeInsets.fromLTRB(60.w, 4.h, 60.w, 12.h),
                  child: AppButton(
                    title: "NEW GAME",
                    height: 60,
                    onPressed: () => Get.to(const GameOptionScreen()),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _gameRow(LeaderboardList g) {
    final status = _statusOf(g);
    final bool faded = status != _GameStatus.cont;
    final Color nameColor =
        faded ? const Color(0xFF9AA0A6) : _accentBlue;

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openGame(g),
      child: Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(faded ? 0.28 : 0.45),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _formatDate(g),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w600,
                    color: faded
                        ? const Color(0xFFB0B4BA)
                        : const Color(0xFF6D28D9),
                  ),
                ),
                SizedBox(height: 2.h),
                Text(
                  (g.gameName ?? "").toUpperCase(),
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w800,
                    color: nameColor,
                  ),
                ),
                SizedBox(height: 4.h),
                // timer text
           /*     Row(
                  children: [
                    Image.asset(
                      "assets/images/home/ic_clock.png",
                      height: 18,
                      errorBuilder: (_, __, ___) => Icon(Icons.timer,
                          size: 18,
                          color: faded ? Colors.grey : _accentBlue),
                    ),
                    SizedBox(width: 6.w),
                    Text(
                      _timerText(g),
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: faded
                            ? const Color(0xFFB0B4BA)
                            : const Color(0xFFEF4444),
                      ),
                    ),
                    if ((g.extraTime ?? "").isNotEmpty) ...[
                      SizedBox(width: 8.w),
                      Text(
                        "+${g.extraTime}",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFFEF4444),
                        ),
                      ),
                    ],
                  ],
                ),*/
              ],
            ),
          ),
          SizedBox(width: 12.w),
          _statusButton(g, status),
        ],
      ),
      ),
    );
  }

  Widget _statusButton(LeaderboardList g, _GameStatus status) {
    switch (status) {
      case _GameStatus.complete:
        return _pill(
          "COMPLETE",
          gradient: const [Color(0xFFE4FCB3), Color(0xFF85F629), Color(0xFF85D102)],
          onTap: null,
        );
      case _GameStatus.incomplete:
        return _pill(
          "INCOMPLETE",
          gradient: const [Color(0xFFECECEC), Color(0xFFD9D9D9)],
          textColor: const Color(0xFF6B7280),
          onTap: null,
        );
      case _GameStatus.cont:
        return _pill(
          "CONTINUE",
          gradient: const [Color(0xFFB3E5FC), Color(0xFF29B6F6)],
          onTap: () => _openGame(g),
        );
    }
  }

  Widget _pill(
    String text, {
    required List<Color> gradient,
    Color textColor = Colors.white,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 128,
        height: 54,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: gradient,
          ),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 6, offset: Offset(0, 3)),
          ],
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Inter',
            fontSize: 15.sp,
            fontWeight: FontWeight.w800,
            color: textColor,
          ),
        ),
      ),
    );
  }
}
