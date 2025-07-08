import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:io';

/// Service for optimizing image loading and caching
class ImageOptimizationService {
  static const Duration _cacheExpiry = Duration(days: 7);
  static const int _memCacheSize = 100; // Number of images in memory cache
  
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
    if (assetPath.startsWith('assets/')) {
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
    // Try to use WebP version if available (better compression)
    final webpPath = assetPath.replaceAll(RegExp(r'\.(png|jpg|jpeg)$'), '.webp');
    
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
      return Hero(
        tag: assetPath,
        child: imageWidget,
      );
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
        return placeholder ?? _buildDefaultPlaceholder(
          width,
          height,
          downloadProgress.progress,
        );
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
      return Hero(
        tag: imageUrl,
        child: imageWidget,
      );
    }

    return imageWidget;
  }

  static Widget _buildDefaultPlaceholder(double? width, double? height, double? progress) {
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
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
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
        child: Icon(
          Icons.error_outline,
          color: Colors.grey,
          size: 32,
        ),
      ),
    );
  }

  /// Preload critical images for better performance
  static Future<void> preloadCriticalImages(BuildContext context) async {
    final imagesToPreload = [
      'assets/BUNA3_BlueStory.png',
      'assets/buna_blue.png',
      'assets/buna_black.png',
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
    
    // Use appropriate resolution variant
    if (devicePixelRatio >= 3.0) {
      final path3x = basePath.replaceAll('.', '_3x.');
      // Check if 3x variant exists (in a real app, you'd check the asset bundle)
      return path3x;
    } else if (devicePixelRatio >= 2.0) {
      final path2x = basePath.replaceAll('.', '_2x.');
      // Check if 2x variant exists
      return path2x;
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