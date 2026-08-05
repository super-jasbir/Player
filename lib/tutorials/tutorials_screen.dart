import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:player/3dView/home_top_bar.dart';
import 'package:player/utils/app_components.dart';

import 'tutorial_detail_screen.dart';
import 'package:player/core/services/tap_sound.dart';

/// A single tutorial entry. Both [thumbnail] and [videoUrl] are network URLs
/// (with a local asset fallback for the thumbnail) — swap them for the real
/// tutorial content (or an API response) when available.
class TutorialItem {
  final String title;
  final String thumbnail;
  final String videoUrl;

  const TutorialItem({
    required this.title,
    required this.thumbnail,
    required this.videoUrl,
  });
}

/// The tutorials list screen: the shared top bar, the SPENDRATHON plaque, a
/// "TUTORIALS" title and a scrollable list of video thumbnails that open the
/// [TutorialDetailScreen] player when tapped.
class TutorialsScreen extends StatelessWidget {
  TutorialsScreen({super.key});

  static const Color _blue = Color(0xFF0288D1);

  final List<TutorialItem> tutorials = const [
    TutorialItem(
      title: "Getting Started",
      thumbnail:
          "https://images.unsplash.com/photo-1542751371-adc38448a05e?w=800&q=80",
      videoUrl: "https://assets.mixkit.co/videos/47140/47140-720.mp4",
    ),
    TutorialItem(
      title: "How to Play",
      thumbnail:
          "https://images.unsplash.com/photo-1552820728-8b83bb6b773f?w=800&q=80",
      videoUrl: "https://assets.mixkit.co/videos/40460/40460-720.mp4",
    ),
  ];

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
                const HomeTopBar(),
                const SizedBox(height: 12),

                /// SPENDRATHON plaque
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: Image.asset(
                    "assets/images/m2/start_bg_logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 16),

                AppComponents.text(
                  "TUTORIALS",
                  color: Colors.white,
                  size: 20,
                  fontWeight: FontWeight.w800,
                ),
                const SizedBox(height: 16),

                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                    children: [
                      for (final t in tutorials) _videoCard(t),
                      const SizedBox(height: 8),
                      _backButton(),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _videoCard(TutorialItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => Get.to(() => TutorialDetailScreen(item: item)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white.withOpacity(0.6)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.network(
                  item.thumbnail,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    );
                  },
                  errorBuilder: (_, __, ___) => Image.asset(
                    "assets/images/m2/ic_video_bg.png",
                    fit: BoxFit.cover,
                  ),
                ),
                Container(color: Colors.black.withOpacity(0.08)),
                Center(
                  child: Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.85),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.play_arrow_rounded,
                        color: _blue, size: 40),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _backButton() {
    return Center(
      child: NoTapSound(
        child: InkWell(
        onTap: () => Get.back(),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.arrow_back, color: Colors.white, size: 18),
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
    );
  }
}
