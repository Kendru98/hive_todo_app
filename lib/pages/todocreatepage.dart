import 'package:flutter/material.dart';
//import 'package:hive/hive.dart';
import 'dart:core';
//import 'package:hive_flutter/hive_flutter.dart';
import '../boxes.dart';
import '../model/thingstodo.dart';

class AddEditToDos extends StatefulWidget {
  @override
  _AddEditToDosState createState() => _AddEditToDosState();
}

class _AddEditToDosState extends State<AddEditToDos> {
  @override
  // void dispose() {
  //   Hive.close();

  //   super.dispose();
  // }

  final _formKey = GlobalKey<FormState>();
  final listitem = TextEditingController();
  final tasktitle = TextEditingController();
  List<String> tasklist = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        iconTheme: const IconThemeData(
          size: 28,
          color: Colors.black, //change your color here
        ),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 30, 8),
            child: GestureDetector(
                child: const Icon(
                  Icons.check,
                  size: 28,
                ),
                onTap: () {
                  AddToDo(tasktitle.text, tasklist);
                  Navigator.pop(context);
                  //add to hive database
                }),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Form(
              key: _formKey,
              child:
                  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
                TextFormField(
                  controller: tasktitle,
                  decoration: const InputDecoration(
                    hintText: "Tytuł listy",
                  ),
                  scrollPadding: const EdgeInsets.all(20.0),
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  autofocus: true,
                  validator: (value) => value != null && value.isEmpty
                      ? 'Tytuł nie może być pusty'
                      : null,
                ),
                const SizedBox(
                  height: 8,
                ),
                TextFormField(
                  onFieldSubmitted: (giventask) {
                    setState(() {
                      tasklist.add(giventask);

                      print(tasklist);
                      listitem.clear();
                    });
                    //dodaj do listy
                  },
                  controller: listitem,
                  decoration: const InputDecoration(
                    hintText: "Dodaj zadanie do listy",
                  ),
                  scrollPadding: const EdgeInsets.all(20.0),
                  maxLines: 1,
                  autofocus: true,
                  validator: (value) => value != null && value.isEmpty
                      ? 'Nie możesz dodać pustej pozycji'
                      : null,
                ),
                ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  //scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: tasklist.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        tasklist[index],
                        style:
                            const TextStyle(fontSize: 18, color: Colors.black),
                      ),
                    );
                  },
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  // void addOrUpdateToDo() async {
  //   final isValid = _formKey.currentState!.validate();
  //   if (isValid) {
  //     final isUpdating = widget.note != null;

  //     if (isUpdating) {
  //       await updateNote();
  //     } else {
  //       await addNote();
  //     }
  //   }
  //   Navigator.of(context).pop();
  // }

  Future AddToDo(String name, List<String> listtodo) async {
    print(name);
    print(listtodo);
    var _isChecked = List<bool>.filled(listtodo.length, false);
    final ToDoData = ToDo()
      ..setreminder = true
      ..endDate = DateTime.now()
      ..name = name
      ..createdDate = DateTime.now()
      ..thingstodo = listtodo
      ..progress = 0
      ..isChecked = _isChecked;
    final box = Boxes.getToDos();
    box.add(ToDoData);
  }
}
