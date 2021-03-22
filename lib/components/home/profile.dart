import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/mystockchart.dart';
import 'package:smsflutter/components/userAuth/menu.dart';
import 'package:smsflutter/services/auth.dart';
import 'package:smsflutter/services/stocksFirestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      value: StocksFirestore().getMyStockGroup(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        AppLocalizations.of(context).profile,
                        style: TextStyle(fontSize: 22),
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  '${AppLocalizations.of(context).name}: ${Auth.localUser.name}',
                                  style: TextStyle(fontSize: 20)),
                              SizedBox(height: 8),
                              Text(
                                  '${AppLocalizations.of(context).email}: ${Auth.localUser.email}',
                                  style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                AppLocalizations.of(context).statistics,
                style: TextStyle(fontSize: 22),
              ),
              SizedBox(height: 8),
              MyStockChart(),
              ButtonTheme(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                buttonColor: Color.fromARGB(255, 45, 189, 196),
                colorScheme: Theme.of(context)
                    .colorScheme
                    .copyWith(secondary: Colors.white),
                textTheme: ButtonTextTheme.accent,
                minWidth: 400,
                height: 40,
                child: RaisedButton(
                    child: Text(
                      AppLocalizations.of(context).logout,
                      style: TextStyle(fontSize: 20),
                    ),
                    onPressed: () {
                      _auth.signOut();
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (context) {
                        return Menu();
                      }), (route) => false);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
