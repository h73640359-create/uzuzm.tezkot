import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_theme.dart';
import '../../../data/models/banner_item.dart';
import '../../../data/sources/demo_banners.dart';
import '../../../navigation/app_routes.dart';

class BannerCarousel extends StatefulWidget {
  const BannerCarousel({super.key});

  @override
  State<BannerCarousel> createState() => _BannerCarouselState();
}

class _BannerCarouselState extends State<BannerCarousel> {
  late final PageController _controller = PageController(viewportFraction: 0.92);
  Timer? _timer;
  int _page = 0;
  final _banners = DemoBanners.all;

  @override
  void initState() {
    super.initState();
    _startAutoPlay();
  }

  void _startAutoPlay() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_controller.hasClients) return;
      final next = (_page + 1) % _banners.length;
      _controller.animateToPage(
        next,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _open(BannerItem b) {
    if (b.categoryId != null) {
      context.push(AppRoutes.categoryPath(b.categoryId!));
    } else if (b.tag != null) {
      context.push(AppRoutes.collectionPath(b.tag!));
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final height = (width * 0.42).clamp(140.0, 210.0);
    return Column(
      children: [
        SizedBox(
          height: height,
          child: Listener(
            onPointerDown: (_) => _timer?.cancel(),
            onPointerUp: (_) => _startAutoPlay(),
            child: PageView.builder(
              controller: _controller,
              itemCount: _banners.length,
              onPageChanged: (i) => setState(() => _page = i),
              itemBuilder: (context, i) {
                return AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    double scale = 1;
                    if (_controller.hasClients && _controller.position.haveDimensions) {
                      final page = _controller.page ?? _page.toDouble();
                      scale = (1 - ((page - i).abs() * 0.06)).clamp(0.9, 1.0);
                    }
                    return Transform.scale(scale: scale, child: child);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: _BannerCard(item: _banners[i], onTap: () => _open(_banners[i])),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(_banners.length, (i) {
            final active = i == _page;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: active ? 20 : 6,
              height: 6,
              decoration: BoxDecoration(
                color: active ? AppColors.primary : context.colors.border,
                borderRadius: BorderRadius.circular(3),
              ),
            );
          }),
        ),
      ],
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.item, required this.onTap});
  final BannerItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(AppRadius.xl),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: item.colors,
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -30,
                child: Icon(item.icon, size: 160, color: Colors.white.withValues(alpha: 0.14)),
              ),
              Positioned(
                right: 24,
                top: 20,
                child: Icon(item.icon, size: 56, color: Colors.white.withValues(alpha: 0.9)),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.22),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        item.badge,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.text.headlineSmall?.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: MediaQuery.sizeOf(context).width * 0.55,
                      child: Text(
                        item.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.text.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
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
}
