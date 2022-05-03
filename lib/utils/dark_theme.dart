import 'package:flutter/material.dart';
import 'package:hive_todo_app/utils/user_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;
  //LightTheme
  ThemeData light = ThemeData.light().copyWith(
      appBarTheme: AppBarTheme(
        color: Color.fromARGB(127, 210, 197, 232),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      primaryColor: Colors.white,
      cardTheme: CardTheme(color: Colors.white),
      textTheme: TextTheme(
          headline1: GoogleFonts.lato(
              textStyle: TextStyle(
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          )),
          headline2: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff9C27B0)),
          )));
  //DarkTheme
  ThemeData dark = ThemeData.dark().copyWith(
      appBarTheme: AppBarTheme(
        color: Color.fromARGB(127, 210, 197, 232),
        iconTheme: IconThemeData(color: Colors.white),
      ),
      primaryColor: Color(0xFFd2c5e8),
      cardTheme:
          CardTheme(color: Color.fromARGB(127, 210, 197, 232)), //Colors.grey),
      textTheme: TextTheme(
        headline1: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
                color: Colors.white)),
        headline2: GoogleFonts.lato(
            textStyle: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.bold,
                color: Color(0xff9C27B0))),

        //bodyText2: TextStyle(),
      ));

  ThemeProvider({required bool isDarkMode}) {
    _selectedTheme = isDarkMode ? dark : light;
  }

  Future<void> swapTheme() async {
    //SharedPreferences preferences = await SharedPreferences.getInstance();
    UserSimplePreferences.init();
    if (_selectedTheme == dark) {
      _selectedTheme = light;
      //preferences.setBool("isDarkTheme", false);
      UserSimplePreferences.setDarkTheme(false);
    } else {
      _selectedTheme = dark;
      //preferences.setBool("isDarkTheme", true);
      UserSimplePreferences.setDarkTheme(true);
    }
    notifyListeners();
  }

  ThemeData getTheme() => _selectedTheme;
}
