import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'models/Ride.dart';
import 'dart:developer';
import 'MainPage.dart';
import 'Wall.dart';

class Notif extends StatefulWidget {
  NotifPage createState() => new NotifPage();
}

class NotifPage extends State<Notif> with SingleTickerProviderStateMixin {
  //TODO: Get RideList from backend.
  //@get: snapshot.data: List<Object>, dRideList: List<Object>
  //Future _future;
  late TabController _tabController;
  var tabList = ( userData.is_driver == 0 ) ? tabPList : tabDList;
  var _rating = 1.0;
  var _state = List.filled(100, 0);
  var driverRideId = 'hello';

  getDriverRideId(r, index){
    setState(() {
      //TODO: update new state to backend
      //@post: state: 1
      _state[index] = 1;
      if(r != null) {
        driverRideId = 'ldkjfslkdjflskdjflskdjf';
        log("return data " + r.id);
        log(driverRideId);
        log("set state");
        log(_state[index].toString());
      }
    });
  }

  Future<List<List<Ride>>> getRide() async {
    List<Ride> p = [];
    List<Ride> d = [];
    for(var i = 0; i < pList.length; i++) {
      var res = await http.get(url + '/rides/' + pList[i], headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },);
      log("p ride data: " + res.body);
      var r = Ride.fromJson(jsonDecode(res.body));
      log(r.toString());
      p.add(r);
    }
    var res;
    log("driverID: " + driverRideId);
    /*if(_state[index] == 1) res = await http.get(url + '/rides/' + driverRideId, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },);
    //else if(_state[index] == 0) */
    res = await http.get(url + '/search', headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },);
    log("d ride data: " + res.body);
    var temp = jsonDecode(res.body);
    log(temp.length.toString());
    for(var i = 0; i < temp.length; i++) {
      /*
      log(i.toString() + " " + temp[i].toString());

      log(temp[i]['id'].toString());
      log(temp[i]['pid'].toString());
      log(temp[i]['did'].toString());
      log(temp[i]['s'].toString());
      log(temp[i]['d'].toString());
      log(temp[i]['p_data'].toString());
      log(temp[i]['p_data'].runtimeType.toString());
      log(temp[i]['d_data'].toString());
      log(temp[i]['p_data'].runtimeType.toString());
       */

      var r = Ride.fromJson(temp[i]);
      //log(i.toString() + " " + r.toString());
      d.add(r);
    }
    log(d.toString());
    List<List<Ride>> list = [p, d];
    log("get notifList");
    return list;
  }

  @override
  void initState() {
    super.initState();
    //_future = getRide();
    _tabController = TabController(vsync: this, length: tabList.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    log("Enter notificaion");
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
              body: FutureBuilder<List<List<Ride>>>(
                future: getRide(),
                builder: (context,AsyncSnapshot<List<List<Ride>>> snapshot) {
                print("snapshot: $snapshot");
                switch (snapshot.connectionState) {
                  case ConnectionState.none: return new Center(child: Text('None', textScaleFactor: 3));
                  case ConnectionState.waiting: return new Center(child: Text('Loading...', textScaleFactor: 3));
                  default:
                    if (snapshot.hasError)
                      return new Center(child: Text('：）', textScaleFactor: 3));
                    else
                      return TabBarView(
                        controller: _tabController,
                        children: tabList.map((status) {
                          var _status = (status == prateAttr) ? 0 : 1;
                          List<Ride> notifList = snapshot.data![_status];
                          log("ListView Builder");
                          log(notifList.length.toString());
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
                                //_state[index] = notifList[index].state;

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
                                          onPressed: () =>  showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
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
                                                    //TODO: update new state to backend
                                                    //@post: state: 3
                                                    setState(() {

                                                    });
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            ),
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
                                      title: Text(notifList[index].p_data.name + driverReceivedText, style: attrStyle),
                                      subtitle: Column(
                                        children: <Widget>[
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.person , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].p_data.gender, style: labelStyle),
                                              SizedBox(width: smallSpace * 4),
                                              Icon(Icons.school , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].p_data.dept, style: labelStyle),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].p_data.grade.toString(), style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.star, color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text((notifList[index].p_data.prate > 0) ? notifList[index].p_data.prate.toString() : '-', style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(notifList[index].s, style: attrStyle),
                                              SizedBox(width: smallSpace),
                                              Icon(Icons.arrow_right_alt , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].d, style: attrStyle),
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
                                          onPressed: () async {
                                            var changeState = {'oid': notifList[index].id, 'did': userData.id};
                                            var changeStateEncode = jsonEncode(changeState);
                                            var res = await http.post(url + '/take', body: changeStateEncode, headers: <String, String> {
                                            'Content-Type': 'application/json; charset=UTF-8',
                                            },);
                                            var r;
                                            log(res.body.toString());
                                            log(res.statusCode.toString());
                                            if(res.statusCode == 200) {
                                              log("return ok");
                                              if(res.body == "failed") {
                                                log("change state failed");
                                              }
                                              else {
                                                log("success");
                                                r = Ride.fromJson(jsonDecode(res.body));
                                              }
                                            }
                                            else {
                                            log("error");
                                            }
                                            getDriverRideId(r, index);
                                            }, //notifList[index].state = _state[index];
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
                                      title: Text(notifList[index].d_data.name + pasAcceptedText, style: attrStyle),
                                      subtitle: Column(
                                        children: <Widget>[
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.person , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].d_data.gender, style: labelStyle),
                                              SizedBox(width: smallSpace * 4),
                                              Icon(Icons.school , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].d_data.dept, style: labelStyle),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].d_data.grade.toString(), style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.star, color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text((notifList[index].d_data.drate > 0) ? notifList[index].d_data.drate.toString() : '-', style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(notifList[index].s, style: attrStyle),
                                              SizedBox(width: smallSpace),
                                              Icon(Icons.arrow_right_alt , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].d, style: attrStyle),
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
                                              //TODO: update new state to backend
                                              //@post: state: 2
                                              _state[index] = 2;
                                              log("set state");
                                              log(_state[index].toString());
                                              //notifList[index].state = _state[index];
                                            });
                                          },
                                        ),
                                        SizedBox(width: smallSpace * 3),
                                        TextButton(
                                          child: Text('Decline', style: textButtonStyle,),
                                          onPressed: () =>  showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
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
                                                    //TODO: update new state to backend
                                                    //@post: state: 4
                                                    setState(() {
                                                    });
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            ),
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
                                      title: Text(driverAcceptedText + notifList[index].p_data.name, style: attrStyle),
                                      subtitle: Column(
                                        children: <Widget>[
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.person , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].p_data.gender, style: labelStyle),
                                              SizedBox(width: smallSpace * 4),
                                              Icon(Icons.school , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].p_data.dept, style: labelStyle),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].p_data.grade.toString(), style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.star, color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text((notifList[index].p_data.prate > 0) ? notifList[index].p_data.prate.toString() : '-', style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Text(notifList[index].s, style: attrStyle),
                                              SizedBox(width: smallSpace),
                                              Icon(Icons.arrow_right_alt , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].d, style: attrStyle),
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
                                          onPressed: () =>  showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
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
                                                    //TODO: update new state to backend
                                                    //@post: state: 5
                                                    setState(() {
                                                    });
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            ),
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
                                      title: Text(FinishedText, style:attrStyle),
                                      subtitle: Column(
                                        children: <Widget>[
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[Text(notifList[index].d_data.name, style: dataStyle),],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.person , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].d_data.gender, style: labelStyle),
                                              SizedBox(width: smallSpace * 4),
                                              Icon(Icons.school , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].d_data.dept, style: labelStyle),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].d_data.grade.toString(), style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.star, color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text((notifList[index].d_data.drate > 0) ? notifList[index].d_data.drate.toString() : '-', style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.star_rate, color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(_rating.toString() ,style: labelStyle),
                                              Slider(
                                                activeColor: appMainColor,
                                                inactiveColor: appBackgroundColor,
                                                value: _rating,
                                                min: 1,
                                                max: 5,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _rating = newValue;
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
                                            //TODO: ask backend to delete the request

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
                                      title: Text(FinishedText, style: attrStyle),
                                      subtitle: Column(
                                        children: <Widget>[
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[Text(notifList[index].p_data.name, style: dataStyle),],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.person , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].p_data.gender, style: labelStyle),
                                              SizedBox(width: smallSpace * 4),
                                              Icon(Icons.school , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].p_data.dept, style: labelStyle),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].p_data.grade.toString(), style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.star, color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text((notifList[index].p_data.prate > 0) ? notifList[index].p_data.prate.toString() : '-', style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.star_rate, color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(_rating.toString() ,style: labelStyle),
                                              Slider(
                                                activeColor: appMainColor,
                                                inactiveColor: appBackgroundColor,
                                                value: _rating,
                                                min: 1,
                                                max: 5,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _rating = newValue;
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
                                            //TODO: ask backend to delete the request

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
                                      title: Text(notifList[index].p_data.name + DeclinedText, style: attrStyle),
                                      subtitle: Column(
                                        children: <Widget>[
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.person , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].p_data.gender, style: labelStyle),
                                              SizedBox(width: smallSpace * 4),
                                              Icon(Icons.school , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].p_data.dept, style: labelStyle),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].p_data.grade.toString(), style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.star, color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text((notifList[index].p_data.prate > 0) ? notifList[index].p_data.prate.toString() : '-', style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.star_rate, color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(_rating.toString() ,style: labelStyle),
                                              Slider(
                                                activeColor: appMainColor,
                                                inactiveColor: appBackgroundColor,
                                                value: _rating,
                                                min: 1,
                                                max: 5,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _rating = newValue;
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
                                            //TODO: ask backend to delete the request

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
                                      title: Text(notifList[index].d_data.name + DeclinedText, style: attrStyle),
                                      subtitle: Column(
                                        children: <Widget>[
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.person , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].d_data.gender, style: labelStyle),
                                              SizedBox(width: smallSpace * 4),
                                              Icon(Icons.school , color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].d_data.dept, style: labelStyle),
                                              SizedBox(width: smallSpace),
                                              Text(notifList[index].d_data.grade.toString(), style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: <Widget>[
                                              Icon(Icons.star, color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text((notifList[index].d_data.drate > 0) ? notifList[index].d_data.drate.toString() : '-', style: labelStyle),
                                            ],
                                          ),
                                          SizedBox(height: smallSpace),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(Icons.star_rate, color: appMainColor, size: 18.0,),
                                              SizedBox(width: smallSpace),
                                              Text(_rating.toString() ,style: labelStyle),
                                              Slider(
                                                activeColor: appMainColor,
                                                inactiveColor: appBackgroundColor,
                                                value: _rating,
                                                min: 1,
                                                max: 5,
                                                onChanged: (newValue) {
                                                  setState(() {
                                                    _rating = newValue;
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
                                            //TODO: ask backend to delete the request
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );

                                var notAccepted = [notAccepted_p, notAccepted_d];
                                var Accepted = [Accepted_p, Accepted_d];
                                var Finished = [Finished_p, Finished_d];
                                var DeclinedBeforeAccepted = [Text('state3'), Text('state3')];
                                var DeclinedByP = [Text('state4'), DeclinedByP_d];
                                var DeclinedByD= [DeclinedByD_p, Text('state5')];

                                var cardList = [
                                  notAccepted, Accepted, Finished, DeclinedBeforeAccepted, DeclinedByP, DeclinedByD,
                                ];
                                log(_state[index].toString());
                                return Center(
                                  child: Card(
                                    child: cardList[_state[index]][_status],
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                }
            }),
            ),
      routes: routes,);
  }
}

final routes = <String, WidgetBuilder> {
  mainPageTag: (context) => MainPage(),
  wallTag: (context) => Wall(),
};