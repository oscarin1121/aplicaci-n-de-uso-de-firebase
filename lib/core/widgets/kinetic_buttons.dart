import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class KineticPrimaryButton extends StatelessWidget {
  const KineticPrimaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isExpanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final BorderRadius borderRadius = BorderRadius.circular(22);
    final bool isDisabled = onPressed == null || isLoading;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: borderRadius,
        gradient: isDisabled
            ? LinearGradient(
                colors: <Color>[
                  AppColors.surfaceContainerHigh,
                  AppColors.surfaceContainer,
                ],
              )
            : AppColors.primaryGradient,
        boxShadow: isDisabled
            ? const <BoxShadow>[]
            : <BoxShadow>[
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 28,
                  spreadRadius: 2,
                  offset: const Offset(0, 12),
                ),
              ],
      ),
      child: TextButton(
        onPressed: isDisabled ? null : onPressed,
        style: TextButton.styleFrom(
          minimumSize: Size(isExpanded ? double.infinity : 0, 64),
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          textStyle: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.onPrimary,
            fontWeight: FontWeight.w800,
          ),
        ),
        child: Row(
          mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isLoading)
              const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.6,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.onPrimary,
                  ),
                ),
              )
            else ...<Widget>[
              if (icon != null) ...<Widget>[
                Icon(icon, size: 22),
                const SizedBox(width: 12),
              ],
              Text(label),
            ],
          ],
        ),
      ),
    );
  }
}

class KineticSecondaryButton extends StatelessWidget {
  const KineticSecondaryButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isExpanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        minimumSize: Size(isExpanded ? double.infinity : 0, 64),
        foregroundColor: AppColors.onSurface,
        side: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.22),
        ),
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        textStyle: Theme.of(
          context,
        ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
      ),
      child: Row(
        mainAxisSize: isExpanded ? MainAxisSize.max : MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          if (icon != null) ...<Widget>[
            Icon(icon, size: 20),
            const SizedBox(width: 10),
          ],
          Text(label),
        ],
      ),
    );
  }
}
