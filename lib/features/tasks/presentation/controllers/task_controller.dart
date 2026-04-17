import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice/core/utils/app_exception.dart';
import 'package:firebase_practice/features/auth/domain/entities/app_user.dart';
import 'package:firebase_practice/features/auth/presentation/controllers/auth_controller.dart';
import 'package:firebase_practice/features/tasks/data/datasources/tasks_remote_data_source.dart';
import 'package:firebase_practice/features/tasks/data/repositories/firestore_task_repository.dart';
import 'package:firebase_practice/features/tasks/domain/entities/task.dart';
import 'package:firebase_practice/features/tasks/domain/repositories/task_repository.dart';
import 'package:firebase_practice/features/tasks/domain/usecases/delete_task.dart';
import 'package:firebase_practice/features/tasks/domain/usecases/save_task.dart';
import 'package:firebase_practice/features/tasks/domain/usecases/set_task_completion.dart';
import 'package:firebase_practice/features/tasks/domain/usecases/watch_task.dart';
import 'package:firebase_practice/features/tasks/domain/usecases/watch_tasks.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final firebaseFirestoreProvider = Provider<FirebaseFirestore>(
  (Ref ref) => FirebaseFirestore.instance,
);

final tasksRemoteDataSourceProvider = Provider<TasksRemoteDataSource>(
  (Ref ref) => TasksRemoteDataSource(ref.watch(firebaseFirestoreProvider)),
);

final taskRepositoryProvider = Provider<TaskRepository>(
  (Ref ref) =>
      FirestoreTaskRepository(ref.watch(tasksRemoteDataSourceProvider)),
);

final watchTasksUseCaseProvider = Provider<WatchTasks>(
  (Ref ref) => WatchTasks(ref.watch(taskRepositoryProvider)),
);

final watchTaskUseCaseProvider = Provider<WatchTask>(
  (Ref ref) => WatchTask(ref.watch(taskRepositoryProvider)),
);

final saveTaskUseCaseProvider = Provider<SaveTask>(
  (Ref ref) => SaveTask(ref.watch(taskRepositoryProvider)),
);

final deleteTaskUseCaseProvider = Provider<DeleteTask>(
  (Ref ref) => DeleteTask(ref.watch(taskRepositoryProvider)),
);

final setTaskCompletionUseCaseProvider = Provider<SetTaskCompletion>(
  (Ref ref) => SetTaskCompletion(ref.watch(taskRepositoryProvider)),
);

final tasksStreamProvider = StreamProvider<List<Task>>((Ref ref) {
  final AppUser? user = ref.watch(currentUserProvider);
  if (user == null) {
    return const Stream<List<Task>>.empty();
  }

  return ref.watch(watchTasksUseCaseProvider)(user.id).map(_sortTasks);
});

final activeTaskCountProvider = Provider<int>((Ref ref) {
  return ref
      .watch(tasksStreamProvider)
      .maybeWhen(
        data: (List<Task> tasks) =>
            tasks.where((Task task) => !task.isCompleted).length,
        orElse: () => 0,
      );
});

final taskByIdProvider = StreamProvider.family<Task, String>((
  Ref ref,
  String taskId,
) {
  final AppUser? user = ref.watch(currentUserProvider);
  if (user == null) {
    throw const AppException('La sesión ya no está disponible.');
  }

  return ref.watch(watchTaskUseCaseProvider)(userId: user.id, taskId: taskId);
});

final taskMutationControllerProvider =
    AsyncNotifierProvider<TaskMutationController, void>(
      TaskMutationController.new,
    );

class TaskMutationController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String> saveTask(Task task) {
    return _run<String>(() async {
      final AppUser user = _requireUser();
      return ref.read(saveTaskUseCaseProvider)(userId: user.id, task: task);
    });
  }

  Future<void> deleteTask(String taskId) {
    return _run<void>(() async {
      final AppUser user = _requireUser();
      await ref.read(deleteTaskUseCaseProvider)(
        userId: user.id,
        taskId: taskId,
      );
    });
  }

  Future<void> setCompletion({required Task task, required bool isCompleted}) {
    return _run<void>(() async {
      final AppUser user = _requireUser();
      await ref.read(setTaskCompletionUseCaseProvider)(
        userId: user.id,
        taskId: task.id,
        isCompleted: isCompleted,
      );
    });
  }

  AppUser _requireUser() {
    final AppUser? user = ref.read(currentUserProvider);
    if (user == null) {
      throw const AppException(
        'Necesitas una sesión activa para editar tareas.',
      );
    }

    return user;
  }

  Future<T> _run<T>(Future<T> Function() action) async {
    state = const AsyncLoading();

    try {
      final T value = await action();
      state = const AsyncData(null);
      return value;
    } catch (error, stackTrace) {
      state = AsyncError(error, stackTrace);
      rethrow;
    }
  }
}

List<Task> _sortTasks(List<Task> tasks) {
  final List<Task> sorted = List<Task>.from(tasks);
  sorted.sort((Task left, Task right) {
    if (left.isCompleted != right.isCompleted) {
      return left.isCompleted ? 1 : -1;
    }

    final int priorityCompare = right.priority.weight.compareTo(
      left.priority.weight,
    );
    if (priorityCompare != 0) {
      return priorityCompare;
    }

    return right.updatedAt.compareTo(left.updatedAt);
  });

  return sorted;
}
