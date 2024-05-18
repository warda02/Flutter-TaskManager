import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class Task {
  String title;

  Task(this.title);
}

class TaskManager extends ChangeNotifier {
  final List<Task> _tasks = [];

  List<Task> get tasks => _tasks;

  void addTask(String title) {
    _tasks.add(Task(title));
    notifyListeners();
  }

  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskManager(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Task Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: TaskManagerScreen(),
      ),
    );
  }
}

class TaskManagerScreen extends StatelessWidget {
  final TextEditingController _controller = TextEditingController();

  TaskManagerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Manager'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(labelText: 'Enter task'),
            ),
          ),
          Consumer<TaskManager>(
            builder: (context, taskManager, child) => Expanded(
              child: ListView.builder(
                itemCount: taskManager.tasks.length,
                itemBuilder: (context, index) {
                  final task = taskManager.tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        taskManager.deleteTask(task);
                      },
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          final title = _controller.text;
          if (title.isNotEmpty) {
            Provider.of<TaskManager>(context, listen: false).addTask(title);
            _controller.clear();
          }
        },
        tooltip: 'Add Task',
        child: const Icon(Icons.add),
      ),
    );
  }
}
