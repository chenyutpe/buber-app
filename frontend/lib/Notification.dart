import 'package:flutter/material.dart';
import 'helpers/Constants.dart';
import 'MainPage.dart';
import 'Wall.dart';

class Notif extends StatefulWidget {
  NotifPage createState() => new NotifPage();
}

class NotifPage extends State<Notif> with SingleTickerProviderStateMixin {
  //TODO: Get two type of notification List pRideList and dRideList from backend.
  //@get: pRideList: List<Object>, dRideList: List<Object>

  late TabController _tabController;
  final accept = SnackBar(content: Text("Accept"));
  final decline = SnackBar(content: Text("decline"));
  var _isPFinished;
  var _isDFinished;
  var _rating;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabList.length);
    setState(() {
      _isPFinished = List.filled(pRideList.length, false);
      _isDFinished = List.filled(dRideList.length, false);
    });
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
            var notifList = (status == prateAttr) ? pRideList : dRideList;
            return notifList.length == 0 ? Text(status, textScaleFactor: 5) : Container(
              alignment: Alignment.center,
              child: ListView.builder(
                itemCount: notifList.length,
                itemBuilder: (BuildContext context, int index){
                  return Opacity(
                    opacity: 1.0,
                    child: Center(
                      child: Card(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ListTile(
                              leading: Icon(Icons.hail, color: appMainColor, size: 40.0,),
                              title: Text((status == prateAttr) ? (pasWaitText + notifList[index].did) :
                                    (notifList[index].pid + driverReceivedText), style: nameStyle),
                              subtitle: Column(
                                children: <Widget>[
                                  SizedBox(height: smallSpace),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.person , color: appMainColor, size: 18.0,),
                                      SizedBox(width: smallSpace),
                                      //Text(/* p/d 's gender */, style: labelStyle),
                                      SizedBox(width: smallSpace * 4),
                                      Icon(Icons.school , color: appMainColor, size: 18.0,),
                                      SizedBox(width: smallSpace),
                                      //Text(/* p/d 's dept and grade */, style: labelStyle),
                                    ],
                                  ),
                                  SizedBox(height: smallSpace),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Icon(Icons.star, color: appMainColor, size: 18.0,),
                                      SizedBox(width: smallSpace),
                                      Text((status == prateAttr) ? ((notifList[index].drate > 0) ? notifList[index].drate.toString() : '-') :
                                      ((notifList[index].prate > 0) ? notifList[index].prate.toString() : '-'), style: labelStyle),
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
                            Visibility(
                              visible: (status == prateAttr) ? _isPFinished[index] : _isDFinished[index] ? true : false,
                              child: DropdownButtonFormField(
                                      items: startList.map((String rating) {
                                        return new DropdownMenuItem(
                                          value: rating,
                                          child: Text(rating, style: TextStyle(fontSize: 24.0,
                                            color: appWhiteColor,)),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() => _rating = newValue);
                                        if(status == prateAttr) notifList[index].drate = _rating;
                                        else notifList[index].prate = _rating;
                                      },
                                      value: _rating,
                                      dropdownColor: appBackgroundColor,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                                        enabledBorder: underlineStyle,
                                        focusedBorder: underlineStyle,
                                      ),
                                    ),
                                  ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                TextButton(
                                  child: Text('Accept', style: labelStyle,),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(accept);
                                  },
                                ),
                                const SizedBox(width: 8),
                                TextButton(
                                  child: Text('Decline', style: labelStyle,),
                                  onPressed: () {
                                    ScaffoldMessenger.of(context).showSnackBar(decline);
                                  },
                                ),
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