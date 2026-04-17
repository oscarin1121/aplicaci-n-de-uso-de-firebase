import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class KineticTextField extends StatefulWidget {
  const KineticTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hintText,
    this.icon,
    this.obscureText = false,
    this.maxLines = 1,
    this.keyboardType,
    this.trailing,
    this.validator,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.textInputAction,
  });

  final String label;
  final TextEditingController controller;
  final String? hintText;
  final IconData? icon;
  final bool obscureText;
  final int maxLines;
  final TextInputType? keyboardType;
  final Widget? trailing;
  final String? Function(String?)? validator;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;

  @override
  State<KineticTextField> createState() => _KineticTextFieldState();
}

class _KineticTextFieldState extends State<KineticTextField> {
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
    final BorderRadius borderRadius = BorderRadius.circular(28);

    return ClipRRect(
      borderRadius: borderRadius,
      child: Stack(
        children: <Widget>[
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            curve: Curves.easeOut,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: _hasFocus
                  ? AppColors.surfaceContainerHigh
                  : AppColors.surfaceContainerLow,
              borderRadius: borderRadius,
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.10),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  widget.label,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: AppColors.outline,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: widget.maxLines > 1
                      ? CrossAxisAlignment.start
                      : CrossAxisAlignment.center,
                  children: <Widget>[
                    if (widget.icon != null) ...<Widget>[
                      Padding(
                        padding: EdgeInsets.only(
                          top: widget.maxLines > 1 ? 4 : 0,
                        ),
                        child: Icon(
                          widget.icon,
                          color: _hasFocus
                              ? AppColors.secondary
                              : AppColors.outline,
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                    ],
                    Expanded(
                      child: TextFormField(
                        controller: widget.controller,
                        focusNode: _focusNode,
                        obscureText: widget.obscureText,
                        maxLines: widget.obscureText ? 1 : widget.maxLines,
                        keyboardType: widget.keyboardType,
                        validator: widget.validator,
                        readOnly: widget.readOnly,
                        onTap: widget.onTap,
                        onChanged: widget.onChanged,
                        textInputAction: widget.textInputAction,
                        style: widget.maxLines > 1
                            ? theme.textTheme.bodyLarge?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              )
                            : theme.textTheme.titleMedium?.copyWith(
                                color: AppColors.onSurface,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                        decoration: InputDecoration(
                          isCollapsed: true,
                          hintText: widget.hintText,
                          hintStyle: widget.maxLines > 1
                              ? theme.textTheme.bodyLarge?.copyWith(
                                  color: AppColors.surfaceVariant,
                                )
                              : theme.textTheme.titleMedium?.copyWith(
                                  color: AppColors.surfaceVariant,
                                  fontSize: 22,
                                ),
                        ),
                      ),
                    ),
                    if (widget.trailing != null) ...<Widget>[
                      const SizedBox(width: 12),
                      widget.trailing!,
                    ],
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              width: _hasFocus ? 3 : 0,
              decoration: const BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(28),
                  bottomLeft: Radius.circular(28),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
