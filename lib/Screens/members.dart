import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:misaghe_noor/Screens/member_details.dart';
import 'package:misaghe_noor/helper/loadingFromFireBase.dart';
import 'package:misaghe_noor/models/member.dart';
import 'package:misaghe_noor/provider/members_provider.dart';

//todo searching
//todo animation
class MembersScreen extends ConsumerStatefulWidget {
  const MembersScreen({super.key});

  @override
  ConsumerState<MembersScreen> createState() => _MembersScreenState();
}

class _MembersScreenState extends ConsumerState<MembersScreen> {
  bool _isLoading = true;
  bool _isSearching = false;
  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    /*final url = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'members-list.json');
    final response = await http.get(url);
    if (response.body == 'null') {
      setState(() {
        _isLoading = false;
      });
      return;
    }
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
      ref.read(membersProvider.notifier).addMembers(loadedItems.cast<Member>());
    }*/
    var lFF = LoadingFromFirebase();
    final loadedItems = await lFF.loadMember();
    ref.read(membersProvider.notifier).addMembers(loadedItems.cast<Member>());



    setState(() {
      _isLoading = false;
    });
  }


  @override
  Widget build(context) {
    List<Member> memberList = ref.watch(membersProvider);
    if (_isSearching) {
      memberList = memberList
          .where((member) =>
              member.name.trim().contains(searchController.text.trim()) ||
              member.family.trim().contains(searchController.text.trim()))
          .toList();
    }
    Widget mainContent;
    if (_isLoading) {
      mainContent = const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (memberList.isEmpty) {
      mainContent =
          const Expanded(child: Center(child: Text('هیج عضوی یافت نشد!')));
    } else {
      mainContent = Expanded(
        child: ListView.builder(
          itemCount: memberList.length,
          itemBuilder: (ctx, index) {
            return Column(
              children: [
                ListTile(
                  // leading: const Icon(Icons.supervised_user_circle),
                  title: Text(
                      " ${memberList[index].name} ${memberList[index].family}"),
                  // subtitle: Text(memberList[index].fatherName!),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MemberDetailsScreen(
                                isEdit: true,
                                memberId: memberList[index].id,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.greenAccent,
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Directionality(
                              textDirection: TextDirection.rtl,
                              child: AlertDialog(
                                content: const Text('عضو حذف شود؟'),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      final url = Uri.https(
                                          'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
                                          'members-list/${memberList[index].id}.json');
                                      http.delete(url);
                                      ref
                                          .read(membersProvider.notifier)
                                          .removeMember(
                                            memberList[index],
                                          );
                                      memberList.remove(
                                        memberList[index],
                                      );
                                      Navigator.pop(context);
                                    },
                                    child: const Text('بله'),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text('خیر'),
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                        icon: const Icon(Icons.delete, color: Colors.red),
                      ),
                    ],
                  ),
                ),
                const Divider(),
              ],
            );
          },
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لیست اعضا'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MemberDetailsScreen(
                      isEdit: false,
                      memberId: '',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                      width: 300,
                      child: TextField(decoration: const InputDecoration(
                        label: Icon(Icons.search),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                        controller: searchController,
                        onChanged: (value) {
                          if (value.trim().isNotEmpty) {
                            setState(() {
                              _isSearching = true;
                            });
                          } else {
                            setState(() {
                              _isSearching = false;
                            });
                          }
                        },
                      )),

                ],
              ),
            ),
            Divider(),
            Container(child: mainContent),
          ],
        ),
      ),
    );
  }
}
