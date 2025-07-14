import 'package:flutter/material.dart';

/// Buna Festival Logo Widget
///
/// Displays the appropriate logo based on the current theme:
/// - Light theme: Blue logo
/// - Dark theme: Pink logo
class BunaLogo extends StatelessWidget {
  final double? width;
  final double? height;
  final BoxFit fit;
  final Color? backgroundColor;

  const BunaLogo({
    super.key,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final logoAsset = isDark ? 'assets/buna_pink.png' : 'assets/buna_blue.png';

    return Container(
      width: width,
      height: height,
      color: backgroundColor,
      child: Image.asset(
        logoAsset,
        fit: fit,
        cacheWidth: width != null ? width!.toInt() : null,
        cacheHeight: height != null ? height!.toInt() : null,
        errorBuilder: (context, error, stackTrace) {
          // Fallback to icon if image fails to load
          return Icon(
            Icons.festival,
            size: width ?? height ?? 48,
            color: Theme.of(context).primaryColor,
          );
        },
      ),
    );
  }
}

/// Buna Festival Logo with Text
///
/// Displays the logo with the festival name below it
class BunaLogoWithText extends StatelessWidget {
  final double? logoSize;
  final double? textSize;
  final bool showSubtitle;
  final Color? textColor;
  final MainAxisAlignment alignment;

  const BunaLogoWithText({
    super.key,
    this.logoSize = 64,
    this.textSize = 24,
    this.showSubtitle = true,
    this.textColor,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveTextColor =
        textColor ?? Theme.of(context).colorScheme.onSurface;

    return Column(
      mainAxisAlignment: alignment,
      children: [
        BunaLogo(width: logoSize, height: logoSize),
        const SizedBox(height: 16),
        Text(
          'Buna Festival',
          style: TextStyle(
            fontSize: textSize,
            fontWeight: FontWeight.bold,
            color: effectiveTextColor,
          ),
        ),
        if (showSubtitle) ...[
          const SizedBox(height: 4),
          Text(
            'Art & Culture 2024',
            style: TextStyle(
              fontSize: (textSize ?? 24) * 0.6,
              color: effectiveTextColor.withValues(alpha: 0.7),
            ),
          ),
        ],
      ],
    );
  }
}
