import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/sellaction.dart';
import 'package:smsflutter/models/mystock.dart';
import 'package:smsflutter/services/stocksFirestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class MyStockTemplate extends StatefulWidget {
  final MyStock mystock;

  MyStockTemplate({this.mystock});

  @override
  _MyStockTemplateState createState() => _MyStockTemplateState();
}

class _MyStockTemplateState extends State<MyStockTemplate> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog<AlertDialog>(
          context: context,
          child: StreamProvider.value(
            value: StocksFirestore().getMyStock(widget.mystock.shortName),
            child: AlertDialog(
              title: Text(widget.mystock.shortName),
              content: SellAction(myStock: widget.mystock),
              actions: <Widget>[
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context).cancel))
              ],
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Image.network(widget.mystock.imageUri,
                        width: 56, height: 56),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.mystock.shortName,
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          widget.mystock.longName,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Text(
                          '${AppLocalizations.of(context).boughtFor}: ${widget.mystock.buyPrice.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '${AppLocalizations.of(context).quantity}: ${widget.mystock.quantity}',
                          style: TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
