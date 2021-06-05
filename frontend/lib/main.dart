import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'Login.dart';
import 'MainPage.dart';
import 'Register.dart';
import 'Modified.dart';
import 'Wall.dart';
import 'Notification.dart';

void main() {
  runApp(BuberBike());
}

class BuberBike extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: appTitle,
        theme: new ThemeData(
          primaryColor: appBackgroundColor,
        ),
        home: Login(),
        routes: routes,
    );
  }
}

final routes = <String, WidgetBuilder>{
  loginTag: (context) => Login(),
  mainPageTag: (context) => MainPage(),
  registerTag: (context) => Register(),
  modifiedTag: (context) => Modified(),
  wallTag: (context) => Wall(),
  notificationTag: (context) => Notif(),
};
