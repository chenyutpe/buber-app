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
  late TabController _tabController;
  // var rating;
  var tabList = ( userData.is_driver == 0 ) ? tabPList : tabDList;
  var _rating = 3.0;
  Future<List<List<Ride>>>? _future;
  // var _dontFetch = false;
  // List<Ride> notifList = [];
  // var _stateDriver = 0;
  // var _statePassenger = 0;
  // var driverRideId = 'hello';

  @override
  void initState() {
    _future = getRide();
    _tabController = TabController(vsync: this, length: tabList.length);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<List<List<Ride>>> getRide() async {
    // if (_dontFetch) {
    //   return [];
    // }
    List<Ride> p = [];
    List<Ride> d = [];
    var res = await http.get(
      url + '/ridesCalledBy/' + userData.id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var temp = jsonDecode(res.body);
    log("getRide_P: "+temp.toString() + "len: " + temp.length.toString());
    // log(temp.length.toString());
    for(var i = 0; i < temp.length; i++) {
      var r = Ride.fromJson(temp[i]);
      p.add(r);
    }

    // log("driverID: " + driverRideId);
    res = await http.get(
      url + '/ridesTookBy/' + userData.id,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    temp = jsonDecode(res.body);
    log("getRide_D: "+temp.toString() + "len: " + temp.length.toString());
    if (temp.length == 0) {
      res = await http.get(
        url + '/search',
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    }
    temp = jsonDecode(res.body);
    log("getRide_D_ALL: "+temp.toString() + "len: " + temp.length.toString());
    // log(temp.length.toString());
    for(var i = 0; i < temp.length; i++) {
      var r = Ride.fromJson(temp[i]);
      d.add(r);
    }

    // log(d.toString());
    List<List<Ride>> list = [p, d];
    log("getRide ends");
    return list;
  }

  @override
  Widget build(BuildContext context) {
    log("Enter notificaion");
    return Scaffold(
              appBar: AppBar(
                backgroundColor: appBackgroundColor,
                title: Text(notificationTag, style: TextStyle(fontSize: 24.0, color: appMainColor)),
                leading: GestureDetector(
                  onTap: (){Navigator.of(context).pop();},
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
                          setState(() {
                            _future = getRide();
                          });
                        },
                        child: Icon(
                          Icons.refresh,
                          color: appMainColor,
                          size: 30.0,
                        ),
                      )
                  ),
                  // This mat make routing messy
                  // Padding(
                  //     padding: EdgeInsets.only(right: 24.0),
                  //     child: GestureDetector(
                  //       onTap: (){
                  //         Navigator.of(context).pushNamed(wallTag);
                  //       },
                  //       child: Icon(
                  //         Icons.pedal_bike,
                  //         color: appMainColor,
                  //         size: 30.0,
                  //       ),
                  //     )
                  // ),
                ],
                bottom: TabBar(
                  controller: _tabController,
                  tabs: tabList.map((status) => Tab(child: Text(status, style: labelStyle))).toList(),
                ),
              ),
              body: FutureBuilder<List<List<Ride>>>(
                future: _future,
                builder: (context,AsyncSnapshot<List<List<Ride>>> snapshot) {
                // print("snapshot: $snapshot");
                switch (snapshot.connectionState) {
                  case ConnectionState.none: return new Center(child: Text('None', textScaleFactor: 3));
                  case ConnectionState.waiting: return new Center(
                    child: new CircularProgressIndicator(valueColor: new AlwaysStoppedAnimation<Color>(appMainColor),),
                  );
                  default:
                    if (snapshot.hasError)
                      return new Center(child: Text('：）', textScaleFactor: 3));
                    else
                      return TabBarView(
                        controller: _tabController,
                        children: tabList.map((status) {
                          var _status = (status == prateAttr) ? 0 : 1;
                          // if (!_dontFetch){
                          List<Ride> notifList = snapshot.data![_status];
                          // }
                          // log(status);
                          // for (int i =0; i<notifList.length;i++) {
                          //   log("req $i: " + notifList[i].s.toString());
                          // }
                          // log("ListView Builder");
                          // log(notifList.length.toString());
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
                                                    log(notifList[index].id + ' ' + notifList[index].s + ' ' + notifList[index].d + ' ' + status);
                                                    Navigator.pop(context, cancelButtonText);
                                                  },
                                                  child: const Text(cancelButtonText),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    var changeState = {'oid': notifList[index].id, 'id': userData.id};
                                                    var changeStateEncode = jsonEncode(changeState);
                                                    var res = await http.post(url + '/cancel', body: changeStateEncode, headers: <String, String> {
                                                    'Content-Type': 'application/json; charset=UTF-8',
                                                    },);
                                                    log(res.body.toString());
                                                    // log(res.statusCode.toString());
                                                    if(res.statusCode == 200) {
                                                      // log("return ok");
                                                      if(res.body == "false") {
                                                        log("cancel ride failed");
                                                      }
                                                      else {
                                                        log("take success");
                                                        setState(() {
                                                          _future = getRide();
                                                        });
                                                      }
                                                    }
                                                    else {
                                                      log("error");
                                                    }
                                                    setState(() {
                                                      // _dontFetch = false;
                                                    });
                                                    Navigator.pop(context, yesButtonText);
                                                  },
                                                  child: const Text(yesButtonText),
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
                                              Text((notifList[index].p_data.prate > 0) ? notifList[index].p_data.prate.toStringAsFixed(1) : '-', style: labelStyle),
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
                                            log(notifList[index].p_data.name);
                                            var changeState = {'oid': notifList[index].id, 'did': userData.id};
                                            var changeStateEncode = jsonEncode(changeState);
                                            var res = await http.post(url + '/take', body: changeStateEncode, headers: <String, String> {
                                            'Content-Type': 'application/json; charset=UTF-8',
                                            },);
                                            // log(res.body.toString());
                                            // log(res.statusCode.toString());
                                            if(res.statusCode == 200) {
                                              // log("return ok");
                                              if(res.body == "failed") {
                                                // TODO: Should use pop-up message and refresh
                                                showDialog<String>(
                                                  context: context,
                                                  builder: (BuildContext context) => AlertDialog(
                                                    title: Text("Error"),
                                                    content: Text("The request is not acceptable!"),
                                                    actions: <Widget>[
                                                      TextButton(
                                                        onPressed: () {
                                                          log("OK");
                                                          Navigator.pop(context, 'OK');
                                                        },
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                                log("Accept failed");
                                              }
                                              else {
                                                log("take success");
                                                setState((){
                                                  _future = getRide();
                                                });
                                              }
                                            }
                                            else {
                                            log("error");
                                            }
                                            var r = jsonDecode(res.body);
                                            if(res != null) {
                                              driverRideId = r["_id"]["\$oid"];
                                              // log("return id: " + r["_id"]["\$oid"]);
                                              log("driverRideId: " + driverRideId);
                                              // log("set state");
                                            }
                                            setState(() {
                                              // _dontFetch = false;
                                            });
                                          }, //notifList[index].state = _stateDriver[index];
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
                                              Text((notifList[index].d_data.drate > 0) ? notifList[index].d_data.drate.toStringAsFixed(1) : '-', style: labelStyle),
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
                                          onPressed: () async {
                                            var changeState = {'oid': notifList[index].id, 'id': userData.id};
                                            var changeStateEncode = jsonEncode(changeState);
                                            var res = await http.post(url + '/finish', body: changeStateEncode, headers: <String, String> {
                                            'Content-Type': 'application/json; charset=UTF-8',
                                            },);
                                            log(res.body.toString());
                                            // log(res.statusCode.toString());
                                            if(res.statusCode == 200) {
                                              // log("return ok");
                                              if(res.body == "false") {
                                                log("finish ride failed");
                                              }
                                              else {
                                                log("finish ride success");
                                                setState(() {
                                                  _future = getRide();
                                                });
                                              }
                                            }
                                            else {
                                              log("error");
                                            }
                                            setState(() {
                                              // _dontFetch = false;
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
                                                    Navigator.pop(context, cancelButtonText);
                                                  },
                                                  child: const Text(cancelButtonText),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    var changeState = {'oid': notifList[index].id, 'id': userData.id};
                                                    var changeStateEncode = jsonEncode(changeState);
                                                    var res = await http.post(url + '/cancel', body: changeStateEncode, headers: <String, String> {
                                                      'Content-Type': 'application/json; charset=UTF-8',
                                                    },);
                                                    log(res.body.toString());
                                                    // log(res.statusCode.toString());
                                                    if(res.statusCode == 200) {
                                                      // log("return ok");
                                                      if(res.body == "false") {
                                                        log("cancel ride failed");
                                                      }
                                                      else {
                                                        log("take success");
                                                        setState(() {
                                                          _future = getRide();
                                                        });
                                                      }
                                                    }
                                                    else {
                                                      log("error");
                                                    }
                                                    setState(() {
                                                      // _dontFetch = false;
                                                    });
                                                    Navigator.pop(context, yesButtonText);
                                                  },
                                                  child: const Text(yesButtonText),
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
                                              Text((notifList[index].p_data.prate > 0) ? notifList[index].p_data.prate.toStringAsFixed(1) : '-', style: labelStyle),
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
                                                    Navigator.pop(context, cancelButtonText);
                                                  },
                                                  child: const Text(cancelButtonText),
                                                ),
                                                TextButton(
                                                  onPressed: () async {
                                                    var changeState = {'oid': notifList[index].id, 'id': userData.id};
                                                    var changeStateEncode = jsonEncode(changeState);
                                                    var res = await http.post(url + '/cancel', body: changeStateEncode, headers: <String, String> {
                                                    'Content-Type': 'application/json; charset=UTF-8',
                                                    },);
                                                    log(res.body.toString());
                                                    // log(res.statusCode.toString());
                                                    if(res.statusCode == 200) {
                                                      // log("return ok");
                                                      if(res.body == "false") {
                                                        log("cancel ride failed");
                                                      }
                                                      else {
                                                        log("cancel success");
                                                        setState(() {
                                                          _future = getRide();
                                                        });
                                                      }
                                                    }
                                                    else {
                                                      log("error");
                                                    }
                                                    setState(() {
                                                      // _dontFetch = false;
                                                    });
                                                    Navigator.pop(context, yesButtonText);
                                                    },
                                                  child: const Text(yesButtonText),
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
                                              Text((notifList[index].d_data.drate > 0) ? notifList[index].d_data.drate.toStringAsFixed(1) : '-', style: labelStyle),
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
                                                    // _dontFetch = true;
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
                                          onPressed: () async {
                                            var changeState = {'oid': notifList[index].id, 'id': userData.id, 'rate':_rating};
                                            var changeStateEncode = jsonEncode(changeState);
                                            var res = await http.post(url + '/review', body: changeStateEncode, headers: <String, String> {
                                              'Content-Type': 'application/json; charset=UTF-8',
                                            },);
                                            log(res.body.toString());
                                            // log(res.statusCode.toString());
                                            if(res.statusCode == 200) {
                                              // log("return ok");
                                              if(res.body == "false") {
                                                log("review failed");
                                              }
                                              else {
                                                log("take success");
                                                setState(() {
                                                  _future = getRide();
                                                });
                                              }
                                            }
                                            else {
                                              log("error");
                                            }
                                            setState(() {
                                              _rating = 3.0;
                                            });
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
                                              Text((notifList[index].p_data.prate > 0) ? notifList[index].p_data.prate.toStringAsFixed(1) : '-', style: labelStyle),
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
                                                    // _dontFetch = true;
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
                                          onPressed: () async {
                                            var changeState = {'oid': notifList[index].id, 'id': userData.id, 'rate':_rating};
                                            var changeStateEncode = jsonEncode(changeState);
                                            var res = await http.post(url + '/review', body: changeStateEncode, headers: <String, String> {
                                              'Content-Type': 'application/json; charset=UTF-8',
                                            },);
                                            log(res.body.toString());
                                            // log(res.statusCode.toString());
                                            if(res.statusCode == 200) {
                                              // log("return ok");
                                              if(res.body == "false") {
                                                log("review failed");
                                              }
                                              else {
                                                log("take success");
                                                setState(() {
                                                  _future = getRide();
                                                });
                                              }
                                            }
                                            else {
                                              log("error");
                                            }
                                            setState(() {
                                              _rating = 3.0;
                                            });
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
                                              Text((notifList[index].p_data.prate > 0) ? notifList[index].p_data.prate.toStringAsFixed(1) : '-', style: labelStyle),
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
                                                    // _dontFetch = true;
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
                                          onPressed: () async {
                                            var changeState = {'oid': notifList[index].id, 'id': userData.id, 'rate':_rating};
                                            var changeStateEncode = jsonEncode(changeState);
                                            var res = await http.post(url + '/review', body: changeStateEncode, headers: <String, String> {
                                              'Content-Type': 'application/json; charset=UTF-8',
                                            },);
                                            log(res.body.toString());
                                            // log(res.statusCode.toString());
                                            if(res.statusCode == 200) {
                                              // log("return ok");
                                              if(res.body == "false") {
                                                log("review failed");
                                              }
                                              else {
                                                log("take success");
                                                setState(() {
                                                  _future = getRide();
                                                });
                                              }
                                            }
                                            else {
                                              log("error");
                                            }
                                            setState(() {
                                              _rating = 3.0;
                                            });
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
                                              Text((notifList[index].d_data.drate > 0) ? notifList[index].d_data.drate.toStringAsFixed(1) : '-', style: labelStyle),
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
                                                    // _dontFetch = true;
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
                                          onPressed: () async {
                                            var changeState = {'oid': notifList[index].id, 'id': userData.id, 'rate':_rating};
                                            var changeStateEncode = jsonEncode(changeState);
                                            var res = await http.post(url + '/review', body: changeStateEncode, headers: <String, String> {
                                              'Content-Type': 'application/json; charset=UTF-8',
                                            },);
                                            log(res.body.toString());
                                            // log(res.statusCode.toString());
                                            if(res.statusCode == 200) {
                                              // log("return ok");
                                              if(res.body == "false") {
                                                log("review failed");
                                              }
                                              else {
                                                log("take success");
                                                setState(() {
                                                  _future = getRide();
                                                });
                                              }
                                            }
                                            else {
                                              log("error");
                                            }
                                            setState(() {
                                              _rating = 3.0;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                );

                                var notAccepted = [notAccepted_p, notAccepted_d];
                                var Accepted = [Accepted_p, Accepted_d];
                                var Finished = [Finished_p, Finished_d];
                                var DeclinedBeforeAccepted = [Offstage(offstage: true), Offstage(offstage: true)];
                                var DeclinedByP = [Offstage(offstage: true), DeclinedByP_d];
                                var DeclinedByD= [DeclinedByD_p, Offstage(offstage: true)];

                                var cardList = [
                                  notAccepted, Accepted, Finished, DeclinedBeforeAccepted, DeclinedByP, DeclinedByD,
                                ];
                                // log(_stateDriver.toString());
                                if (notifList.isEmpty) {
                                  return Center(
                                    child: Card(
                                      child: cardList[0][_status],
                                    ),
                                  );
                                }
                                return Center(
                                  child: Card(
                                    child: cardList[notifList[index].state][_status],
                                  ),
                                );
                              },
                            ),
                          );
                        }).toList(),
                      );
                }
            }),
            );
  }
}
//
// final routes = <String, WidgetBuilder> {
//   mainPageTag: (context) => MainPage(),
//   wallTag: (context) => Wall(),
// };