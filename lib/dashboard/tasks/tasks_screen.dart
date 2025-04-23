import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:taskhub/dashboard/task_model.dart' as model;
import 'package:taskhub/dashboard/tasks/task_item.dart';
import 'package:taskhub/dashboard/tasks/task_filter.dart';
import 'package:taskhub/dashboard/dashboard_screen.dart';
import 'package:taskhub/dashboard/timer/timer_screen.dart';
import 'package:taskhub/dashboard/profile/profile_screen.dart';

class TasksScreen extends StatefulWidget {
  const TasksScreen({super.key});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  TaskFilter _currentFilter = TaskFilter.pending;
  bool _isLoading = false;
  List<model.Task> _tasks = [];
  RealtimeChannel? _tasksChannel;
  final SupabaseClient _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _fetchTasks();
    _setupRealtimeUpdates();
  }

  @override
  void dispose() {
    _tasksChannel?.unsubscribe();
    super.dispose();
  }

  Future<void> _fetchTasks() async {
    setState(() => _isLoading = true);
    try {
      final response = await _supabase
          .from('tasks')
          .select()
          .eq('user_id', _supabase.auth.currentUser!.id)
          .order('created_at', ascending: false);

      setState(() {
        _tasks =
            (response as List<dynamic>)
                .map((task) => model.Task.fromMap(task as Map<String, dynamic>))
                .toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading tasks: ${e.toString()}')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _setupRealtimeUpdates() {
    _tasksChannel =
        _supabase
            .channel('public:tasks')
            .onPostgresChanges(
              event: PostgresChangeEvent.all,
              schema: 'public',
              table: 'tasks',
              filter: PostgresChangeFilter(
                type: PostgresChangeFilterType.eq,
                column: 'user_id',
                value: _supabase.auth.currentUser!.id,
              ),
              callback: (payload) {
                if (mounted) {
                  _fetchTasks();
                }
              },
            )
            .subscribe();
  }

  Future<void> _toggleTaskCompletion(model.Task task) async {
    try {
      await _supabase
          .from('tasks')
          .update({'is_completed': !task.isCompleted})
          .eq('id', task.id);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating task: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final filteredTasks =
        _tasks.where((task) {
          return _currentFilter == TaskFilter.pending
              ? !task.isCompleted
              : task.isCompleted;
        }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('Tasks', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          _buildFilterTabs(),
          Expanded(
            child:
                _isLoading
                    ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFFF0B55),
                      ),
                    )
                    : filteredTasks.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: filteredTasks.length,
                      itemBuilder:
                          (context, index) => TaskItem(
                            task: filteredTasks[index],
                            onToggleComplete:
                                (task) => _toggleTaskCompletion(task),
                          ),
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTaskDialog(context),
        backgroundColor: const Color(0xFFFF0B55),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildFilterTabs() {
    return Container(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFF333333))),
      ),
      child: Row(
        children: [
          _buildTabButton('Pending', TaskFilter.pending),
          _buildTabButton('Completed', TaskFilter.completed),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, TaskFilter filter) {
    final isSelected = _currentFilter == filter;
    return Expanded(
      child: TextButton(
        onPressed: () => setState(() => _currentFilter = filter),
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              color: isSelected ? const Color(0xFFFF0B55) : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color:
                isSelected ? const Color(0xFFFF0B55) : const Color(0xFF6C7A89),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.task, size: 100, color: Colors.grey[700]),
          const SizedBox(height: 20),
          Text(
            _currentFilter == TaskFilter.pending
                ? 'No pending tasks'
                : 'No completed tasks',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adding new tasks',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF1A1A1A),
      builder: (context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Add New Task',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Task Title',
                    labelStyle: const TextStyle(color: Color(0xFF6C7A89)),
                    filled: true,
                    fillColor: Colors.black,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF333333)),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty) return;

                    try {
                      await _supabase.from('tasks').insert({
                        'user_id': _supabase.auth.currentUser!.id,
                        'title': titleController.text,
                        'is_completed': false,
                        'created_at': DateTime.now().toIso8601String(),
                      });
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error adding task: ${e.toString()}'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF0B55),
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Add Task',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      currentIndex: 1,
      onTap: (index) {
        if (index == 1) return;

        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const DashboardScreen(),
                transitionDuration: Duration.zero,
              ),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const TimerScreen(),
                transitionDuration: Duration.zero,
              ),
            );
            break;
          case 3:
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (_, __, ___) => const ProfileScreen(),
                transitionDuration: Duration.zero,
              ),
            );
            break;
        }
      },
      backgroundColor: Colors.black,
      selectedItemColor: const Color(0xFFFF0B55),
      unselectedItemColor: const Color(0xFF6C7A89),
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.calendar_today),
          label: 'Today',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.task), label: 'Tasks'),
        BottomNavigationBarItem(icon: Icon(Icons.timer), label: 'Timer'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
      ],
    );
  }
}
