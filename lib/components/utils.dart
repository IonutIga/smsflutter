import 'package:flutter/material.dart';

class Utils {
  static Color primaryColor = Color.fromARGB(255, 228, 68, 58);
  static Color secondaryColor = Color.fromARGB(255, 45, 189, 196);
  static TextTheme textTheme = TextTheme(
    headline1: TextStyle(
        fontSize: 32, color: Colors.black, fontWeight: FontWeight.normal),
    headline2: TextStyle(
        fontSize: 28, color: Colors.black, fontWeight: FontWeight.normal),
    headline3: TextStyle(
        fontSize: 22, color: Colors.black, fontWeight: FontWeight.normal),
    headline4: TextStyle(
        fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
    headline5: TextStyle(
        fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal),
    headline6: TextStyle(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal),
  );
  static SliderThemeData sliderTheme = SliderThemeData(
    activeTrackColor: Utils.secondaryColor,
  );
  static ButtonThemeData getButtonTheme({context: BuildContext}) {
    return ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        buttonColor: Utils.secondaryColor,
        colorScheme:
            Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
        textTheme: ButtonTextTheme.accent,
        minWidth: 400.00,
        height: 40);
  }

  static void navigator({context: BuildContext, page: Widget}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }
}
