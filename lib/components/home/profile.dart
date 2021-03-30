import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/mystockchart.dart';
import 'package:smsflutter/components/userAuth/menu.dart';
import 'package:smsflutter/components/utils.dart';
import 'package:smsflutter/services/auth.dart';
import 'package:smsflutter/services/stocksFirestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Widget used to show info about the current logged in user and a chart about owned stocks
class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // Enable Auth service
  final Auth _auth = Auth();

  @override
  Widget build(BuildContext context) {
    return StreamProvider.value(
      // Provide the values to use for the chart
      value: StocksFirestore().getMyStockGroup(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          // Main
          child: Column(
            children: <Widget>[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  // Label, Name, Email
                  child: Column(
                    children: [
                      // Label
                      Text(
                        AppLocalizations.of(context).profile,
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Name
                              Utils.getColonLabels(
                                  AppLocalizations.of(context).name,
                                  Auth.localUser.name,
                                  Theme.of(context).textTheme.headline4),
                              SizedBox(height: 8),
                              // Email
                              Utils.getColonLabels(
                                  AppLocalizations.of(context).email,
                                  Auth.localUser.email,
                                  Theme.of(context).textTheme.headline4),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 8),
              // Label
              Text(
                AppLocalizations.of(context).statistics,
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: 8),
              // Initialize the chart
              MyStockChart(),
              // Logout Button
              RaisedButton(
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
                  })
            ],
          ),
        ),
      ),
    );
  }
}
