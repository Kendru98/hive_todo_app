import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_app/pages/todocreatepage.dart';
import '../boxes.dart';
import '../model/thingstodo.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  @override
  void dispose() {
    Hive.box('todos').close();
    super.dispose(); //7:45
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ValueListenableBuilder<Box<ToDo>>(
          valueListenable: Boxes.getToDos().listenable(),
          builder: (context, box, _) {
            final todos = box.values.toList().cast<ToDo>();

            return buildContent(todos);
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => AddEditToDos())));

          //navigation to addtodoeditcreate
        },
      ),
    );
  }

  Widget buildContent(List<ToDo> todos) {
    if (todos.isEmpty) {
      return const Center(
        child: Text(
          'Brak elementów do wyświetlenia!',
          style: TextStyle(fontSize: 24),
        ),
      );
    } else {
      return Column(
        children: [
          const SizedBox(height: 24),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: todos.length,
              itemBuilder: (BuildContext context, int index) {
                final todo = todos[index];

                return buildList(context, todo);
              },
            ),
          ),
        ],
      );
    }
  }

  Widget buildList(
    BuildContext context,
    ToDo todo,
  ) {
    // final color = todo.isExpense ? Colors.red : Colors.green;

    //  final amount = '\$' + todo.amount.toStringAsFixed(2);
    //final date = DateFormat.yMMMd().format(todo.createdDate);

    return Card(
      color: Colors.white,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        title: Text(
          todo.name,
          maxLines: 2,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        //subtitle: Text(date),
        trailing: Text(
          todo.createdDate.toIso8601String(),
          style: const TextStyle(
              color: Colors.lightBlue,
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
        // children: [
        //   buildButtons(context, todo),
        // ],
      ),
    );
  }
}
