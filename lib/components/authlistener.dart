import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smsflutter/components/home/navpage.dart';
import 'package:smsflutter/models/currency.dart';
import 'package:smsflutter/models/user.dart';
import 'userAuth/menu.dart';

class AuthListener extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Currency.lang = Localizations.localeOf(context).languageCode;
    final user = Provider.of<User>(context);
    return user != null ? NavPage() : Menu();
  }
}
