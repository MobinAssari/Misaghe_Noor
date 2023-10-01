import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:misaghe_noor/Screens/meeting_details.dart';
import 'package:misaghe_noor/Screens/presence_screen.dart';
import 'package:misaghe_noor/helper/ConnectToDataBase.dart';
import 'package:misaghe_noor/models/meeting.dart';
import 'package:misaghe_noor/provider/meetings_provider.dart';
import 'package:misaghe_noor/provider/presence_provider.dart';

import '../models/activity.dart';
import '../models/presence.dart';
import '../provider/activity_provider.dart';

class MeetingsScreen extends ConsumerStatefulWidget {
  const MeetingsScreen({super.key});

  @override
  ConsumerState<MeetingsScreen> createState() => _MeetingsScreenState();
}

class _MeetingsScreenState extends ConsumerState<MeetingsScreen> {
  bool _isLoading = true;
  bool _isSearching = false;
  TextEditingController searchController = TextEditingController();
  var loading = ConnectToDataBase();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItem();
  }

  void _loadItem() async {

    final loadedItems = await loading.loadMeeting();
    ref
        .read(meetingsProvider.notifier)
        .addMeetings(loadedItems.cast<Meeting>());

    final loadedPresences = await loading.loadPresence();
    ref
        .read(presencesProvider.notifier)
        .addPresences(loadedPresences.cast<Presence>());


    final loadedActivities = await loading.loadActivity();
    ref
        .read(activityProvider.notifier)
        .addActivities(loadedActivities.cast<Activity>());


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
              meeting.activityName!
                  .trim()
                  .contains(searchController.text.trim()) ||
              meeting.description!.trim().contains(searchController.text.trim()))
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
            DateTime date = DateTime.parse(meetingList[index].date!);
            return Column(
              children: [
                ListTile(
                  // leading: const Icon(Icons.supervised_user_circle),
                  title: Text(" ${meetingList[index].activityName}",style: TextStyle(fontSize: 22),),
                  subtitle: Text(' ${date.year}/${date.month}/${date.day}'),
                  trailing: Wrap(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => PresenceScreen(
                                meetingId: meetingList[index].id,
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.contacts_sharp,
                          color: Colors.blueAccent,
                        ),
                      ),
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
                      /*IconButton(
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
                                            'meetings-list/${meetingList[index].id}.json');
                                        var response = http.delete(url);

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
                      ),*/
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
