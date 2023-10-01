class Presence {
  Presence({
    required this.id,
    required this.meetingId,
    required this.memberId,
    required this.time,
    required this.enter,
    required this.exit
  });
  late String id;
  late String? meetingId;
  late String? memberId;
  late String? enter;
  late String? exit;
  late int? time;

  Presence.fromJson(Map<String, dynamic> json){
    id = json['id'];
    meetingId = json['meetingId'];
    memberId = json['memberId'];
    enter = json['enter'];
    exit = json['exit'];
    time = json['time'];
  }
}
