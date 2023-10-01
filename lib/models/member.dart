import 'dart:core';

class Member {
  Member({
    required this.id,
    required this.name,
    required this.family,
    required this.fatherName,
    required this.meliNumber,
    required this.shenasnameNumber,
    required this.address,
    required this.phone,
    required this.mobile,
    required this.lastChangedUserId
  });

  late String id;
  late String name;
  late String family;
  late String? fatherName;
  late String? meliNumber;
  late String? shenasnameNumber;
  late String? phone;
  late String? mobile;
  late String? address;
  late String? lastChangedUserId;

  Member.fromJson(Map<String, dynamic> json){
    id = json['id'];
    name = json['name'];
    family = json['family'];
    fatherName = json['fatherName'];
    meliNumber = json['meliNumber'];
    shenasnameNumber = json['shenasnameNumber'];
    phone = json['phone'];
    mobile = json['mobile'];
    address = json['address'];
    lastChangedUserId = json['lastChangedUserId'];
  }
}
