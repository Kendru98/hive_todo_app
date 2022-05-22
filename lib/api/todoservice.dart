import 'package:hive/hive.dart';
import 'package:hive_todo_app/model/thingstodo.dart';

class TodoService {
  late Box<ToDo> _todos;

  Future<void> init() async {
    // Hive.registerAdapter(ToDoAdapter());
    _todos = await Hive.openBox<ToDo>('todos');
  }

  List<ToDo> getTodos() {
    final todos = _todos.values;
    print(todos.toList());
    return todos.toList();
  }

  void addTodo(String name, List<String> listtodo) {
    var _isChecked = List<bool>.filled(listtodo.length, false);

    // final box = Boxes.getToDos();
    // box.add(ToDoData);
    _todos.add(ToDo(
      name,
      DateTime.now(),
      true, //pointless
      DateTime.now(), //pointless
      _isChecked,
      0,
      listtodo,
    ));
  }

  Future<void> removeTodo(final ToDo todo) async {
    await todo.delete();
  }

  Future<void> updateTodo(ToDo toDo, String name, List<String> listtodo,
      List<bool> isChecked) async {
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
