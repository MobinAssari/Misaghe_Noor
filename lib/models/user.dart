class User {
  User(
      {required this.name,
      required this.family,
      required this.userName,
      required this.password,
      required this.isAdmin});

  final String name;
  final String family;
  final String userName;
  final String password;
  final bool isAdmin;
}
