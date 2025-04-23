class Task {
  final String id;
  final String userId; // Added user ID
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate; // Added due date
  final String? priority; // Added priority (high/medium/low)
  final bool isCompleted;

  Task({
    required this.id,
    required this.userId,
    required this.title,
    this.description,
    required this.createdAt,
    this.dueDate,
    this.priority,
    this.isCompleted = false,
  });

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      id: map['id'] as String,
      userId: map['user_id'] as String,
      title: map['title'] as String,
      description: map['description'] as String?,
      createdAt: DateTime.parse(map['created_at'] as String),
      dueDate:
          map['due_date'] != null
              ? DateTime.parse(map['due_date'] as String)
              : null,
      priority: map['priority'] as String?,
      isCompleted: map['is_completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'description': description,
      'created_at': createdAt.toIso8601String(),
      'due_date': dueDate?.toIso8601String(),
      'priority': priority,
      'is_completed': isCompleted,
    };
  }

  Task copyWith({
    String? id,
    String? userId,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    String? priority,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  String toString() {
    return 'Task(id: $id, userId: $userId, title: $title, description: $description, '
        'createdAt: $createdAt, dueDate: $dueDate, priority: $priority, '
        'isCompleted: $isCompleted)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Task &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.description == description &&
        other.createdAt == createdAt &&
        other.dueDate == dueDate &&
        other.priority == priority &&
        other.isCompleted == isCompleted;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        title.hashCode ^
        description.hashCode ^
        createdAt.hashCode ^
        dueDate.hashCode ^
        priority.hashCode ^
        isCompleted.hashCode;
  }

  // Helper methods for priority
  bool get isHighPriority => priority?.toLowerCase() == 'high';
  bool get isMediumPriority => priority?.toLowerCase() == 'medium';
  bool get isLowPriority => priority?.toLowerCase() == 'low';

  // Format due date for display
  String? get formattedDueDate {
    if (dueDate == null) return null;
    return '${dueDate!.day}/${dueDate!.month}/${dueDate!.year} ${dueDate!.hour}:${dueDate!.minute.toString().padLeft(2, '0')}';
  }
}
