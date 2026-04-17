import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class LoginFormField extends StatefulWidget {
  const LoginFormField({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    this.hintText,
    this.keyboardType,
    this.obscureText = false,
    this.validator,
    this.textInputAction,
    this.trailing,
  });

  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String? hintText;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextInputAction? textInputAction;
  final Widget? trailing;

  @override
  State<LoginFormField> createState() => _LoginFormFieldState();
}

class _LoginFormFieldState extends State<LoginFormField> {
  late final FocusNode _focusNode;
  bool _hasFocus = false;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode()
      ..addListener(() {
        if (!mounted) {
          return;
        }

        setState(() => _hasFocus = _focusNode.hasFocus);
      });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (widget.label.trim().isNotEmpty) ...<Widget>[
          Text(
            widget.label.toUpperCase(),
            style: theme.textTheme.labelMedium?.copyWith(
              color: AppColors.onSurface,
              fontSize: 12,
              letterSpacing: 2.1,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 14),
        ],
        AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: _hasFocus
                  ? AppColors.secondary.withValues(alpha: 0.22)
                  : AppColors.outlineVariant.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 18),
              Icon(
                widget.icon,
                size: 28,
                color: _hasFocus ? AppColors.secondary : AppColors.outline,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TextFormField(
                  controller: widget.controller,
                  focusNode: _focusNode,
                  obscureText: widget.obscureText,
                  keyboardType: widget.keyboardType,
                  validator: widget.validator,
                  textInputAction: widget.textInputAction,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontSize: 19,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurface,
                  ),
                  decoration: InputDecoration(
                    hintText: widget.hintText,
                    hintStyle: theme.textTheme.titleLarge?.copyWith(
                      fontSize: 19,
                      fontWeight: FontWeight.w500,
                      color: AppColors.outline.withValues(alpha: 0.42),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 22),
                    isDense: true,
                    errorStyle: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                ),
              ),
              if (widget.trailing != null) ...<Widget>[
                widget.trailing!,
                const SizedBox(width: 8),
              ] else
                const SizedBox(width: 18),
            ],
          ),
        ),
      ],
    );
  }
}
