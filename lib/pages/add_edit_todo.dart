import 'package:flutter/material.dart';
import 'package:hive_todo_app/api/localnotification_api.dart';
import 'package:hive_todo_app/model/to_do.dart';
import 'package:hive_todo_app/providers/todo_provider.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class AddEditTodo extends StatefulWidget {
  final ToDo? toDo;
  AddEditTodo({this.toDo});
  @override
  _AddEditTodoState createState() => _AddEditTodoState();
}

class _AddEditTodoState extends State<AddEditTodo> {
  final _formKey = GlobalKey<FormState>();
  final listitem = TextEditingController();
  final tasktitle = TextEditingController();
  var reminderdate = DateTime.now();
  var setreminder = false;
  List<String> tasklist = [];

  var count = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.toDo != null) {
      tasktitle.text = widget.toDo!.name;
      tasklist = widget.toDo!.thingstodo;
    }
    FocusNode myFocusNode = FocusNode();
    final provider = context.read<
        TodoListController>(); //Provider.of<TodoListController>(context, listen: false);
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
              onTap: () async {
                FocusScope.of(context).unfocus();
                DatePicker.showDateTimePicker(context,
                    theme: DatePickerTheme(),
                    currentTime: DateTime.now(),
                    showTitleActions: true,
                    minTime: DateTime.now(),
                    maxTime: DateTime(2030, 6, 7, 05, 09), onChanged: (date) {
                  print('change $date in time zone ' +
                      date.timeZoneOffset.inHours.toString());
                }, onConfirm: (date) {
                  setreminder = true;
                  print('confirm $date');
                  setState(() {
                    reminderdate = date;
                  });
                }, locale: LocaleType.pl);
              },
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 30, 8),
            child: GestureDetector(
              child: const Icon(
                Icons.check,
                size: 28,
              ),
              onTap: () {
                if (widget.toDo != null) {
                  NotificationApi.showScheduledNotification(
                      title: tasktitle.text,
                      body: 'Pamiętaj o swoich rzeczach do zrobienia!',
                      scheduleDate: reminderdate);
                  provider.editToDo(widget.toDo!, tasktitle.text,
                      widget.toDo!.thingstodo, widget.toDo!.isChecked);

                  Navigator.of(context).popUntil((_) => count++ >= 2);
                } else {
                  provider.addTodo(
                      tasktitle.text, tasklist, setreminder, reminderdate);
                  if (setreminder == true) {
                    NotificationApi.showScheduledNotification(
                        title: tasktitle.text,
                        body: 'Pamiętaj o swoich rzeczach do zrobienia!',
                        scheduleDate: reminderdate);
                  }
                  Navigator.pop(context);
                }
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
                      if (giventask.isEmpty || giventask.trim().length == 0) {
                        return validationAlert();
                      } else {
                        setState(() {
                          tasklist.add(giventask);
                          listitem.clear();
                          myFocusNode.requestFocus();
                        });
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void validationAlert() {
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