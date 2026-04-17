import 'package:firebase_practice/core/routes/app_route_paths.dart';
import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:firebase_practice/core/widgets/kinetic_buttons.dart';
import 'package:firebase_practice/core/widgets/kinetic_shell.dart';
import 'package:firebase_practice/core/widgets/kinetic_text_field.dart';
import 'package:firebase_practice/features/tasks/domain/entities/task.dart';
import 'package:firebase_practice/features/tasks/presentation/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TaskFormScreen extends ConsumerWidget {
  const TaskFormScreen({super.key, this.taskId});

  final String? taskId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (taskId == null) {
      return const _TaskEditorForm();
    }

    final AsyncValue<Task> taskAsync = ref.watch(taskByIdProvider(taskId!));
    return taskAsync.when(
      data: (Task task) => _TaskEditorForm(initialTask: task),
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
}

class _TaskEditorForm extends ConsumerStatefulWidget {
  const _TaskEditorForm({this.initialTask});

  final Task? initialTask;

  @override
  ConsumerState<_TaskEditorForm> createState() => _TaskEditorFormState();
}

class _TaskEditorFormState extends ConsumerState<_TaskEditorForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _titleController;
  late final TextEditingController _labelController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _requirementsController;
  late TaskPriority _priority;
  DateTime? _dueDate;

  bool get _isEditing => widget.initialTask != null;

  @override
  void initState() {
    super.initState();
    final Task? task = widget.initialTask;
    _titleController = TextEditingController(text: task?.title ?? '');
    _labelController = TextEditingController(text: task?.label ?? '');
    _descriptionController = TextEditingController(
      text: task?.description ?? '',
    );
    _requirementsController = TextEditingController(
      text: task?.requirements.join('\n') ?? '',
    );
    _priority = task?.priority ?? TaskPriority.medium;
    _dueDate = task?.dueDate;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _labelController.dispose();
    _descriptionController.dispose();
    _requirementsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(taskMutationControllerProvider).isLoading;

    return KineticShell(
      showBackButton: true,
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 980),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 16,
                    runSpacing: 12,
                    children: <Widget>[
                      Text(
                        _isEditing ? 'Edit Task' : 'Add New Task',
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.secondary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.secondary.withValues(alpha: 0.24),
                          ),
                        ),
                        child: Text(
                          _isEditing ? 'UPDATE MODE' : 'DRAFT MODE',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.secondary),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Initialize una unidad de trabajo con alcance, prioridad, deadline '
                    'y notas técnicas listas para guardarse en Firestore.',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 30),
                  KineticTextField(
                    label: 'Architectural Title',
                    controller: _titleController,
                    hintText: 'e.g., Refactor Firebase Authentication Module',
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Escribe un título.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final bool stacked = constraints.maxWidth < 760;
                          if (stacked) {
                            return Column(
                              children: <Widget>[
                                _PrioritySelectorCard(
                                  value: _priority,
                                  onChanged: (TaskPriority value) {
                                    setState(() => _priority = value);
                                  },
                                ),
                                const SizedBox(height: 20),
                                KineticTextField(
                                  label: 'Contextual Label',
                                  controller: _labelController,
                                  hintText: 'DevOps, UI, Security...',
                                  icon: Icons.label_outline_rounded,
                                ),
                              ],
                            );
                          }

                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: _PrioritySelectorCard(
                                  value: _priority,
                                  onChanged: (TaskPriority value) {
                                    setState(() => _priority = value);
                                  },
                                ),
                              ),
                              const SizedBox(width: 20),
                              Expanded(
                                child: KineticTextField(
                                  label: 'Contextual Label',
                                  controller: _labelController,
                                  hintText: 'DevOps, UI, Security...',
                                  icon: Icons.label_outline_rounded,
                                ),
                              ),
                            ],
                          );
                        },
                  ),
                  const SizedBox(height: 20),
                  _DueDateCard(
                    dueDate: _dueDate,
                    onTap: _pickDate,
                    onClear: _dueDate == null
                        ? null
                        : () => setState(() => _dueDate = null),
                  ),
                  const SizedBox(height: 20),
                  KineticTextField(
                    label: 'Detailed Scope & Technical Notes',
                    controller: _descriptionController,
                    hintText:
                        'Document the requirements, edge cases and architecture constraints...',
                    maxLines: 6,
                    validator: (String? value) {
                      if (value == null || value.trim().length < 12) {
                        return 'Agrega una descripción con un poco más de contexto.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  KineticTextField(
                    label: 'Technical Requirements (one per line)',
                    controller: _requirementsController,
                    hintText:
                        'Implement real-time listeners\nValidate Firestore rules\nImprove UX states',
                    maxLines: 5,
                  ),
                  const SizedBox(height: 28),
                  LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                          final bool stacked = constraints.maxWidth < 640;
                          if (stacked) {
                            return Column(
                              children: <Widget>[
                                KineticPrimaryButton(
                                  label: _isEditing
                                      ? 'Update in Firestore'
                                      : 'Save to Firestore',
                                  icon: Icons.cloud_upload_rounded,
                                  isLoading: isLoading,
                                  onPressed: isLoading ? null : _handleSave,
                                ),
                                const SizedBox(height: 16),
                                KineticSecondaryButton(
                                  label: 'Discard changes',
                                  onPressed: isLoading ? null : _handleDiscard,
                                ),
                              ],
                            );
                          }

                          return Row(
                            children: <Widget>[
                              Expanded(
                                child: KineticPrimaryButton(
                                  label: _isEditing
                                      ? 'Update in Firestore'
                                      : 'Save to Firestore',
                                  icon: Icons.cloud_upload_rounded,
                                  isLoading: isLoading,
                                  onPressed: isLoading ? null : _handleSave,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: KineticSecondaryButton(
                                  label: 'Discard changes',
                                  onPressed: isLoading ? null : _handleDiscard,
                                ),
                              ),
                            ],
                          );
                        },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime now = DateTime.now();
    final DateTime initialDate = _dueDate ?? now.add(const Duration(days: 3));
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 5),
    );

    if (picked == null || !mounted) {
      return;
    }

    setState(() => _dueDate = picked);
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final DateTime now = DateTime.now();
    final Task draft = Task(
      id: widget.initialTask?.id ?? '',
      ownerId: widget.initialTask?.ownerId ?? '',
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim(),
      priority: _priority,
      label: _labelController.text.trim(),
      requirements: _requirementsController.text
          .split('\n')
          .map((String line) => line.trim())
          .where((String line) => line.isNotEmpty)
          .toList(),
      isCompleted: widget.initialTask?.isCompleted ?? false,
      createdAt: widget.initialTask?.createdAt ?? now,
      updatedAt: now,
      dueDate: _dueDate,
      completedAt: widget.initialTask?.completedAt,
      referenceCode: widget.initialTask?.referenceCode ?? '',
    );

    try {
      final String taskId = await ref
          .read(taskMutationControllerProvider.notifier)
          .saveTask(draft);

      if (!mounted) {
        return;
      }

      context.go(AppRoutePaths.detail(taskId));
    } catch (error) {
      _showMessage(error.toString());
    }
  }

  void _handleDiscard() {
    if (context.canPop()) {
      context.pop();
      return;
    }

    context.go(AppRoutePaths.tasks);
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message.replaceFirst('Exception: ', ''))),
    );
  }
}

class _PrioritySelectorCard extends StatelessWidget {
  const _PrioritySelectorCard({required this.value, required this.onChanged});

  final TaskPriority value;
  final ValueChanged<TaskPriority> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.10),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Execution Priority',
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(color: AppColors.outline),
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              const Icon(Icons.priority_high_rounded, color: AppColors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<TaskPriority>(
                    value: value,
                    dropdownColor: AppColors.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(18),
                    isExpanded: true,
                    iconEnabledColor: AppColors.outline,
                    style: Theme.of(context).textTheme.titleMedium,
                    items: TaskPriority.values
                        .map(
                          (TaskPriority priority) =>
                              DropdownMenuItem<TaskPriority>(
                                value: priority,
                                child: Text(priority.formLabel),
                              ),
                        )
                        .toList(),
                    onChanged: (TaskPriority? value) {
                      if (value != null) {
                        onChanged(value);
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _DueDateCard extends StatelessWidget {
  const _DueDateCard({
    required this.dueDate,
    required this.onTap,
    required this.onClear,
  });

  final DateTime? dueDate;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final String label = dueDate == null
        ? 'Tap to define a deadline'
        : '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(28),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: AppColors.outlineVariant.withValues(alpha: 0.10),
          ),
        ),
        child: Row(
          children: <Widget>[
            const Icon(Icons.event_note_rounded, color: AppColors.secondary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Deadline',
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: AppColors.outline),
                  ),
                  const SizedBox(height: 8),
                  Text(label, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
            if (onClear != null)
              IconButton(
                onPressed: onClear,
                icon: const Icon(Icons.close_rounded),
                color: AppColors.outline,
              ),
          ],
        ),
      ),
    );
  }
}
