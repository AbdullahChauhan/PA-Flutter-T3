import 'package:flutter/material.dart';
import 'package:pa_flutter_t3/core/services/Api.dart';
import 'package:pa_flutter_t3/screens/auth/sign_in.dart';
import 'package:pa_flutter_t3/screens/home.dart';

class AuthWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: Api.onAuthStateChanged,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final user = snapshot.data;
          return user != null ? Home(userID: user.uid) : SignIn();
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}