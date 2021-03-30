import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/authlistener.dart';
import 'package:smsflutter/components/utils.dart';
import 'package:smsflutter/models/user.dart';
import 'package:smsflutter/services/auth.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Providing the user to the AuthListener child
    return StreamProvider<User>.value(
      value: Auth().user,
      child: MaterialApp(
        localizationsDelegates: [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', ''),
          const Locale('ro', ''),
        ],
        home: AuthListener(),
        // Setting general themes for different widgets
        theme: ThemeData(
          textTheme: Utils.textTheme,
          sliderTheme: Utils.sliderTheme,
          buttonTheme: Utils.getButtonTheme(context),
          primaryColor: Utils.primaryColor,
        ),
      ),
    );
  }
}
