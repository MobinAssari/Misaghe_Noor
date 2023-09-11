class Presence {
  Presence({
    required this.id,
    required this.meetingId,
    required this.memberId,
    required this.time,
    required this.enter,
    required this.exit
  });
  final String id;
  String meetingId;
  String memberId;
  late String enter;
  late String exit;
  late int time;
}
