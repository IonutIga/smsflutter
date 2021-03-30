import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/loading.dart';
import 'package:smsflutter/components/utils.dart';
import 'package:smsflutter/models/stock.dart';
import 'package:smsflutter/services/stocksFirestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Widget used to show the details of a stock on the market; enable buy option
class Details extends StatefulWidget {
  // Info source
  final Stock stock;
  @override
  _DetailsState createState() => _DetailsState();

  Details({this.stock});
}

class _DetailsState extends State<Details> {
  double _quantity = 0;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    // Color to so use for statistic info, based on result
    Color statisticColor =
        num.tryParse(widget.stock.statistic) >= 0 ? Colors.green : Colors.red;
    // max stocks a user can buy (specific type)
    double _maxBudget =
        (StocksFirestore.userBudget / widget.stock.nowPrice).roundToDouble();
    return _isLoading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).buy),
            ),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                // Main
                child: Column(
                  children: <Widget>[
                    // Image, Name
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          // Image
                          child: Image.network(widget.stock.imageUri,
                              width: 104, height: 104),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              // Short Name
                              Text(
                                widget.stock.shortName,
                                style: Theme.of(context).textTheme.headline1,
                              ),
                              // Long Name
                              Text(
                                widget.stock.longName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline4
                                    .copyWith(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Current, Previous, Price Difference
                    Row(
                      children: <Widget>[
                        Expanded(
                          // Current Price
                          child: Utils.getDetailsCard(
                              context,
                              AppLocalizations.of(context).current,
                              widget.stock.nowPrice),
                        ),
                        // Previous Price
                        Expanded(
                          child: Utils.getDetailsCard(
                              context,
                              AppLocalizations.of(context).previous,
                              widget.stock.oldPrice),
                        ),
                        // Price Difference
                        Expanded(
                          child: Utils.getDetailsCard(
                              context,
                              AppLocalizations.of(context).current,
                              widget.stock.nowPrice,
                              color: statisticColor),
                        ),
                      ],
                    ),
                    // Slider, Label
                    Row(
                      children: <Widget>[
                        Expanded(
                          // Slider
                          child: Slider(
                            value: _quantity,
                            min: 0,
                            max: _maxBudget,
                            onChanged: (value) {
                              setState(() {
                                _quantity = value;
                              });
                            },
                          ),
                        ),
                        // Quantity
                        Text(
                          _quantity.round().toString(),
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.start,
                        ),
                        // Label
                        Text(
                          AppLocalizations.of(context).stocks,
                          style: Theme.of(context).textTheme.headline4,
                          textAlign: TextAlign.end,
                        ),
                      ],
                    ),
                    // Buy Button
                    RaisedButton(
                      onPressed: () async {
                        if (_quantity != 0) {
                          try {
                            await StocksFirestore().insertMyStock(
                                stock: widget.stock, quantity: _quantity);
                          } catch (e) {
                            // Not enough money
                            return showDialog<AlertDialog>(
                              context: context,
                              child: AlertDialog(
                                title: Text(AppLocalizations.of(context).alert),
                                content: Text(
                                  AppLocalizations.of(context).alertBudgetMsg,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text('OK'),
                                  )
                                ],
                              ),
                            );
                          }
                          setState(() {
                            _isLoading = true;
                          });
                          Navigator.pop(context);
                        } else {
                          // No quantity set
                          return showDialog<AlertDialog>(
                            context: context,
                            child: AlertDialog(
                              title: Text(AppLocalizations.of(context).alert),
                              content: Text(
                                  AppLocalizations.of(context).alertQtyMsg),
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
                        AppLocalizations.of(context).buy,
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Align(
                        alignment: Alignment.bottomLeft,
                        // Label
                        child: Text(
                            AppLocalizations.of(context).companyDescription,
                            style: Theme.of(context).textTheme.headline2),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: SingleChildScrollView(
                        // Company description
                        child: Text(
                          widget.stock.companyDescription,
                          style: Theme.of(context).textTheme.headline4,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
  }
}
