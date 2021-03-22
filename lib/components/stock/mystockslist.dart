import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/loading.dart';
import 'package:smsflutter/components/stock/mystocktemplate.dart';
import 'package:smsflutter/models/mystock.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyStocksList extends StatefulWidget {
  @override
  _MyStocksListState createState() => _MyStocksListState();
}

class _MyStocksListState extends State<MyStocksList> {
  @override
  Widget build(BuildContext context) {
    var myStockList = Provider.of<List<MyStock>>(context);
    return myStockList == null
        ? Loading()
        : myStockList.isNotEmpty
            ? ListView.builder(
                itemCount: myStockList.length,
                itemBuilder: (context, index) {
                  return MyStockTemplate(mystock: myStockList[index]);
                },
              )
            : Center(
                child: Text(
                  AppLocalizations.of(context).noStocksFound,
                  style: TextStyle(
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
  }
}
