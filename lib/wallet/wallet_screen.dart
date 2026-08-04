import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../core/theme/app_fonts.dart';
import '../core/theme/app_images.dart';
import 'models/wallet_data.dart';
import 'wallet_controller.dart';
import 'widgets/wallet_glass_card.dart';

/// The wallet screen: a blurred cityscape scene, a glass avatar + points chip
/// header, the blue TOTAL BALANCE card with the "How to use" note, a glass
/// TRANSACTION history card and the floating HOME pill.
///
/// Laid out with absolute positions against the 390x844 Figma frame (the frame
/// ScreenUtil is initialised with in main.dart), so `.w`/`.h` map 1:1 onto the
/// design coordinates.
class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(WalletController());

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const _WalletBackground(),
          const _WalletTopBar(),

          // ---- Balance card + transaction history ----
          // Laid out in a column so the balance card can grow (when the "How
          // to use" note expands) without ever overlapping the transaction
          // card below it.
          Positioned(
            left: 0,
            right: 0,
            top: 89.h,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 342.w, child: const _BalanceCard()),
                SizedBox(height: 12.h),
                SizedBox(
                  width: 370.w,
                  height: 231.h,
                  child: const _TransactionCard(),
                ),
              ],
            ),
          ),

          // ---- Home pill ----
          Positioned(
            top: 761.h,
            left: 0,
            right: 0,
            child: Align(
              child: _HomePill(onTap: () => Get.back()),
            ),
          ),
        ],
      ),
    );
  }
}

/// The cityscape photo behind the wallet, softened by a light backdrop blur so
/// the glass cards stay legible (Figma node 25:602: 10px blur over the scene).
class _WalletBackground extends StatelessWidget {
  const _WalletBackground();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.walletBackground, fit: BoxFit.cover),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.white.withOpacity(0.04)),
          ),
        ],
      ),
    );
  }
}

/// Glass avatar chip (left) and points chip (right) pinned to the top.
class _WalletTopBar extends StatelessWidget {
  const _WalletTopBar();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: 20.w,
          top: 24.h,
          child: SizedBox(
            width: 50.w,
            height: 50.w,
            child: WalletGlassCard(
              child: ClipOval(
                child: Image.asset(
                  AppImages.walletAvatar,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
        Positioned(left: 291.w, top: 37.h, child: const _PointsChip()),
      ],
    );
  }
}

/// Star + points balance pill at the top right (e.g. "999,999").
class _PointsChip extends StatelessWidget {
  const _PointsChip();

  @override
  Widget build(BuildContext context) {
    final WalletController c = Get.find<WalletController>();
    return SizedBox(
      width: 82.w,
      height: 25.h,
      child: WalletGlassCard(
        padding: EdgeInsets.only(left: 5.w, right: 8.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SvgPicture.asset(AppImages.walletStarChip, width: 16.w, height: 19.h),
            SizedBox(width: 8.w),
            Obx(
              () => Text(
                c.wallet.value?.points ?? '—',
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: kWalletBlue,
                  height: 1.56,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The blue TOTAL BALANCE card: label, star + balance + info icon, masked card
/// number and the overlaid "How to use" note.
class _BalanceCard extends StatelessWidget {
  const _BalanceCard();

  @override
  Widget build(BuildContext context) {
    final WalletController c = Get.find<WalletController>();
    return Container(
      padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 16.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xE64FC3F7), Color(0xE65E8DE8)],
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x334FC3F7),
            blurRadius: 24,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "TOTAL BALANCE",
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Colors.white,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 6.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(AppImages.walletStar, width: 20.w, height: 24.h),
              SizedBox(width: 8.w),
              Obx(
                () => Text(
                  c.wallet.value?.totalBalance ?? "—",
                  style: TextStyle(
                    fontFamily: AppFonts.family,
                    fontSize: 32.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    height: 1.0,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Padding(
                padding: EdgeInsets.only(top: 6.h),
                child: GestureDetector(
                  onTap: c.toggleHowToUse,
                  behavior: HitTestBehavior.opaque,
                  child: Obx(
                    () => Icon(
                      c.showHowToUse.value
                          ? Icons.info_rounded
                          : Icons.info_outline,
                      size: 18.w,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          const _CardChip(),
          SizedBox(height: 16.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Obx(
                  () => Text(
                    c.wallet.value?.maskedCardNumber ?? "",
                    style: TextStyle(
                      fontFamily: AppFonts.family,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Image.asset(AppImages.walletLogo, height: 24.h),
            ],
          ),
          // Shown only when the info icon is tapped.
          Obx(() {
            if (!c.showHowToUse.value) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.only(top: 12.h),
              child: _HowToUse(steps: c.wallet.value?.howToUse ?? const []),
            );
          }),
        ],
      ),
    );
  }
}

/// The gold EMV-style chip on the balance card. Drawn rather than shipped as
/// an asset: a rounded gold plate with the contact grid etched into it.
class _CardChip extends StatelessWidget {
  const _CardChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40.w,
      height: 30.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6.r),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF7D774), Color(0xFFE0A93D)],
        ),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 2, offset: Offset(0, 1)),
        ],
      ),
      child: CustomPaint(painter: _CardChipPainter()),
    );
  }
}

/// Etches the chip's contact pattern: a centre pad with lines fanning out.
class _CardChipPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint line = Paint()
      ..color = const Color(0x99A9781F)
      ..strokeWidth = 1.1
      ..style = PaintingStyle.stroke;

    final double w = size.width;
    final double h = size.height;
    final Rect pad = Rect.fromCenter(
      center: Offset(w / 2, h / 2),
      width: w * 0.42,
      height: h * 0.5,
    );
    final RRect padR = RRect.fromRectAndRadius(pad, const Radius.circular(2));

    // Horizontal contacts (left and right of the centre pad).
    canvas.drawLine(Offset(0, h * 0.5), Offset(pad.left, h * 0.5), line);
    canvas.drawLine(Offset(pad.right, h * 0.5), Offset(w, h * 0.5), line);
    // Vertical contacts (above and below the centre pad).
    canvas.drawLine(Offset(w * 0.5, 0), Offset(w * 0.5, pad.top), line);
    canvas.drawLine(Offset(w * 0.5, pad.bottom), Offset(w * 0.5, h), line);
    // Diagonal corner contacts.
    canvas.drawLine(Offset(w * 0.16, h * 0.16), pad.topLeft, line);
    canvas.drawLine(Offset(w * 0.84, h * 0.16), pad.topRight, line);
    canvas.drawLine(Offset(w * 0.16, h * 0.84), pad.bottomLeft, line);
    canvas.drawLine(Offset(w * 0.84, h * 0.84), pad.bottomRight, line);

    canvas.drawRRect(padR, line);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// The translucent "How to use" note overlaying the lower half of the balance
/// card, with a heading and numbered instructions.
class _HowToUse extends StatelessWidget {
  const _HowToUse({required this.steps});

  final List<String> steps;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.82),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "How to use:",
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 6.h),
          for (int i = 0; i < steps.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: i == steps.length - 1 ? 0 : 6.h),
              child: Text(
                "${i + 1}. ${steps[i]}",
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                  height: 1.3,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// The glass TRANSACTION history card: a header row and one white row per
/// transaction, plus a page indicator.
class _TransactionCard extends StatelessWidget {
  const _TransactionCard();

  @override
  Widget build(BuildContext context) {
    final WalletController c = Get.find<WalletController>();
    return WalletGlassCard(
      radius: 20,
      boxShadow: kWalletGlassShadow,
      padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "TRANSACTION",
            style: TextStyle(
              fontFamily: AppFonts.family,
              fontSize: 14.sp,
              fontWeight: FontWeight.w800,
              color: kWalletBlue,
            ),
          ),
          SizedBox(height: 10.h),
          const _TxnHeaderRow(),
          SizedBox(height: 6.h),
          Expanded(
            child: Obx(() {
              if (c.loading.value && c.wallet.value == null) {
                return const Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: kWalletBlue,
                    ),
                  ),
                );
              }
              final txns = c.wallet.value?.transactions ?? const [];
              return ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: txns.length,
                separatorBuilder: (_, __) => SizedBox(height: 5.h),
                itemBuilder: (_, i) => _TxnRow(txn: txns[i]),
              );
            }),
          ),
          SizedBox(height: 4.h),
          Center(
            child: Text(
              "1",
              style: TextStyle(
                fontFamily: AppFonts.family,
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF878787),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Shared column layout for the transaction table (header + rows).
class _TxnColumns extends StatelessWidget {
  const _TxnColumns({
    required this.points,
    required this.qty,
    required this.date,
    required this.time,
    required this.item,
    required this.style,
  });

  final String points;
  final String qty;
  final String date;
  final String time;
  final String item;
  final TextStyle style;

  Widget _cell(String text, int flex, TextAlign align) => Expanded(
        flex: flex,
        child: Text(text, textAlign: align, style: style),
      );

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _cell(points, 22, TextAlign.left),
        _cell(qty, 14, TextAlign.center),
        _cell(date, 30, TextAlign.center),
        _cell(time, 26, TextAlign.center),
        _cell(item, 26, TextAlign.right),
      ],
    );
  }
}

/// Grey column headers of the transaction table.
class _TxnHeaderRow extends StatelessWidget {
  const _TxnHeaderRow();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      child: _TxnColumns(
        points: "Pts",
        qty: "Qty",
        date: "Date",
        time: "Time",
        item: "Item",
        style: TextStyle(
          fontFamily: AppFonts.family,
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xFF525252),
        ),
      ),
    );
  }
}

/// A single white transaction row.
class _TxnRow extends StatelessWidget {
  const _TxnRow({required this.txn});

  final WalletTransaction txn;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30.h,
      padding: EdgeInsets.symmetric(horizontal: 14.w),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: const [
          BoxShadow(color: Color(0x26000000), blurRadius: 5),
        ],
      ),
      child: _TxnColumns(
        points: txn.points,
        qty: "${txn.quantity}",
        date: txn.date,
        time: txn.time,
        item: txn.item,
        style: TextStyle(
          fontFamily: AppFonts.family,
          fontSize: 10.sp,
          fontWeight: FontWeight.w600,
          color: kWalletBlue,
        ),
      ),
    );
  }
}

/// Floating glass "HOME" button pinned near the bottom of the wallet screen.
class _HomePill extends StatelessWidget {
  const _HomePill({this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap ?? () => Get.back(),
      child: SizedBox(
        width: 78.w,
        height: 46.h,
        child: WalletGlassCard(
          boxShadow: kWalletGlassShadow,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(AppImages.walletHome, width: 27.w, height: 18.h),
              SizedBox(height: 2.h),
              Text(
                "HOME",
                style: TextStyle(
                  fontFamily: AppFonts.family,
                  fontSize: 8.sp,
                  fontWeight: FontWeight.w700,
                  color: kWalletBlue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
