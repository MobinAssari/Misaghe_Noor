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
    required this.lastChangeUsreId
  });

  final String id;
  final String name;
  final String family;
  final String? fatherName;
  final String? meliNumber;
  final String? shenasnameNumber;
  final String? phone;
  final String? mobile;
  final String? address;
  final String? lastChangeUsreId;
}
