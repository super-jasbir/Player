import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/utils/app_components.dart';
import 'package:video_player/video_player.dart';

import 'tutorials_screen.dart';
import 'package:player/core/services/tap_sound.dart';

/// Plays a single tutorial video full-screen with standard playback controls
/// (play / pause / seek / fullscreen) via chewie.
class TutorialDetailScreen extends StatefulWidget {
  final TutorialItem item;

  const TutorialDetailScreen({super.key, required this.item});

  @override
  State<TutorialDetailScreen> createState() => _TutorialDetailScreenState();
}

class _TutorialDetailScreenState extends State<TutorialDetailScreen> {
  static const Color _blue = Color(0xFF0288D1);

  VideoPlayerController? _videoController;
  ChewieController? _chewieController;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      final controller =
          VideoPlayerController.networkUrl(Uri.parse(widget.item.videoUrl));
      _videoController = controller;
      await controller.initialize();
      if (!mounted) return;
      setState(() {
        _chewieController = ChewieController(
          videoPlayerController: controller,
          autoPlay: true,
          looping: false,
          allowFullScreen: true,
          aspectRatio: controller.value.aspectRatio,
          materialProgressColors: ChewieProgressColors(
            playedColor: _blue,
            handleColor: _blue,
            bufferedColor: Colors.white54,
            backgroundColor: Colors.white24,
          ),
        );
      });
    } catch (_) {
      if (mounted) setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    _videoController?.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            Expanded(
              child: Center(child: _player()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _topBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 8),
      child: Row(
        children: [
          NoTapSound(
            child: IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
          Expanded(
            child: AppComponents.text(
              widget.item.title,
              color: Colors.white,
              size: 17,
              fontWeight: FontWeight.w700,
              maxLine: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _player() {
    if (_error) {
      return AppComponents.text(
        "Unable to load this video",
        color: Colors.white70,
        size: 14,
      );
    }
    final chewie = _chewieController;
    if (chewie == null || !_videoController!.value.isInitialized) {
      return const CircularProgressIndicator(color: Colors.white);
    }
    return AspectRatio(
      aspectRatio: _videoController!.value.aspectRatio,
      child: Chewie(controller: chewie),
    );
  }
}
