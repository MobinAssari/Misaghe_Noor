import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:misaghe_noor/Screens/meeting_details.dart';
import 'package:misaghe_noor/models/meeting.dart';
import 'package:misaghe_noor/provider/meetings_provider.dart';

class MeetingsScreen extends ConsumerStatefulWidget {
  const MeetingsScreen({super.key});

  @override
  ConsumerState<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends ConsumerState<MeetingsScreen> {
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
        'meetings-list.json');
    final response = await http.get(url);
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<Meeting> loadedItems = [];
    for (final item in listData.entries) {
      loadedItems.add(Meeting(
          id: item.key,
          activityName: item.value['activityName'],
          date: item.value['date'],
          description: item.value['description'],
          lastChangeUserId: item.value['lastChangeUserId'],),);
      ref.read(meetingsProvider.notifier).addMeetings(loadedItems.cast<Meeting>());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Meeting> meetingList = ref.watch(meetingsProvider);
    Widget mainContent;
    if (_isLoading) {
      mainContent = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (meetingList.isEmpty) {
      mainContent = const Center(child: Text('هیج جلسه ای یافت نشد!'));
    } else {
      mainContent = ListView.builder(
        itemCount: meetingList.length,
        itemBuilder: (ctx, index) {
          return Column(
            children: [
              ListTile(
                // leading: const Icon(Icons.supervised_user_circle),
                title: Text(
                    " ${meetingList[index].activityName}"),
                trailing: Wrap(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => MeetingDetailsScreen(
                              isEdit: true,
                              userId: meetingList[index].id,
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
                              content: Text('جلسه حذف شود؟'),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      final url = Uri.https(
                                          'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
                                          'members-list/${meetingList[index].id}.json');
                                      http.delete(url);

                                      ref
                                          .read(meetingsProvider.notifier)
                                          .removeMeeting(meetingList[index]);
                                      meetingList.remove(meetingList[index]);
                                      Navigator.pop(context);
                                    },
                                    child: Text('بله')),
                                TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('خیر'))
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
          title: const Text('لیست جلسات'),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const MeetingDetailsScreen(
                      isEdit: false,
                      userId: '',
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.add),
            ),
          ],
        ),
        body: mainContent,
      ),
    );
  }
}
