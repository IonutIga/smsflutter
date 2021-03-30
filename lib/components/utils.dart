import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Class used to provide general solutions for same problems
class Utils {
  static Color primaryColor = Color.fromARGB(255, 228, 68, 58);

  static Color secondaryColor = Color.fromARGB(255, 45, 189, 196);

  // Text themes that will be used thorughout the app
  // FontSize, Color, FontWeight
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

  // Slider Theme
  // ActiveTrackColor
  static SliderThemeData sliderTheme = SliderThemeData(
    activeTrackColor: Utils.secondaryColor,
  );

  // AllRightsReserved template
  static Row getAllRightsReserved(BuildContext context) {
    return
        // Main
        Row(
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
// Card design for prices shown in the details page
  static Card getDetailsCard(BuildContext context, String label, num value,
      {Color color: Colors.black}) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child:
            // Main
            Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 4.0),
                // Price type
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
              // Value
              child: Text(
                value.toStringAsFixed(2),
                style: Theme.of(context)
                    .textTheme
                    .headline4
                    .copyWith(color: color),
              ),
            ),
            // Currency
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

  // Button design used throughout the app
  // Shape, ButtonColor, ColorScheme, TextTheme, MinWidth, Height
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

  // Template for labels that use the colon as separator
  static Text getColonLabels(String label, String text, TextStyle heading) {
    return Text(
      "$label: $text",
      style: heading,
    );
  }

  // Template for both types of stocks
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
        child:
            // Main
            Column(
          children: <Widget>[
            // Basic description
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  // Image
                  child: Image.network(imageUri, width: 56, height: 56),
                ),
                Expanded(
                  // Names
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      // Short Name
                      Text(
                        shortName,
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      // Long Name
                      Text(
                        longName,
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  // Prices or price and quantity
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
            // Price difference, only for market stocks
            if (priceDiff != null)
              Padding(padding: const EdgeInsets.all(8.0), child: priceDiff),
          ],
        ),
      ),
    );
  }

  // General navigator behavior for moving to a page
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
