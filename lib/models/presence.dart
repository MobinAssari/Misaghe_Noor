class Presence {
  Presence({
    required this.id,
    required this.meetingId,
    required this.memberId,
    required this.time,
    this.enter = '',
    this.exit = ''
  });
  final String id;
  final String meetingId;
  final String memberId;
  late  String enter;
  late String exit;
  late int time;
}
