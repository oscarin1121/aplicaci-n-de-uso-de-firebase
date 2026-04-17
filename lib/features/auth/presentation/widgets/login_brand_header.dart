import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoginBrandHeader extends StatelessWidget {
  const LoginBrandHeader({super.key, required this.subtitle});

  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      children: <Widget>[
        Container(
          width: 74,
          height: 74,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.14),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.36),
                blurRadius: 28,
                offset: const Offset(0, 14),
              ),
            ],
          ),
          child: const Icon(
            Icons.terminal_rounded,
            size: 36,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 34),
        Text(
          'Kinetic Dev',
          textAlign: TextAlign.center,
          style: textTheme.displayMedium?.copyWith(
            fontSize: 44,
            fontWeight: FontWeight.w700,
            letterSpacing: -1.6,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle.toUpperCase(),
          textAlign: TextAlign.center,
          style: textTheme.labelMedium?.copyWith(
            color: AppColors.outline,
            fontSize: 15,
            letterSpacing: 4.8,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
