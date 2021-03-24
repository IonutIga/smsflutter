import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Utils {
  static Color primaryColor = Color.fromARGB(255, 228, 68, 58);

  static Color secondaryColor = Color.fromARGB(255, 45, 189, 196);

  static TextTheme textTheme = TextTheme(
    headline1: TextStyle(
        fontSize: 32, color: Colors.black, fontWeight: FontWeight.normal),
    headline2: TextStyle(
        fontSize: 28, color: Colors.black, fontWeight: FontWeight.normal),
    headline3: TextStyle(
        fontSize: 22, color: Colors.black, fontWeight: FontWeight.normal),
    headline4: TextStyle(
        fontSize: 20, color: Colors.black, fontWeight: FontWeight.normal),
    headline5: TextStyle(
        fontSize: 18, color: Colors.black, fontWeight: FontWeight.normal),
    headline6: TextStyle(
        fontSize: 16, color: Colors.black, fontWeight: FontWeight.normal),
  );

  static SliderThemeData sliderTheme = SliderThemeData(
    activeTrackColor: Utils.secondaryColor,
  );

  static Row getAllRightsReserved(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.copyright),
        Text(
          AppLocalizations.of(context).allRightsReserved,
          style: Theme.of(context).textTheme.headline6,
        ),
      ],
    );
  }

// color optional cu val default negru
  static Card getDetailsCard(BuildContext context, String label, num value,
      {Color color: Colors.black}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                child: Text(
                  '$label:',
                  style: Theme.of(context)
                      .textTheme
                      .headline4
                      .copyWith(fontWeight: FontWeight.bold, color: color),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                value.toStringAsFixed(2),
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: color),
              ),
            ),
            Text('${AppLocalizations.of(context).currency}',
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: color)),
          ],
        ),
      ),
    );
  }

  static ButtonThemeData getButtonTheme(BuildContext context) {
    return ButtonThemeData(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        buttonColor: Utils.secondaryColor,
        colorScheme:
            Theme.of(context).colorScheme.copyWith(secondary: Colors.white),
        textTheme: ButtonTextTheme.accent,
        minWidth: 400.00,
        height: 40);
  }

  static Text getColonLabels(String label, String text, TextStyle heading) {
    return Text(
      "$label: $text",
      style: heading,
    );
  }

  static Card getTemplateStock(BuildContext context,
      {String imageUri,
      String shortName,
      String longName,
      Text labelOne,
      Text labelTwo,
      Text priceDiff}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Image.network(imageUri, width: 56, height: 56),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        shortName,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      Text(
                        longName,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      labelOne,
                      labelTwo,
                    ],
                  ),
                ),
              ],
            ),
            if (priceDiff != null)
              Padding(padding: const EdgeInsets.all(8.0), child: priceDiff),
          ],
        ),
      ),
    );
  }

  static void navigator(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) {
          return page;
        },
      ),
    );
  }
}
