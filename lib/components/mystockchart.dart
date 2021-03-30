import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/loading.dart';
import 'package:smsflutter/models/mystockgroup.dart';

// Widget representing the chart of owned stocks
class MyStockChart extends StatelessWidget {
  MyStockChart();
  @override
  Widget build(BuildContext context) {
    // Get the list of stock groups
    final List<MyStockGroup> myStockGroup =
        Provider.of<List<MyStockGroup>>(context);
    // Create series which are data for the chart
    List<Series<MyStockGroup, String>> series = [
      Series(
        id: 'owned',
        data: myStockGroup,
        domainFn: (MyStockGroup m, _) => m.name,
        measureFn: (MyStockGroup m, _) => m.quantity,
      ),
    ];

    return myStockGroup == null
        ? Loading()
        : Container(
            height: 300,
            padding: EdgeInsets.all(16),
            child: BarChart(
              series,
            ),
          );
  }
}
