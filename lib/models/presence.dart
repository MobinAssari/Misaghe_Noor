class Presence {
  Presence({
    required this.activityId,
    required this.memberId,
    required this.enterTime,
    required this.exitTime,
    required this.total,
  });

  final String activityId;
  final String memberId;
  final DateTime enterTime;
  final DateTime exitTime;
  final Duration total;

  Duration getTotalTime() {
    var total = exitTime.difference(enterTime);
    return total;
  }
}
