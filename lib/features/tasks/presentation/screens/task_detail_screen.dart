import 'package:firebase_practice/core/routes/app_route_paths.dart';
import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:firebase_practice/core/utils/date_time_formatters.dart';
import 'package:firebase_practice/core/widgets/kinetic_buttons.dart';
import 'package:firebase_practice/core/widgets/kinetic_card.dart';
import 'package:firebase_practice/core/widgets/kinetic_shell.dart';
import 'package:firebase_practice/features/tasks/domain/entities/task.dart';
import 'package:firebase_practice/features/tasks/presentation/controllers/task_controller.dart';
import 'package:firebase_practice/features/tasks/presentation/widgets/task_status_chip.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TaskDetailScreen extends ConsumerWidget {
  const TaskDetailScreen({super.key, required this.taskId});

  final String taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<Task> taskAsync = ref.watch(taskByIdProvider(taskId));

    return taskAsync.when(
      data: (Task task) => KineticShell(
        showBackButton: true,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _DetailHeader(
                    task: task,
                    onDelete: () => _deleteTask(context, ref, task),
                    onToggleStatus: () => _toggleStatus(context, ref, task),
                    onEdit: () => context.go(AppRoutePaths.edit(task.id)),
                  ),
                  const SizedBox(height: 26),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final bool stacked = constraints.maxWidth < 880;

                          if (stacked) {
                            return Column(
                              children: <Widget>[
                                _DescriptionPanel(task: task),
                                const SizedBox(height: 18),
                                _MetadataPanel(task: task),
                              ],
                            );
                          }

                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: _DescriptionPanel(task: task),
                              ),
                              const SizedBox(width: 18),
                              Expanded(child: _MetadataPanel(task: task)),
                            ],
                          );
                        },
                  ),
                  const SizedBox(height: 26),
                  _InsightSection(task: task),
                ],
              ),
            ),
          ),
        ),
      ),
      loading: () => const KineticShell(
        showBackButton: true,
        child: Center(
          child: CircularProgressIndicator(color: AppColors.primary),
        ),
      ),
      error: (Object error, StackTrace stackTrace) => KineticShell(
        showBackButton: true,
        child: Center(
          child: Text(
            error.toString().replaceFirst('Exception: ', ''),
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ),
    );
  }

  Future<void> _deleteTask(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) async {
    try {
      await ref
          .read(taskMutationControllerProvider.notifier)
          .deleteTask(task.id);

      if (!context.mounted) {
        return;
      }

      context.go(AppRoutePaths.tasks);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }

  Future<void> _toggleStatus(
    BuildContext context,
    WidgetRef ref,
    Task task,
  ) async {
    try {
      await ref
          .read(taskMutationControllerProvider.notifier)
          .setCompletion(task: task, isCompleted: !task.isCompleted);
    } catch (error) {
      if (!context.mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error.toString().replaceFirst('Exception: ', '')),
        ),
      );
    }
  }
}

class _DetailHeader extends StatelessWidget {
  const _DetailHeader({
    required this.task,
    required this.onDelete,
    required this.onToggleStatus,
    required this.onEdit,
  });

  final Task task;
  final VoidCallback onDelete;
  final VoidCallback onToggleStatus;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 14,
          runSpacing: 10,
          children: <Widget>[
            TaskStatusChip(task: task),
            Text(
              task.referenceCode,
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          task.title,
          style: Theme.of(
            context,
          ).textTheme.displayMedium?.copyWith(fontSize: 52),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 14,
          runSpacing: 12,
          children: <Widget>[
            SizedBox(
              width: 220,
              child: KineticSecondaryButton(
                label: 'Delete Task',
                icon: Icons.delete_outline_rounded,
                onPressed: onDelete,
              ),
            ),
            SizedBox(
              width: 260,
              child: KineticPrimaryButton(
                label: task.isCompleted ? 'Reopen Task' : 'Mark as Completed',
                icon: task.isCompleted
                    ? Icons.autorenew_rounded
                    : Icons.check_circle_rounded,
                onPressed: onToggleStatus,
              ),
            ),
            SizedBox(
              width: 180,
              child: KineticSecondaryButton(
                label: 'Edit',
                icon: Icons.edit_rounded,
                onPressed: onEdit,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DescriptionPanel extends StatelessWidget {
  const _DescriptionPanel({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return KineticCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Description',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          Text(
            task.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontSize: 18,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 26),
          Container(
            height: 1,
            color: AppColors.outlineVariant.withValues(alpha: 0.12),
          ),
          const SizedBox(height: 26),
          Text(
            'Technical Requirements',
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppColors.primary),
          ),
          const SizedBox(height: 16),
          if (task.requirements.isEmpty)
            Text(
              'Aún no agregas requerimientos técnicos para esta tarea.',
              style: Theme.of(context).textTheme.bodyLarge,
            )
          else
            ...task.requirements.map(
              (String requirement) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Padding(
                      padding: EdgeInsets.only(top: 4),
                      child: Icon(
                        Icons.fiber_manual_record_rounded,
                        size: 12,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        requirement,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _MetadataPanel extends StatelessWidget {
  const _MetadataPanel({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        KineticCard(
          accentColor: AppColors.primary,
          color: AppColors.surfaceContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Deadline',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                  const Icon(
                    Icons.event_note_rounded,
                    color: AppColors.primary,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                DateTimeFormatters.dueDateLabel(task.dueDate),
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8),
              Text(
                DateTimeFormatters.dueDateHint(task.dueDate),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: task.isOverdue
                      ? AppColors.error
                      : AppColors.primary.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        KineticCard(
          color: AppColors.surfaceContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Labels', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: <Widget>[
                  _LabelChip(
                    label: task.label.isEmpty ? 'Unlabeled' : task.label,
                    color: AppColors.secondary,
                  ),
                  _LabelChip(
                    label: task.priority.formLabel,
                    color: AppColors.tertiary,
                  ),
                  _LabelChip(
                    label: task.referenceCode,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        KineticCard(
          color: AppColors.surfaceContainer,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('History', style: Theme.of(context).textTheme.labelSmall),
              const SizedBox(height: 18),
              _HistoryItem(
                icon: Icons.add_comment_rounded,
                title: 'Created task',
                subtitle: DateTimeFormatters.formatTimestamp(task.createdAt),
              ),
              const SizedBox(height: 14),
              _HistoryItem(
                icon: Icons.edit_rounded,
                title: 'Last edited',
                subtitle: DateTimeFormatters.formatTimestamp(task.updatedAt),
              ),
              if (task.completedAt != null) ...<Widget>[
                const SizedBox(height: 14),
                _HistoryItem(
                  icon: Icons.check_circle_rounded,
                  title: 'Completed at',
                  subtitle: DateTimeFormatters.formatTimestamp(
                    task.completedAt!,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _InsightSection extends StatelessWidget {
  const _InsightSection({required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Learning Context',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Container(
                height: 1,
                color: AppColors.outlineVariant.withValues(alpha: 0.10),
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool stacked = constraints.maxWidth < 760;
            if (stacked) {
              return Column(
                children: <Widget>[
                  _InsightCard(
                    icon: Icons.code_rounded,
                    title: 'Firestore Document',
                    subtitle:
                        '/users/${task.ownerId}/tasks/${task.id}\nReal-time sync ready for listening.',
                  ),
                  const SizedBox(height: 16),
                  _InsightCard(
                    icon: Icons.insights_rounded,
                    title: 'Execution Lens',
                    subtitle: task.isCompleted
                        ? 'La tarea ya cerró su ciclo. Puedes reabrirla o usarla como referencia.'
                        : 'Prioridad ${task.priority.formLabel.toLowerCase()} y estado ${task.statusLabel.toLowerCase()} para seguir iterando.',
                  ),
                ],
              );
            }

            return Row(
              children: <Widget>[
                Expanded(
                  child: _InsightCard(
                    icon: Icons.code_rounded,
                    title: 'Firestore Document',
                    subtitle:
                        '/users/${task.ownerId}/tasks/${task.id}\nReal-time sync ready for listening.',
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _InsightCard(
                    icon: Icons.insights_rounded,
                    title: 'Execution Lens',
                    subtitle: task.isCompleted
                        ? 'La tarea ya cerró su ciclo. Puedes reabrirla o usarla como referencia.'
                        : 'Prioridad ${task.priority.formLabel.toLowerCase()} y estado ${task.statusLabel.toLowerCase()} para seguir iterando.',
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}

class _LabelChip extends StatelessWidget {
  const _LabelChip({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Text(
        label,
        style: Theme.of(
          context,
        ).textTheme.labelMedium?.copyWith(color: color, letterSpacing: 0.8),
      ),
    );
  }
}

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerHigh,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: AppColors.onSurface),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(title, style: Theme.of(context).textTheme.titleSmall),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppColors.outline),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _InsightCard extends StatelessWidget {
  const _InsightCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return KineticCard(
      child: Row(
        children: <Widget>[
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: AppColors.secondary, size: 32),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(title, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(subtitle, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
