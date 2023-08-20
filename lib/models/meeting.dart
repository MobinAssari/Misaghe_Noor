
class Meeting {
  Meeting({
    required this.id,
    required this.activityName,
    required this.date,
    required this.description,
    required this.lastChangeUserId
  });
  final String id;
  final String activityName;
  final String date;
  final String description;
  final String lastChangeUserId;
}
