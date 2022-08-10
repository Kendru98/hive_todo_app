import 'package:hive/hive.dart';
import 'package:hive_todo_app/model/to_do.dart';

class Boxes {
  static Box<ToDo> getToDos() => Hive.box<ToDo>('todos');
}
