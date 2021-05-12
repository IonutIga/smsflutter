import 'package:flutter/material.dart';
import 'package:smsflutter/components/home/details.dart';
import 'package:smsflutter/components/utils.dart';
import 'package:smsflutter/models/stock.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Widget used to display an individual stock
class StockTemplate extends StatelessWidget {
  // where the data comes from
  final Stock stock;

  StockTemplate({this.stock});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Navigate to details page
      onTap: () {
        Utils.navigator(
          context,
          Details(
            stock: stock,
          ),
        );
      },
      // Get the template from utils using data from the stock
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
          stock.statistic + ' ' + AppLocalizations.of(context).currency,
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
