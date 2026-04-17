import 'package:firebase_practice/features/tasks/domain/entities/task.dart';
import 'package:firebase_practice/features/tasks/domain/repositories/task_repository.dart';

class WatchTask {
  const WatchTask(this._repository);

  final TaskRepository _repository;

  Stream<Task> call({required String userId, required String taskId}) {
    return _repository.watchTask(userId: userId, taskId: taskId);
  }
}
