import 'package:flutter/material.dart';
import '../db_helper.dart';
import '../models/task.dart';

class TaskScreen extends StatefulWidget {
  final Task? task;

  TaskScreen({this.task});

  @override
  _TaskScreenState createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final DatabaseHelper _dbHelper =
      DatabaseHelper.instance; // Use singleton instance
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _timeController = TextEditingController();
  final _dateController = TextEditingController();
  String _priority = 'Low';

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title ?? '';
      _descriptionController.text = widget.task!.description ?? '';
      _timeController.text = widget.task!.time ?? '';
      _dateController.text = widget.task!.date ?? '';
      _priority = widget.task!.priority ?? 'Low';
    }
  }

  void _saveTask() async {
    final title = _titleController.text;
    final description = _descriptionController.text;
    final time = _timeController.text;
    final date = _dateController.text;

    if (title.isEmpty || description.isEmpty || time.isEmpty || date.isEmpty) {
      // Show error
      return;
    }

    final task = {
      'title': title,
      'description': description,
      'date': date,
      'time': time,
      'priority': _priority,
    };

    if (widget.task != null) {
      // Update existing task
      task['id'] = widget.task!.id.toString(); // Convert to String
      await _dbHelper.updateTask(task);
    } else {
      // Insert new task
      await _dbHelper.saveTask(task);
    }

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Add Task' : 'Edit Task'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: _timeController,
              decoration: InputDecoration(labelText: 'Time'),
            ),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(labelText: 'Date'),
            ),
            DropdownButton<String>(
              value: _priority,
              onChanged: (String? newValue) {
                setState(() {
                  _priority = newValue!;
                });
              },
              items: <String>['High', 'Medium', 'Low']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveTask,
              child: Text('Save'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
