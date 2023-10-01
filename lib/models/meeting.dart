
class Meeting {
  Meeting({
    required this.id,
    required this.activityName,
    required this.date,
    required this.description,
    required this.lastChangedUserId
  });
  late String id;
  late String? activityName;
  late String? date;
  late String? description;
  late String? lastChangedUserId;

  Meeting.fromJson(Map<String, dynamic> json){
    id = json['id'];
    activityName = json['activityName'];
    date = json['date'];
    description = json['description'];
    lastChangedUserId = json['lastChangedUserId'];
  }
}
