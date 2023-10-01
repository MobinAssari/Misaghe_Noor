class User {
  User(
      {required this.id,
      required this.name,
      required this.family,
      required this.userName,
      required this.password,
      required this.isAdmin});

  late String id;
  String? name;
  String? family;
  String? userName;
  String? password;
  bool? isAdmin;

  User.fromJson(Map<String, dynamic> json){
    id = json['id'].toString();
    name = json['name'];
    family = json['family'];
    userName = json['userName'];
    password = json['password'];
    isAdmin = json['isAdmin'];
  }
}
