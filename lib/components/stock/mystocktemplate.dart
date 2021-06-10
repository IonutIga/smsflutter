import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/sellaction.dart';
import 'package:smsflutter/components/utils.dart';
import 'package:smsflutter/models/mystock.dart';
import 'package:smsflutter/services/stocksFirestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Widget used to display an individual my stock
class MyStockTemplate extends StatelessWidget {
  final MyStock mystock;

  MyStockTemplate({this.mystock});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      // Show dialog to enable sell option
      onTap: () {
        showDialog<AlertDialog>(
          context: context,
          child: StreamProvider.value(
            value: StocksFirestore().getMyStock(mystock.shortName),
            child: AlertDialog(
              title: Text(mystock.shortName),
              content: SellAction(myStock: mystock),
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
      // Get the template from utils using data from the owned stock
      child: Utils.getTemplateStock(
        context,
        imageUri: mystock.imageUri,
        shortName: mystock.shortName,
        longName: mystock.longName,
        labelOne: Utils.getColonLabels(
            AppLocalizations.of(context).boughtFor,
            mystock.buyPrice.toStringAsFixed(2),
            Theme.of(context).textTheme.headline6),
        labelTwo: Utils.getColonLabels(AppLocalizations.of(context).quantity,
            mystock.quantity.toString(), Theme.of(context).textTheme.headline6),
      ),
    );
  }
}
