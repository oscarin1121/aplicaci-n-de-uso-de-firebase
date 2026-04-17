import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoginFooter extends StatelessWidget {
  const LoginFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Wrap(
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 18,
          runSpacing: 10,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.72),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'FIREBASE AUTH ACTIVE',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppColors.outline,
                    letterSpacing: 2.4,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            Text(
              'V1.0.4-STABLE',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: AppColors.outlineVariant,
                letterSpacing: 2.4,
                fontSize: 11,
              ),
            ),
          ],
        ),
        const SizedBox(height: 26),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const <Widget>[
            Expanded(child: _FooterLink(label: 'PRIVACY\nPROTOCOL')),
            Expanded(child: _FooterLink(label: 'TERMS OF\nSERVICE')),
            Expanded(child: _FooterLink(label: 'SYSTEM\nSTATUS')),
          ],
        ),
      ],
    );
  }
}

class _FooterLink extends StatelessWidget {
  const _FooterLink({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      textAlign: TextAlign.left,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: AppColors.outline,
        letterSpacing: 1.9,
        fontSize: 11,
        height: 1.9,
      ),
    );
  }
}
