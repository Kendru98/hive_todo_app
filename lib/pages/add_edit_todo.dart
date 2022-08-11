import 'package:flutter/material.dart';
import 'package:hive_todo_app/api/localnotification_api.dart';
import 'package:hive_todo_app/model/todo.dart';
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
  final listItem = TextEditingController();
  final taskTitle = TextEditingController();
  DateTime reminderDate = DateTime.now();
  bool setReminder = false;
  List<String> taskList = [];

  var count = 0;
  @override
  Widget build(BuildContext context) {
    if (widget.toDo != null) {
      taskTitle.text = widget.toDo!.name;
      taskList = widget.toDo!.thingstodo;
    }
    FocusNode myFocusNode = FocusNode();
    final provider = context.read<TodoListController>();
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        actions: [
          Container(
            margin: const EdgeInsets.fromLTRB(0, 8, 30, 8),
            child: GestureDetector(
              child: const Icon(
                FontAwesomeIcons.bell,
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
                  setReminder = true;
                  print('confirm $date');
                  setState(() {
                    reminderDate = date;
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
              ),
              onTap: () {
                if (widget.toDo != null) {
                  NotificationApi.showScheduledNotification(
                      title: taskTitle.text,
                      body: 'Pamiętaj o swoich rzeczach do zrobienia!',
                      scheduleDate: reminderDate);
                  provider.editToDo(
                    widget.toDo!,
                    taskTitle.text,
                    widget.toDo!.thingstodo,
                    widget.toDo!.isChecked,
                  );

                  Navigator.of(context).popUntil((_) => count++ >= 2);
                } else {
                  provider.addTodo(
                      taskTitle.text, taskList, setReminder, reminderDate);
                  if (setReminder) {
                    NotificationApi.showScheduledNotification(
                      title: taskTitle.text,
                      body: 'Pamiętaj o swoich rzeczach do zrobienia!',
                      scheduleDate: reminderDate,
                    );
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
                    controller: taskTitle,
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
                          taskList.add(giventask);
                          listItem.clear();
                          myFocusNode.requestFocus();
                        });
                      }
                    },
                    controller: listItem,
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
                    itemCount: taskList.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(
                          taskList[index],
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
