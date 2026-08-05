import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_components.dart';
import 'package:player/core/services/tap_sound.dart';

/// A single inventory entry. Static for now — swap the [items] list for an API
/// response when the inventory endpoint is available.
class InventoryItem {
  final String name;
  final String description;

  const InventoryItem({required this.name, required this.description});
}

/// The player's inventory ("briefcase") screen — a scrollable grid of usable
/// items, styled after the Figma "INVENTORY" design.
class InventoryScreen extends StatelessWidget {
  InventoryScreen({super.key});

  // Palette pulled from the design.
  static const Color _brown = Color(0xFF6E3B2C);
  static const Color _titleBlue = Color(0xFF29ABE2);
  static const Color _navy = Color(0xFF0E2A6B);
  static const Color _orange = Color(0xFFF26A21);
  static const Color _yellow = Color(0xFFFFD400);

  static const LinearGradient _useGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFF8FD8F8), Color(0xFF37B4F0), Color(0xFF1E9AD6)],
  );

  static const LinearGradient _cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFFF5E7D8), Color(0xFFE7D0BC)],
  );

  static const LinearGradient _goldGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF6D365), Color(0xFFC79A3B)],
  );

  // Placeholder inventory — eight identical "Time Controller" items.
  final List<InventoryItem> items = List.generate(
    8,
    (_) => const InventoryItem(
      name: "Time Controller",
      description: "Extend extra 20mins",
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _brown,
      body: Column(
        children: [
          _header(context),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
              itemCount: items.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.72,
              ),
              itemBuilder: (context, index) => _itemCard(context, items[index]),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Header (briefcase lid + handle + latches + back)
  // ---------------------------------------------------------------------------
  Widget _header(BuildContext context) {
    final double topPad = MediaQuery.of(context).padding.top;
    return SizedBox(
      height: topPad + 178,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Blue sky (briefcase exterior) with soft clouds.
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: topPad + 120,
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF7FC5EE), Color(0xFFAFDCF3)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                      top: topPad + 20, left: 30, child: _cloud(60)),
                  Positioned(
                      top: topPad + 55, right: 26, child: _cloud(46)),
                  Positioned(top: topPad + 12, right: 90, child: _cloud(34)),
                ],
              ),
            ),
          ),

          // INVENTORY title.
          Positioned(
            top: topPad + 40,
            left: 0,
            right: 0,
            child: Center(
              child: AppComponents.text(
                "INVENTORY",
                color: Colors.white,
                size: 24,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          // Orange handle-mount bar sitting on the lid seam.
          Positioned(
            top: topPad + 110,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 210,
                height: 18,
                decoration: BoxDecoration(
                  color: _orange,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
            ),
          ),

          // Metal handle (arch).
          Positioned(
            top: topPad + 78,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 150,
                height: 42,
                decoration: const BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Color(0xFFC4C9CE), width: 7),
                    left: BorderSide(color: Color(0xFFC4C9CE), width: 7),
                    right: BorderSide(color: Color(0xFFC4C9CE), width: 7),
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
                ),
              ),
            ),
          ),

          // Gold latches.
          Positioned(top: topPad + 108, left: 48, child: _latch()),
          Positioned(top: topPad + 108, right: 48, child: _latch()),

          // Back button.
          Positioned(
            top: topPad + 150,
            left: 16,
            child: NoTapSound(
              child: InkWell(
              onTap: () => Get.back(),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                  const SizedBox(width: 6),
                  AppComponents.text(
                    "Back",
                    color: Colors.white,
                    size: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ],
              ),
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cloud(double size) {
    return Container(
      width: size,
      height: size * 0.5,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.55),
        borderRadius: BorderRadius.circular(size),
      ),
    );
  }

  Widget _latch() {
    return Container(
      width: 46,
      height: 20,
      decoration: BoxDecoration(
        gradient: _goldGradient,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF8A6D2B)),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Item card
  // ---------------------------------------------------------------------------
  Widget _itemCard(BuildContext context, InventoryItem item) {
    return Container(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 12),
      decoration: BoxDecoration(
        gradient: _cardGradient,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.6)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _timeControllerIcon(),
          Column(
            children: [
              AppComponents.text(
                item.name,
                color: _titleBlue,
                size: 16,
                fontWeight: FontWeight.w800,
                maxLine: 1,
              ),
              const SizedBox(height: 2),
              AppComponents.text(
                item.description,
                color: const Color(0xFF6B5B52),
                size: 12,
                fontWeight: FontWeight.w500,
                maxLine: 1,
              ),
            ],
          ),
          _useButton(context, item),
        ],
      ),
    );
  }

  Widget _useButton(BuildContext context, InventoryItem item) {
    return InkWell(
      onTap: () => _showUseDialog(context, item),
      child: Container(
        height: 40,
        width: double.infinity,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: _useGradient,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1E9AD6).withOpacity(0.4),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: AppComponents.text(
          "USE",
          color: Colors.white,
          size: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // "USE" dialog flow: confirm -> activated (see Figma screenshots).
  // ---------------------------------------------------------------------------
  void _showUseDialog(BuildContext context, InventoryItem item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => _powerCardDialog(
        title: item.name.toUpperCase(),
        subtitle: const Text(
          "Confirm to use?",
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color(0xFF8A8A8A),
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        primaryLabel: "USE",
        onPrimary: () {
          Navigator.of(dialogCtx).pop();
          _showActivatedDialog(context, item);
        },
        showClose: true,
        onClose: () => Navigator.of(dialogCtx).pop(),
      ),
    );
  }

  void _showActivatedDialog(BuildContext context, InventoryItem item) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (dialogCtx) => _powerCardDialog(
        title: "ACTIVATED",
        subtitle: Text.rich(
          TextSpan(
            style: const TextStyle(
              color: Color(0xFF5A5A5A),
              fontSize: 15,
              fontWeight: FontWeight.w500,
            ),
            children: [
              const TextSpan(text: "Power card - "),
              TextSpan(
                text: item.name,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const TextSpan(text: "\nhave been activate."),
            ],
          ),
          textAlign: TextAlign.center,
        ),
        primaryLabel: "DONE",
        onPrimary: () => Navigator.of(dialogCtx).pop(),
        showClose: false,
      ),
    );
  }

  Widget _powerCardDialog({
    required String title,
    required Widget subtitle,
    required String primaryLabel,
    required VoidCallback onPrimary,
    required bool showClose,
    VoidCallback? onClose,
  }) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(22, 26, 22, 22),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.92),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppComponents.text(
              title,
              color: _titleBlue,
              size: 26,
              fontWeight: FontWeight.w900,
            ),
            const SizedBox(height: 8),
            subtitle,
            const SizedBox(height: 22),
            SizedBox(
              width: 120,
              height: 114,
              child: FittedBox(
                fit: BoxFit.contain,
                child: _timeControllerIcon(),
              ),
            ),
            const SizedBox(height: 26),
            InkWell(
              onTap: onPrimary,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                height: 54,
                width: double.infinity,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: _useGradient,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF1E9AD6).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: AppComponents.text(
                  primaryLabel,
                  color: Colors.white,
                  size: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            if (showClose) ...[
              const SizedBox(height: 12),
              InkWell(
                onTap: onClose,
                child: AppComponents.text(
                  "CLOSE",
                  color: const Color(0xFF8A8A8A),
                  size: 14,
                  fontWeight: FontWeight.w700,
                  enableUnderLine: true,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Stopwatch + lightning "Time Controller" icon (drawn, no asset).
  // ---------------------------------------------------------------------------
  Widget _timeControllerIcon() {
    return SizedBox(
      width: 82,
      height: 78,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          // Alarm bells.
          Positioned(top: 6, left: 16, child: _bell(-0.5)),
          Positioned(top: 6, right: 16, child: _bell(0.5)),
          // Top button (crown).
          Positioned(
            top: 2,
            child: Container(
              width: 14,
              height: 9,
              decoration: BoxDecoration(
                color: _orange,
                borderRadius: BorderRadius.circular(3),
              ),
            ),
          ),
          // Motion lines.
          Positioned(
            left: 0,
            top: 34,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _motionLine(16),
                const SizedBox(height: 4),
                _motionLine(11),
                const SizedBox(height: 4),
                _motionLine(7),
              ],
            ),
          ),
          // Main dial.
          Container(
            width: 58,
            height: 58,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _navy,
              border: Border.all(color: _orange, width: 4),
            ),
            child: const Icon(Icons.bolt, color: _yellow, size: 34),
          ),
        ],
      ),
    );
  }

  Widget _bell(double angle) {
    return Transform.rotate(
      angle: angle,
      child: Container(
        width: 14,
        height: 14,
        decoration: const BoxDecoration(
          color: _orange,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(8),
            topRight: Radius.circular(8),
            bottomLeft: Radius.circular(3),
            bottomRight: Radius.circular(3),
          ),
        ),
      ),
    );
  }

  Widget _motionLine(double width) {
    return Container(
      width: width,
      height: 3,
      decoration: BoxDecoration(
        color: _navy,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
