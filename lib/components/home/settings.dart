import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smsflutter/components/home/navpage.dart';
import 'package:smsflutter/components/utils.dart';
import 'package:smsflutter/models/currency.dart';

// Widget used to display settings option; only for Ro
class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  num _currency;

// Get the currency everytime the page is loaded
  initState() {
    super.initState();
    prefGet();
  }

// Set the currency in shared preferences
  prefSet(num value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _currency = value;
      Currency.currency = value;
      prefs.setDouble('currency', value);
    });
  }

// Get the currency from shared preferences
  prefGet() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      // default to avoid any error
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
        // Main
        child: Column(
          children: [
            // Slider
            Slider(
              // Default to avoid any error
              value: _currency != null ? _currency : 1,
              min: 1,
              max: 10,
              onChanged: (value) {
                setState(() {
                  _currency = value;
                });
              },
            ),
            // Info label
            Utils.getColonLabels(
                "Rata actuală de conversie EUR-RON",
                _currency?.toStringAsFixed(2),
                Theme.of(context).textTheme.headline5),
            SizedBox(
              height: 8,
            ),
            // Button to save the new currency value
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
