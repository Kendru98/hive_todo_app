import 'package:flutter/material.dart';
import 'package:hive_todo_app/model/thingstodo.dart';
import 'package:hive_todo_app/pages/todocreatepage.dart';
import 'package:intl/intl.dart';

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
    @override
    final date = DateFormat.yMMMd('pl').format(widget.todo.createdDate);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,

        //ikonki kolor
        actions: [
          deleteButton(widget.todo),
          editButton(widget.todo)
        ], //editButton(widget.todo)
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
                      setState(() {
                        widget.todo.isChecked[index] = value!;
                        countProgress(widget.todo.isChecked);
                      });
                    });
              },
            )
          ],
        ),
      ),
    );
  }

  Widget deleteButton(ToDo todo) => IconButton(
        icon: Icon(Icons.delete),
        onPressed: () async {
          // if (Hive.box('todos').isOpen == true) {
          //   Hive.openBox('todos');
          // }
          await todo.delete();
          Navigator.pop(context);
        },
      );

  Widget editButton(ToDo toDo) => IconButton(
        icon: Icon(Icons.edit_outlined),
        onPressed: () async {
          await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddEditToDos(toDo: toDo)));

          // await Navigator.of(context).push(MaterialPageRoute(
          //      builder: (context) => AddEditNoteScreen(note: notes)));
          //  refreshNotes();
        },
      );

  countProgress(
    List<bool> CheckedList,
  ) {
    double progress;
    int checkedvalues = 0;
    int listsize = CheckedList.length;

    CheckedList.forEach((element) {
      if (element == true) checkedvalues = checkedvalues + 1;
    });
    progress = (checkedvalues / listsize) * 100;
    print(progress);
    updateProgress(progress, widget.todo);
  }

  updateProgress(double progress, ToDo toDo) {
    toDo.progress = progress;

    toDo.save();
  }
}
