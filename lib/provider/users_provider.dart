import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';

class UserNotifier extends StateNotifier<List<User>> {
  UserNotifier() : super([]);

  void addUsers(List<User> userList) {
    state = [...userList];
  }

  void removeUser(User user) {
    state = state.where((m) => m.userName != user.userName).toList();
  }

  User? findUser(String id){
    for(var user in state){
      if(user.id == id) return user;
    }
    return null;
  }
}
final usersProvider =
StateNotifierProvider<UserNotifier, List<User>>((ref) {
  return UserNotifier();
});
