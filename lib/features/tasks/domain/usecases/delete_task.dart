import 'package:firebase_practice/features/tasks/domain/repositories/task_repository.dart';

class DeleteTask {
  const DeleteTask(this._repository);

  final TaskRepository _repository;

  Future<void> call({required String userId, required String taskId}) {
    return _repository.deleteTask(userId: userId, taskId: taskId);
  }
}
