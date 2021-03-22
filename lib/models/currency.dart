import 'package:shared_preferences/shared_preferences.dart';

class Currency {
  static num currency;
  static String lang;

  Currency() {
    _getCurrency();
  }

  _getCurrency() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    currency = double.tryParse(pref.getDouble('currency').toStringAsFixed(2));
  }
}
