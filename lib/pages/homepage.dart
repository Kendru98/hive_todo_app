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

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  Color checkProgress(double progress) {
    if (progress == 100) {
      return Color(0xFF86FC86);
    } else {
      return Color(0xFFBB86FC);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool switchState = UserSimplePreferences.getDarkTheme() ?? false;
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
              value: switchState,
              onChanged: (bool newValue) {
                setState(() {
                  switchState;
                });

                final provider = context.read<ThemeProvider>();
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
          final toDoProvider = provider.toDoList;

          return ListView.builder(
            itemCount: toDoProvider.length,
            itemBuilder: (context, index) {
              final providerIndex = toDoProvider[index];
              return Card(
                child: ListTile(
                  title: Text(
                    providerIndex.name,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.headline1,
                  ),
                  trailing: Text(
                    'Utworzony: \n' +
                        DateFormat.yMMMd('pl').format(
                          providerIndex.createdDate,
                        ),
                    style: Theme.of(context).textTheme.headline2,
                  ),
                  subtitle: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: new LinearPercentIndicator(
                      width: MediaQuery.of(context).size.width - 200,
                      animation: true,
                      lineHeight: 20,
                      animationDuration: 2000,
                      percent: providerIndex.progress / 100,
                      center: Text(
                          '${providerIndex.progress.toStringAsFixed(1)} %'),
                      barRadius: Radius.circular(20),
                      progressColor: checkProgress(
                        providerIndex.progress,
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsTodo(
                          todo: providerIndex,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
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
}
