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
  final String meetingId;
  final String memberId;
  late final  String enter;
  late final String exit;
  late int time;
}
