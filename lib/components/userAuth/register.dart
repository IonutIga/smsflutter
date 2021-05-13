import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smsflutter/components/home/navpage.dart';
import 'package:smsflutter/components/loading.dart';
import 'package:smsflutter/components/utils.dart';
import 'package:smsflutter/services/auth.dart';

// Widget used to enable resiter functionality
class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

// Enable auth service
final Auth _auth = Auth();

String _email = '';
String _name = '';
String _password = '';
// Valid password contains at least one upper, one lower, one number and is min 8 chars length
RegExp _regExp = new RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}$');
bool _isLoading = false;
// keep track of the state of the form, to validate it
GlobalKey<FormState> _formId = GlobalKey<FormState>();

class _RegisterState extends State<Register> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).register),
      ),
      body: _isLoading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                // Main
                child: Form(
                  key: _formId,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      // Message, Name, Email, Password, Confirm Password and Register Button
                      child: Column(
                        children: <Widget>[
                          // Message
                          Text(
                            AppLocalizations.of(context).joinUs,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(
                            height: 64,
                          ),
                          // Name
                          TextFormField(
                            // return null if valid or a string as help text
                            validator: (value) => value.trim().isEmpty
                                ? AppLocalizations.of(context).insertName
                                : null,
                            onChanged: (value) {
                              setState(() {
                                _name = value.trim();
                              });
                            },
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context).name),
                          ),
                          // Email
                          TextFormField(
                            // return null if valid or a string as help text
                            validator: (value) =>
                                // Email Validator for checking email correctness
                                !EmailValidator.validate(value.trim())
                                    ? AppLocalizations.of(context).invalidEmail
                                    : null,
                            onChanged: (value) {
                              setState(() {
                                _email = value.trim();
                              });
                            },
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context).email),
                          ),
                          // Password
                          TextFormField(
                            // Validate against the regexp
                            validator: (value) => (!_regExp.hasMatch(value))
                                ? AppLocalizations.of(context).invalidPassword
                                : null,
                            onChanged: (value) {
                              setState(
                                () {
                                  _password = value;
                                },
                              );
                            },
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText:
                                    AppLocalizations.of(context).password),
                          ),
                          // Confirm Password
                          TextFormField(
                            validator: (value) =>
                                !(_password.compareTo(value) == 0) ||
                                        value.isEmpty
                                    ? AppLocalizations.of(context)
                                        .invalidConfirmPassword
                                    : null,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context)
                                    .confirmPassword),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: SizedBox(
                              height: 40,
                              width: 350,
                              // Register Button
                              child: RaisedButton(
                                onPressed: () async {
                                  // validate the form based on its state
                                  if (_formId.currentState.validate()) {
                                    try {
                                      setState(() {
                                        _isLoading = true;
                                      });

                                      dynamic result =
                                          await _auth.registerAsync(
                                              _email, _password, _name);
                                      if (result != null) {
                                        setState(() {
                                          _isLoading = false;
                                        });
                                        Utils.navigator(context, NavPage());
                                      } else
                                        setState(() {
                                          _isLoading = false;
                                        });
                                    } catch (e) {
                                      setState(() {
                                        _isLoading = false;
                                      });
                                      showDialog<AlertDialog>(
                                        context: context,
                                        child: AlertDialog(
                                          title: Text(
                                              AppLocalizations.of(context)
                                                  .alert),
                                          content: Text(
                                            e.toString().substring(11),
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: Text('OK'),
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: Text(
                                  AppLocalizations.of(context).register,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40),
                          Utils.getAllRightsReserved(context),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
