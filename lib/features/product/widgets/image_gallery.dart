import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_image.dart';

/// Mahsulot rasmlari karuseli. Bosilganda to'liq ekranda zoom qilish mumkin.
class ImageGallery extends StatefulWidget {
  const ImageGallery({super.key, required this.images, required this.heroTag});
  final List<String> images;
  final String heroTag;

  @override
  State<ImageGallery> createState() => _ImageGalleryState();
}

class _ImageGalleryState extends State<ImageGallery> {
  final _controller = PageController();
  int _page = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openViewer() {
    Navigator.of(context).push(
      PageRouteBuilder<void>(
        opaque: false,
        barrierColor: Colors.black,
        pageBuilder: (_, __, ___) => _FullscreenViewer(
          images: widget.images,
          initialIndex: _page,
          heroTag: widget.heroTag,
        ),
        transitionsBuilder: (_, a, __, child) => FadeTransition(opacity: a, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.images.isEmpty ? [''] : widget.images;
    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(
          color: Colors.white,
          child: PageView.builder(
            controller: _controller,
            itemCount: images.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => GestureDetector(
              onTap: _openViewer,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 90, 24, 40),
                child: AppImage(images[i], fit: BoxFit.contain),
              ),
            ),
          ),
        ),
        if (images.length > 1)
          Positioned(
            bottom: 34,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (i) {
                final active = i == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: active ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primary : Colors.black26,
                    borderRadius: BorderRadius.circular(3),
                  ),
                );
              }),
            ),
          ),
        Positioned(
          right: 16,
          bottom: 34,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.45),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.zoom_in_rounded, color: Colors.white, size: 18),
          ),
        ),
      ],
    );
  }
}

class _FullscreenViewer extends StatefulWidget {
  const _FullscreenViewer({required this.images, required this.initialIndex, required this.heroTag});
  final List<String> images;
  final int initialIndex;
  final String heroTag;

  @override
  State<_FullscreenViewer> createState() => _FullscreenViewerState();
}

class _FullscreenViewerState extends State<_FullscreenViewer> {
  late final PageController _controller = PageController(initialPage: widget.initialIndex);
  late int _page = widget.initialIndex;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: widget.images.length,
            onPageChanged: (i) => setState(() => _page = i),
            itemBuilder: (context, i) => InteractiveViewer(
              minScale: 1,
              maxScale: 4,
              child: Center(
                child: AppImage(widget.images[i], fit: BoxFit.contain, width: double.infinity),
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  IconButton.filled(
                    style: IconButton.styleFrom(backgroundColor: Colors.white24),
                    icon: const Icon(Icons.close_rounded, color: Colors.white),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const Spacer(),
                  if (widget.images.length > 1)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${_page + 1} / ${widget.images.length}',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
