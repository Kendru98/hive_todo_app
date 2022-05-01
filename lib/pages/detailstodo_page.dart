import 'package:flutter/material.dart';
import 'package:hive_todo_app/model/thingstodo.dart';
import 'package:intl/intl.dart';

class DetailsTodo extends StatelessWidget {
  const DetailsTodo({required ToDo this.todo});

  final ToDo todo;

  @override
  Widget build(BuildContext context) {
    @override
    final date = DateFormat.yMMMd('pl').format(todo.createdDate);
    return Scaffold(
      body: ListView(
        children: [
          Column(
            children: [
              Text(
                todo.name,
                maxLines: 2,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                date,
                style: const TextStyle(
                    color: Colors.lightBlue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
