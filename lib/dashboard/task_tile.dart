import 'package:flutter/material.dart';
import 'package:taskhub/dashboard/task_model.dart';

class TaskTile extends StatelessWidget {
  final Task task;
  final VoidCallback onDelete;
  final ValueChanged<bool> onToggleComplete; // Made it required

  const TaskTile({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onToggleComplete, // Made required
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (bool? newValue) {
            if (newValue != null) {
              onToggleComplete(newValue);
            }
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: task.description != null ? Text(task.description!) : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}
