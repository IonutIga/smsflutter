import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/home/navpage.dart';
import 'package:smsflutter/models/currency.dart';
import 'package:smsflutter/models/user.dart';
import 'userAuth/menu.dart';

// Widget used to listen to auth changes, in order to
// display the right content
class AuthListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Initialize app language, as this widget is always built
    Currency.lang = Localizations.localeOf(context).languageCode;
    final user = Provider.of<User>(context);
    return user != null ? NavPage() : Menu();
  }
}
