import 'package:misaghe_noor/models/activity.dart';
import 'package:misaghe_noor/models/member.dart';

class Presence {
  Presence({
    required this.activity,
    required this.member,
    required this.enterTime,
    required this.exitTime,
    required this.total,
  });

  final Activity activity;
  final Member member;
  final DateTime enterTime;
  final DateTime exitTime;
  final Duration total;

  Duration GetTotalTime() {
    var total = exitTime.difference(enterTime);
    return total;
  }
}
