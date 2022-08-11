import 'package:flutter/cupertino.dart';
import 'package:hive_todo_app/boxes.dart';
import 'package:hive_todo_app/model/todo.dart';

class TodoListController extends ChangeNotifier {
  List<ToDo> _toDoList = [];
  List<ToDo> get toDoList => _toDoList;

  var box = Boxes.getToDos();
  TodoListController() {
    _fetchTodos();
  }

  void _fetchTodos() {
    _toDoList = box.values.toList().cast<ToDo>();
    notifyListeners();
  }

  void countProgress(List<bool> checkedList, ToDo toDo) {
    double progress;
    int checkedvalues = 0;
    int listsize = checkedList.length;

    checkedList.forEach((element) {
      if (element) checkedvalues = checkedvalues + 1;
    });
    progress = (checkedvalues / listsize) * 100;
    updateProgress(progress, toDo);
  }

  Future<void> updateProgress(double progress, ToDo toDo) async {
    toDo.progress = progress;

    await toDo.save();
    notifyListeners();
  }

  Future<void> deleteTodo(ToDo toDo) async {
    await toDo.delete();
    _fetchTodos();
  }

  Future<void> addTodo(
    String name,
    List<String> listtodo,
    bool reminderset,
    DateTime reminder,
  ) async {
    List<bool> _isChecked = List<bool>.filled(listtodo.length, false);
    final ToDo toDoData = ToDo()
      ..setreminder = reminderset
      ..endDate = reminder
      ..name = name
      ..createdDate = DateTime.now()
      ..thingstodo = listtodo
      ..progress = 0
      ..isChecked = _isChecked;

    await box.add(toDoData);
    _fetchTodos();
  }

  Future<void> editToDo(
    ToDo toDo,
    String name,
    List<String> listtodo,
    List<bool> isChecked,
  ) async {
    var listdiff = listtodo.length - isChecked.length;
    var isCheckedfixed = List<bool>.filled(listdiff, false);
    List<bool> newList = new List.from(isChecked)..addAll(isCheckedfixed);
    int checkedvalues = 0;
    newList.forEach(
      (element) {
        if (element) checkedvalues = checkedvalues + 1;
      },
    );
    toDo.name = name;
    toDo.thingstodo = listtodo;
    toDo.isChecked = newList; //przedluz liste bool o nowa dlugosc listy todo
    toDo.progress = (checkedvalues / listtodo.length) * 100; //
    await toDo.save();
  }
}
