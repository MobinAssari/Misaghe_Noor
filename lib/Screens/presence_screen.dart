import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/Screens/presence_details.dart';
import 'package:misaghe_noor/provider/presence_provider.dart';
import '../helper/ConnectToDataBase.dart';
import '../models/member.dart';
import '../models/presence.dart';
import '../provider/members_provider.dart';

class PresenceScreen extends ConsumerStatefulWidget {
  const PresenceScreen({super.key, required this.meetingId});

  final String meetingId;

  @override
  ConsumerState<PresenceScreen> createState() => _PresenceScreenState();
}

class _PresenceScreenState extends ConsumerState<PresenceScreen> {
  var loading = ConnectToDataBase();

  List<Presence> presenceList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final loadedPresences = await loading.loadPresence();
    ref
        .read(presencesProvider.notifier)
        .addPresences(loadedPresences.cast<Presence>());
    final loadedItems = await loading.loadMember();
    ref.read(membersProvider.notifier).addMembers(loadedItems.cast<Member>());

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    presenceList = ref
        .watch(presencesProvider)
        .reversed
        .where((element) => element.meetingId == widget.meetingId)
        .toList();
    Member? member;
    Widget mainContent;
    if (isLoading) {
      mainContent = const Center(
        child: CircularProgressIndicator(),
      );
    } else if (presenceList.isEmpty) {
      mainContent = const Center(
        child: Text('هیج داده ای پیدا نشد'),
      );
    } else {
      mainContent = Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        child: ListView.builder(
          itemCount: presenceList.length,
          itemBuilder: (ctx, index) {
            member = ref
                .read(membersProvider.notifier)
                .findMember(presenceList[index].memberId!);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => PresenceDetailsScreen(
                        isEdit: false,
                        presenceId: presenceList[index].id,
                      ),
                    ),
                  );
                },
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        member == null
                            ? Container()
                            : Text(
                                " ${member!.name} ${member!.family}",
                                style: const TextStyle(fontSize: 20),
                              ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(80, 0, 0, 0),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Center(
                              child: Text(
                                'ورود: ${presenceList[index].enter}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(80, 0, 0, 0),
                              ),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10.0)),
                            ),
                            child: Center(
                              child: Text(
                                'خروج: ${presenceList[index].exit}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          Container(
                            width: 100,
                            height: 50,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: const Color.fromARGB(80, 0, 0, 0),
                              ),
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'کل: ${toHourMinute(presenceList[index].time!)}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            ),
                          ),
                          /*IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => PresenceDetailsScreen(
                                    isEdit: false,
                                    presenceId: presenceList[index].id,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit),
                            color: Colors.red,
                          ),*/
                        ],
                      ),
                    ),
                    const Divider(color: Colors.black),
                  ],
                ),
              ),
            );
          },
        ),
      );
    }
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('لیست حضور و غیاب'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => PresenceDetailsScreen(
                        isEdit: false,
                        meetingId: widget.meetingId,
                      ),
                    ),
                  );
                },
                icon: const Icon(CupertinoIcons.add))
          ],
        ),
        body: mainContent,
      ),
    );
  }

  int calculateDuration(TimeOfDay? start, TimeOfDay? end) {
    int subMin = end!.minute - start!.minute;
    int subHour = end.hour - start.hour;
    if (subMin < 0) {
      subHour--;
      subMin = 60 + subMin;
    }
    if (subHour < 0) return 0;
    int duration = (subHour * 60 + subMin);
    return duration;
  }

  //get's a int(minute) and returns an String in hh:mm format
  String toHourMinute(int totalMinute) {
    String hour = (totalMinute ~/ 60).toString();
    String minute = totalMinute % 60 < 10
        ? '0${totalMinute % 60}'
        : (totalMinute % 60).toString();
    String result = '$hour:$minute';
    return result;
  }
}
