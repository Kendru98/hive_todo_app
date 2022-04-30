import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_app/model/thingstodo.dart';
import 'package:hive_todo_app/pages/todospage.dart';
import 'package:hive_todo_app/utils/user_preferences.dart';
import 'splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());
  await Hive.openBox<ToDo>('todos');

  await UserSimplePreferences.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  bool firstrun = UserSimplePreferences.getFirstRun() ?? false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: firstrun == false ? const SplashScreen() : const ToDoPage());
  }
}
