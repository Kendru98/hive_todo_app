import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_todo_app/pages/homepage.dart';
import 'package:hive_todo_app/utils/user_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Colors.blue,
                Colors.teal,
              ]),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Dzień Dobry!',
                  style: GoogleFonts.lato(
                    textStyle: const TextStyle(
                      fontSize: 42,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    'aby przejść do aplikacji  i zacząć organizować swoje sprawy naciśnij przycisk!',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(top: 40),
                ),
                ElevatedButton(
                  onPressed: () {
                    UserSimplePreferences.setFirstRun(true);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomePage(),
                      ),
                    );
                  },
                  child: Text(
                    'Zaczynamy!',
                    style: GoogleFonts.lato(
                      textStyle: const TextStyle(
                        fontSize: 24,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
