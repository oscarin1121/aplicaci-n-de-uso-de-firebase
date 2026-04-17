import 'package:firebase_practice/core/routes/app_route_paths.dart';
import 'package:firebase_practice/core/theme/app_colors.dart';
import 'package:firebase_practice/core/widgets/kinetic_shell.dart';
import 'package:firebase_practice/features/auth/domain/entities/app_user.dart';
import 'package:firebase_practice/features/auth/presentation/controllers/auth_controller.dart';
import 'package:firebase_practice/features/tasks/domain/entities/task.dart';
import 'package:firebase_practice/features/tasks/presentation/controllers/task_controller.dart';
import 'package:firebase_practice/features/tasks/presentation/widgets/task_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class TaskListScreen extends ConsumerWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<Task>> tasksAsync = ref.watch(tasksStreamProvider);
    final int activeTaskCount = ref.watch(activeTaskCountProvider);
    final AppUser? user = ref.watch(currentUserProvider);

    return KineticShell(
      selectedSection: ConsoleSection.tasks,
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(AppRoutePaths.newTask),
        backgroundColor: AppColors.primary,
        foregroundColor: AppColors.onPrimary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: const Icon(Icons.add_rounded, size: 30),
      ),
      child: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 940),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _TaskDashboardHero(
                  activeTaskCount: activeTaskCount,
                  developerName: user?.preferredName,
                ),
                const SizedBox(height: 36),
                const _QueueHeader(),
                const SizedBox(height: 24),
                tasksAsync.when(
                  data: (List<Task> tasks) {
                    if (tasks.isEmpty) {
                      return const _EmptyQueue();
                    }

                    return Column(
                      children: tasks
                          .map(
                            (Task task) => Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: TaskTile(
                                task: task,
                                onTap: () =>
                                    context.go(AppRoutePaths.detail(task.id)),
                                onEdit: () =>
                                    context.go(AppRoutePaths.edit(task.id)),
                                onToggle: () => _toggleTask(context, ref, task),
                              ),
                            ),
                          )
                          .toList(),
                    );
                  },
                  loading: () => const Padding(
                    padding: EdgeInsets.only(top: 32),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  error: (Object error, StackTrace stackTrace) {
                    return _ErrorCard(message: error.toString());
                  },
                ),
                const SizedBox(height: 28),
                _SystemStatusCard(userId: user?.id),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _toggleTask(
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

class _TaskDashboardHero extends StatelessWidget {
  const _TaskDashboardHero({
    required this.activeTaskCount,
    required this.developerName,
  });

  final int activeTaskCount;
  final String? developerName;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool stacked = constraints.maxWidth < 720;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHigh,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AppColors.outlineVariant.withValues(alpha: 0.18),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 10,
                    height: 10,
                    decoration: const BoxDecoration(
                      color: AppColors.secondary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text(
                    'LIVE CONSOLE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: AppColors.onSurface,
                      letterSpacing: 2.4,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            if (stacked)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _HeroTitle(developerName: developerName),
                  const SizedBox(height: 20),
                  _HeroStats(activeTaskCount: activeTaskCount),
                ],
              )
            else
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: _HeroTitle(developerName: developerName)),
                  const SizedBox(width: 24),
                  _HeroStats(activeTaskCount: activeTaskCount),
                ],
              ),
          ],
        );
      },
    );
  }
}

class _HeroTitle extends StatelessWidget {
  const _HeroTitle({required this.developerName});

  final String? developerName;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Manage', style: textTheme.displayLarge),
        Text(
          'Sprints.',
          style: textTheme.displayLarge?.copyWith(color: AppColors.primary),
        ),
        const SizedBox(height: 16),
        Text(
          'Sincronizando metadata desde Firestore para ${developerName ?? 'tu consola'} '
          'con una UI pensada para prácticas de Firebase y arquitectura limpia.',
          style: textTheme.bodyLarge?.copyWith(
            color: AppColors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _HeroStats extends StatelessWidget {
  const _HeroStats({required this.activeTaskCount});

  final int activeTaskCount;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              '$activeTaskCount',
              style: Theme.of(
                context,
              ).textTheme.displayMedium?.copyWith(fontSize: 60),
            ),
            const SizedBox(width: 14),
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Text(
                'ACTIVE TASKS',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontSize: 14,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 3,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _QueueHeader extends StatelessWidget {
  const _QueueHeader();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          'PRIORITY QUEUE',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.onSurface,
            letterSpacing: 3.4,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Container(
            height: 1,
            color: AppColors.outlineVariant.withValues(alpha: 0.20),
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.filter_list_rounded,
          color: AppColors.onSurfaceVariant,
          size: 20,
        ),
      ],
    );
  }
}

class _SystemStatusCard extends StatelessWidget {
  const _SystemStatusCard({required this.userId});

  final String? userId;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.10),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.code_rounded,
              color: AppColors.secondary,
              size: 34,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Text.rich(
              TextSpan(
                children: <InlineSpan>[
                  TextSpan(
                    text: 'Connected to ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const TextSpan(
                    text: 'firebase-primary-01',
                    style: TextStyle(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: '. Real-time listeners activos sobre ',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const TextSpan(
                    text: '/users/{uid}/tasks',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  TextSpan(
                    text: '. Session: ${userId ?? 'anonymous'}.',
                    style: Theme.of(context).textTheme.bodyLarge,
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

class _EmptyQueue extends StatelessWidget {
  const _EmptyQueue();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Tu consola está lista.',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 12),
          Text(
            'Crea tu primera tarea para empezar a practicar autenticación, '
            'Firestore y navegación con una estructura limpia.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  const _ErrorCard({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Text(
        message.replaceFirst('Exception: ', ''),
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: AppColors.error),
      ),
    );
  }
}
