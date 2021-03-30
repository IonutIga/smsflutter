import 'package:shared_preferences/shared_preferences.dart';

// Class used for checking the system language and getting the current EUR-RON rate
class Currency {
  static num currency;
  static String lang;

  Currency() {
    _getCurrency();
  }

  // Async call that will get the current rate saved as preferences for continuous use
  _getCurrency() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    currency = double.tryParse(pref.getDouble('currency').toStringAsFixed(2));
  }
}
