import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_app/bloc/todos_bloc.dart';
import 'package:hive_todo_app/model/thingstodo.dart';
import 'package:hive_todo_app/pages/todospage.dart';
import 'package:hive_todo_app/utils/dark_theme.dart';
import 'package:hive_todo_app/utils/user_preferences.dart';
import 'splash_screen.dart';
import 'package:provider/provider.dart';
import '/bloc/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(ToDoAdapter());
  await Hive.openBox<ToDo>('todos');

  await UserSimplePreferences.init().then((preferences) {
    var isDarkTheme = UserSimplePreferences.getDarkTheme() ?? false;
    return runApp(
      ChangeNotifierProvider<ThemeProvider>(
        child: MyApp(),
        create: (BuildContext context) {
          return ThemeProvider(isDarkMode: isDarkTheme);
        },
      ),
    );
  });
}

class MyApp extends StatelessWidget {
  bool firstrun = UserSimplePreferences.getFirstRun() ?? false;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => TodosBloc()..add(LoadTodos()),
          ),
        ],
        child: Consumer<ThemeProvider>(builder: (context, value, child) {
          return MaterialApp(
            theme: value.getTheme(),
            home: firstrun == false ? const SplashScreen() : const ToDoPage(),
          );
        }));
  }
}
