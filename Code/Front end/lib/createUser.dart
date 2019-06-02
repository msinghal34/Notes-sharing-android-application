import 'package:flutter/material.dart';
import 'session.dart';
import 'dart:convert';
import 'home.dart';

class CreateUser extends StatefulWidget {
  @override
  CreateUserState createState() => new CreateUserState();
}

class CreateUserState extends State<CreateUser> {
  final _formKey = GlobalKey<FormState>();
  final namecont = TextEditingController();
  final emailcont = TextEditingController();
  final usercont = TextEditingController();
  final passcont = TextEditingController();
  final repasscont = TextEditingController();

  @override
  Widget build(BuildContext context1) {
    // Build a Form widget using the _formKey we created above

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("Create Account"),
        ),
        body: Builder(builder: (scaffoldContext) {
          void reset() {
            usercont.clear();
            passcont.clear();
            namecont.clear();
            emailcont.clear();
            repasscont.clear();
          }

          void authenticate(value) {
            print(value);
            final parsed = json.decode(value);

            if (parsed['status'].toString().toLowerCase() != 'true') {
              print('Passed2');
              Scaffold.of(scaffoldContext).showSnackBar(
                  SnackBar(content: Text(parsed['message'])));
            } else {
              print('Passed3');
              reset();
              Navigator.pushReplacement(
                scaffoldContext,
                MaterialPageRoute(
                    builder: (scaffoldContext) => MyHomePage(
                          selectedIndex: 0,
                        )), //Profile(myuid: myuid)),
              );
            }
          }

          return Form(
              key: _formKey,
              child:  ListView(
                scrollDirection: Axis.vertical,
                shrinkWrap: false,
                padding: const EdgeInsets.all(24.0),
                children: <Widget>[
                      TextFormField(
                        key: Key('Name'),
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 6.0),
                        ),
                        controller: namecont,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your name';
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
                      TextFormField(
                        key: Key('EmailID'),
                        decoration: InputDecoration(
                          labelText: 'EmailID',
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 6.0),
                        ),
                        controller: emailcont,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter your email ID';
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                      ),
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
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                      TextFormField(
                        obscureText: true,
                        key: Key('RePassword'),
                        decoration: InputDecoration(
                          labelText: 'Re enter your password',
                          border: OutlineInputBorder(),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 12.0, horizontal: 6.0),
                        ),
                        controller: repasscont,
                        validator: (value) {
                          if (value != passcont.text) {
                            return 'Password doesn\'t match';
                          }
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: RaisedButton(
                          color: Theme.of(context).accentColor,
                          padding: const EdgeInsets.all(12.0),
                          splashColor: Theme.of(context).primaryColor,
                          onPressed: () {
                            // Validate will return true if the form is valid, or false if
                            // the form is invalid.
                            print("HI");
                            //reset();
                            if (_formKey.currentState.validate()) {
                              Scaffold.of(scaffoldContext).showSnackBar(
                                  SnackBar(
                                      content: Text('Creating account...')));

                              var a = new Session();

                              print(a.url + 'CreateNewUser');

                              a
                                  .post(a.url + 'CreateNewUser', {
                                    "name": namecont.text,
                                    "email_id": emailcont.text,
                                    "user_id": usercont.text,
                                    "password": passcont.text
                                  })
                                  .then((value) => authenticate(value))
                                  .catchError((error) => Scaffold.of(
                                          scaffoldContext)
                                      .showSnackBar(SnackBar(
                                          content: Text(
                                              'Failed to connect to server'))));
                            }
                          },
                          child: Text('Create Account'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 120.0),
                      ),
                    ],
                  ));
        }));
  }
}
