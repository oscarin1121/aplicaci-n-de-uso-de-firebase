import 'package:firebase_practice/features/tasks/domain/entities/task.dart';
import 'package:firebase_practice/features/tasks/domain/repositories/task_repository.dart';

class SaveTask {
  const SaveTask(this._repository);

  final TaskRepository _repository;

  Future<String> call({required String userId, required Task task}) {
    return _repository.saveTask(userId: userId, task: task);
  }
}
