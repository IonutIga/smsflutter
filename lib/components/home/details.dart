import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/loading.dart';
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
                                  style: TextStyle(fontSize: 32),
                                ),
                                Text(
                                  widget.stock.longName,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        '${AppLocalizations.of(context).current}:',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        widget.stock.nowPrice
                                            .toStringAsFixed(2),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Text(
                                        '${AppLocalizations.of(context).currency}',
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 4.0),
                                        child: Text(
                                          '${AppLocalizations.of(context).previous}:',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        widget.stock.oldPrice
                                            .toStringAsFixed(2),
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                    Text(
                                        '${AppLocalizations.of(context).currency}',
                                        style: TextStyle(fontSize: 20)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        '${AppLocalizations.of(context).pricediff}:',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: statisticColor),
                                      ),
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 4.0),
                                      child: Text(
                                        widget.stock.statistic.toString(),
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: statisticColor),
                                      ),
                                    ),
                                    Text(
                                        '${AppLocalizations.of(context).currency}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: statisticColor)),
                                  ],
                                ),
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
                              min: 0,
                              max: (StocksFirestore.userBudget /
                                      widget.stock.nowPrice)
                                  .roundToDouble(),
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
                      ButtonTheme(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        buttonColor: Color.fromARGB(255, 45, 189, 196),
                        colorScheme: Theme.of(context)
                            .colorScheme
                            .copyWith(secondary: Colors.white),
                        textTheme: ButtonTextTheme.accent,
                        minWidth: 400,
                        height: 40,
                        child: RaisedButton(
                          onPressed: () async {
                            if (_quantity != 0) {
                              try {
                                await StocksFirestore().insertMyStock(
                                    stock: widget.stock, quantity: _quantity);
                              } catch (e) {
                                return showDialog<AlertDialog>(
                                  context: context,
                                  child: AlertDialog(
                                    title: Text(
                                        AppLocalizations.of(context).alert),
                                    content: Text(AppLocalizations.of(context)
                                        .alertBudgetMsg),
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
                              setState(() {
                                _isLoading = true;
                              });
                              Navigator.pop(context);
                            } else {
                              return showDialog<AlertDialog>(
                                context: context,
                                child: AlertDialog(
                                  title:
                                      Text(AppLocalizations.of(context).alert),
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
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Align(
                          alignment: Alignment.bottomLeft,
                          child: Text(
                            AppLocalizations.of(context).companyDescription,
                            style: TextStyle(
                              fontSize: 28,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 200,
                        child: SingleChildScrollView(
                          child: Text(
                            widget.stock.companyDescription,
                            style: TextStyle(fontSize: 20),
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
