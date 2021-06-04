class Ride {
  final String id;
  final String pid;
  final String did;
  final String s;
  final String d;
  final int state;
  final double prate;
  final double drate;

  Ride({
    required this.id,
    required this.pid,
    required this.did,
    required this.s,
    required this.d,
    required this.state,
    required this.prate,
    required this.drate
  });

  factory Ride.fromJson(Map<String, dynamic> json){
    if(json['did'] == null) {
      return new Ride(
        id: json['_id']['\$oid'],
        pid: json['pid']['\$oid'],
        did: '',
        s: json['s'],
        d: json['d'],
        state: json ['state'],
        prate: json['prate'],
        drate: json['drate'],
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
        drate: json['drate'],
      );
    }

  }
}