import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smsflutter/components/userAuth/help.dart';
import 'package:smsflutter/components/userAuth/login.dart';
import 'package:smsflutter/components/userAuth/register.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smsflutter/components/utils.dart';

// Widget for the menu screen
class Menu extends StatefulWidget {
  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  // Initialize preferences with a default value if not set
  // User will reach this page at least once
  initPrefs() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getDouble('currency') == null) pref.setDouble('currency', 4.4);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Stock Market Simulator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          // Main
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 88.0),
                child: Text(
                  'Stock Market Simulator',
                  style: TextStyle(fontSize: 72, color: Utils.primaryColor),
                  textAlign: TextAlign.center,
                ),
              ),
              // Register, Login, Help Buttons
              Column(
                children: [
                  // Register
                  RaisedButton(
                    onPressed: () {
                      Utils.navigator(context, Register());
                    },
                    child: Text(
                      AppLocalizations.of(context).register,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  // Login
                  RaisedButton(
                      onPressed: () {
                        Utils.navigator(context, Login());
                      },
                      child: Text(
                        AppLocalizations.of(context).login,
                        style: TextStyle(fontSize: 20),
                      )),
                  // Help
                  RaisedButton(
                    onPressed: () {
                      Utils.navigator(context, Help());
                    },
                    child: Text(AppLocalizations.of(context).help,
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Utils.getAllRightsReserved(context),
              )
            ],
          ),
        ),
      ),
    );
  }
}
