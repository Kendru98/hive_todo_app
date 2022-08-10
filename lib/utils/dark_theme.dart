import 'package:flutter/material.dart';
import 'package:hive_todo_app/utils/user_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

class ThemeProvider extends ChangeNotifier {
  late ThemeData _selectedTheme;

  ThemeData light = ThemeData.light().copyWith(
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.amber),
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
        ),
      ),
      headline2: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Color(0xff9C27B0),
        ),
      ),
      headline3: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w300,
          color: Color.fromARGB(255, 15, 13, 13),
        ),
      ),
    ),
  );

  ThemeData dark = ThemeData.dark().copyWith(
    floatingActionButtonTheme:
        FloatingActionButtonThemeData(backgroundColor: Colors.amber),
    appBarTheme: AppBarTheme(
      color: Color.fromARGB(127, 210, 197, 232),
      iconTheme: IconThemeData(color: Colors.white),
    ),
    primaryColor: Color(0xFFd2c5e8),
    cardTheme: CardTheme(
      color: Color.fromARGB(127, 210, 197, 232),
    ), //Colors.grey),
    textTheme: TextTheme(
      headline1: GoogleFonts.lato(
        textStyle: TextStyle(
            fontSize: 18.0, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      headline2: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 14.0,
          fontWeight: FontWeight.bold,
          color: Color.fromARGB(253, 227, 139, 243),
        ),
      ),
      headline3: GoogleFonts.lato(
        textStyle: TextStyle(
          fontSize: 16.0,
          fontWeight: FontWeight.w400,
          color: Color.fromARGB(255, 243, 243, 243),
        ),
      ),
    ),
  );

  ThemeProvider({required bool isDarkMode}) {
    _selectedTheme = isDarkMode ? dark : light;
  }

  Future<void> swapTheme() async {
    UserSimplePreferences.init();
    _selectedTheme != light ? _selectedTheme = dark : _selectedTheme = light;
    await UserSimplePreferences.setDarkTheme(true);
    notifyListeners();
  }

  ThemeData getTheme() => _selectedTheme;
}
