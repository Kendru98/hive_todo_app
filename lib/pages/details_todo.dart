import 'package:flutter/material.dart';
import 'package:hive_todo_app/model/to_do.dart';
import 'package:hive_todo_app/pages/add_edit_todo.dart';
import 'package:hive_todo_app/providers/todo_provider.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class DetailsTodo extends StatefulWidget {
  const DetailsTodo({required ToDo this.todo});

  final ToDo todo;

  @override
  State<DetailsTodo> createState() => _DetailsTodoState();
}

class _DetailsTodoState extends State<DetailsTodo> {
  @override
  initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final provider = context.read<TodoListController>();
    @override
    final date = DateFormat.yMMMd('pl').format(widget.todo.createdDate);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () async {
              await provider.deleteTodo(widget.todo);

              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined),
            onPressed: () async {
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => AddEditTodo(toDo: widget.todo),
                ),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.todo.name,
              maxLines: 2,
              style: Theme.of(context).textTheme.headline1,
            ),
            Text(date, style: Theme.of(context).textTheme.headline2),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.todo.thingstodo.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(widget.todo.thingstodo[index],
                      style: Theme.of(context).textTheme.headline1),
                  value: widget.todo.isChecked[index],
                  onChanged: (value) {
                    setState(
                      () {
                        widget.todo.isChecked[index] = value!;
                        provider.countProgress(
                            widget.todo.isChecked, widget.todo);
                      },
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
