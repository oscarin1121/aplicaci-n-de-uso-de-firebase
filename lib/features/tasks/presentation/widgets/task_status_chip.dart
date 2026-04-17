import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:firebase_practice/features/tasks/domain/entities/task.dart';
import 'package:flutter/material.dart';

class TaskStatusChip extends StatelessWidget {
  const TaskStatusChip({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    final _TaskStatusPresentation presentation = _statusPresentation(task);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: presentation.background,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        presentation.label.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: presentation.foreground,
          letterSpacing: 1.6,
        ),
      ),
    );
  }

  _TaskStatusPresentation _statusPresentation(Task task) {
    if (task.isCompleted) {
      return _TaskStatusPresentation(
        label: task.statusLabel,
        background: AppColors.surfaceContainerHighest,
        foreground: AppColors.onSurfaceVariant,
      );
    }

    return switch (task.priority) {
      TaskPriority.urgent => _TaskStatusPresentation(
        label: task.statusLabel,
        background: AppColors.errorContainer.withValues(alpha: 0.18),
        foreground: AppColors.error,
      ),
      TaskPriority.high => _TaskStatusPresentation(
        label: task.statusLabel,
        background: AppColors.secondary.withValues(alpha: 0.14),
        foreground: AppColors.secondary,
      ),
      TaskPriority.medium || TaskPriority.low => _TaskStatusPresentation(
        label: task.statusLabel,
        background: AppColors.tertiary.withValues(alpha: 0.14),
        foreground: AppColors.tertiary,
      ),
    };
  }
}

class _TaskStatusPresentation {
  const _TaskStatusPresentation({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;
}
