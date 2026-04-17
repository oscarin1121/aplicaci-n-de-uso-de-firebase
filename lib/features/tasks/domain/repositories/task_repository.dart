import 'package:firebase_practice/features/tasks/domain/entities/task.dart';

abstract class TaskRepository {
  Stream<List<Task>> watchTasks(String userId);

  Stream<Task> watchTask({required String userId, required String taskId});

  Future<String> saveTask({required String userId, required Task task});

  Future<void> deleteTask({required String userId, required String taskId});

  Future<void> setTaskCompletion({
    required String userId,
    required String taskId,
    required bool isCompleted,
  });
}
