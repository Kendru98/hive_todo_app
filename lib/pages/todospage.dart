import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo_app/api/localnotification_api.dart';
import 'package:hive_todo_app/pages/details_todo.dart';
import 'package:hive_todo_app/pages/add_edit_todo.dart';
import 'package:hive_todo_app/providers/todo_provider.dart';
import 'package:hive_todo_app/utils/dark_theme.dart';
import 'package:hive_todo_app/utils/user_preferences.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToDoPage extends StatefulWidget {
  const ToDoPage({Key? key}) : super(key: key);

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  @override
  void dispose() {
    Hive.box('todos').close();
    super.dispose();
  }

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

                final provider = context.read()<ThemeProvider>();
                provider.swapTheme();
              },
            ),
            Icon(
              FontAwesomeIcons.moon,
              color: Colors.grey,
            ),
          ],
        ),
        elevation: 0,
      ),
      body: Consumer<TodoListController>(
        builder: (context, provider, child) {
          return ListView.builder(
            itemCount: provider.toDoList.length,
            itemBuilder: (context, index) => Card(
              child: ListTile(
                title: Text(provider.toDoList[index].name,
                    maxLines: 2, style: Theme.of(context).textTheme.headline1),
                trailing: Text(
                    'Utworzony: \n' +
                        DateFormat.yMMMd('pl')
                            .format(provider.toDoList[index].createdDate),
                    style: Theme.of(context).textTheme.headline2),
                subtitle: Padding(
                  padding: EdgeInsets.all(15.0),
                  child: new LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 200,
                      animation: true,
                      lineHeight: 20.0,
                      animationDuration: 2000,
                      percent: provider.toDoList[index].progress / 100,
                      center: Text(
                          '${provider.toDoList[index].progress.toStringAsFixed(1)} %'),
                      barRadius: Radius.circular(20),
                      progressColor:
                          checkProgress(provider.toDoList[index].progress)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailsTodo(
                        todo: provider.toDoList[index],
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddEditTodo(),
            ),
          );
        },
      ),
    );
  }

  Color checkProgress(double progress) {
    if (progress == 100) {
      return Color(0xFF86FC86);
    } else {
      return Color(0xFFBB86FC);
    }
  }
}
