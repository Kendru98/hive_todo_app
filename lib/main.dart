import 'package:flutter/material.dart';

import 'package:hive_flutter/hive_flutter.dart';

import 'package:hive_todo_app/pages/todospage.dart';
import 'package:hive_todo_app/providers/todo_provider.dart';
import 'package:hive_todo_app/utils/dark_theme.dart';
import 'package:hive_todo_app/utils/user_preferences.dart';

import 'model/to_do.dart';
import 'splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());
  await Hive.openBox<ToDo>('todos');

  await UserSimplePreferences.init().then(
    (preferences) {
      bool isDarkTheme = UserSimplePreferences.getDarkTheme() ?? false;
      return runApp(
        ChangeNotifierProvider<ThemeProvider>(
          child: MyApp(),
          create: (BuildContext context) {
            return ThemeProvider(isDarkMode: isDarkTheme);
          },
        ),
      );
    },
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool firstrun = UserSimplePreferences.getFirstRun() ?? false;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => TodoListController(),
        )
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, value, child) {
          return MaterialApp(
            theme: value.getTheme(),
            home: firstrun ? const ToDoPage() : const SplashScreen(),
          );
        },
      ),
    );
  }
}
