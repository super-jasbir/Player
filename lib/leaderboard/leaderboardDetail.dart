import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/merchant/merchant_controller.dart';
import '../utils/app_components.dart';
import 'package:player/core/services/sound_service.dart';
import 'package:player/core/services/tap_sound.dart';

class LeaderboardDetail extends StatefulWidget {
  String? ID = "";
  String? title = "";

  LeaderboardDetail({super.key, this.ID, this.title});

  @override
  State<LeaderboardDetail> createState() => _GameScreenState();
}

class _GameScreenState extends State<LeaderboardDetail> {
  var controller = Get.put(MerchantController());
  bool _loading = true;

  /// Whether the leaderboard timer has been unlocked with a Time Key. While
  /// false every row shows the "UNLOCK TIME" button; once activated the actual
  /// completion times are revealed.
  bool _timeUnlocked = false;

  // Colours pulled from the Figma design.
  static const Color _blue = Color(0xFF0288D1);
  static const Color _labelGrey = Color(0xFF525252);
  static const Color _valueGrey = Color(0xFF747474);
  static const Color _highlight = Color(0xFF00CCFF);
  static const Color _gold = Color(0xFFF5B301);

  static const LinearGradient _buttonGradient = LinearGradient(
    begin: Alignment.topRight,
    end: Alignment.bottomLeft,
    colors: [Color(0xFFB3E5FC), Color(0xFF29B6F6), Color(0xFF0288D1)],
  );

  String _selectedGameName = "Game A";

  @override
  void initState() {
    super.initState();
    // Play the leaderboard sound when the screen opens.
    SoundService.instance.playLeaderboard();
    // Defer until after the first frame — the API calls trigger getProfile()
    // which updates observables, and doing that during build throws
    // "setState() called during build".
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadGames());
  }

  /// Loads the player's games to populate the "Game A" dropdown, then opens
  /// the leaderboard for the initial game (the one passed in, or the first).
  void _loadGames() {
    controller.leaderboardList(() {
      if (!mounted) return;
      // Pick the initial game: the id passed in, else the first game.
      String initialId = widget.ID ?? "";
      if (initialId.isEmpty && controller.leaderList.isNotEmpty) {
        initialId = controller.leaderList.first.gameUniqueId ?? "";
      }
      if (initialId.isNotEmpty) {
        _selectGame(initialId);
      } else {
        // No games for this player — show the empty/error state.
        setState(() => _loading = false);
      }
    });
  }

  /// Switches the leaderboard to [gameId] and reloads its rankings.
  void _selectGame(String gameId) {
    String name = _selectedGameName;
    for (final g in controller.leaderList) {
      if (g.gameUniqueId == gameId) {
        name = g.gameName ?? name;
        break;
      }
    }
    setState(() {
      _selectedGameName = name;
      _loading = true;
    });
    controller.leaderboardDetail(gameId, () {
      if (mounted) setState(() => _loading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final list = controller.leaderDetail;
    final currentUserId = controller.appController.profileData?.userId;

    dynamic currentUser;
    for (final e in list) {
      if (currentUserId != null &&
          currentUserId.isNotEmpty &&
          e.playerUniqueId == currentUserId) {
        currentUser = e;
        break;
      }
    }

    // Rows shown in the scrollable table: everyone below the podium (rank 4+)
    // except the logged-in player, who gets a pinned highlighted row.
    final rows = list
        .skip(3)
        .where((e) => e.playerUniqueId != currentUserId)
        .toList();

    return Scaffold(
      body: Stack(
        children: [
          // Blurred background image
          Positioned.fill(
            child: ImageFiltered(
              imageFilter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
              child: Image.asset(
                "assets/images/m2/game_bg.png",
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Light-blue sky gradient fading into the blurred background
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Color(0xFF69C3F0),
                    Color(0xFF9BD4F1),
                    Color(0x00FFFFFF),
                  ],
                  stops: [0.0, 0.20, 0.42],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                /// top navigation
                Container(
                  margin: const EdgeInsets.only(top: 10, left: 18, right: 18),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child: NoTapSound(
                          child: InkWell(
                          onTap: () => Get.back(),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.arrow_back_ios_new,
                                  color: Colors.white, size: 16),
                              SizedBox(width: 4),
                              Text(
                                "Back",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                        ),
                      ),
                      AppComponents.text(
                        "LEADERBOARD",
                        fontWeight: FontWeight.w800,
                        size: 22,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                /// game selector
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: PopupMenuButton<String>(
                    onSelected: _selectGame,
                    offset: const Offset(0, 46),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    itemBuilder: (_) => controller.leaderList
                        .map(
                          (g) => PopupMenuItem<String>(
                            value: g.gameUniqueId ?? "",
                            child: Text(g.gameName ?? ""),
                          ),
                        )
                        .toList(),
                    child: Container(
                      height: 40,
                      padding: const EdgeInsets.symmetric(horizontal: 18),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFF1F0F0)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _selectedGameName.isNotEmpty
                                  ? _selectedGameName
                                  : "Game A",
                              style: const TextStyle(
                                  color: Color(0xFF848484), fontSize: 12),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Icon(Icons.keyboard_arrow_down,
                              color: Color(0xFF848484), size: 20),
                        ],
                      ),
                    ),
                  ),
                ),

                if (_loading)
                  const Expanded(
                    child: Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    ),
                  )
                else if (list.isEmpty)
                  Expanded(child: _emptyState())
                else ...[
                const SizedBox(height: 18),

                /// podium (top 3)
                _buildPodium(list),

                const SizedBox(height: 16),

                /// leaderboard table
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.72),
                      borderRadius: BorderRadius.circular(20),
                      border:
                          Border.all(color: Colors.white.withOpacity(0.8)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.12),
                          offset: const Offset(0, 8),
                          blurRadius: 24,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _tableHeader(),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                            children: [
                              for (int i = 0; i < rows.length; i++) ...[
                                if (i > 0) const SizedBox(height: 5),
                                _playerRow(rows[i]),
                              ],
                              // The logged-in player's own row, pinned as the
                              // last entry directly after the list.
                              if (currentUser != null) ...[
                                if (rows.isNotEmpty)
                                  const SizedBox(height: 5),
                                _currentUserRow(currentUser),
                              ],
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                ],

                /// HOME button
                Padding(
                  padding: const EdgeInsets.only(bottom: 16, top: 4),
                  child: _homeButton(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Empty / error state
  // ---------------------------------------------------------------------------
  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_outlined,
                color: Colors.white.withOpacity(0.9), size: 48),
            const SizedBox(height: 12),
            AppComponents.text(
              controller.leaderDetailError.isNotEmpty
                  ? controller.leaderDetailError
                  : controller.leaderListError.isNotEmpty
                      ? controller.leaderListError
                      : "No leaderboard data available",
              color: Colors.white,
              size: 15,
              fontWeight: FontWeight.w600,
              textAlign: TextAlign.center,
              maxLine: 3,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Podium
  // ---------------------------------------------------------------------------
  Widget _buildPodium(List list) {
    final first = list.isNotEmpty ? list[0] : null;
    final second = list.length > 1 ? list[1] : null;
    final third = list.length > 2 ? list[2] : null;

    // Only render podium slots that actually have a player, so a leaderboard
    // with just 1 or 2 entries doesn't show empty/broken avatars.
    final children = <Widget>[
      if (third != null) _podiumItem(third, 3),
      if (first != null) _podiumItem(first, 1),
      if (second != null) _podiumItem(second, 2),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: children,
      ),
    );
  }

  Widget _podiumItem(dynamic player, int place) {
    final bool isFirst = place == 1;
    final double avatar = isFirst ? 90 : 64;

    return SizedBox(
      width: isFirst ? 132 : 112,
      child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 34,
          child: isFirst
              ? const Text("👑", style: TextStyle(fontSize: 32))
              : null,
        ),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              height: avatar,
              width: avatar,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: ClipOval(
                child: _avatarImage(player?.playerImage,
                    iconSize: isFirst ? 40 : 28),
              ),
            ),
            Positioned(
              bottom: -12,
              child: _rankBadge(place),
            ),
          ],
        ),
        const SizedBox(height: 18),
        AppComponents.text(
          player?.playerName ?? "-",
          color: Colors.white,
          size: 14,
          fontWeight: FontWeight.w600,
          maxLine: 1,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 2),
        AppComponents.text(
          "${player?.stationsCompleted ?? 0}pts",
          color: Colors.white,
          size: 12,
          fontWeight: FontWeight.w500,
        ),
      ],
      ),
    );
  }

  Widget _rankBadge(int place) {
    final Color color = place == 1
        ? _gold
        : place == 2
            ? const Color(0xFF29B6F6)
            : const Color(0xFFFF9800);
    final String label = place == 1
        ? "1st"
        : place == 2
            ? "2nd"
            : "3rd";
    return SizedBox(
      width: 40,
      height: 40,
      child: ClipPath(
        clipper: _HexagonClipper(),
        child: Container(
          color: color,
          alignment: Alignment.center,
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Table
  // ---------------------------------------------------------------------------
  Widget _tableHeader() {
    Widget label(String t, {TextAlign align = TextAlign.start}) => Text(
          t,
          textAlign: align,
          style: const TextStyle(color: _labelGrey, fontSize: 10),
        );

    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 6),
      child: Row(
        children: [
          SizedBox(width: 34, child: label("Rank", align: TextAlign.center)),
          const SizedBox(width: 12),
          Expanded(flex: 3, child: label("User")),
          Expanded(
              flex: 2,
              child: label("Pts", align: TextAlign.center)),
          Expanded(
              flex: 3,
              child: label("Time", align: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _playerRow(dynamic player) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.white.withOpacity(0.8)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              "${player.rank ?? ''}",
              textAlign: TextAlign.center,
              style: const TextStyle(color: _valueGrey, fontSize: 14),
            ),
          ),
          const SizedBox(width: 8),
          _avatar(player.playerImage),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              player.playerName ?? "",
              style: const TextStyle(color: _valueGrey, fontSize: 14),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${player.stationsCompleted ?? 0}pts",
              textAlign: TextAlign.center,
              style: const TextStyle(color: _valueGrey, fontSize: 14),
            ),
          ),
          Expanded(
            flex: 3,
            child: _timeCell(player, _valueGrey),
          ),
        ],
      ),
    );
  }

  /// The Time column content: the UNLOCK TIME button while locked, otherwise
  /// the completion time. Wrapped in a FittedBox so the button never overflows
  /// a narrow row.
  Widget _timeCell(dynamic player, Color color) {
    if (_timeUnlocked) {
      return Align(
        alignment: Alignment.centerRight,
        child: _timeText(player.totalTime, color: color),
      );
    }
    return Align(
      alignment: Alignment.centerRight,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerRight,
        child: _unlockButton(),
      ),
    );
  }

  Widget _timeText(String? time, {required Color color}) {
    return Text(
      (time == null || time.isEmpty) ? "--:--:--" : time,
      textAlign: TextAlign.right,
      style: TextStyle(
          color: color, fontSize: 14, fontWeight: FontWeight.bold),
    );
  }

  Widget _currentUserRow(dynamic player) {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: _highlight, width: 2),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 30,
            child: Text(
              "${player.rank ?? ''}",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _blue, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 6),
          _avatar(player.playerImage),
          const SizedBox(width: 10),
          Expanded(
            flex: 3,
            child: Text(
              player.playerName ?? "",
              style: const TextStyle(
                  color: _blue, fontSize: 14, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "${player.stationsCompleted ?? 0}pts",
              textAlign: TextAlign.center,
              style: const TextStyle(
                  color: _blue, fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            flex: 3,
            child: _timeCell(player, _blue),
          ),
        ],
      ),
    );
  }

  Widget _avatar(String? url) {
    return Container(
      height: 30,
      width: 30,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xFF2196F3),
      ),
      child: ClipOval(child: _avatarImage(url, iconSize: 18)),
    );
  }

  /// Loads a remote avatar, falling back to a person placeholder when the URL
  /// is empty or fails — never attempts to load an empty asset (which crashes).
  Widget _avatarImage(String? url, {double iconSize = 24}) {
    if (url == null || url.isEmpty) {
      return _avatarPlaceholder(iconSize);
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _avatarPlaceholder(iconSize),
    );
  }

  Widget _avatarPlaceholder(double iconSize) {
    return Container(
      color: const Color(0xFFB0BEC5),
      alignment: Alignment.center,
      child: Icon(Icons.person, color: Colors.white, size: iconSize),
    );
  }

  Widget _unlockButton() {
    return InkWell(
      onTap: () => _showTimeKeyDialog(),
      child: Container(
        height: 24,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          gradient: _buttonGradient,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.67)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.lock, color: Colors.white, size: 10),
            SizedBox(width: 5),
            Text(
              "UNLOCK TIME",
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _homeButton() {
    return InkWell(
      onTap: () => Get.until((route) => route.isFirst),
      child: Container(
        width: 84,
        height: 52,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFE1F5FE), Color(0xFFB3E5FC)],
          ),
          borderRadius: BorderRadius.circular(40),
          border: Border.all(color: Colors.white, width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4FC3F7).withOpacity(0.35),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.home_outlined, color: _blue, size: 22),
            SizedBox(height: 1),
            Text(
              "HOME",
              style: TextStyle(
                color: _blue,
                fontSize: 9,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Time Key dialogs (confirm -> activated)
  // ---------------------------------------------------------------------------
  void _showTimeKeyDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => _keyDialogCard(
        header: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppComponents.text("TIME KEY",
                color: _blue, size: 26, fontWeight: FontWeight.w800),
            const SizedBox(height: 6),
            AppComponents.text("Confirm to use?",
                color: const Color(0xFF6B6B6B),
                size: 13,
                fontWeight: FontWeight.w500),
          ],
        ),
        buttonText: "USE",
        onButton: () {
          Navigator.pop(context);
          setState(() => _timeUnlocked = true);
          _showActivatedDialog();
        },
        showClose: true,
      ),
    );
  }

  void _showActivatedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _keyDialogCard(
        header: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppComponents.text("ACTIVATED",
                color: _blue, size: 26, fontWeight: FontWeight.w800),
            const SizedBox(height: 6),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(color: Color(0xFF6B6B6B), fontSize: 13),
                children: [
                  TextSpan(text: "Power card - "),
                  TextSpan(
                    text: "TIME KEY",
                    style: TextStyle(
                        color: _blue, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            AppComponents.text("Leaderboard timer have been unlock.",
                color: const Color(0xFF6B6B6B),
                size: 13,
                textAlign: TextAlign.center),
          ],
        ),
        buttonText: "DONE",
        onButton: () => Navigator.pop(context),
        showClose: false,
      ),
    );
  }

  /// Frosted-glass dialog with a golden key illustration, a full-width blue
  /// action button, and an optional underlined CLOSE link.
  Widget _keyDialogCard({
    required Widget header,
    required String buttonText,
    required VoidCallback onButton,
    bool showClose = false,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 22),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.78),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.85)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 24,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                header,
                const SizedBox(height: 12),
                Transform.rotate(
                  angle: -0.35,
                  child: const Text("🔑", style: TextStyle(fontSize: 88)),
                ),
                const SizedBox(height: 22),
                InkWell(
                  onTap: onButton,
                  child: Container(
                    height: 52,
                    width: double.infinity,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF6CC5F2), Color(0xFF2196E0)],
                      ),
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF2196E0).withOpacity(0.4),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      buttonText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                if (showClose) ...[
                  const SizedBox(height: 14),
                  InkWell(
                    onTap: () => Navigator.pop(context),
                    child: const Text(
                      "CLOSE",
                      style: TextStyle(
                        color: Color(0xFF6B6B6B),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A pointy-top hexagon used for the podium rank badges (1st / 2nd / 3rd).
class _HexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final double w = size.width;
    final double h = size.height;
    return Path()
      ..moveTo(w * 0.5, 0)
      ..lineTo(w, h * 0.25)
      ..lineTo(w, h * 0.75)
      ..lineTo(w * 0.5, h)
      ..lineTo(0, h * 0.75)
      ..lineTo(0, h * 0.25)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
