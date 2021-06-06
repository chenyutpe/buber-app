import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/User.dart';
import 'dart:developer';

class MainPage extends StatefulWidget {
  MainDetails createState() => new MainDetails();
}

class MainDetails extends State<MainPage> {

  Future<User> getData() async {
    var getData = await http.get(url + '/users/' + userData.id , headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },);
    log("userData.prate: " + userData.prate.toString());
    log("userData.drate: " + userData.drate.toString());
    userData = User.fromJson(jsonDecode(getData.body));
    return userData;
  }

  @override
  Widget build(BuildContext context) {
    // log("mp: "+userData.gender);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBackgroundColor,
        title: Text('Profile', style: TextStyle(fontSize: 24.0, color: appMainColor)),
        leading: GestureDetector(
          onTap: () => showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Text(logoutAlertTitle),
              content: Text(logoutAlertText),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, 'Cancel'),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    log("Back to Login.");
                    Navigator.pop(context, 'Yes');
                    Navigator.of(context).pushNamedAndRemoveUntil(loginTag, (Route<dynamic> route) => false);
                  },
                  child: const Text('Yes'),
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
                onTap: ()  {
                  Navigator.of(context).pushNamed(notificationTag);
                },
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
                  Navigator.of(context).pushNamed(modifiedTag);
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
      body: FutureBuilder<User>(
          future: getData(),
          builder: (context,AsyncSnapshot<User> snapshot) {
        // print("snapshot: $snapshot");
        switch (snapshot.connectionState) {
            case ConnectionState.none: return new Center(child: Text('None', textScaleFactor: 3));
            case ConnectionState.waiting: return new Center(
              child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(appMainColor),),
              );
            default:
              if (snapshot.hasError)
              return new Center(child: Text('：）', textScaleFactor: 3));
              else {
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
                      child: Text(snapshot.data!.name, textAlign: TextAlign.center, style: dataStyle,),
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
                      child: Text(snapshot.data!.gender, textAlign: TextAlign.center, style: dataStyle,),
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
                      child: Text(snapshot.data!.dept, textAlign: TextAlign.center, style: dataStyle,),
                    ),
                    Expanded(
                      child: Text(gradeAttr, textAlign: TextAlign.center, style: attrStyle,),
                    ),
                    Expanded(
                      child: Text(snapshot.data!.grade.toString(), textAlign: TextAlign.center, style: dataStyle,),
                    ),
                  ],
                );

                final status = Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(statusAttr, textAlign: TextAlign.left, style: attrStyle,),
                    ),
                    Expanded(
                      child: Text(statusList[snapshot.data!.is_driver], textAlign: TextAlign.center, style: dataStyle,),
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
                      child: Text((snapshot.data!.prate == 0) ? disable : userData.prate.toStringAsFixed(1), textAlign: TextAlign.center, style: dataStyle,),
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
                      Navigator.of(context).pushNamed(wallTag);
                    },
                    child: Text(wallButtonText, style: TextStyle(fontSize: 24.0, color: appBackgroundColor)),
                  ),
                );
                return Scaffold(
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
                );
              }
        }}),
    );
  }
}
//
// final routes = <String, WidgetBuilder> {
//   loginTag: (context) => Login(),
//   modifiedTag: (context) => Modified(),
//   notificationTag: (context) => Notif(),
//   wallTag: (context) => Wall(),
// };