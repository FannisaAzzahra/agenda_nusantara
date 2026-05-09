import 'package:flutter/material.dart';
import '../database/database_helper.dart';
import '../models/task.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  List<Task> _tasks = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  Future<void> _loadTasks() async {
    final tasks = await DatabaseHelper.instance.getAllTasks();
    setState(() {
      _tasks = tasks;
      _isLoading = false;
    });
  }

  Future<void> _toggleTask(Task task) async {
    final newStatus = task.isCompleted == 0;
    await DatabaseHelper.instance.toggleTaskComplete(task.id!, newStatus);
    _loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Tugas'),
        backgroundColor: const Color(0xFF4A7C6F),
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _tasks.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.inbox_outlined,
                          size: 64, color: Colors.grey),
                      SizedBox(height: 12),
                      Text(
                        'Belum ada tugas.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _tasks.length,
                  itemBuilder: (context, index) {
                    final task = _tasks[index];
                    final isPenting = task.category == 'penting';
                    final isCompleted = task.isCompleted == 1;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.04),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 4,
                        ),
                        leading: GestureDetector(
                          onTap: () => _toggleTask(task),
                          child: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: isCompleted
                                    ? const Color(0xFF4A7C6F)
                                    : Colors.grey[400]!,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(4),
                              color: isCompleted
                                  ? const Color(0xFF4A7C6F)
                                  : Colors.transparent,
                            ),
                            child: isCompleted
                                ? const Icon(Icons.check,
                                    color: Colors.white, size: 16)
                                : null,
                          ),
                        ),
                        title: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            decoration: isCompleted
                                ? TextDecoration.lineThrough
                                : TextDecoration.none,
                            color: isCompleted ? Colors.grey : Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          '${task.dueDate} · ${isPenting ? "Penting" : "Biasa"}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                        trailing: Icon(
                          Icons.play_arrow,
                          color: isPenting
                              ? const Color(0xFFD32F2F)
                              : const Color(0xFF4A7C6F),
                        ),
                        onTap: () => _toggleTask(task),
                      ),
                    );
                  },
                ),
    );
  }
}
