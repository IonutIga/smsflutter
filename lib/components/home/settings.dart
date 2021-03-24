import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smsflutter/components/home/navpage.dart';
import 'package:smsflutter/models/currency.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  num _currency;

  initState() {
    super.initState();
    prefGet();
  }

  prefSet(num value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currency = value;
      Currency.currency = value;
      prefs.setDouble('currency', value);
    });
  }

  prefGet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currency = prefs.getDouble('currency') ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Slider(
              value: _currency != null ? _currency : 1,
              min: 1,
              max: 10,
              onChanged: (value) {
                setState(() {
                  _currency = value;
                });
              },
            ),
            Text(
              _currency == null
                  ? ''
                  : ' Rata actuală de conversie EUR-RON: ${_currency.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.headline5,
            ),
            SizedBox(
              height: 8,
            ),
            RaisedButton(
              onPressed: () async {
                await prefSet(_currency);
                Navigator.pushAndRemoveUntil(context,
                    MaterialPageRoute(builder: (context) {
                  return NavPage();
                }), (route) => false);
              },
              child: Text(
                'Salvează',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
