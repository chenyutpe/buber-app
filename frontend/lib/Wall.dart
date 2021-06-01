import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'MainPage.dart';
import 'Notification.dart';
import 'dart:developer';

class Wall extends StatelessWidget {
  final snackBar = SnackBar(content: Text(queryHintText));

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: mainPageTag,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: appBackgroundColor,
          title: Text('Driver List', style: TextStyle(fontSize: 24.0, color: appMainColor)),
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
            Padding(
                padding: EdgeInsets.only(right: 24.0),
                child: GestureDetector(
                  onTap: (){
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);},
                  child: Icon(
                    Icons.more_vert,
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
  //TODO: Get driverList from backend
  //@get: driverList: List<Object>

  var newRide = new Ride(userData.sid, '', '', '', 0, -1, -1);
  var numOfList = driverList.length;
  var _start;
  var _dest;
  var _isSelected;

  @override
  void initState() {
    setState(() {
      _isSelected = List.filled(numOfList, false);
    });
  }

  @override
  Widget build(BuildContext context) {

    return Center(
      /* 列表 */
      child: ListView.builder(
        itemCount: driverList.length,
        itemBuilder: (BuildContext context, int index){
          return Opacity(
            opacity: 1.0,
            child: Center(
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      leading: Icon(Icons.pedal_bike, color: appMainColor, size: 30.0,),
                      title: Text(driverList[index].name + " @" + driverList[index].sid, style: nameStyle),
                      subtitle: Column(
                        children: <Widget>[
                          SizedBox(height: smallSpace),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.person , color: appMainColor, size: 18.0,),
                              SizedBox(width: smallSpace),
                              Text(driverList[index].gender, style: labelStyle),
                              SizedBox(width: smallSpace * 4),
                              Icon(Icons.school , color: appMainColor, size: 18.0,),
                              SizedBox(width: smallSpace),
                              Text(driverList[index].dept + " " + driverList[index].grade, style: labelStyle),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Icon(Icons.star, color: appMainColor, size: 18.0,),
                              SizedBox(width: smallSpace),
                              Text(driverList[index].drate.toString(), style: labelStyle),
                            ],
                          ),
                        ],
                      ),
                    ),
                    /* 選擇地點 */
                      Visibility(
                        visible: _isSelected[index] ? true : false,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: DropdownButtonFormField(
                                items: startList.map((String start) {
                                  return new DropdownMenuItem(
                                    value: start,
                                    child: Text(start, style: TextStyle(fontSize: 24.0,
                                      color: appWhiteColor,)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() => _start = newValue);
                                  newRide.s = _start;
                                },
                                value: _start,
                                dropdownColor: appBackgroundColor,
                                decoration: InputDecoration(
                                  labelText: startAttr,
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  enabledBorder: underlineStyle,
                                  focusedBorder: underlineStyle,
                                  labelStyle: labelStyle,
                                ),
                              ),
                            ),
                            Expanded(
                              child: DropdownButtonFormField(
                                items: destList.map((String dest) {
                                  return new DropdownMenuItem(
                                    value: dest,
                                    child: Text(dest, style: TextStyle(fontSize: 24.0,
                                      color: appWhiteColor,)),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() => _dest = newValue);
                                  newRide.d = _dest;
                                },
                                value: _dest,
                                dropdownColor: appBackgroundColor,
                                decoration: InputDecoration(
                                  labelText: destAttr,
                                  contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                  enabledBorder: underlineStyle,
                                  focusedBorder: underlineStyle,
                                  labelStyle: labelStyle,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        TextButton(
                          child: Text(_isSelected[index] ? sendButtonText : chooseButtonText, style: labelStyle,),
                          onPressed: () {
                            if(_isSelected[index]) {
                              newRide.did = driverList[index].sid;
                              Navigator.of(context).pushNamed(notificationTag);
                            }
                            initState();
                            setState(() {
                              _isSelected[index] = true;
                            });
                            //TODO: Send newRide to backend.
                            //@post: newRide: Object(FormData?)
                            //@return: message: String
                          },
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

final routes = <String, WidgetBuilder> {
  mainPageTag: (context) => MainPage(),
  notificationTag: (context) => Notif(),
};
