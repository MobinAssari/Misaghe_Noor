import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/provider/presence_provider.dart';
import '../helper/loadingFromFireBase.dart';
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
  var loading = LoadingFromFirebase();

  List<Presence> presenceList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  List<TextEditingController> enterTimeControllers = [];
  List<TextEditingController> exitTimeControllers = [];
  List<TextEditingController> totalTimeControllers = [];
  List<TimeOfDay?> enterList = [];
  List<TimeOfDay?> exitList = [];

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
        .where((element) => element.meetingId == widget.meetingId)
        .toList();
    Member? member;
    Widget mainContent;
    if (isLoading) {
      mainContent = const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      mainContent = Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
        child: ListView.builder(
          itemCount: presenceList.length,
          itemBuilder: (ctx, index) {
            enterTimeControllers.add(TextEditingController());
            exitTimeControllers.add(TextEditingController());
            totalTimeControllers.add(TextEditingController());

            //return Text('data');
            member = ref
                .read(membersProvider.notifier)
                .findMember(presenceList[index].memberId);
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
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
                  ListTile(
                    trailing: Wrap(
                      children: [
                        SizedBox(
                          width: 80,
                          height: 50,
                          child: TextField(
                            style: const TextStyle(fontSize: 20),
                            controller: enterTimeControllers[index],
                            //editing controller of this TextField
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                //icon: Icon(Icons.timer), //icon of text field
                                labelText: "ورود" //label text of field
                                ),
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              if (enterList.length == index) {
                                enterList.add(await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                ));
                              } else {
                                enterList[index] = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                              }
                              if (enterList[index] != null) {
                                setState(() {
                                  presenceList[index].enter =
                                      "${enterList[index]!.hour}:${enterList[index]!.minute}";
                                  enterTimeControllers[index].text =
                                      presenceList[index].enter;
                                  //set the value of text field.
                                  if (enterList[index] != null &&
                                      exitList[index] != null) {
                                    totalTimeControllers[index]
                                        .text = calculateDuration(
                                            enterList[index], exitList[index])
                                        .toString();
                                  }
                                });
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 6,
                        ),
                        SizedBox(
                          width: 80,
                          height: 50,
                          child: TextField(
                            style: const TextStyle(fontSize: 20),
                            controller: exitTimeControllers[index],
                            //editing controller of this TextField
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                //icon: Icon(Icons.timer), //icon of text field
                                labelText: "خروج" //label text of field
                                ),
                            readOnly: true,
                            //set it true, so that user will not able to edit text
                            onTap: () async {
                              if (exitList.length == index) {
                                exitList.add(await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                ));
                              } else {
                                exitList[index] = await showTimePicker(
                                  initialTime: TimeOfDay.now(),
                                  context: context,
                                );
                              }
                              if (exitList[index] != null) {
                                setState(() {
                                  presenceList[index].exit =
                                      "${exitList[index]!.hour}:${exitList[index]!.minute}";
                                  exitTimeControllers[index].text =
                                      presenceList[index].exit;
                                  if (enterList[index] != null &&
                                      exitList[index] != null) {
                                    totalTimeControllers[index]
                                        .text = calculateDuration(
                                            enterList[index], exitList[index])
                                        .toString();
                                  }
                                });
                              } else {
                              }
                            },
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Container(
                          width: 90,
                          height: 50,
                          decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10.0)),
                          ),
                          child: Center(
                            child: Text(
                              totalTimeControllers[index].text.isNotEmpty
                                  ? 'کل: ${toHourMinute(int.parse(totalTimeControllers[index].text),)}'
                                  : 'کل: ',
                              style: const TextStyle(fontSize: 18),
                              //'کل: ${toHourMinute(int.parse(totalTimeControllers[index].text))}' ?? '',style: TextStyle(fontSize: 16)

                              //set it true, so that user will not able to edit text
                            ),
                          ),
                        ),
                        //             IconButton(onPressed: (){}, icon: Icon(Icons.check,color: Colors.greenAccent,),)
                      ],
                    ),
                  ),
                  const Divider(color: Colors.black),
                ],
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
