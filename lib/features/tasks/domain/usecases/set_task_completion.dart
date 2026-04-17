import 'package:firebase_practice/features/tasks/domain/repositories/task_repository.dart';

class SetTaskCompletion {
  const SetTaskCompletion(this._repository);

  final TaskRepository _repository;

  Future<void> call({
    required String userId,
    required String taskId,
    required bool isCompleted,
  }) {
    return _repository.setTaskCompletion(
      userId: userId,
      taskId: taskId,
      isCompleted: isCompleted,
    );
  }
}
