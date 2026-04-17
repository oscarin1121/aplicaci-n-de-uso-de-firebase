import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:firebase_practice/core/utils/date_time_formatters.dart';
import 'package:firebase_practice/features/tasks/domain/entities/task.dart';
import 'package:firebase_practice/features/tasks/presentation/widgets/task_status_chip.dart';
import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    super.key,
    required this.task,
    required this.onTap,
    required this.onToggle,
    required this.onEdit,
  });

  final Task task;
  final VoidCallback onTap;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final bool completed = task.isCompleted;
    const BorderRadius borderRadius = BorderRadius.all(Radius.circular(28));

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(28),
        child: ClipRRect(
          borderRadius: borderRadius,
          child: Stack(
            children: <Widget>[
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: completed
                      ? AppColors.surfaceContainer
                      : AppColors.surfaceContainerLow,
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.10),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: completed
                          ? AppColors.primary.withValues(alpha: 0.08)
                          : Colors.black.withValues(alpha: 0.18),
                      blurRadius: 24,
                      offset: const Offset(0, 16),
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _CompletionDot(isCompleted: completed, onTap: onToggle),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            task.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontSize: 20,
                                  decoration: completed
                                      ? TextDecoration.lineThrough
                                      : null,
                                  color: completed
                                      ? AppColors.onSurface.withValues(
                                          alpha: 0.55,
                                        )
                                      : AppColors.onSurface,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Wrap(
                            crossAxisAlignment: WrapCrossAlignment.center,
                            spacing: 12,
                            runSpacing: 8,
                            children: <Widget>[
                              TaskStatusChip(task: task),
                              Text(
                                'Ref: ${task.referenceCode}',
                                style: Theme.of(context).textTheme.labelMedium,
                              ),
                              Text(
                                DateTimeFormatters.relativeUpdate(
                                  task.updatedAt,
                                ),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: AppColors.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_rounded),
                      color: AppColors.onSurface,
                      style: IconButton.styleFrom(
                        backgroundColor: AppColors.surfaceContainerHigh,
                      ),
                    ),
                  ],
                ),
              ),
              if (completed)
                const Positioned(
                  left: 0,
                  top: 0,
                  bottom: 0,
                  child: _CompletedAccent(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompletedAccent extends StatelessWidget {
  const _CompletedAccent();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          bottomLeft: Radius.circular(28),
        ),
      ),
      child: SizedBox(width: 4),
    );
  }
}

class _CompletionDot extends StatelessWidget {
  const _CompletionDot({required this.isCompleted, required this.onTap});

  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isCompleted ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: isCompleted ? AppColors.primary : AppColors.outline,
            width: 2,
          ),
          boxShadow: isCompleted
              ? <BoxShadow>[
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.34),
                    blurRadius: 16,
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: isCompleted
            ? const Icon(
                Icons.check_rounded,
                size: 18,
                color: AppColors.onPrimary,
              )
            : null,
      ),
    );
  }
}
