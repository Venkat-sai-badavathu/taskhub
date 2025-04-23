import 'package:flutter/material.dart';
import 'package:taskhub/dashboard/task_model.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(Task) onToggleComplete;

  const TaskItem({
    super.key,
    required this.task,
    required this.onToggleComplete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: const Color(0xFF1A1A1A),
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) => onToggleComplete(task),
          fillColor: MaterialStateProperty.resolveWith<Color>((states) {
            return const Color(0xFF1A1A1A);
          }),
          side: const BorderSide(color: Color(0xFFFF0B55)),
          checkColor: Colors.white,
        ),
        title: Text(
          task.title,
          style: TextStyle(
            color: Colors.white,
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.dueDate != null) ...[
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 14,
                    color: Color(0xFF6C7A89),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(task.dueDate!),
                    style: const TextStyle(color: Color(0xFF6C7A89)),
                  ),
                ],
              ),
            ],
            if (task.priority != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getPriorityColor(task.priority!),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  task.priority!.toUpperCase(),
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ),
            ],
          ],
        ),
        trailing: const Icon(Icons.chevron_right, color: Color(0xFF6C7A89)),
        onTap: () => _showTaskDetails(context),
      ),
    );
  }

  void _showTaskDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (task.description != null) ...[
                Text(
                  task.description!,
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(height: 16),
              ],
              if (task.dueDate != null) ...[
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFF6C7A89)),
                    const SizedBox(width: 8),
                    Text(
                      'Due: ${_formatDate(task.dueDate!)}',
                      style: const TextStyle(color: Color(0xFF6C7A89)),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              if (task.priority != null) ...[
                Row(
                  children: [
                    const Icon(Icons.flag, color: Color(0xFF6C7A89)),
                    const SizedBox(width: 8),
                    Text(
                      'Priority: ${task.priority!.toUpperCase()}',
                      style: const TextStyle(color: Color(0xFF6C7A89)),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF0B55),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }

  Color _getPriorityColor(String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return Colors.red[900]!;
      case 'medium':
        return Colors.orange[900]!;
      case 'low':
        return Colors.green[900]!;
      default:
        return Colors.grey[800]!;
    }
  }
}
