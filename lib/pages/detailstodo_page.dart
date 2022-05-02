import 'package:flutter/material.dart';
import 'package:hive_todo_app/model/thingstodo.dart';
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
    // openbox();
    super.initState();

    //_isChecked = List<bool>.filled(widget.todo.thingstodo.length, false);
  }

  // openbox() async {
  //   await Hive.openBox<ToDo>('todos');
  // }

  Widget build(BuildContext context) {
    @override
    final date = DateFormat.yMMMd('pl').format(widget.todo.createdDate);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black), //ikonki kolor
        actions: [editButton(), deleteButton(widget.todo)],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text(
              widget.todo.name,
              maxLines: 2,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            Text(
              date,
              style: const TextStyle(
                  color: Colors.lightBlue,
                  fontWeight: FontWeight.bold,
                  fontSize: 16),
            ),
            ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.todo.thingstodo.length,
              itemBuilder: (BuildContext context, int index) {
                return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    title: Text(
                      widget.todo.thingstodo[index],
                      style: const TextStyle(fontSize: 18, color: Colors.black),
                    ),
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

  Widget editButton() => IconButton(
        icon: Icon(Icons.edit_outlined),
        onPressed: () async {
          // if (isLoading) return;

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
