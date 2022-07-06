import 'package:flutter/cupertino.dart';

import '../boxes.dart';
import '../model/thingstodo.dart';

class TodoListController extends ChangeNotifier {
  List<ToDo> _todolist = [];
  List<ToDo> get todolist => _todolist;

  var Box = Boxes.getToDos();
  TodoListController() {
    _fetchTodos();
    notifyListeners();
  }

  void _fetchTodos() {
    _todolist = Box.values.toList().cast<ToDo>();
    notifyListeners();
  }

  countProgress(List<bool> CheckedList, ToDo toDo) {
    double progress;
    int checkedvalues = 0;
    int listsize = CheckedList.length;

    CheckedList.forEach((element) {
      if (element == true) checkedvalues = checkedvalues + 1;
    });
    progress = (checkedvalues / listsize) * 100;
    updateProgress(progress, toDo);
  }

  updateProgress(double progress, ToDo toDo) {
    toDo.progress = progress;

    toDo.save();
    notifyListeners();
  }

  deletetodo(ToDo todo) {
    todo.delete();
    _fetchTodos();
  }

  addtodo(
    String name,
    List<String> listtodo,
    bool reminderset,
    DateTime reminder,
  ) {
    var _isChecked = List<bool>.filled(listtodo.length, false);
    final ToDoData = ToDo()
      ..setreminder = reminderset
      ..endDate = reminder
      ..name = name
      ..createdDate = DateTime.now()
      ..thingstodo = listtodo
      ..progress = 0
      ..isChecked = _isChecked;

    Box.add(ToDoData);
    _fetchTodos();
  }

  editToDo(
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
}
