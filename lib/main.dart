import 'package:church_backoffice/screens/login.dart';
import 'package:church_backoffice/screens/register.dart';
import 'package:flutter/material.dart';

import 'components/layout.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LoginScreen());
  }
}
