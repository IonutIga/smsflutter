import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smsflutter/components/home/navpage.dart';
import 'package:smsflutter/components/loading.dart';
import 'package:smsflutter/components/utils.dart';
import 'package:smsflutter/services/auth.dart';

// Widget for login
class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

// Enable Auth services
final Auth _auth = Auth();

String _email = '';
String _password = '';
bool _isLoading = false;
// Track the state of the form to validate it
GlobalKey<FormState> _formId = GlobalKey<FormState>();

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).login),
      ),
      body: _isLoading
          ? Loading()
          : Padding(
              padding: EdgeInsets.all(16),
              child: SingleChildScrollView(
                // Main
                child: Form(
                  key: _formId,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      // Message, Email, Password, Login Button
                      child: Column(
                        children: <Widget>[
                          // Message
                          Text(
                            AppLocalizations.of(context).letsTrade,
                            style: Theme.of(context).textTheme.headline1,
                          ),
                          SizedBox(
                            height: 64,
                          ),
                          // Email
                          TextFormField(
                            // return null if valid or a string as help text
                            validator: (value) =>
                                !EmailValidator.validate(value)
                                    ? AppLocalizations.of(context).invalidEmail
                                    : null,
                            onChanged: (value) {
                              setState(() {
                                _email = value;
                              });
                            },
                            decoration: InputDecoration(
                                hintText: AppLocalizations.of(context).email),
                          ),
                          // Password
                          TextFormField(
                            // Check to be completed, assumed it is valid since user is registered
                            validator: (value) => (value.isEmpty)
                                ? AppLocalizations.of(context).insertPassword
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
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24.0),
                            child: SizedBox(
                              height: 40,
                              width: 350,
                              // Login Button
                              child: RaisedButton(
                                onPressed: () async {
                                  // validate the form based on its state
                                  if (_formId.currentState.validate()) {
                                    try {
                                      setState(() {
                                        _isLoading = true;
                                      });
                                      dynamic result = await _auth.loginAsync(
                                          _email, _password);

                                      if (result != null) {
                                        Utils.navigator(context, NavPage());
                                        setState(
                                          () {
                                            _isLoading = false;
                                          },
                                        );
                                      } else
                                        setState(
                                          () {
                                            _isLoading = false;
                                          },
                                        );
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
                                  AppLocalizations.of(context).login,
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 80),
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
