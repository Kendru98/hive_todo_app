import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Colors.blue, Colors.teal]
            // Color(Colors.accents, Colors.blue),
            ),
      ),
      child: Column(
        children: [
          Text(
            'Dzień Dobry!',
            style: GoogleFonts.lato(
              textStyle: const TextStyle(
                fontSize: 42,
              ),
            ),
          )
        ],
      ),
    );
  }
}
