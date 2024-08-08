import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../models/task.dart';
import 'task_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DatabaseHelper _dbHelper =
      DatabaseHelper.instance; // Use singleton instance
  List<Task> _tasks = [];
  String _selectedPriorityFilter = '';

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }

  void _loadTasks([String? priority]) async {
    List<Map<String, dynamic>> taskMaps = await _dbHelper.getTasks(priority);
    setState(() {
      _tasks = taskMaps.map((map) => Task.fromMap(map)).toList();
    });
  }

  void _deleteTask(int id) async {
    await _dbHelper.deleteTask(id);
    _loadTasks(_selectedPriorityFilter);
  }

  void _navigateToTaskScreen([Task? task]) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TaskScreen(task: task)),
    );
    _loadTasks(_selectedPriorityFilter);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('To-Do List'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () => _loadTasks('High'),
                  child: Text('High Priority'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent, // Updated parameter
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _loadTasks('Medium'),
                  child: Text('Medium Priority'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent, // Updated parameter
                  ),
                ),
                ElevatedButton(
                  onPressed: () => _loadTasks('Low'),
                  child: Text('Low Priority'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent, // Updated parameter
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 5,
                  child: ListTile(
                    title: Text(task.title),
                    subtitle: Text(
                        '${task.description}\n${task.date} ${task.time}\nPriority: ${task.priority}'),
                    onTap: () => _navigateToTaskScreen(task),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () => _deleteTask(task.id!),
                      color: Colors.red,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToTaskScreen(),
        child: Icon(Icons.add),
        backgroundColor: Colors.blueAccent,
      ),
    );
  }
}
