import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smsflutter/components/userAuth/help.dart';
import 'package:smsflutter/components/userAuth/login.dart';
import 'package:smsflutter/components/userAuth/register.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smsflutter/components/utils.dart';

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
              Column(
                children: [
                  RaisedButton(
                    onPressed: () {
                      Utils.navigator(context, Register());
                    },
                    child: Text(
                      AppLocalizations.of(context).register,
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Utils.navigator(context, Login());
                    },
                    child: Text(AppLocalizations.of(context).login,
                        style: Theme.of(context).textTheme.headline4),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Utils.navigator(context, Help());
                    },
                    child: Text(AppLocalizations.of(context).help,
                        style: Theme.of(context).textTheme.headline4),
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
