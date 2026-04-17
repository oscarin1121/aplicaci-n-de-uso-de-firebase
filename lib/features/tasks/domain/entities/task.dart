enum TaskPriority { low, medium, high, urgent }

extension TaskPriorityX on TaskPriority {
  String get firestoreValue {
    return switch (this) {
      TaskPriority.low => 'low',
      TaskPriority.medium => 'medium',
      TaskPriority.high => 'high',
      TaskPriority.urgent => 'urgent',
    };
  }

  String get formLabel {
    return switch (this) {
      TaskPriority.low => 'Low / Routine',
      TaskPriority.medium => 'Medium / Standard',
      TaskPriority.high => 'High / Critical',
      TaskPriority.urgent => 'Urgent / Hotfix',
    };
  }

  int get weight {
    return switch (this) {
      TaskPriority.low => 0,
      TaskPriority.medium => 1,
      TaskPriority.high => 2,
      TaskPriority.urgent => 3,
    };
  }

  static TaskPriority fromValue(String? value) {
    return TaskPriority.values.firstWhere(
      (TaskPriority item) => item.firestoreValue == value,
      orElse: () => TaskPriority.medium,
    );
  }
}

class Task {
  const Task({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.priority,
    required this.label,
    required this.requirements,
    required this.isCompleted,
    required this.createdAt,
    required this.updatedAt,
    required this.referenceCode,
    this.dueDate,
    this.completedAt,
  });

  final String id;
  final String ownerId;
  final String title;
  final String description;
  final TaskPriority priority;
  final String label;
  final List<String> requirements;
  final bool isCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? dueDate;
  final DateTime? completedAt;
  final String referenceCode;

  bool get isOverdue {
    if (dueDate == null || isCompleted) {
      return false;
    }

    return dueDate!.isBefore(DateTime.now());
  }

  String get statusLabel {
    if (isCompleted) {
      return 'Completed';
    }

    return switch (priority) {
      TaskPriority.urgent => 'Hotfix',
      TaskPriority.high => 'In Progress',
      TaskPriority.medium || TaskPriority.low => 'Pending',
    };
  }

  Task copyWith({
    String? id,
    String? ownerId,
    String? title,
    String? description,
    TaskPriority? priority,
    String? label,
    List<String>? requirements,
    bool? isCompleted,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? dueDate,
    DateTime? completedAt,
    String? referenceCode,
  }) {
    return Task(
      id: id ?? this.id,
      ownerId: ownerId ?? this.ownerId,
      title: title ?? this.title,
      description: description ?? this.description,
      priority: priority ?? this.priority,
      label: label ?? this.label,
      requirements: requirements ?? this.requirements,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      referenceCode: referenceCode ?? this.referenceCode,
    );
  }
}
