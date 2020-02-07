import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pa_flutter_t3/screens/auth/google_sign_in.dart';
import './sign_up.dart';
import '../home.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  var formKey = GlobalKey<FormState>();
  bool isLoading;

  @override
  void initState() {
    isLoading = false;
    checkUser();
    super.initState();
  }

  checkUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) => Home(
              userID: user.uid,
              userName: user.displayName,
              userEmail: user.email)));
    }
  }

  void signIn() async {
    try {
      setState(() {
        isLoading = true;
      });
      var auth = FirebaseAuth.instance;
      //Creating user profile on firebase
      await auth.signInWithEmailAndPassword(
          email: emailCtrl.text, password: passwordCtrl.text);
      checkUser();
    } catch (err) {
      print(err);
    } finally {
      isLoading = false;
      emailCtrl.text = '';
      passwordCtrl.text = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          minimum: EdgeInsets.all(18.0),
          maintainBottomViewPadding: true,
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                isLoading
                    ? Center(child: CircularProgressIndicator())
                    : Column(
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                'Welcome to ',
                                style: Theme.of(context).textTheme.title,
                              ),
                              Text('New Talk',
                                  style: TextStyle(
                                      fontSize: 24.0,
                                      fontWeight: FontWeight.w600))
                            ],
                          ),
                          Text(
                            'Please Login OR Sign up to continue app',
                          ),
                          SizedBox(
                            height: 24.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GoogleSignInButton(
                                darkMode: true,
                                text: 'Google',
                                onPressed: () {
                                  var status = signInWithGoogle();
                                  status.whenComplete(() {}).then((value) {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return Home(
                                            userID: value.uid,
                                            userName: value.displayName,
                                            userEmail: value.email,
                                          );
                                        },
                                      ),
                                    );
                                  });
                                },
                              ),
                              FacebookSignInButton(
                                text: 'Facebook',
                              )
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          Row(
                            children: <Widget>[
                              Expanded(
                                  child: Divider(
                                height: 2.0,
                                color: Colors.grey,
                                indent: 50,
                                endIndent: 10,
                              )),
                              Text('OR'),
                              Expanded(
                                  child: Divider(
                                height: 2.0,
                                color: Colors.grey,
                                indent: 10,
                                endIndent: 50,
                              )),
                            ],
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            controller: emailCtrl,
                            validator: (value) {
                              if (!value.contains("@")) {
                                return "Please enter a valid email";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.emailAddress,
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: 'Email',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            controller: passwordCtrl,
                            validator: (value) {
                              if (value.length < 6) {
                                return "Password must be at least 6 characters long";
                              }
                              return null;
                            },
                            autofocus: false,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Password',
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: RaisedButton(
                              color: Color(0xFF585858),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(6),
                              ),
                              onPressed: () {
                                if (formKey.currentState.validate()) {
                                  signIn();
                                }
                              },
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Login Now',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                CupertinoPageRoute(builder: (ctx) => SignUp())),
                            child: Text(
                              'Don\'t have an account. Register Now',
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                        ],
                      )
              ],
            ),
          )),
    );
  }
}
