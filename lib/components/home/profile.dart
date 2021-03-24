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
                        style: Theme.of(context).textTheme.headline3,
                      ),
                      SizedBox(height: 8),
                      Row(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                  '${AppLocalizations.of(context).name}: ${Auth.localUser.name}',
                                  style: Theme.of(context).textTheme.headline4),
                              SizedBox(height: 8),
                              Text(
                                  '${AppLocalizations.of(context).email}: ${Auth.localUser.email}',
                                  style: Theme.of(context).textTheme.headline4),
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
                style: Theme.of(context).textTheme.headline3,
              ),
              SizedBox(height: 8),
              MyStockChart(),
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
