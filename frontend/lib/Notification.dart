import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'dart:developer';
import 'MainPage.dart';
import 'Wall.dart';

class Notif extends StatefulWidget {
  NotifPage createState() => new NotifPage();
}

class NotifPage extends State<Notif> with SingleTickerProviderStateMixin {
  //TODO: Get RideList from backend.
  //@get: pRideList: List<Object>, dRideList: List<Object>

  late TabController _tabController;
  var tabList = ( userData.is_driver == 0 ) ? tabPList : tabDList;
  var _rating = List.filled((pRideList.length > dRideList.length ) ? pRideList.length : dRideList.length, 1.0);
  var _state = List.filled((pRideList.length > dRideList.length ) ? pRideList.length : dRideList.length, 0);

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabList.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: mainPageTag,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: appBackgroundColor,
          title: Text('Notification', style: TextStyle(fontSize: 24.0, color: appMainColor)),
          leading: GestureDetector(
            onTap: (){Navigator.of(context).pushNamed(mainPageTag);},
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
                  onTap: (){
                      Navigator.of(context).pushNamed(wallTag);
                  },
                  child: Icon(
                    Icons.pedal_bike,
                    color: appMainColor,
                    size: 30.0,
                  ),
                )
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: tabList.map((status) => Tab(child: Text(status, style: labelStyle))).toList(),
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: tabList.map((status) {
            var _status = (status == prateAttr) ? 0 : 1;
            var notifList = (status == prateAttr) ? pRideList : dRideList;

            return notifList.length == 0 ?
             Center(
              child: Text(noRequestText, textScaleFactor: 3),
            ) :
            Container(
              alignment: Alignment.center,
              child:
              ListView.builder(
                itemCount: notifList.length,
                itemBuilder: (BuildContext context, int index){
                  _state[index] = notifList[index].state;

                  final notAccepted_p = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.more_horiz, color: appMainColor, size: 40.0,),
                        title: Text(pasWaitText, style: nameStyle),
                        subtitle: Column(
                          children: <Widget>[
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(notifList[index].s, style: nameStyle),
                                SizedBox(width: smallSpace),
                                Icon(Icons.arrow_right_alt , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(notifList[index].d, style: nameStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: Text('Decline', style: textButtonStyle,),
                            onPressed: () =>  AlertDialog(
                              title: Text(declinedAlertTitle),
                              content: Text(declinedAlertText),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    log("Cancel");
                                    Navigator.pop(context, 'Cancel');
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _state[index] = 3;
                                      log(_state[index].toString());
                                    });
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),

                          ),
                        ],
                      ),
                    ],
                  );

                  final notAccepted_d = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.hail, color: appMainColor, size: 40.0,),
                        title: Text(pList[index].name + driverReceivedText, style: nameStyle),
                        subtitle: Column(
                          children: <Widget>[
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.person , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(pList[index].gender, style: labelStyle),
                                SizedBox(width: smallSpace * 4),
                                Icon(Icons.school , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(pList[index].dept, style: labelStyle),
                                SizedBox(width: smallSpace),
                                Text(pList[index].grade, style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.star, color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text((pList[index].prate > 0) ? pList[index].prate.toString() : '-', style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(notifList[index].s, style: nameStyle),
                                SizedBox(width: smallSpace),
                                Icon(Icons.arrow_right_alt , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(notifList[index].d, style: nameStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: Text('Accept', style: textButtonStyle,),
                            onPressed: () {
                              setState(() {
                                _state[index] = 1;
                                log(_state[index].toString());
                              });
                            },
                          ),
                          SizedBox(width: smallSpace * 3),
                          TextButton(
                            child: Text('Decline', style: textButtonStyle,),
                            onPressed: () =>  AlertDialog(
                              title: Text(declinedAlertTitle),
                              content: Text(declinedAlertText),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    log("Cancel");
                                    Navigator.pop(context, 'Cancel');
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                    });
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );

                  final Accepted_p = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.hail, color: appMainColor, size: 40.0,),
                        title: Text(dList[index].name + pasAcceptedText, style: nameStyle),
                        subtitle: Column(
                          children: <Widget>[
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.person , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(dList[index].gender, style: labelStyle),
                                SizedBox(width: smallSpace * 4),
                                Icon(Icons.school , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(dList[index].dept, style: labelStyle),
                                SizedBox(width: smallSpace),
                                Text(dList[index].grade, style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.star, color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text((dList[index].drate > 0) ? dList[index].drate.toString() : '-', style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(notifList[index].s, style: nameStyle),
                                SizedBox(width: smallSpace),
                                Icon(Icons.arrow_right_alt , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(notifList[index].d, style: nameStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: Text('Finish', style: textButtonStyle,),
                            onPressed: () {
                              setState(() {
                                _state[index] = 2;
                                log(_state[index].toString());
                              });
                            },
                          ),
                          SizedBox(width: smallSpace * 3),
                          TextButton(
                            child: Text('Decline', style: textButtonStyle,),
                            onPressed: () =>  AlertDialog(
                              title: Text(declinedAlertTitle),
                              content: Text(declinedAlertText),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    log("Cancel");
                                    Navigator.pop(context, 'Cancel');
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _state[index] = 4;
                                      log(_state[index].toString());
                                    });
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );

                  final Accepted_d = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.hail, color: appMainColor, size: 40.0,),
                        title: Text(driverAcceptedText + pList[index].name, style: nameStyle),
                        subtitle: Column(
                          children: <Widget>[
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.person , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(pList[index].gender, style: labelStyle),
                                SizedBox(width: smallSpace * 4),
                                Icon(Icons.school , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(pList[index].dept, style: labelStyle),
                                SizedBox(width: smallSpace),
                                Text(pList[index].grade, style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.star, color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text((pList[index].prate > 0) ? pList[index].prate.toString() : '-', style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(notifList[index].s, style: nameStyle),
                                SizedBox(width: smallSpace),
                                Icon(Icons.arrow_right_alt , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(notifList[index].d, style: nameStyle),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          SizedBox(width: smallSpace),
                          TextButton(
                            child: Text('Decline', style: textButtonStyle,),
                            onPressed: () =>  AlertDialog(
                              title: Text(declinedAlertTitle),
                              content: Text(declinedAlertText),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () {
                                    log("Cancel");
                                    Navigator.pop(context, 'Cancel');
                                  },
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      _state[index] = 5;
                                      log(_state[index].toString());
                                    });
                                  },
                                  child: const Text('Yes'),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  );

                  final Finished_p = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.tag_faces, color: appMainColor, size: 40.0,),
                        title: Text(FinishedText, style: nameStyle),
                        subtitle: Column(
                          children: <Widget>[
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[Text(dList[index].name, style: labelStyle),],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.person , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(dList[index].gender, style: labelStyle),
                                SizedBox(width: smallSpace * 4),
                                Icon(Icons.school , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(dList[index].dept, style: labelStyle),
                                SizedBox(width: smallSpace),
                                Text(dList[index].grade, style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.star, color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text((dList[index].drate > 0) ? dList[index].drate.toString() : '-', style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.star_rate, color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(_rating[index].toString() ,style: labelStyle),
                                Slider(
                                  activeColor: appMainColor,
                                  inactiveColor: appBackgroundColor,
                                  value: _rating[index],
                                  min: 1,
                                  max: 5,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _rating[index] = newValue;
                                    });
                                  },
                                  onChangeStart: (startValue) {
                                    print('onChangeStart:$startValue');
                                  },
                                  onChangeEnd: (endValue) {
                                    print('onChangeEnd:$endValue');
                                  },
                                  label: "Rating",
                                  divisions: 4,
                                ),
                              ],
                            ),

                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: Text('Send', style: textButtonStyle,),
                            onPressed: () {

                            },
                          ),
                        ],
                      ),
                    ],
                  );

                  final Finished_d = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.tag_faces, color: appMainColor, size: 40.0,),
                        title: Text(FinishedText, style: nameStyle),
                        subtitle: Column(
                          children: <Widget>[
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[Text(pList[index].name, style: labelStyle),],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.person , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(pList[index].gender, style: labelStyle),
                                SizedBox(width: smallSpace * 4),
                                Icon(Icons.school , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(pList[index].dept, style: labelStyle),
                                SizedBox(width: smallSpace),
                                Text(pList[index].grade, style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.star, color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text((pList[index].prate > 0) ? pList[index].prate.toString() : '-', style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.star_rate, color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(_rating[index].toString() ,style: labelStyle),
                                Slider(
                                  activeColor: appMainColor,
                                  inactiveColor: appBackgroundColor,
                                  value: _rating[index],
                                  min: 1,
                                  max: 5,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _rating[index] = newValue;
                                    });
                                  },
                                  onChangeStart: (startValue) {
                                    print('onChangeStart:$startValue');
                                  },
                                  onChangeEnd: (endValue) {
                                    print('onChangeEnd:$endValue');
                                  },
                                  label: "Rating",
                                  divisions: 4,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: Text('Send', style: textButtonStyle,),
                            onPressed: () {
                            },
                          ),
                        ],
                      ),
                    ],
                  );

                  final DeclinedByP_d = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.hail, color: appMainColor, size: 40.0,),
                        title: Text(pList[index].name + DeclinedText, style: nameStyle),
                        subtitle: Column(
                          children: <Widget>[
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.person , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(pList[index].gender, style: labelStyle),
                                SizedBox(width: smallSpace * 4),
                                Icon(Icons.school , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(pList[index].dept, style: labelStyle),
                                SizedBox(width: smallSpace),
                                Text(pList[index].grade, style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.star, color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text((pList[index].prate > 0) ? pList[index].prate.toString() : '-', style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.star_rate, color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(_rating[index].toString() ,style: labelStyle),
                                Slider(
                                  activeColor: appMainColor,
                                  inactiveColor: appBackgroundColor,
                                  value: _rating[index],
                                  min: 1,
                                  max: 5,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _rating[index] = newValue;
                                    });
                                  },
                                  onChangeStart: (startValue) {
                                    print('onChangeStart:$startValue');
                                  },
                                  onChangeEnd: (endValue) {
                                    print('onChangeEnd:$endValue');
                                  },
                                  label: "Rating",
                                  divisions: 4,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: Text('Send', style: textButtonStyle,),
                            onPressed: () {

                            },
                          ),
                        ],
                      ),
                    ],
                  );

                  final DeclinedByD_p = Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ListTile(
                        leading: Icon(Icons.hail, color: appMainColor, size: 40.0,),
                        title: Text(dList[index].name + DeclinedText, style: nameStyle),
                        subtitle: Column(
                          children: <Widget>[
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.person , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(dList[index].gender, style: labelStyle),
                                SizedBox(width: smallSpace * 4),
                                Icon(Icons.school , color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(dList[index].dept, style: labelStyle),
                                SizedBox(width: smallSpace),
                                Text(dList[index].grade, style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Icon(Icons.star, color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text((dList[index].drate > 0) ? dList[index].drate.toString() : '-', style: labelStyle),
                              ],
                            ),
                            SizedBox(height: smallSpace),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(Icons.star_rate, color: appMainColor, size: 18.0,),
                                SizedBox(width: smallSpace),
                                Text(_rating[index].toString() ,style: labelStyle),
                                Slider(
                                  activeColor: appMainColor,
                                  inactiveColor: appBackgroundColor,
                                  value: _rating[index],
                                  min: 1,
                                  max: 5,
                                  onChanged: (newValue) {
                                    setState(() {
                                      _rating[index] = newValue;
                                    });
                                  },
                                  onChangeStart: (startValue) {
                                    print('onChangeStart:$startValue');
                                  },
                                  onChangeEnd: (endValue) {
                                    print('onChangeEnd:$endValue');
                                  },
                                  label: "Rating",
                                  divisions: 4,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          TextButton(
                            child: Text('Send', style: textButtonStyle,),
                            onPressed: () {
                            },
                          ),
                        ],
                      ),
                    ],
                  );

                  var notAccepted = [notAccepted_p, notAccepted_d];
                  var Accepted = [Accepted_p, Accepted_d];
                  var Finished = [Finished_p, Finished_d];
                  var DeclinedBeforeAccepted = [notAccepted_p, notAccepted_p];
                  var DeclinedByP = [notAccepted_p, DeclinedByP_d];
                  var DeclinedByD= [DeclinedByD_p, notAccepted_p];

                  var cardList = [
                    notAccepted, Accepted, Finished, DeclinedBeforeAccepted, DeclinedByP, DeclinedByD,
                  ];

                  return Center(
                      child: Card(
                        child: cardList[_state[index]][_status],
                      ),
                    );
                },
              ),
            );
          }).toList(),
        ),
      ),
      routes: routes,
    );
  }
}

final routes = <String, WidgetBuilder> {
  mainPageTag: (context) => MainPage(),
  wallTag: (context) => Wall(),
};