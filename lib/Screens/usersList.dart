import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/provider/users_provider.dart';

import '../models/user.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  const UsersListScreen({super.key});

  @override
  ConsumerState<UsersListScreen> createState() => _UsersListScreenState();
}

class _UsersListScreenState extends ConsumerState<UsersListScreen> {
  @override
  Widget build(BuildContext context) {
    List<User> userList = ref.read(usersProvider);
    return Directionality(textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: const Text('لیست کاربران'),),
        body: ListView.builder(
          itemCount: userList.length,
          itemBuilder: (ctx, index) {
            return Column(
              children: [
                ListTile(
                  // leading: const Icon(Icons.supervised_user_circle),
                  title: Text(
                    " ${userList[index].name} ${userList[index].family}",
                    style: const TextStyle(fontSize: 22)
                  ),
                ),
                const Divider(),
              ],
            );
          },
        ),
      ),
    );
  }
}
