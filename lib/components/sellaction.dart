import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/models/mystock.dart';
import 'package:smsflutter/services/stocksFirestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SellAction extends StatefulWidget {
  @override
  _SellActionState createState() => _SellActionState();

  final MyStock myStock;
  SellAction({this.myStock});
}

class _SellActionState extends State<SellAction> {
  double _quantity = 1;

  @override
  Widget build(BuildContext context) {
    num currentPrice = Provider.of<num>(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${AppLocalizations.of(context).boughtFor}: ${widget.myStock.buyPrice.toString()} ${AppLocalizations.of(context).currency}',
                style: TextStyle(fontSize: 18),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  '${AppLocalizations.of(context).current}: ${currentPrice.toString()} ${AppLocalizations.of(context).currency}',
                  style: TextStyle(fontSize: 18, color: Colors.green),
                ),
              ),
            ),
          ],
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: Slider(
                activeColor: Color.fromARGB(255, 45, 189, 196),
                value: _quantity,
                min: 1,
                max: widget.myStock.quantity.toDouble(),
                onChanged: (value) {
                  setState(() {
                    _quantity = value;
                  });
                },
              ),
            ),
            Text(
              _quantity.round().toString(),
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.start,
            ),
            Text(
              AppLocalizations.of(context).stocks,
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.end,
            ),
          ],
        ),
        RaisedButton(
          onPressed: () async {
            await StocksFirestore()
                .updateMyStock(myStock: widget.myStock, quantity: _quantity);
            Navigator.pop(context);
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
