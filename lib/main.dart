import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LifePath',
      initialRoute: 'home',
      routes: {
        // 'login' : ( BuildContext context ) => LoginPage(),
        // 'home'  : ( BuildContext context ) => HomePage(),
        // 'recuerdo'  : ( BuildContext context ) => RecuerdoPage(),
      },
      theme: ThemeData(
        primaryColor: Colors.brown,
      ),
    );
  }
}
