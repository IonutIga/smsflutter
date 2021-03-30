import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/stock/stockslist.dart';
import 'package:smsflutter/models/stock.dart';
import 'package:smsflutter/services/stocksFirestore.dart';

// Widget use to show the list of stocks on the market
class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<Stock>>.value(
      // Provide the list of stocks
      value: StocksFirestore().stocksList,
      child: Scaffold(
        body: StocksList(),
      ),
    );
  }
}
