import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:misaghe_noor/Screens/meeting_details.dart';
import 'package:misaghe_noor/models/meeting.dart';
import 'package:misaghe_noor/models/presence.dart';
import 'package:misaghe_noor/provider/meetings_provider.dart';
import 'package:misaghe_noor/provider/presence_provider.dart';

class MeetingsScreen extends ConsumerStatefulWidget {
  const MeetingsScreen({super.key});

  @override
  ConsumerState<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends ConsumerState<MeetingsScreen> {
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
    final meetingUrl = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'meetings-list.json');
    final meetingResponse = await http.get(meetingUrl);
    final Map<String, dynamic> meetingListData = json.decode(meetingResponse.body);
    final List<Meeting> loadedMeetings = [];
    for (final item in meetingListData.entries) {
      loadedMeetings.add(
        Meeting(
          id: item.key,
          activityName: item.value['activityName'],
          date: item.value['date'],
          description: item.value['description'],
          lastChangeUserId: item.value['lastChangeUserId'],
        ),
      );
      ref
          .read(meetingsProvider.notifier)
          .addMeetings(loadedMeetings.cast<Meeting>());
    }
    final presenceUrl = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'presences-list.json');
    final presenceResponse = await http.get(presenceUrl);
    final Map<String, dynamic> presenceListData = json.decode(presenceResponse.body);
    final List<Presence> loadedIPresences = [];
    for (final item in presenceListData.entries) {
      loadedIPresences.add(
        Presence(
          id: item.key,
          meetingId: item.value['meetingId'],
          memberId: item.value['memberId'],
          time: item.value['time'],
        ),
      );
      ref
          .read(presencesProvider.notifier)
          .addPresences(loadedIPresences.cast<Presence>());
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Meeting> meetingList = ref.watch(meetingsProvider);
    if (_isSearching) {
      meetingList = meetingList
          .where((meeting) =>
              meeting.activityName
                  .trim()
                  .contains(searchController.text.trim()) ||
              meeting.description.trim().contains(searchController.text.trim()))
          .toList();
    }
    Widget mainContent;
    if (_isLoading) {
      mainContent = const Expanded(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else if (meetingList.isEmpty) {
      mainContent =
          const Expanded(child: Center(child: Text('هیج جلسه ای یافت نشد!')));
    } else {
      mainContent = Expanded(
        child: ListView.builder(
          itemCount: meetingList.length,
          itemBuilder: (ctx, index) {
            return Column(
              children: [
                ListTile(
                  // leading: const Icon(Icons.supervised_user_circle),
                  title: Text(" ${meetingList[index].activityName}"),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => MeetingDetailsScreen(
                                isEdit: true,
                                meetingId: meetingList[index].id,
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
        ),
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
                      meetingId: '',
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
                      child: TextField(
                        decoration: const InputDecoration(
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
