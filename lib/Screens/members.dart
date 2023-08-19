import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:misaghe_noor/models/member.dart';
import 'package:misaghe_noor/provider/members_provider.dart';

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
          family: item.value['family'],
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
    Widget mainContent;
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
          return Column(
            children: [
              ListTile(
                // leading: const Icon(Icons.supervised_user_circle),
                title: Text(
                    " ${memberList[index].name} ${memberList[index].family}"),
                trailing: Wrap(
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.greenAccent,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        showDialog(context: context, builder: (context) =>
                            AlertDialog(
                              content: Text('عضو حذف شود؟'),
                              actions: [
                                TextButton(onPressed: (){
                                  final url = Uri.https(
                                      'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
                                      'members-list/${memberList[index].id}.json');
                                  http.delete(url);

                                  ref
                                      .read(membersProvider.notifier)
                                      .removeMember(memberList[index]);
                                  memberList.remove(memberList[index]);
                                  Navigator.pop(context);
                                }, child: Text('بله')),
                                TextButton(onPressed:()=> Navigator.pop(context), child: Text('خیر'))
                              ],
                            ));

                      },
                      icon: const Icon(Icons.delete, color: Colors.red),
                    ),
                  ],
                ),
              ),
              Divider(),
            ],
          );
        },
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لیست اعضا'),
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
