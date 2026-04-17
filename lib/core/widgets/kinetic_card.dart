import 'dart:ui';

import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class KineticCard extends StatelessWidget {
  const KineticCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(24),
    this.color,
    this.glass = false,
    this.accentColor,
    this.borderRadius,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color? color;
  final bool glass;
  final Color? accentColor;
  final BorderRadius? borderRadius;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = borderRadius ?? BorderRadius.circular(28);
    final Widget card = ClipRRect(
      borderRadius: radius,
      child: Stack(
        children: <Widget>[
          Container(
            padding: padding,
            decoration: BoxDecoration(
              color: (color ?? AppColors.surfaceContainerLow).withValues(
                alpha: glass ? 0.78 : 1,
              ),
              borderRadius: radius,
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.12),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.onSurface.withValues(alpha: 0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: child,
          ),
          if (accentColor != null)
            Positioned(
              left: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: 4,
                decoration: BoxDecoration(
                  color: accentColor!,
                  borderRadius: BorderRadius.only(
                    topLeft: radius.topLeft,
                    bottomLeft: radius.bottomLeft,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    if (!glass) {
      return card;
    }

    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: card,
      ),
    );
  }
}
