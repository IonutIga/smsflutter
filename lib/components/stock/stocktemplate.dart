import 'package:flutter/material.dart';
import 'package:smsflutter/components/home/details.dart';
import 'package:smsflutter/components/utils.dart';
import 'package:smsflutter/models/stock.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class StockTemplate extends StatelessWidget {
  final Stock stock;

  StockTemplate({this.stock});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Utils.navigator(
            context: context,
            page: Details(
              stock: stock,
            ));
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
                    child: Image.network(stock.imageUri, width: 56, height: 56),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          stock.shortName,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                        Text(
                          stock.longName,
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
                          '${AppLocalizations.of(context).current}: ${stock.nowPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        Text(
                          '${AppLocalizations.of(context).previous}: ${stock.oldPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  '${AppLocalizations.of(context).pricedifference}: ${stock.statistic} ${AppLocalizations.of(context).currency}',
                  style: TextStyle(
                      color: double.tryParse(stock.statistic) >= 0
                          ? Colors.green
                          : Colors.red,
                      fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
