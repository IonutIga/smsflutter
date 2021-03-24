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
                  style: TextStyle(
                      fontSize: 72, color: Color.fromARGB(255, 228, 68, 58)),
                  textAlign: TextAlign.center,
                ),
              ),
              Column(
                children: [
                  RaisedButton(
                    onPressed: () {
                      Utils.navigator(context: context, page: Register());
                    },
                    child: Text(
                      AppLocalizations.of(context).register,
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Utils.navigator(context: context, page: Login());
                    },
                    child: Text(AppLocalizations.of(context).login,
                        style: TextStyle(fontSize: 20)),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Utils.navigator(context: context, page: Help());
                    },
                    child: Text(AppLocalizations.of(context).help,
                        style: TextStyle(fontSize: 20)),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.copyright),
                    Text(
                      AppLocalizations.of(context).allRightsReserved,
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
