import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// Service for optimizing image loading and caching
class ImageOptimizationService {
  /// Build an optimized image widget with caching and progressive loading
  static Widget buildOptimizedImage({
    required String assetPath,
    required BoxFit fit,
    double? width,
    double? height,
    Widget? placeholder,
    Widget? errorWidget,
    bool enableHeroAnimation = false,
  }) {
    // For local assets, use optimized asset loading
    if (assetPath.startsWith('assets/images/')) {
      return _buildOptimizedAssetImage(
        assetPath: assetPath,
        fit: fit,
        width: width,
        height: height,
        placeholder: placeholder,
        errorWidget: errorWidget,
        enableHeroAnimation: enableHeroAnimation,
      );
    }

    // For network images, use cached network image
    return _buildOptimizedNetworkImage(
      imageUrl: assetPath,
      fit: fit,
      width: width,
      height: height,
      placeholder: placeholder,
      errorWidget: errorWidget,
      enableHeroAnimation: enableHeroAnimation,
    );
  }

  static Widget _buildOptimizedAssetImage({
    required String assetPath,
    required BoxFit fit,
    double? width,
    double? height,
    Widget? placeholder,
    Widget? errorWidget,
    bool enableHeroAnimation = false,
  }) {
    Widget imageWidget = Image.asset(
      assetPath,
      fit: fit,
      width: width,
      height: height,
      // Progressive loading with fade animation
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) return child;

        return AnimatedOpacity(
          opacity: frame == null ? 0 : 1,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
          child: child,
        );
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _buildDefaultErrorWidget(width, height);
      },
    );

    // Add hero animation if requested
    if (enableHeroAnimation) {
      return Hero(tag: assetPath, child: imageWidget);
    }

    return imageWidget;
  }

  static Widget _buildOptimizedNetworkImage({
    required String imageUrl,
    required BoxFit fit,
    double? width,
    double? height,
    Widget? placeholder,
    Widget? errorWidget,
    bool enableHeroAnimation = false,
  }) {
    Widget imageWidget = CachedNetworkImage(
      imageUrl: imageUrl,
      fit: fit,
      width: width,
      height: height,
      memCacheHeight: height?.toInt(),
      memCacheWidth: width?.toInt(),
      maxHeightDiskCache: (height ?? 800).toInt(),
      maxWidthDiskCache: (width ?? 800).toInt(),

      // Progressive loading
      progressIndicatorBuilder: (context, url, downloadProgress) {
        return placeholder ??
            _buildDefaultPlaceholder(width, height, downloadProgress.progress);
      },

      errorWidget: (context, url, error) {
        return errorWidget ?? _buildDefaultErrorWidget(width, height);
      },

      // Fade in animation
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
    );

    // Add hero animation if requested
    if (enableHeroAnimation) {
      return Hero(tag: imageUrl, child: imageWidget);
    }

    return imageWidget;
  }

  static Widget _buildDefaultPlaceholder(
    double? width,
    double? height,
    double? progress,
  ) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
            ),
            if (progress != null) ...[
              const SizedBox(height: 8),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static Widget _buildDefaultErrorWidget(double? width, double? height) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: const Center(
        child: Icon(Icons.error_outline, color: Colors.grey, size: 32),
      ),
    );
  }

  /// Preload critical images for better performance
  static Future<void> preloadCriticalImages(BuildContext context) async {
    final imagesToPreload = [
      'assets/images/BUNA3_BlueStory_600x600.webp',
      'assets/images/BUNA3_PinkStory_600x600.webp',
      'assets/images/buna_blue.png',
      'assets/images/buna_black.png',
    ];

    for (final imagePath in imagesToPreload) {
      try {
        await precacheImage(AssetImage(imagePath), context);
      } catch (e) {
        print('Failed to preload image $imagePath: $e');
      }
    }
  }

  /// Get optimized asset path based on device pixel ratio
  static String getOptimizedAssetPath(String basePath, BuildContext context) {
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    // Use WebP variants for BUNA3 images
    if (basePath.contains('BUNA3_BlueStory')) {
      if (devicePixelRatio >= 3.0) {
        return 'assets/images/BUNA3_BlueStory_1200x1200.webp';
      } else if (devicePixelRatio >= 2.0) {
        return 'assets/images/BUNA3_BlueStory_600x600.webp';
      } else {
        return 'assets/images/BUNA3_BlueStory_300x300.webp';
      }
    }
    if (basePath.contains('BUNA3_PinkStory')) {
      if (devicePixelRatio >= 3.0) {
        return 'assets/images/BUNA3_PinkStory_1200x1200.webp';
      } else if (devicePixelRatio >= 2.0) {
        return 'assets/images/BUNA3_PinkStory_600x600.webp';
      } else {
        return 'assets/images/BUNA3_PinkStory_300x300.webp';
      }
    }
    return basePath;
  }

  /// Clear image cache if needed (for debugging or memory management)
  static Future<void> clearImageCache() async {
    await DefaultCacheManager().emptyCache();
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// Get cache statistics for monitoring
  static Map<String, dynamic> getCacheStats() {
    final imageCache = PaintingBinding.instance.imageCache;
    return {
      'currentSize': imageCache.currentSize,
      'maximumSize': imageCache.maximumSize,
      'currentSizeBytes': imageCache.currentSizeBytes,
      'maximumSizeBytes': imageCache.maximumSizeBytes,
      'liveImageCount': imageCache.liveImageCount,
      'pendingImageCount': imageCache.pendingImageCount,
    };
  }
}
