import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'models/User.dart';
import 'dart:developer';
import 'dart:async';
import 'package:http/http.dart' as http;
import 'Login.dart';
import 'Modified.dart';
import 'Notification.dart';
import 'Wall.dart';

class MainPage extends StatelessWidget {

  //TODO: userData from backend
  //@get: userData: Object(FormData?)

    @override
    Widget build(BuildContext context) {

      final parag = FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: 0.1,
        child: Container(
          height: smallSpace,
          color: appMainColor,
        ),
      );

      final userName = Row(
        children: <Widget>[
          Expanded(
            child: Text(nameAttr, textAlign: TextAlign.left, style: attrStyle,),
          ),
          Expanded(
            child: Text(userData.name, textAlign: TextAlign.center, style: dataStyle,),
          ),
          Expanded(
            child: Text("", textAlign: TextAlign.center, style: attrStyle,),
          ),
          Expanded(
            child: Text("", textAlign: TextAlign.center, style: dataStyle,),
          ),
        ],
      );
      // 3a
      final gender = Row(
        children: <Widget>[
          Expanded(
            child: Text(genderAttr, textAlign: TextAlign.left, style: attrStyle,),
          ),
          Expanded(
            child: Text(userData.gender, textAlign: TextAlign.center, style: dataStyle,),
          ),
          Expanded(
            child: Text("", textAlign: TextAlign.center, style: attrStyle,),
          ),
          Expanded(
            child: Text("", textAlign: TextAlign.center, style: dataStyle,),
          ),
        ],
      );

      final studentDept = Row(
        children: <Widget>[
          Expanded(
            child: Text(deptAttr, textAlign: TextAlign.left, style: attrStyle,),
          ),
          Expanded(
            child: Text(userData.dept, textAlign: TextAlign.center, style: dataStyle,),
          ),
          Expanded(
            child: Text(gradeAttr, textAlign: TextAlign.center, style: attrStyle,),
          ),
          Expanded(
            child: Text(userData.grade.toString(), textAlign: TextAlign.center, style: dataStyle,),
          ),
        ],
      );

      final status = Row(
        children: <Widget>[
          Expanded(
            child: Text(statusAttr, textAlign: TextAlign.left, style: attrStyle,),
          ),
          Expanded(
            child: Text(statusList[userData.is_driver], textAlign: TextAlign.center, style: dataStyle,),
          ),
          Expanded(
            child: Text("", textAlign: TextAlign.center, style: attrStyle,),
          ),
          Expanded(
            child: Text("", textAlign: TextAlign.center, style: attrStyle,),
          ),
        ],
      );

      final ratingsTitle = Row(
        children: <Widget>[
          Expanded(
            child: Text(rateAttr, textAlign: TextAlign.left, style: attrStyle,),
          ),
          Expanded(
            child: Text("P", textAlign: TextAlign.center, style: dataStyle,),
          ),
          Expanded(
            child: Text((userData.prate == 0) ? disable : userData.prate.toStringAsFixed(1), textAlign: TextAlign.center, style: dataStyle,),
          ),
          Expanded(
            child: Text("", textAlign: TextAlign.center, style: dataStyle,),
          ),
        ],

      );

      final ratings = Row(
        children: <Widget>[
          Expanded(
            child: Text("", textAlign: TextAlign.center, style: dataStyle,),
          ),
          Expanded(
            child: Text("D", textAlign: TextAlign.center, style: dataStyle,),
          ),
          Expanded(
            child: Text((userData.drate == 0) ? disable : userData.drate.toStringAsFixed(1), textAlign: TextAlign.center, style: dataStyle,),
          ),
          Expanded(
            child: Text("", textAlign: TextAlign.center, style: dataStyle,),
          ),
        ],

      );
      final wallButton = Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: ElevatedButton(
          style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
            ),
            padding: MaterialStateProperty.all<EdgeInsets>(
                EdgeInsets.all(12)),
            backgroundColor: MaterialStateProperty.all<Color>(appMainColor),
          ),
          onPressed: () {
            log("Navigate to Wall.");
            Navigator.push(context, new MaterialPageRoute(
              builder: (context) => new Wall())
            );

          },
          child: Text(wallButtonText, style: TextStyle(fontSize: 24.0, color: appBackgroundColor)),
        ),
      );

      return MaterialApp(
        title: mainPageTag,
        home: Scaffold(
          appBar: AppBar(
              backgroundColor: appBackgroundColor,
              title: Text(mainPageTitle, style: TextStyle(fontSize: 24.0, color: appMainColor)),
            leading: GestureDetector(
              onTap: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: Text(logoutAlertTitle),
                    content: Text(logoutAlertText),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, cancelButtonText),
                        child: const Text(cancelButtonText),
                      ),
                      TextButton(
                        onPressed: () {
                          log("Back to Login.");
                          Navigator.pop(context, yesButtonText);
                          Navigator.of(context).pushNamed(loginTag);
                        },
                        child: const Text(yesButtonText),
                      ),
                    ],
                  ),
              ),
              child: Icon(
                Icons.logout,
                color: appMainColor,
                size: 30.0,
              ),
            ),
            actions: <Widget>[
              Padding(
                  padding: EdgeInsets.only(right: 24.0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context, new MaterialPageRoute(builder: (context) => new Notif() ) ),
                    child: Icon(
                      Icons.notifications,
                      color: appMainColor,
                      size: 30.0,
                    ),
                  )
              ),
              Padding(
                  padding: EdgeInsets.only(right: 24.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(context, new MaterialPageRoute(builder: (context) => new Modified() ) );
                      },
                    child: Icon(
                        Icons.edit,
                        color: appMainColor,
                        size: 30.0,
                    ),
                  )
              ),
            ],
          ),
          body: Scaffold(
            backgroundColor: appBackgroundColor,
            body: Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(left: 24.0, right: 24.0),
                children: <Widget>[
                  parag,
                  SizedBox(height: smallSpace * 3),
                  userName,
                  SizedBox(height: smallSpace),
                  gender,
                  SizedBox(height: smallSpace),
                  studentDept,
                  SizedBox(height: smallSpace * 3),
                  parag,
                  SizedBox(height: smallSpace * 3),
                  status,
                  SizedBox(height: smallSpace),
                  ratingsTitle,
                  SizedBox(height: smallSpace),
                  ratings,
                  SizedBox(height: smallSpace * 3),
                  wallButton,
                ],
              ),
            ),
          ),
        ),
        routes: routes,
      );
    }
}

final routes = <String, WidgetBuilder> {
  loginTag: (context) => Login(),
  modifiedTag: (context) => Modified(),
  notificationTag: (context) => Notif(),
  wallTag: (context) => Wall(),
};
