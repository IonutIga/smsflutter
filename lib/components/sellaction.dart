import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/utils.dart';
import 'package:smsflutter/models/mystock.dart';
import 'package:smsflutter/services/stocksFirestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Widget for the sell action
class SellAction extends StatefulWidget {
  @override
  _SellActionState createState() => _SellActionState();

  // Stock to be sold
  final MyStock myStock;
  SellAction({this.myStock});
}

class _SellActionState extends State<SellAction> {
  // Quantity to sell, default 1 for eliminating errors
  double _quantity = 1;

  @override
  Widget build(BuildContext context) {
    // Current price of the stock on the market
    num currentPrice = Provider.of<num>(context);
    return
        // Main
        Column(
      // Show the Dialog wrapped around info
      mainAxisSize: MainAxisSize.min,
      children: [
        // Buy Price and Current Price
        Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              // Buy Price
              child: Utils.getColonLabels(
                  AppLocalizations.of(context).boughtFor,
                  widget.myStock.buyPrice.toStringAsFixed(2) +
                      AppLocalizations.of(context).currency,
                  Theme.of(context).textTheme.headline6),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                // Current Price
                child: Utils.getColonLabels(
                    AppLocalizations.of(context).current,
                    currentPrice != null
                        ? currentPrice.toStringAsFixed(2) +
                            AppLocalizations.of(context).currency
                        : " ",
                    Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.green)),
              ),
            ),
          ],
        ),
        // Slider and its value
        Row(
          children: <Widget>[
            Expanded(
              // Slider
              child: Slider(
                activeColor: Color.fromARGB(255, 45, 189, 196),
                value: _quantity,
                min: 1,
                // Cannot sell more than owned
                max: widget.myStock.quantity.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _quantity = value;
                  });
                },
              ),
            ),
            // Slider value
            Text(
              _quantity.round().toString(),
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.start,
            ),
            Text(
              AppLocalizations.of(context).stocks,
              style: Theme.of(context).textTheme.headline4,
              textAlign: TextAlign.end,
            ),
          ],
        ),
        // Button for selling process
        RaisedButton(
          onPressed: () async {
            // Check for errors
            try {
              await StocksFirestore()
                  .updateMyStock(myStock: widget.myStock, quantity: _quantity);
              Navigator.pop(context);
            } catch (e) {
              return showDialog<AlertDialog>(
                context: context,
                child: AlertDialog(
                  title: Text(AppLocalizations.of(context).alert),
                  content: Text(AppLocalizations.of(context).generalErrorMsg),
                  actions: <Widget>[
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('OK'))
                  ],
                ),
              );
            }
          },
          child: Text(
            AppLocalizations.of(context).sell,
            style: TextStyle(fontSize: 18),
          ),
        )
      ],
    );
  }
}
