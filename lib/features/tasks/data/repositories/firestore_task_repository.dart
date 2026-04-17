import 'package:firebase_practice/features/tasks/data/datasources/tasks_remote_data_source.dart';
import 'package:firebase_practice/features/tasks/domain/entities/task.dart';
import 'package:firebase_practice/features/tasks/domain/repositories/task_repository.dart';

class FirestoreTaskRepository implements TaskRepository {
  const FirestoreTaskRepository(this._remoteDataSource);

  final TasksRemoteDataSource _remoteDataSource;

  @override
  Future<void> deleteTask({required String userId, required String taskId}) {
    return _remoteDataSource.deleteTask(userId: userId, taskId: taskId);
  }

  @override
  Future<String> saveTask({required String userId, required Task task}) {
    return _remoteDataSource.saveTask(userId: userId, task: task);
  }

  @override
  Future<void> setTaskCompletion({
    required String userId,
    required String taskId,
    required bool isCompleted,
  }) {
    return _remoteDataSource.setTaskCompletion(
      userId: userId,
      taskId: taskId,
      isCompleted: isCompleted,
    );
  }

  @override
  Stream<Task> watchTask({required String userId, required String taskId}) {
    return _remoteDataSource.watchTask(userId: userId, taskId: taskId);
  }

  @override
  Stream<List<Task>> watchTasks(String userId) {
    return _remoteDataSource.watchTasks(userId);
  }
}
