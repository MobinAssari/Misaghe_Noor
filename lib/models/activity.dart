class Activity {
  Activity({required this.id, required this.name, });
   late String id;
   late String name;
  Activity.fromJson(dynamic json){
    name = json['name'];
    id = json["id"];
  }
}