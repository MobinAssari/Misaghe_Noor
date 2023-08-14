import 'package:misaghe_noor/models/activity.dart';

class Meeting {
  Meeting({
    required this.activity,
    required this.date,
  });

  final Activity activity;
  final DateTime date;
}
