import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_todo_app/bloc/todos_bloc.dart';
import 'dart:core';
import '../api/localnotification_api.dart';
import '../model/thingstodo.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddEditToDos extends StatefulWidget {
  final ToDo? toDo;
  AddEditToDos({this.toDo});
  @override
  _AddEditToDosState createState() => _AddEditToDosState();
}

class _AddEditToDosState extends State<AddEditToDos> {
  @override
  final _formKey = GlobalKey<FormState>();
  final listitem = TextEditingController();
  final tasktitle = TextEditingController();
  var reminderdate = DateTime.now();
  var setreminder = false;
  List<String> tasklist = [];

  var count = 0;
  @override
  Widget build(
    BuildContext context,
  ) {
    // ToDo toDo
    if (widget.toDo != null) {
      tasktitle.text = widget.toDo!.name;
      tasklist = widget.toDo!.thingstodo;
    }
    FocusNode myFocusNode = FocusNode();
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          iconTheme: const IconThemeData(
            size: 28,
            color: Colors.black,
          ),
          actions: [
            Container(
              margin: const EdgeInsets.fromLTRB(0, 8, 30, 8),
              child: GestureDetector(
                  child: const Icon(
                    FontAwesomeIcons.bell,
                    size: 28,
                  ),
                  onTap: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    DatePicker.showDateTimePicker(context,
                        theme: DatePickerTheme(),
                        currentTime: DateTime.now(),
                        showTitleActions: true,
                        minTime: DateTime.now(),
                        maxTime: DateTime(2030, 6, 7, 05, 09),
                        onChanged: (date) {
                      print('change $date in time zone ' +
                          date.timeZoneOffset.inHours.toString());
                    }, onConfirm: (date) {
                      setreminder = true;
                      print('confirm $date');
                      setState(() {
                        reminderdate = date;
                      });
                    }, locale: LocaleType.pl);

                    //add to hive database
                  }),
            ),
            Container(
              margin: const EdgeInsets.fromLTRB(0, 8, 30, 8),
              child: BlocBuilder<TodosBloc, TodosState>(
                builder: (context, state) {
                  return GestureDetector(
                    child: const Icon(
                      Icons.check,
                      size: 28,
                    ),
                    onTap: () {
                      if (widget.toDo != null) {
                        EditToDo(widget.toDo!, tasktitle.text,
                            widget.toDo!.thingstodo, widget.toDo!.isChecked);
                        NotificationApi.showScheduledNotification(
                            title: tasktitle.text,
                            body: 'Pamiętaj o swoich rzeczach do zrobienia!',
                            scheduleDate: reminderdate);
                        Navigator.of(context).popUntil((_) => count++ >= 2);
                      } else {
                        context
                            .read<TodosBloc>()
                            .add(AddTodo(tasktitle.text, tasklist));
                        Navigator.pop(context);
                      }
                      //add to hive database
                    },
                  );
                },
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Form(
                key: _formKey,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextFormField(
                        style: Theme.of(context).textTheme.headline3,
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
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        focusNode: myFocusNode,
                        style: Theme.of(context).textTheme.headline3,
                        onFieldSubmitted: (giventask) {
                          if (giventask.isEmpty ||
                              giventask.trim().length == 0) {
                            return ValidationAlert();
                          } else {
                            setState(() {
                              tasklist.add(giventask);
                              listitem.clear();
                              myFocusNode.requestFocus();
                            });
                            //dodaj do listy
                          }
                        },
                        controller: listitem,
                        decoration: const InputDecoration(
                          hintText: "Dodaj zadanie do listy",
                        ),
                        scrollPadding: const EdgeInsets.all(20.0),
                        maxLines: 1,
                        autofocus: true,
                        validator: (value) => (value != null &&
                                value.isEmpty &&
                                value.trim().length != 0)
                            ? 'Nie możesz dodać pustej pozycji'
                            : null,
                      ),
                      ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: tasklist.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            title: Text(
                              tasklist[index],
                              style: Theme.of(context).textTheme.headline1,
                            ),
                          );
                        },
                      ),
                    ]),
              ),
            ],
          ),
        ));
  }

  // Future AddToDo(
  //   String name,
  //   List<String> listtodo,
  // ) async {
  //   var _isChecked = List<bool>.filled(listtodo.length, false);
  //   final ToDoData = ToDo()
  //     ..setreminder = setreminder
  //     ..endDate = reminderdate
  //     ..name = name
  //     ..createdDate = DateTime.now()
  //     ..thingstodo = listtodo
  //     ..progress = 0
  //     ..isChecked = _isChecked;
  //   final box = Boxes.getToDos();
  //   box.add(ToDoData);
  // }

  void EditToDo(
      ToDo toDo, String name, List<String> listtodo, List<bool> isChecked) {
    var listdiff = listtodo.length - isChecked.length;
    var isCheckedfixed = List<bool>.filled(listdiff, false);
    List<bool> newList = new List.from(isChecked)..addAll(isCheckedfixed);
    int checkedvalues = 0;
    newList.forEach((element) {
      if (element == true) checkedvalues = checkedvalues + 1;
    });
    toDo.name = name;
    toDo.thingstodo = listtodo;
    toDo.isChecked = newList; //przedluz liste bool o nowa dlugosc listy todo
    toDo.progress = (checkedvalues / listtodo.length) * 100; //
    toDo.save();
  }

  void ValidationAlert() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Zadanie nie może być puste",
          style: TextStyle(color: Colors.red),
        ),
        duration: Duration(seconds: 3),
      ),
    );
  }
}
