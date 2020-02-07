import 'package:flutter/material.dart';
import 'package:pa_flutter_t3/screens/auth/sign_in.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // primarySwatch: Colors.blue,
        primaryColor: Colors.white,
        accentColor: Colors.grey,
        textTheme: ThemeData.light().textTheme.copyWith(
            body1: TextStyle(
              // color: Color.fromRGBO(0, 0, 0, 1)
            ),
            body2: TextStyle(
              // color: Color.fromRGBO(0, 0, 0, 1)
            ),
            title: TextStyle(
              fontSize: 22.0
            ),
            subtitle: TextStyle(
              fontSize: 16.0
            ),
            caption: TextStyle(
              fontSize: 14.0,
              color: Colors.black
            ),
          )
      ),
      home: SignIn(),
    );
  }
}
