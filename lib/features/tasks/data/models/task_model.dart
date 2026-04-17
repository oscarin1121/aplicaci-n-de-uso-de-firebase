import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice/features/tasks/domain/entities/task.dart';

class TaskModel extends Task {
  const TaskModel({
    required super.id,
    required super.ownerId,
    required super.title,
    required super.description,
    required super.priority,
    required super.label,
    required super.requirements,
    required super.isCompleted,
    required super.createdAt,
    required super.updatedAt,
    required super.referenceCode,
    super.dueDate,
    super.completedAt,
  });

  factory TaskModel.fromTask(Task task) {
    return TaskModel(
      id: task.id,
      ownerId: task.ownerId,
      title: task.title,
      description: task.description,
      priority: task.priority,
      label: task.label,
      requirements: task.requirements,
      isCompleted: task.isCompleted,
      createdAt: task.createdAt,
      updatedAt: task.updatedAt,
      dueDate: task.dueDate,
      completedAt: task.completedAt,
      referenceCode: task.referenceCode,
    );
  }

  factory TaskModel.fromDocument(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final Map<String, dynamic> data = document.data() ?? <String, dynamic>{};

    return TaskModel(
      id: document.id,
      ownerId: data['ownerId'] as String? ?? '',
      title: data['title'] as String? ?? '',
      description: data['description'] as String? ?? '',
      priority: TaskPriorityX.fromValue(data['priority'] as String?),
      label: data['label'] as String? ?? '',
      requirements: List<String>.from(
        data['requirements'] as List<dynamic>? ?? const <String>[],
      ),
      isCompleted: data['isCompleted'] as bool? ?? false,
      createdAt: _readTimestamp(data['createdAt']) ?? DateTime.now(),
      updatedAt: _readTimestamp(data['updatedAt']) ?? DateTime.now(),
      dueDate: _readTimestamp(data['dueDate']),
      completedAt: _readTimestamp(data['completedAt']),
      referenceCode: data['referenceCode'] as String? ?? 'KD-0000',
    );
  }

  Map<String, dynamic> toDocument() {
    return <String, dynamic>{
      'ownerId': ownerId,
      'title': title,
      'description': description,
      'priority': priority.firestoreValue,
      'label': label,
      'requirements': requirements,
      'isCompleted': isCompleted,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'dueDate': dueDate != null ? Timestamp.fromDate(dueDate!) : null,
      'completedAt': completedAt != null
          ? Timestamp.fromDate(completedAt!)
          : null,
      'referenceCode': referenceCode,
    };
  }

  static DateTime? _readTimestamp(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    return null;
  }
}
