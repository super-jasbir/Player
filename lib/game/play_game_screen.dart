import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/app_controller.dart';
import 'package:player/game/game_list_screen.dart';

import '../3dView/home_top_bar.dart';

class SelectGameZone extends StatefulWidget {
  const SelectGameZone({super.key});

  @override
  State<SelectGameZone> createState() => _GameScreenState();
}

class _GameScreenState extends State<SelectGameZone> {
  final AppController controller = Get.find<AppController>();

  // The selectable game zones, in display order (2 per row).
  static const List<String> _zones = [
    "All",
    "East",
    "West",
    "North",
    "South",
    "Central",
    "North West",
    "South West",
    "North East",
    "South East",
  ];

  void _onZoneTap(String zone) {
    controller.gameZone = zone;
    Get.to(GameListScreen());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Blurred city background (shared with the game-list screen).
          const HomeBlurredBackground(),

          SafeArea(
            child: Column(
              children: [
                const HomeTopBar(),
                const SizedBox(height: 12),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    padding: const EdgeInsets.fromLTRB(16, 18, 16, 8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.30),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _Header(onBack: () => Get.back()),
                        const SizedBox(height: 4),
                        const Text(
                          "Please Select The Game Zone",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Expanded(
                          child: _ZoneGrid(
                            zones: _zones,
                            onZoneTap: _onZoneTap,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Card header with the back button (left) and the centered screen title.
class _Header extends StatelessWidget {
  const _Header({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 34,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: InkWell(
              onTap: onBack,
              borderRadius: BorderRadius.circular(8),
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back, size: 20, color: Color(0xFF0288D1)),
                    SizedBox(width: 3),
                    Text(
                      "Back",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF0288D1),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Text(
            "TOURISM GAMES",
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: Color(0xFF1E88E5),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// Scrollable 2-column grid of zone cards.
class _ZoneGrid extends StatelessWidget {
  const _ZoneGrid({required this.zones, required this.onZoneTap});

  final List<String> zones;
  final ValueChanged<String> onZoneTap;

  @override
  Widget build(BuildContext context) {
    final List<Widget> rows = [];
    for (int i = 0; i < zones.length; i += 2) {
      rows.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: Row(
            children: [
              Expanded(
                child: _ZoneCard(
                  label: zones[i],
                  onTap: () => onZoneTap(zones[i]),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: i + 1 < zones.length
                    ? _ZoneCard(
                        label: zones[i + 1],
                        onTap: () => onZoneTap(zones[i + 1]),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      );
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.only(top: 4, bottom: 8),
      child: Column(children: rows),
    );
  }
}

/// A single gradient zone card (142x110 in the design; width flexes to fit).
class _ZoneCard extends StatelessWidget {
  const _ZoneCard({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 110,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB3E5FC),
              Color(0xFF29B6F6),
              Color(0xFF0288D1),
            ],
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            width: 1,
            color: Colors.white.withOpacity(0.667),
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Inter',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            shadows: [
              Shadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1)),
            ],
          ),
        ),
      ),
    );
  }
}
