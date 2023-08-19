import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/data/dummy_user.dart';
import '../models/user.dart';

class UserNotifier extends StateNotifier<List<User>> {
  UserNotifier() : super(dummyUser);

  void addUsers(List<User> userList) {
    state = [...userList];
  }

  void removeUser(User user) {
    state = state.where((m) => m.userName != user.userName).toList();
  }
}
final usersProvider =
StateNotifierProvider<UserNotifier, List<User>>((ref) {
  return UserNotifier();
});
