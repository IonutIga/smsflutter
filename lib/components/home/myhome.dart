import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/stock/mystockslist.dart';
import 'package:smsflutter/models/mystock.dart';
import 'package:smsflutter/services/stocksFirestore.dart';

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return StreamProvider<List<MyStock>>.value(
      value: StocksFirestore().myStockList,
      child: Scaffold(
        body: MyStocksList(),
      ),
    );
  }
}
