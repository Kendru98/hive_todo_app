import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_todo_app/api/localnotification_api.dart';
import 'package:hive_todo_app/api/todoservice.dart';
import 'package:hive_todo_app/bloc/blocs.dart';
import 'package:hive_todo_app/pages/todocreatepage.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../model/thingstodo.dart';
import '../utils/dark_theme.dart';
import '../utils/user_preferences.dart';
import '../api/localnotification_api.dart';
import 'detailstodo_page.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  // void dispose() {
  //   Hive.box('todos').close();
  //   super.dispose(); //7:45
  // }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    NotificationApi.init(initScheduled: true);
    listenNotifications();
  }

  void listenNotifications() => NotificationApi.onNotifications.stream.listen;

  @override
  Widget build(BuildContext context) {
    final bool switchstate = UserSimplePreferences.getDarkTheme() ?? false;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              FontAwesomeIcons.sun,
              color: Colors.yellowAccent,
            ),
            CupertinoSwitch(
                value: switchstate,
                onChanged: (bool newValue) {
                  setState(() {
                    switchstate;
                  });
                  Provider.of<ThemeProvider>(context, listen: false)
                      .swapTheme();
                }),
            Icon(
              FontAwesomeIcons.moon,
              color: Colors.grey,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) =>
            TodosBloc(RepositoryProvider.of<TodoService>(context))
              ..add(LoadTodos()),
        child: BlocBuilder<TodosBloc, TodosState>(builder: (context, state) {
          if (state is TodosLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          if (state is TodosLoaded) {
            return Column(
              children: [
                const SizedBox(height: 24),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8),
                    itemCount: state.todos.length, //todos.length,
                    itemBuilder: (BuildContext context, int index) {
                      //final todo = todos[index];

                      return buildList(context, state.todos[index]);
                    },
                  ),
                ),
              ],
            );
          }
          return Text('Something goes wrong');
        }),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Colors.white,
        elevation: 10,
        hoverColor: Colors.green,
        tooltip: 'Dodaj nową listę',
        child: Icon(
          FontAwesomeIcons.plus,
        ),
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => AddEditToDos())));
        },
      ),
    );
  }

  Widget buildList(
    BuildContext context,
    ToDo todo,
  ) {
    final date = DateFormat.yMMMd('pl').format(todo.createdDate);

    return Card(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: ((context) => DetailsTodo(
                        todo: todo,
                      ))));
        },
        child: ListTile(
          title: Text(todo.name,
              maxLines: 2, style: Theme.of(context).textTheme.headline1),
          trailing: Text('Utworzony: \n' + date,
              style: Theme.of(context).textTheme.headline2),
          subtitle: Padding(
            padding: EdgeInsets.all(15.0),
            child: new LinearPercentIndicator(
                width: MediaQuery.of(context).size.width - 200,
                animation: true,
                lineHeight: 20.0,
                animationDuration: 2000,
                percent: todo.progress / 100,
                center: Text('${todo.progress.ceil()} %'),
                barRadius: Radius.circular(20),
                progressColor: checkprogress(todo.progress)),
          ),
        ),
      ),
    );
  }

  checkprogress(double progress) {
    if (progress == 100) {
      return Color(0xFF86FC86);
    } else {
      return Color(0xFFBB86FC);
    }
  }
}
