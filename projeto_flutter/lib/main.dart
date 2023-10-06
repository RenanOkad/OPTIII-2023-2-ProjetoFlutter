import 'package:flutter/material.dart';

void main() {
  runApp(TodoApp());
}

class TodoApp extends StatelessWidget {
  const TodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lista de Tarefas',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TodoListScreen(),
    );
  }
}

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({super.key});

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  List<TodoItem> todos = [];
  bool isAddScreenVisible = false;

  void _toggleAddScreen() {
    setState(() {
      isAddScreenVisible = !isAddScreenVisible;
    });
  }

  void _addTodo() async {
    final newTodo = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) {
          return const AddTodoScreen();
        },
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;
          var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: child,
          );
        },
      ),
    );

    if (newTodo != null) {
      setState(() {
        todos.add(TodoItem(newTodo, false));
      });
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      todos[index].isCompleted = !todos[index].isCompleted;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Tarefas'),
      ),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(todos[index].task),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              child: const Icon(Icons.delete),
            ),
            secondaryBackground: Container(
              color: Colors.green,
              alignment: Alignment.centerRight,
              child: const Icon(Icons.check),
            ),
            onDismissed: (direction) {
              if (direction == DismissDirection.startToEnd) {
                setState(() {
                  todos.removeAt(index);
                });
              } else if (direction == DismissDirection.endToStart) {
                _toggleTodo(index);
              }
            },
            child: ListTile(
              title: Text(
                todos[index].task,
                style: TextStyle(
                  decoration: todos[index].isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: todos[index].isCompleted ? Colors.grey : Colors.black,
                ),
              ),
              onTap: () => _toggleTodo(index),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: isAddScreenVisible
              ? const AlwaysStoppedAnimation(0.75)
              : const AlwaysStoppedAnimation(0.0),
        ),
        onPressed: () {
          if (isAddScreenVisible) {
            _addTodo();
          }
          _toggleAddScreen();
        },
      ),
    );
  }
}

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});

  @override
  _AddTodoScreenState createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  void _addTodo() {
    String newTodo = _textEditingController.text;
    Navigator.of(context).pop(newTodo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Tarefa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _textEditingController,
              decoration: const InputDecoration(labelText: 'Tarefa'),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: _addTodo,
              child: const Text('Adicionar'),
            ),
          ],
        ),
      ),
    );
  }
}

class TodoItem {
  String task;
  bool isCompleted;

  TodoItem(this.task, this.isCompleted);
}
