import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/loading.dart';
import 'package:smsflutter/components/utils.dart';
import 'package:smsflutter/models/stock.dart';
import 'package:smsflutter/services/stocksFirestore.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Details extends StatefulWidget {
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
    Color statisticColor =
        num.tryParse(widget.stock.statistic) >= 0 ? Colors.green : Colors.red;
    double _maxBudget =
        (StocksFirestore.userBudget / widget.stock.nowPrice).roundToDouble();
    return _isLoading
        ? Loading()
        : StreamProvider<num>.value(
            value: StocksFirestore().budget,
            child: Scaffold(
              appBar: AppBar(
                title: Text(AppLocalizations.of(context).buy),
              ),
              body: Padding(
                padding: const EdgeInsets.all(8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.network(widget.stock.imageUri,
                                width: 104, height: 104),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  widget.stock.shortName,
                                  style: Theme.of(context).textTheme.headline1,
                                ),
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
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Utils.getDetailsCard(
                                context,
                                AppLocalizations.of(context).current,
                                widget.stock.nowPrice),
                          ),
                          Expanded(
                            child: Utils.getDetailsCard(
                                context,
                                AppLocalizations.of(context).previous,
                                widget.stock.oldPrice),
                          ),
                          Expanded(
                            child: Utils.getDetailsCard(
                                context,
                                AppLocalizations.of(context).current,
                                widget.stock.nowPrice,
                                color: statisticColor),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
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
                      RaisedButton(
                        onPressed: () async {
                          if (_quantity != 0) {
                            try {
                              await StocksFirestore().insertMyStock(
                                  stock: widget.stock, quantity: _quantity);
                            } catch (e) {
                              return showDialog<AlertDialog>(
                                context: context,
                                child: AlertDialog(
                                  title:
                                      Text(AppLocalizations.of(context).alert),
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
                          child: Text(
                              AppLocalizations.of(context).companyDescription,
                              style: Theme.of(context).textTheme.headline2),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: SingleChildScrollView(
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
            ),
          );
  }
}
