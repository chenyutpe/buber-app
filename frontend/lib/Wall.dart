import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'MainPage.dart';
import 'Notification.dart';
import 'dart:developer';

class Wall extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mainPageTag,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: appBackgroundColor,
          title: Text(reqTitle, style: TextStyle(fontSize: 24.0, color: appMainColor)),
          leading: GestureDetector(
            onTap: (){Navigator.of(context).pushNamed(loginTag);},
            child: Icon(
              Icons.arrow_back,
              color: appMainColor,
              size: 30.0,
            ),
          ),
          actions: <Widget>[
            Padding(
                padding: EdgeInsets.only(right: 24.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(notificationTag),
                  child: Icon(
                    Icons.notifications,
                    color: appMainColor,
                    size: 30.0,
                  ),
                )
            ),
          ],
        ),
        body: WallPage(),
      ),
      routes: routes,
    );
  }

}

class WallPage extends StatefulWidget {
  WallList createState() => new WallList();
}

class WallList extends State<WallPage> {

  var newRide = new Ride(userData.sid, '', '', '', 0, -1, -1);
  final _formKey = GlobalKey<FormState>();
  final _startController = TextEditingController();
  final _destController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Form(
      key: _formKey,
      child: Center(
                child: Padding(
                  padding: EdgeInsets.only(left: 24.0, right: 24.0),
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      subtitle: Row(
                        children: <Widget>[
                          Expanded(
                            child: TextFormField(
                              controller: _startController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: startAttr,
                                contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
                                enabledBorder: underlineStyle,
                                focusedBorder: underlineStyle,
                                hintStyle: hintStyle,
                              ),
                              style: labelStyle,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return startIsEmptyText;
                                }
                                else {
                                  log("Save start");
                                  newRide.s = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                          Icon(Icons.arrow_right_alt , color: appMainColor, size: 30.0,),
                          Expanded(
                            child: TextFormField(
                              controller: _destController,
                              keyboardType: TextInputType.text,
                              textInputAction: TextInputAction.next,
                              maxLines: 1,
                              decoration: InputDecoration(
                                hintText: destAttr,
                                contentPadding: EdgeInsets.fromLTRB(15.0, 10.0, 10.0, 0.0),
                                enabledBorder: underlineStyle,
                                focusedBorder: underlineStyle,
                                hintStyle: hintStyle,
                              ),
                              style: labelStyle,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return destIsEmptyText;
                                }
                                else {
                                  log("Save dest");
                                  newRide.d = value;
                                  return null;
                                }
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: smallSpace * 3),
                    /* 選擇地點 */
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.mail , color: appMainColor, size: 24.0,),
                        SizedBox(width: smallSpace),
                        TextButton(
                          style: ButtonStyle(
                          ),
                          onPressed: () {
                            if(_formKey.currentState!.validate()) Navigator.of(context).pushNamed(notificationTag);
                          },
                          child: Text(sendButtonText, style: nameStyle),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
          ),
    );

  }
}

final routes = <String, WidgetBuilder> {
  mainPageTag: (context) => MainPage(),
  notificationTag: (context) => Notif(),
};
