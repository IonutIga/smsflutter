import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/loading.dart';
import 'package:smsflutter/components/stock/stocktemplate.dart';
import 'package:smsflutter/models/stock.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StocksList extends StatefulWidget {
  @override
  _StocksListState createState() => _StocksListState();
}

class _StocksListState extends State<StocksList> {
  @override
  Widget build(BuildContext context) {
    var stockList = Provider.of<List<Stock>>(context);
    return stockList == null
        ? Loading()
        : ListView.builder(
            itemCount: stockList.length,
            itemBuilder: (context, index) {
              return stockList == null
                  ? Loading()
                  : stockList.isNotEmpty
                      ? StockTemplate(stock: stockList[index])
                      : Center(
                          child: Text(
                            AppLocalizations.of(context).noStocksFound,
                            style: Theme.of(context).textTheme.headline4,
                            textAlign: TextAlign.center,
                          ),
                        );
            },
          );
  }
}
