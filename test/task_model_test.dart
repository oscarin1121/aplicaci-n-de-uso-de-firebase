import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_practice/features/tasks/data/models/task_model.dart';
import 'package:firebase_practice/features/tasks/domain/entities/task.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('serializes a task model with dates and requirements', () {
    final DateTime createdAt = DateTime(2026, 4, 16, 18, 0);
    final DateTime updatedAt = DateTime(2026, 4, 16, 18, 30);
    final DateTime dueDate = DateTime(2026, 4, 20);

    final TaskModel task = TaskModel(
      id: 'task-001',
      ownerId: 'user-001',
      title: 'Optimize Cloud Functions',
      description: 'Review listeners and reduce repeated writes.',
      priority: TaskPriority.high,
      label: 'Backend',
      requirements: <String>[
        'Reduce duplicated listeners',
        'Validate Firestore rules',
      ],
      isCompleted: false,
      createdAt: DateTime(2026, 4, 16, 18, 0),
      updatedAt: DateTime(2026, 4, 16, 18, 30),
      dueDate: DateTime(2026, 4, 20),
      referenceCode: 'KD-1024',
    );

    final Map<String, dynamic> document = task.toDocument();

    expect(document['ownerId'], 'user-001');
    expect(document['priority'], 'high');
    expect(document['label'], 'Backend');
    expect(document['requirements'], hasLength(2));
    expect((document['createdAt'] as Timestamp).toDate(), createdAt);
    expect((document['updatedAt'] as Timestamp).toDate(), updatedAt);
    expect((document['dueDate'] as Timestamp).toDate(), dueDate);
  });
}
