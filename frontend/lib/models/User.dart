import 'dart:developer';

class User {
  final String id;
  final String sid;
  final String password;
  final String name;
  final String dept;
  final int grade;
  final String gender;
  final int is_driver;
  //final String cert;
  final double prate;
  final double drate;

  User({
    required this.id,
    required this.sid,
    required this.password,
    required this.name,
    required this.dept,
    required this.grade,
    required this.gender,
    required this.is_driver,
    //required this.cert,
    required this.prate,
    required this.drate,
  });

  User.empty({this.id = '', this.sid = '', this.password = '', this.dept = '', this.grade = 0,
    this.gender = '', this.is_driver = 0,  this.prate = 0.0, this.drate = 0.0, this.name = ''});

  factory User.fromJson(Map<String, dynamic> json){
    /*
    log("----Check data type ------");
    log(json.runtimeType.toString());
    log("id " + json['_id']['\$oid'].runtimeType.toString());
    log("sid " + json['sid'].runtimeType.toString());
    log("password " + json['password'].runtimeType.toString());
    log("name " + json['name'].runtimeType.toString());
    log("dept " + json['dept'].runtimeType.toString());
    log("grade " + json ['grade'].runtimeType.toString());
    log("gender " + json['gender'].runtimeType.toString());
    log("is_driver " + json['is_driver'].runtimeType.toString());
    //log("cert " + json['cert']['\$oid'].runtimeType.toString());
    log("prate " + json['prate'].runtimeType.toString());
    log("drate " + json['drate'].runtimeType.toString());
    log("----Check data type ------");
    */

    if(json['cert'] == null) return new User(
      id: json['_id']['\$oid'],
      sid: json['sid'],
      password: json['password'],
      name: json['name'],
      dept: json['dept'],
      grade: json ['grade'],
      gender: json['gender'],
      is_driver: json['is_driver'],
      //cert: '',
      prate: json['prate'],
      drate: json['drate'],
    );
    else return new User(
        id: json['_id']['\$oid'],
        sid: json['sid'],
        password: json['password'],
        name: json['name'],
        dept: json['dept'],
        grade: json ['grade'],
        gender: json['gender'],
        is_driver: json['is_driver'],
        //cert: json['cert']['\$oid'],
        prate: json['prate'],
        drate: json['drate'],
    );
  }
}