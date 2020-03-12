import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import './sign_in.dart';
import '../home.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController nameCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController confirmPassCtrl = TextEditingController();

  var formKey = GlobalKey<FormState>();
  bool isLoading;

  @override
  void initState() {
    isLoading = false;
    super.initState();
  }

  checkUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      Navigator.of(context).push(MaterialPageRoute(
          builder: (ctx) =>
              Home(userID: user.uid,)));
    }
  }

  void signUp() async {
    try {
      setState(() {
        isLoading = true;
      });
      var auth = FirebaseAuth.instance;
      // creating user profile on firebase
      var response = await auth.createUserWithEmailAndPassword(
          email: emailCtrl.text, password: passwordCtrl.text);

      // get the created user
      FirebaseUser u = response.user;

      // build profile update request
      var infoUpdate = UserUpdateInfo();
      infoUpdate.displayName = nameCtrl.text;

      // update profile now!
      await u.updateProfile(infoUpdate);

      FirebaseUser realtimeUser = await auth.currentUser();
      print(realtimeUser.displayName);
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
      resizeToAvoidBottomInset: false,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark
            .copyWith(
              statusBarColor: Colors.white,
              systemNavigationBarColor: Colors.white),
      child: SafeArea(
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
                          TextFormField(
                            controller: nameCtrl,
                            validator: (value) {
                              if (!value.contains(" ")) {
                                return "Please enter a full name of atleast have one single space";
                              }
                              return null;
                            },
                            keyboardType: TextInputType.text,
                            autofocus: false,
                            decoration: InputDecoration(
                              hintText: 'Please enter your full name',
                              contentPadding:
                                  EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                            ),
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
                              hintText: 'Please enter your email',
                              contentPadding:
                                  EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
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
                              hintText: 'Please enter your password',
                              contentPadding:
                                  EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(6.0)),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          TextFormField(
                            controller: confirmPassCtrl,
                            validator: (value) {
                              if (passwordCtrl.text != value) {
                                return "Password must be same";
                              }
                              return null;
                            },
                            autofocus: false,
                            obscureText: true,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              contentPadding:
                                  EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 0.0),
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
                                  signUp();
                                }
                              },
                              padding: EdgeInsets.all(12),
                              child: Text(
                                'Register Now',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 16.0,
                          ),
                          GestureDetector(
                            onTap: () => Navigator.of(context).push(
                                CupertinoPageRoute(builder: (ctx) => SignIn())),
                            child: Text(
                              'Already have an account. Login Now',
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
      )
    );
  }
}
