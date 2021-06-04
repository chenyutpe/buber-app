class User {
  final String id;
  final String sid;
  final String password;
  final String name;
  final String dept;
  final int grade;
  final String gender;
  final int is_driver;
  final String cert;
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
    required this.cert,
    required this.prate,
    required this.drate,
  });

  factory User.fromJson(Map<String, dynamic> json){
    return new User(
        id: json['_id']['\$oid'],
        sid: json['sid'],
        password: json['password'],
        name: json['name'],
        dept: json['dept'],
        grade: json ['grade'],
        gender: json['gender'],
        is_driver: json['is_driver'],
        cert: json['cert'],
        prate: json['prate'],
        drate: json['drate'],
    );
  }
}