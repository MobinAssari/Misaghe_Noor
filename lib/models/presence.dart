class Presence {
  Presence({
    required this.id,
    required this.meetingId,
    required this.memberId,
    required this.time
  });
  final String id;
  final String meetingId;
  final String memberId;
  late int time;
}
