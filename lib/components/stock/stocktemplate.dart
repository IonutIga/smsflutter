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
          context,
          Details(
            stock: stock,
          ),
        );
      },
      child: Utils.getTemplateStock(
        context,
        imageUri: stock.imageUri,
        shortName: stock.shortName,
        longName: stock.longName,
        labelOne: Utils.getColonLabels(
            AppLocalizations.of(context).current,
            stock.nowPrice.toStringAsFixed(2),
            Theme.of(context).textTheme.headline6),
        labelTwo: Utils.getColonLabels(
            AppLocalizations.of(context).previous,
            stock.oldPrice.toStringAsFixed(2),
            Theme.of(context).textTheme.headline6),
        priceDiff: Utils.getColonLabels(
          AppLocalizations.of(context).pricedifference,
          stock.statistic + AppLocalizations.of(context).currency,
          TextStyle(
              color: double.tryParse(stock.statistic) >= 0
                  ? Colors.green
                  : Colors.red,
              fontSize: 16),
        ),
      ),
    );
  }
}
