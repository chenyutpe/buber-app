import 'User.dart';
import 'dart:convert';

//var empty = new User();

class Ride {
  final String id;
  final String pid;
  final String did;
  final String s;
  final String d;
  final int state;
  final User p_data;
  final double prate;
  final User d_data;
  final double drate;

  Ride({
    required this.id,
    required this.pid,
    required this.did,
    required this.s,
    required this.d,
    required this.state,
    required this.prate,
    required this.p_data,
    required this.drate,
    required this.d_data,
  });

  factory Ride.fromJson(Map<String, dynamic> json){
    if(json['did'] == null && json['d_data'] == null) {
      return new Ride(
        id: json['_id']['\$oid'],
        pid: json['pid']['\$oid'],
        did: '',
        s: json['s'],
        d: json['d'],
        state: json ['state'],
        prate: json['prate'],
        p_data: User.fromJson(json['p_data']),
        drate: json['drate'],
        d_data: User.empty(),
      );
    }
      else{
      return new Ride(
        id: json['_id']['\$oid'],
        pid: json['pid']['\$oid'],
        did: json['did']['\$oid'],
        s: json['s'],
        d: json['d'],
        state: json ['state'],
        prate: json['prate'],
        p_data: User.fromJson(json['p_data']),
        drate: json['drate'],
        d_data: User.fromJson(json['d_data']),
      );
    }

  }
}