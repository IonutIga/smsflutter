import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smsflutter/components/utils.dart';

import 'home/settings.dart';

class Budget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final budget = Provider.of<num>(context);
    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              if (Localizations.localeOf(context).languageCode == 'ro')
                Utils.navigator(context, Settings());
            },
            child: Text(
              budget != null
                  ? '${AppLocalizations.of(context).cash}: ${budget.toStringAsFixed(2)} ${AppLocalizations.of(context).currency}'
                  : "",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}
