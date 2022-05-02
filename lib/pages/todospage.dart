import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_app/pages/detailstodo_page.dart';
import 'package:hive_todo_app/pages/todocreatepage.dart';
import 'package:intl/intl.dart';
import '../boxes.dart';
import '../model/thingstodo.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  void initState() {
    initializeDateFormatting();
    // TODO: implement initState
    super.initState();
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
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue,
        elevation: 10,
        hoverColor: Colors.green,
        tooltip: 'Dodaj nową listę',
        child: Icon(
          FontAwesomeIcons.plus,
        ),
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
    final date = DateFormat.yMMMd('pl').format(todo.createdDate);

    return Card(
        color: Colors.white,
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: ((context) => DetailsTodo(
                          todo: todo,
                        ))));
          },
          child: ListTile(
            //tilePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            title: Text(
              todo.name,
              maxLines: 2,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            //subtitle: Text(date),
            trailing: Text(
              date, //todo.createdDate.toIso8601String(),
              style: const TextStyle(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            subtitle: Padding(
              padding: EdgeInsets.all(15.0),
              child: new LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 300,
                animation: true,
                lineHeight: 20.0,
                animationDuration: 2000,
                percent: todo.progress / 100,
                center: Text('${todo.progress} %'),
                barRadius: Radius.circular(20),
                progressColor: Colors.greenAccent,
              ),
            ),
          ),
        ));
  }
}
