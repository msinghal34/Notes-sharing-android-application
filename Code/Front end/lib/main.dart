import 'package:flutter/material.dart';
import 'session.dart';
import 'package:flutter/rendering.dart'; // Required for debugPaintSizeEnabled
import 'dart:convert';
import 'home.dart';
import 'createUser.dart';

void main() {
  debugPaintSizeEnabled = false;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'Lecture Notes';
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        color: Colors.white,
        initialRoute: '/',
        theme: ThemeData(
          brightness: Brightness.light,
          primaryColor: Colors.brown[400],
          accentColor: Color.fromRGBO(199, 67, 117, 1.0),
        ),
        routes: {
          '/': (context) => MyCustomForm(),
        });
  }
}

// Create a Form Widget
class MyCustomForm extends StatefulWidget {
  @override
  Login createState() {
    return Login();
  }
}

// Create a corresponding State class. This class will hold the data related to
// the form.
class Login extends State<MyCustomForm> {
  // Create a global key that will uniquely identify the Form widget and allow
  // us to validate the form
  //
  // Note: This is a GlobalKey<FormState>, not a GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();
  final usercont = TextEditingController();
  final passcont = TextEditingController();

  @override
  Widget build(BuildContext context1) {
    // Build a Form widget using the _formKey we created above

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Login"),
        ),
        body: Builder(builder: (scaffoldContext) {
          void reset() {
            usercont.clear();
            passcont.clear();
          }

          void authenticate(value) {
            print(value);
            final parsed = json.decode(value);

            if (parsed['status'].toString().toLowerCase() != 'true') {
              print('Passed2');

              Scaffold.of(scaffoldContext)
                  .showSnackBar(SnackBar(content: Text(parsed['message'])));
            } else {
              print('Passed3');
              reset();
              Navigator.pushReplacement(
                scaffoldContext,
                MaterialPageRoute(
                    builder: (scaffoldContext) => MyHomePage(selectedIndex: 0)),
              );
            }
          }

          return Form(
              key: _formKey,
              child: ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: false,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 72.0),
                children: <Widget>[
                  TextFormField(
                    key: Key('Username'),
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 6.0),
                    ),
                    controller: usercont,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter username';
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                  ),
                  TextFormField(
                    obscureText: true,
                    key: Key('Password'),
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 6.0),
                    ),
                    controller: passcont,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Please enter password';
                      }
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  RaisedButton(
                    color: Theme.of(context).accentColor,
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    splashColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.

                      //reset();
                      if (_formKey.currentState.validate()) {
                        Scaffold.of(scaffoldContext).showSnackBar(
                            SnackBar(content: Text('Logging in...')));

                        var a = new Session();
                        print(a.url + 'LoginServlet');
                        a
                            .post(a.url + 'LoginServlet', {
                              "user_id": usercont.text,
                              "password": passcont.text
                            })
                            .then((value) => authenticate(value))
                            .catchError((error) => Scaffold.of(scaffoldContext)
                                .showSnackBar(SnackBar(
                                    content:
                                        Text('Failed to connect to server'))));
                      }
                    },
                    child: Center(child: Text('Login')),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                  ),
                  RaisedButton(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    splashColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      // Validate will return true if the form is valid, or false if
                      // the form is invalid.
                      reset();
                      Navigator.push(
                        scaffoldContext,
                        MaterialPageRoute(
                            builder: (scaffoldContext) => CreateUser()),
                      );
                    },
                    child: Text('Create New Account'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 60.0),
                  ),
                ],
              ));
        }));
  }
}
