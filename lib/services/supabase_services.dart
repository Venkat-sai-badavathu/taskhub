import 'package:supabase_flutter/supabase_flutter.dart';
import '../dashboard/task_model.dart';

class SupabaseService {
  final SupabaseClient _supabase = Supabase.instance.client;

  Future<List<Task>> getTasks() async {
    final response = await _supabase
        .from('tasks')
        .select('*')
        .eq('user_id', _supabase.auth.currentUser!.id)
        .order('created_at', ascending: false);

    if (response == null) return [];

    return (response as List).map((task) => Task.fromMap(task)).toList();
  }

  Future<void> addTask(Task task) async {
    await _supabase.from('tasks').insert({
      'id': task.id,
      'user_id': _supabase.auth.currentUser!.id,
      'title': task.title,
      'description': task.description,
      'created_at': task.createdAt.toIso8601String(),
      'is_completed': task.isCompleted,
    });
  }

  Future<void> updateTask(Task task) async {
    await _supabase
        .from('tasks')
        .update({
          'title': task.title,
          'description': task.description,
          'is_completed': task.isCompleted,
        })
        .eq('id', task.id);
  }

  Future<void> deleteTask(String taskId) async {
    await _supabase.from('tasks').delete().eq('id', taskId);
  }
}
