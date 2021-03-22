import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/budget.dart';
import 'package:smsflutter/components/home/home.dart';
import 'package:smsflutter/components/home/profile.dart';
import 'package:smsflutter/services/stocksFirestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'myhome.dart';

class NavPage extends StatefulWidget {
  @override
  _NavPageState createState() => _NavPageState();
}

class _NavPageState extends State<NavPage> {
  int _index = 0;
  static final List<Widget> _navPages = <Widget>[MyHome(), Home(), Profile()];

  @override
  Widget build(BuildContext context) {
    return StreamProvider<num>.value(
      value: StocksFirestore().budget,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text('Stock Market Simulator'),
          actions: [Budget()],
        ),
        body: Center(child: _navPages.elementAt(_index)),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.money),
                label: AppLocalizations.of(context).stocks),
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: AppLocalizations.of(context).market),
            BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: AppLocalizations.of(context).profile),
          ],
          onTap: _onItemTapped,
        ),
      ),
    );
  }

  _onItemTapped(int index) {
    setState(() {
      _index = index;
    });
  }
}
