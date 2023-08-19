import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:misaghe_noor/models/member.dart';
import 'package:misaghe_noor/models/user.dart';
import 'package:misaghe_noor/provider/members_provider.dart';
import 'package:misaghe_noor/provider/users_provider.dart';

//todo define empty list
//todo better ui
//todo link to member details
//todo animation
class MembersScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  bool _isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    final url = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'members-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<Member> loadedItems = [];
    for (final item in listData.entries) {
      loadedItems.add(Member(
          id: item.key,
          name: item.value['name'],
          fatherName: item.value['fatherName'],
          meliNumber: item.value['meliNumber'],
          shenasnameNumber: item.value['shenasnameNumber'],
          address: item.value['address'],
          phone: item.value['phone'],
          mobile: item.value['mobile'],
          lastChangeUsreId: item.value['lastChangeUsreId']));
      ref.read(membersProvider.notifier).addMember(loadedItems.cast<Member>());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(context) {
    List<Member> memberList = ref.watch(membersProvider);
    var mainContent;
    if (_isLoading) {
      mainContent = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (memberList.isEmpty) {
      mainContent = const Center(child: Text('هیج عضوی یافت نشد!'));
    } else {
      mainContent = ListView.builder(
        itemCount: memberList.length,
        itemBuilder: (ctx, index) {
          return ListTile(
            title: Text(
              memberList[index].name,
            ),
          );
        },
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: Text('لیست اعضا'),
          actions: [
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: mainContent,
      ),
    );
  }
}
