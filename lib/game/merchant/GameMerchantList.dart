import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';
import 'package:player/app_controller.dart';
import 'package:player/common_widgets.dart';
import 'package:player/core/theme/app_text_styles.dart';
import 'package:player/data/modal/GetMerchantPaymentResponse.dart';
import 'package:player/data/modal/game/game_detail_response.dart'
    show OutletDetail;
import 'package:player/game/merchant/GameMerchantDetail.dart';
import 'package:player/merchant/merchant_controller.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../3dView/home_top_bar.dart';
// ---- imports kept for the OLD UI (see commented block at the bottom) ----
import 'package:player/data/network/api_endpoints.dart';
import 'package:player/utils/app_utils.dart';
import '../../3dView/home_screen_player.dart';
import '../../routes/app_routes.dart';
import '../../utils/app_color.dart';
import '../../utils/app_components.dart';
import '../game_controller.dart';
import 'package:player/core/services/tap_sound.dart';
import 'package:player/core/services/sound_service.dart';

/// Accent blue used for titles / links (matches the login screen).
const Color _accentBlue = Color(0xFF0288D1);

/// Muted grey used for the text of an already-completed shop.
const Color _completedGrey = Color(0xFF9AA0A6);

/// Flat green of the "COMPLETE" badge on a finished shop.
const Color _completeGreen = Color(0xFF6EF03F);

/// Points shown after completing a shop. Static for now — the `commission` the
/// payment API returns is always 0, so the real value is not wired up yet.
const int _earnedPoints = 45;

/// Bonus shown after a successful share. Static for now — nothing credits it
/// server-side yet, so the player's balance does not actually change.
const int _sharePoints = 20;

class GameMerchantList extends StatefulWidget {
  const GameMerchantList({super.key});

  @override
  State<GameMerchantList> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameMerchantList> {
  final GameController controller = Get.put(GameController());
  final AppController appC = Get.find<AppController>();
  final MerchantController merchantC = Get.put(MerchantController());

  DateTime oldTime = DateTime.now();
  DateTime newTime = DateTime.now();
  Timer? _timer;
  Timer? _qrPollTimer;

  /// Incremented every time a QR flow starts or is cancelled. Async callbacks
  /// capture the value at their start and bail out if it has moved on, so a
  /// late API response cannot act on a flow the player already backed out of.
  int _qrSession = 0;
  Duration diff = Duration.zero;
  DateTime now = DateTime.now();

  /// Local path of the selfie captured for the current outlet, attached to the
  /// share sheet in the points dialog.
  String _capturedImagePath = "";

  @override
  void initState() {
    appC.selectedNation;
    controller.getGameDetail(controller.gameData?.gameUniqueId ?? "",
        controller.appController.selectHalalNonHalaValue, () {
      if (!mounted) return;
      setState(() {});
      _setupTimer();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer?.cancel();
    // Stop the looping timer sound when leaving the screen.
    SoundService.instance.stopTimer();
    _cancelQrSession();
    super.dispose();
  }

  /// Starts (or refreshes) the elapsed-time ticker based on the game timers.
  void _setupTimer() {
    final gi = controller.gameInfo.value;
    _timer?.cancel();
    if (gi.end_timer_count == null && gi.start_timer_count != null) {
      oldTime = DateTime.parse(gi.start_timer_count ?? "00:00:00");
      // Timer is running — start the looping timer sound.
      SoundService.instance.startTimerLoop();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (!mounted) return;
        setState(() {
          now = DateTime.now();
          diff = now.difference(oldTime);
        });
      });
    } else if (gi.end_timer_count != null && gi.start_timer_count != null) {
      oldTime = DateTime.parse(gi.start_timer_count ?? "00:00:00");
      newTime = DateTime.parse(gi.end_timer_count ?? "00:00:00");
      diff = newTime.difference(oldTime);
      // Timer already ended — make sure no timer sound is playing.
      SoundService.instance.stopTimer();
    } else {
      SoundService.instance.stopTimer();
    }
  }

  String formatAsHHMMSS(Duration diff) {
    int hours = diff.inHours;
    int minutes = diff.inMinutes % 60;
    int seconds = diff.inSeconds % 60;
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }

  void _refreshGameDetail() {
    controller.getGameDetail(controller.gameData?.gameUniqueId ?? "",
        controller.appController.selectHalalNonHalaValue, () {
      if (!mounted) return;
      setState(() {});
      _setupTimer();
    });
  }

  // ---- SHOW QR flow: fetch the player QR, show it in a dialog, poll for the
  // ---- merchant payment, then show the congratulation dialog. ----
  void _showQrFlow(OutletDetail data) {
    controller.outletDetail = data;
    merchantC.playerDetailsInfo.value = "";
    // Drop any amount left over from a previous outlet so a stale value cannot
    // be mistaken for a payment against this one.
    merchantC.merchantPaymentResponse?.value = GetMerchantPaymentResponse();

    final int session = ++_qrSession;
    _openQrDialog(session);

    merchantC.getPlayerDetail(
        controller.gameData?.gameUniqueId ?? "", data.outletUniqueId, () {
      if (!mounted || session != _qrSession) return;
      _qrPollTimer?.cancel();
      _qrPollTimer = Timer.periodic(const Duration(seconds: 5), (t) {
        if (session != _qrSession) {
          t.cancel();
          return;
        }
        merchantC.getPlayerPaymentDetail(
            controller.gameData?.gameUniqueId ?? "", data.outletId.toString(),
            () {
          if (!mounted || session != _qrSession) return;
          final paid =
              merchantC.merchantPaymentResponse?.value.data?.amountPaid;
          if (paid != null && paid.isNotEmpty) {
            t.cancel();
            _cancelQrSession();
            if (Navigator.canPop(context)) {
              Navigator.of(context).pop(); // close QR dialog
            }
            _showCongratsDialog();
          }
        });
      });
    });
  }

  /// Ends the current QR flow: stops polling and invalidates the session so any
  /// in-flight response from it is ignored.
  void _cancelQrSession() {
    _qrPollTimer?.cancel();
    _qrPollTimer = null;
    _qrSession++;
  }

  void _openQrDialog(int session) {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "QR",
      barrierColor: Colors.black.withOpacity(0.45),
      pageBuilder: (ctx, _, __) {
        return PopScope(
          // The hardware / gesture back also has to end the flow, not just the
          // "Back" label below.
          onPopInvokedWithResult: (didPop, _) {
            if (didPop && session == _qrSession) _cancelQrSession();
          },
          child: Material(
            type: MaterialType.transparency,
            child: Stack(
              children: [
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(color: Colors.black.withOpacity(0.15)),
                  ),
                ),
                SafeArea(
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _infoChip("Show the QR to the merchant."),
                        SizedBox(height: 44.h),
                        Obx(() {
                          final d = merchantC.playerDetailsInfo.value;
                          if (d.isEmpty) {
                            return const SizedBox(
                              height: 260,
                              width: 260,
                              child: Center(
                                child: CupertinoActivityIndicator(
                                    color: Colors.white, radius: 22),
                              ),
                            );
                          }
                          return QrImageView(
                            data: d,
                            version: QrVersions.auto,
                            size: 260,
                            gapless: false,
                            eyeStyle: const QrEyeStyle(
                                eyeShape: QrEyeShape.square,
                                color: Colors.white),
                            dataModuleStyle: const QrDataModuleStyle(
                                dataModuleShape: QrDataModuleShape.square,
                                color: Colors.white),
                          );
                        }),
                        SizedBox(height: 44.h),
                        NoTapSound(
                          child: InkWell(
                          onTap: () {
                            _cancelQrSession();
                            Navigator.of(ctx).pop();
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.arrow_back,
                                  color: Colors.white, size: 20),
                              SizedBox(width: 6.w),
                              Text(
                                "Back",
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showCongratsDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Congrats",
      barrierColor: Colors.black.withOpacity(0.45),
      pageBuilder: (ctx, _, __) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(color: Colors.black.withOpacity(0.10)),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "CONGRATULATION",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          color: _accentBlue,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "To finish the steps process with a selfie",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Image.asset("assets/images/home/ic_selfi.png",
                          height: 140, fit: BoxFit.contain),
                      SizedBox(height: 24.h),
                      AppButton(
                        title: "CONTINUE",
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _captureAndComplete();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // ---- After the congrats dialog: open the camera and upload the selfie, then
  // ---- show the amount-paid dialog. The completion API is NOT called here —
  // ---- it only fires once the player taps SUBMIT. ----
  Future<void> _captureAndComplete() async {
    // Fresh capture each time.
    merchantC.uploadedProfileImage.value = "";
    _capturedImagePath = "";
    await merchantC.pickImage(camera: true);

    // User cancelled the camera / upload failed.
    if (merchantC.uploadedProfileImage.value.isEmpty) {
      Fluttertoast.showToast(msg: "Please capture an image to continue");
      return;
    }

    // Local file of the capture, kept so it can be attached to the share sheet.
    _capturedImagePath = merchantC.path.value;
    _showAmountDialog();
  }

  /// Shows what the player paid at the merchant alongside the selfie they just
  /// captured. SUBMIT is what triggers the game-completion API.
  void _showAmountDialog() {
    final String amount =
        merchantC.merchantPaymentResponse?.value.data?.amountPaid ?? "0";
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Amount",
      barrierColor: Colors.black.withOpacity(0.45),
      pageBuilder: (ctx, _, __) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(color: Colors.black.withOpacity(0.10)),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 24.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "AMOUNT PAID",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          color: _accentBlue,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "SG \$ $amount",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF374151),
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "Submit to complete this shop.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      if (_capturedImagePath.isNotEmpty)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(16.r),
                          child: Image.file(
                            File(_capturedImagePath),
                            height: 160,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(height: 24.h),
                      AppButton(
                        title: "SUBMIT",
                        onPressed: () {
                          Navigator.of(ctx).pop();
                          _submitCompletion();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Fires the game-completion API and celebrates on success.
  void _submitCompletion() {
    // Same "is this the last outlet?" logic as the old GameMerchantDetail.
    bool lastItem = false;
    final int completedCount =
        controller.outletList.where((item) => item.isGameStarted == 1).length;
    if (completedCount == (controller.outletList.length - 1)) {
      lastItem = true;
    }

    merchantC.gameComplete(
      controller.gameData?.gameUniqueId ?? "",
      controller.gameData?.start_timer_count,
      controller.gameData?.end_timer_count,
      appC.gameName,
      lastItem,
      controller.outletDetail?.outletId.toString() ?? "",
      controller.outletDetail?.outletName ?? "",
      () {
        // Refresh the merchant list behind the dialog, then celebrate.
        _refreshGameDetail();
        _showPointsDialog();
      },
    );
  }

  void _showPointsDialog() {
    final String shareText =
        "I just earned $_earnedPoints points on Spendrathon! Join me and start turning your spending into rewards.";
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Points",
      barrierColor: Colors.black.withOpacity(0.45),
      pageBuilder: (ctx, _, __) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(color: Colors.black.withOpacity(0.10)),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "CONGRATULATION",
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          color: _accentBlue,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "You earned $_earnedPoints points.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        "SHARE to earn extra points.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Icon(Icons.star_rounded,
                          size: 110,
                          color: const Color(0xFFF4B400),
                          shadows: const [
                            Shadow(
                                color: Colors.black26,
                                blurRadius: 8,
                                offset: Offset(0, 4)),
                          ]),
                      SizedBox(height: 22.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(
                            icon: Icons.facebook,
                            color: const Color(0xFF1877F2),
                            onTap: () => _share(shareText),
                          ),
                          SizedBox(width: 16.w),
                          _socialButton(
                            icon: Icons.camera_alt,
                            color: const Color(0xFFE1306C),
                            onTap: () => _share(shareText),
                          ),
                          SizedBox(width: 16.w),
                          _socialButton(
                            icon: Icons.chat,
                            color: const Color(0xFF25D366),
                            onTap: () => _share(shareText),
                          ),
                          SizedBox(width: 16.w),
                          _socialButton(
                            icon: Icons.close,
                            color: Colors.black,
                            onTap: () => _share(shareText),
                          ),
                          SizedBox(width: 16.w),
                          _socialButton(
                            icon: Icons.more_horiz,
                            color: const Color(0xFF4FC3F7),
                            onTap: () => _share(shareText),
                          ),
                        ],
                      ),
                      SizedBox(height: 18.h),
                      InkWell(
                        onTap: () => _closeToMerchantList(ctx),
                        child: Text(
                          "CLOSE",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Shares the selfie + text, then — once the player comes back from WhatsApp
  /// (or wherever they shared) — celebrates with the share-successful dialog.
  Future<void> _share(String text) async {
    // Attach the selfie when it is still on disk; text-only otherwise.
    final bool hasImage =
        _capturedImagePath.isNotEmpty && File(_capturedImagePath).existsSync();
    final params = hasImage
        ? ShareParams(text: text, files: [XFile(_capturedImagePath)])
        : ShareParams(text: text);

    ShareResult result;
    try {
      result = await SharePlus.instance.share(params);
    } catch (_) {
      return; // Share sheet failed to open — stay on the points dialog.
    }

    // Backing out of the share sheet earns nothing; let them try again.
    if (result.status == ShareResultStatus.dismissed) return;
    if (!mounted) return;

    // Replace the points dialog with the share-successful one.
    Navigator.of(context).pop();
    _showShareSuccessDialog();
  }

  void _showShareSuccessDialog() {
    showGeneralDialog(
      context: context,
      barrierDismissible: false,
      barrierLabel: "Shared",
      barrierColor: Colors.black.withOpacity(0.45),
      pageBuilder: (ctx, _, __) {
        return Material(
          type: MaterialType.transparency,
          child: Stack(
            children: [
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                  child: Container(color: Colors.black.withOpacity(0.10)),
                ),
              ),
              Center(
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 24.w),
                  padding: EdgeInsets.fromLTRB(24.w, 28.h, 24.w, 20.h),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.92),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: const [
                      BoxShadow(
                          color: Colors.black26,
                          blurRadius: 20,
                          offset: Offset(0, 8)),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "SHARE SUCCESSFUL!",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 26.sp,
                          fontWeight: FontWeight.w900,
                          color: _accentBlue,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      Text(
                        "You earned $_sharePoints extra points for sharing.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 14.sp,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      SizedBox(height: 20.h),
                      Image.asset("assets/images/home/ic_selfi.png",
                          height: 140, fit: BoxFit.contain),
                      SizedBox(height: 24.h),
                      AppButton(
                        title: "DONE",
                        onPressed: () => _closeToMerchantList(ctx),
                      ),
                      SizedBox(height: 12.h),
                      InkWell(
                        onTap: () => _closeToMerchantList(ctx),
                        child: Text(
                          "CLOSE",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.grey.shade600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  /// Ends the shop-completion flow: dismisses the dialog and leaves the player
  /// on the merchant list, with the shop they just finished now marked
  /// complete. The selfie is dropped so it cannot leak into the next shop.
  void _closeToMerchantList(BuildContext dialogContext) {
    Navigator.of(dialogContext).pop();
    _capturedImagePath = "";
    merchantC.uploadedProfileImage.value = "";
    _refreshGameDetail();
  }

  Widget _socialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      customBorder: const CircleBorder(),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child: Icon(icon, color: Colors.white, size: 22),
      ),
    );
  }

  Widget _infoChip(String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: BorderRadius.circular(22.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.info_outline, size: 16, color: Colors.grey.shade600),
          SizedBox(width: 8.w),
          Text(
            text,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // NEW UI
  // =========================================================================
  @override
  Widget build(BuildContext context) {
    final gi = controller.gameInfo.value;
    final timerText =
        (gi.start_timer_count != null || gi.end_timer_count != null)
            ? formatAsHHMMSS(diff)
            : "00:00:00";

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const HomeBlurredBackground(),
          SafeArea(
            child: Column(
              children: [
                _topPanel(timerText),
                Expanded(
                  child: Obx(() {
                    final outlets = controller.outletList;
                    if (outlets.isEmpty) {
                      return Center(
                        child: Text(
                          "No Merchant Available In This Zone",
                          style: TextStyle(
                            fontFamily: 'Inter',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 20.h),
                      itemCount: outlets.length,
                      itemBuilder: (_, i) => _merchantCard(outlets[i]),
                    );
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _topPanel(String timerText) {
    return Container(
      margin: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 8.h),
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.30),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: const [
          BoxShadow(
              color: Colors.black12, blurRadius: 10, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const BackToLoginButton(text: 'Back'),
              const Spacer(),
              Image.asset("assets/images/home/ic_clock.png", height: 30),
              SizedBox(width: 8.w),
              Text(
                timerText,
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w800,
                  color: _accentBlue,
                ),
              ),
              const Spacer(),
            ],
          ),
          SizedBox(height: 10.h),
          Obx(() {
            final outlets = controller.outletList;
            final total = outlets.length;
            final completed = outlets.where((d) => d.isGameStarted == 1).length;
            final progress = total == 0 ? 0.0 : completed / total;
            final pct = (progress * 100).round();
            return Column(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6.r),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 8,
                    backgroundColor: Colors.white.withOpacity(0.6),
                    valueColor:
                        const AlwaysStoppedAnimation<Color>(_accentBlue),
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    Text(
                      "Completed Shop",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF374151),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      "$pct%",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w800,
                        color: _accentBlue,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  /// Static badge shown in place of "SHOW QR" once a shop is done. Not a button
  /// — there is nothing left to do on a completed shop.
  Widget _completeBadge() {
    return Container(
      width: 118,
      height: 60.h,
      decoration: BoxDecoration(
        color: _completeGreen,
        borderRadius: BorderRadius.circular(18.r),
      ),
      alignment: Alignment.center,
      child: Text("COMPLETE", style: AppTextStyles.button),
    );
  }

  /// Opens the outlet's detail screen and refreshes the list on the way back,
  /// so a game started from there is reflected here.
  void _openMerchantDetail(OutletDetail data) {
    controller.outletDetail = data;
    Get.to(GameMerchantDetail())?.then((_) => _refreshGameDetail());
  }

  Widget _merchantCard(OutletDetail data) {
    final bool completed = data.isGameStarted == 1;
    // Completed shops are shown in a muted grey; pending ones keep the blue accent.
    final Color titleColor = completed ? _completedGrey : _accentBlue;
    final Color bodyColor =
        completed ? _completedGrey : const Color(0xFF374151);

    return GestureDetector(
      // The whole card opens the detail screen, not just "View Details".
      // onTap: () => _openMerchantDetail(data),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(completed ? 0.75 : 0.92),
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 6,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    data.outletName,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      color: titleColor,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    data.outletAddress,
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      color: bodyColor,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    "${data.startHours} to ${data.endHours}",
                    style: TextStyle(
                      fontFamily: 'Inter',
                      fontSize: 13.sp,
                      color: bodyColor,
                    ),
                  ),
                  SizedBox(height: 6.h),
                  InkWell(
                    // onTap: () => _openMerchantDetail(data),
                    child: Text(
                      "View Details",
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: titleColor,
                        decoration: TextDecoration.underline,
                        decorationColor: titleColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            completed
                ? _completeBadge()
                : AppButton(
                    title: "SHOW QR",
                    width: 118,
                    height: 60,
                    onPressed: () => _showQrFlow(data),
                  ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// OLD UI (kept for reference — uncomment this block and restore the original
// build() above to revert to the previous design).
// =============================================================================
/*
class _GameScreenStateOld extends State<GameMerchantList> {
  var controller = Get.put(GameController());
  var appC = Get.find<AppController>();

  late DateTime oldTime;
  late DateTime newTime;
  late Timer? _timer;
  Duration diff = Duration.zero;
  DateTime now = DateTime.now();

  @override
  void initState() {
    appC.selectedNation;

    controller.getGameDetail(controller.gameData?.gameUniqueId ?? "",
        controller.appController.selectHalalNonHalaValue, () {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    if(controller.gameInfo.value.end_timer_count==null && controller.gameInfo.value.start_timer_count!=null){
      if(_timer!=null){
        _timer?.cancel();
      }
    }
    super.dispose();
  }

  String formatAsHHMMSS(Duration diff) {
    int hours = diff.inHours;
    int minutes = diff.inMinutes % 60;
    int seconds = diff.inSeconds % 60;

    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(hours)}:${twoDigits(minutes)}:${twoDigits(seconds)}";
  }


  @override
  Widget build(BuildContext context) {

    if(controller.gameInfo.value.end_timer_count==null && controller.gameInfo.value.start_timer_count!=null){
      oldTime = DateTime.parse(controller.gameInfo.value.start_timer_count ?? "00:00:00");

      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        setState(() {
          now = DateTime.now();
          diff = now.difference(oldTime);
        });
      });
    }
    else if(controller.gameInfo.value.end_timer_count!=null && controller.gameInfo.value.start_timer_count!=null){
      oldTime = DateTime.parse(controller.gameInfo.value.start_timer_count ?? "00:00:00");
      newTime = DateTime.parse(controller.gameInfo.value.end_timer_count ?? "00:00:00");

      diff = newTime.difference(oldTime);
    }

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(
                "assets/images/m2/game_bg.png",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.infinity,
              height: double.infinity,
              color: Colors.grey.withOpacity(0.2),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .05,
                  left: 18,
                  right: 18),
              child: Row(
                children: [
                  NoTapSound(
                    child: InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        color: Colors.white,
                      )),
                  ),
                  Spacer(),
                  AppComponents.text("Merchant List",
                      fontWeight: FontWeight.w700,
                      size: 25,
                      color: Colors.white),
                  Spacer(),
                  InkWell(
                      onTap: () {
                        Get.offAll(HomeScreenPlayer());
                      },
                      child: Icon(
                        Icons.home,
                        size: 30,
                        color: Colors.white,
                      )),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * .14,
                  left: 40,
                  right: 40),
              child: Image.asset(
                "assets/images/m2/start_bg_logo.png",
              ),
            ),
            Container(
                margin: EdgeInsets.only(
                    left: 15,
                    bottom: 10,
                    top: MediaQuery.of(context).size.height * .27,
                    right: 15),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/m3/merchant_bg.png"),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      Colors.black,
                      BlendMode.srcIn,
                    ),
                  ),
                ),
                child: Stack(
                  children: [
                    Container(
                      margin: EdgeInsets.only(bottom: 30),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(12)),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                controller.gameInfo.value.start_timer_count != null ? formatAsHHMMSS(diff) :
                                controller.gameInfo.value.end_timer_count != null ? formatAsHHMMSS(diff) : "00:00:00",
                                style: TextStyle(
                                    fontSize: 40, color: Colors.white),
                              ),
                            ),
                            Container(
                                height: MediaQuery.of(context).size.height * .7,
                                margin: EdgeInsets.only(
                                    left: 15, right: 15, top: 0, bottom: 30),
                                child: controller.outletList.isNotEmpty
                                    ? ListView.builder(
                                        itemCount: controller.outletList.length,
                                        itemBuilder: (context, index) {
                                          var data = controller.outletList[index];
                                          return InkWell(
                                            onTap: () {},
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10,bottom: (index + 1) == controller.outletList.length ? 200 : 0),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(12)),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Container(
                                                    height: 50,
                                                    width: 50,
                                                    child: ClipOval(
                                                      child: AppUtils.remoteImageLoader(
                                                          ApiEndPoint
                                                                  .imageBaseUrl +
                                                              "merchant/" +
                                                              data.initalImage),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      SizedBox(
                                                        height: 14,
                                                      ),
                                                      AppComponents.text(
                                                          data.outletName,
                                                          fontWeight:
                                                          FontWeight.w500,
                                                          textOverflow: TextOverflow.clip,
                                                          color: Colors.black),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      AppComponents.text(
                                                          "Business Hours",
                                                          fontWeight:
                                                          FontWeight.w400,
                                                          color: Colors.black),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.timer,
                                                            color: Colors.grey,
                                                            size: 18,
                                                          ),
                                                          SizedBox(
                                                            width: 4,
                                                          ),
                                                          AppComponents.text(
                                                              data.startHours +
                                                                  " - " +
                                                                  data.endHours,
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                              color:
                                                              Colors.black,
                                                              size: 12)
                                                        ],
                                                      ),
                                                      SizedBox(
                                                        height: 6,
                                                      ),
                                                      Container(
                                                        width: 120,
                                                        margin: EdgeInsets.only(
                                                            right: 8),
                                                        child: AppComponents.text(
                                                            "Minimum Spending SG \$ ${data.minimumSpending}",
                                                            size: 13,
                                                            maxLine: 2,
                                                            fontWeight:
                                                            FontWeight.w500,
                                                            color:
                                                            Colors.black),
                                                      ),
                                                      SizedBox(
                                                        width: 8,
                                                      ),
                                                      SizedBox(
                                                        height: 4,
                                                      ),
                                                      InkWell(
                                                          onTap: () {
                                                            controller.outletDetail = data;
                                                            Get.toNamed(AppRoutes.merchantQR,arguments: {
                                                              "game_unique_id":controller.gameData?.gameUniqueId,
                                                            })?.then((v){
                                                              controller.getGameDetail(controller.gameData?.gameUniqueId ?? "",
                                                                  controller.appController.selectHalalNonHalaValue, () {
                                                                    setState(() {
                                                                      if(controller.gameInfo.value.end_timer_count==null && controller.gameInfo.value.start_timer_count!=null){
                                                                        oldTime = DateTime.parse(controller.gameInfo.value.start_timer_count ?? "00:00:00");

                                                                        _timer = Timer.periodic(const Duration(seconds: 1), (_) {
                                                                          setState(() {
                                                                            now = DateTime.now();
                                                                            diff = now.difference(oldTime);
                                                                          });
                                                                        });
                                                                      }
                                                                      else if(controller.gameInfo.value.end_timer_count!=null && controller.gameInfo.value.start_timer_count!=null){
                                                                        oldTime = DateTime.parse(controller.gameInfo.value.start_timer_count ?? "00:00:00");
                                                                        newTime = DateTime.parse(controller.gameInfo.value.end_timer_count ?? "00:00:00");
                                                                        if(_timer!=null){
                                                                          _timer?.cancel();
                                                                        }
                                                                        diff = newTime.difference(oldTime);
                                                                      }
                                                                    });
                                                                  });
                                                            });
                                                          },
                                                          child: AppComponents.text(
                                                              "Click To Start",
                                                              enableUnderLine: true,
                                                              color: AppColors.darkGreen)),
                                                      SizedBox(
                                                        height: 10,
                                                      )
                                                    ],
                                                  )),
                                                  data.isGameStarted == 1
                                                      ? Container(
                                                    height: 25,
                                                    margin: EdgeInsets.only(right: 15,left: 15),
                                                    decoration: BoxDecoration(
                                                        shape: BoxShape
                                                            .circle,
                                                        border: Border.all(
                                                            color: Colors
                                                                .green,
                                                            width: 1)),
                                                    child: Center(
                                                        child: Icon(
                                                          Icons.check,
                                                          color: Colors.green,
                                                          size: 13,
                                                        )),
                                                  ) : Container(),
                                                ],
                                              ),
                                            ),
                                          );
                                        })
                                    : Align(
                                        alignment: Alignment.center,
                                        child: AppComponents.text(
                                            "   No Merchant Available In This Zone    ",
                                            color: Colors.black)))
                          ],
                        ),
                      ),
                    ),
                  ],
                )),
          ],
        ),
      ),
    );
  }
}
*/
