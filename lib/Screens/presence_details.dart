import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/Screens/members.dart';
import 'package:misaghe_noor/helper/ConnectToDataBase.dart';
import 'package:misaghe_noor/models/member.dart';
import 'package:misaghe_noor/models/presence.dart';
import 'package:misaghe_noor/provider/members_provider.dart';
import 'package:misaghe_noor/provider/presence_provider.dart';

class PresenceDetailsScreen extends ConsumerStatefulWidget {
  const PresenceDetailsScreen(
      {super.key, this.presenceId, this.meetingId, required this.isEdit});

  final String? presenceId;
  final String? meetingId;
  final bool isEdit;

  @override
  ConsumerState<PresenceDetailsScreen> createState() =>
      _PresenceDetailsScreenState();
}

class _PresenceDetailsScreenState extends ConsumerState<PresenceDetailsScreen> {
  bool _isLoading = false;
  TextEditingController enterController = TextEditingController();
  TextEditingController exitController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  String? meetingId;
  String? presenceId;
  String totalText = '';
  Presence? presence;
  TimeOfDay? enterTime;
  TimeOfDay? exitTime;
  late String memberId;
  Member? member;

  @override
  void dispose() {
    super.dispose();
    enterController.dispose();
    exitController.dispose();
    nameController.dispose();
  }

  @override
  void initState() {
    meetingId = widget.meetingId;
    if (!widget.isEdit && widget.presenceId != null) {
      presence =
          ref.read(presencesProvider.notifier).findPresence(widget.presenceId!);
      member =
          ref.read(membersProvider.notifier).findMember(presence!.memberId!);
      meetingId = presence!.meetingId;
    }
    if (presence != null) {
      enterController.text = presence!.enter!;
      exitController.text = presence!.exit!;
      totalText = presence!.time.toString();
      Member? member =
          ref.read(membersProvider.notifier).findMember(presence!.memberId!);
      if (member != null) {
        nameController.text = "${member.name} ${member.family}";
      }
    }
    super.initState();
  }

  void _saving() async {
    if (member != null &&
        enterController.text.isNotEmpty &&
        exitController.text.isNotEmpty &&
        totalText.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      if (widget.isEdit) {
        connectToDataBase.patchPresence(Presence(
            id: presence!.id,
            meetingId: presence!.meetingId,
            memberId: member!.id,
            time: int.parse(totalText),
            enter: enterController.text,
            exit: exitController.text));
        ref.read(presencesProvider.notifier).removePresence(presence!);
        presenceId = presence!.id;
      } else {
        presenceId = await connectToDataBase.postPresence(Presence(
            id: '',
            meetingId: widget.meetingId,
            memberId: member!.id,
            time: int.parse(totalText),
            enter: enterController.text,
            exit: exitController.text));
      }

      ref.read(presencesProvider.notifier).addPresence(Presence(
          id: presenceId!,
          meetingId: meetingId!,
          memberId: member!.id,
          time: int.parse(totalText),
          enter: enterController.text,
          exit: exitController.text));
      Navigator.of(context).pop();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('جزئیات حضور و غیاب'),
        ),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 26),
            child: Column(
              children: <Widget>[
                TextField(
                  style: const TextStyle(fontSize: 20),
                  controller: nameController,
                  //editing controller of this TextField
                  decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      //icon: Icon(Icons.timer), //icon of text field
                      labelText: "نام" //label text of field
                      ),
                  readOnly: true,
                  //set it true, so that user will not able to edit text
                  onTap: () async {
                    memberId = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => const MembersScreen(picking: true),
                      ),
                    );
                    member =
                        ref.read(membersProvider.notifier).findMember(memberId);
                    setState(() {
                      nameController.text =
                          " ${member!.name} ${member!.family}";
                    });
                  },
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 100,
                      height: 70,
                      child: TextField(
                        style: const TextStyle(fontSize: 20),
                        controller: enterController,
                        //editing controller of this TextField
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            //icon: Icon(Icons.timer), //icon of text field
                            labelText: "ورود" //label text of field
                            ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          enterTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );
                          setState(() {
                            if (enterTime != null) {
                              if (exitTime == null) {
                                exitController.text = '';
                                totalText = '0';
                              } else {
                                totalText =
                                    calculateDuration(enterTime, exitTime)
                                        .toString();
                              }
                              /* presence?.enter =
                              "${enterTime!.hour}:${enterTime!.minute}  ";*/
                              enterController.text =
                                  "${enterTime!.hour}:${enterTime!.minute}";
                              //set the value of text field.
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    SizedBox(
                      width: 100,
                      height: 70,
                      child: TextField(
                        style: const TextStyle(fontSize: 20),
                        controller: exitController,
                        //editing controller of this TextField
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            //icon: Icon(Icons.timer), //icon of text field
                            labelText: "خروج" //label text of field
                            ),
                        readOnly: true,
                        //set it true, so that user will not able to edit text
                        onTap: () async {
                          exitTime = await showTimePicker(
                            initialTime: TimeOfDay.now(),
                            context: context,
                          );

                          setState(() {
                            if (exitTime != null) {
                              if (enterTime == null) {
                                enterController.text = '';
                                totalText = '0';
                              } else {
                                totalText =
                                    calculateDuration(enterTime, exitTime)
                                        .toString();
                              }
                              /*presence!.exit =
                                  "${exitTime!.hour}:${exitTime!.minute}";*/
                              exitController.text =
                                  "${exitTime!.hour}:${exitTime!.minute}";
                            }
                          });
                        },
                      ),
                    ),
                    const SizedBox(
                      width: 12,
                    ),
                    Container(
                      width: 100,
                      height: 65,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10.0)),
                      ),
                      child: Center(
                        child: Text(
                          totalText.isNotEmpty
                              ? 'کل: ${toHourMinute(
                                  int.parse(totalText),
                                )}'
                              : 'کل: ',
                          style: const TextStyle(fontSize: 18),
                          //'کل: ${toHourMinute(int.parse(totalTimeControllers[index].text))}' ?? '',style: TextStyle(fontSize: 16)

                          //set it true, so that user will not able to edit text
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Align(
                    alignment: AlignmentDirectional.topEnd,
                    child: SizedBox(
                      width: 100,
                      height: 50,
                      child: ElevatedButton(
                          onPressed: _isLoading ? () {} : _saving,
                          child: _isLoading
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text('ذخیره')),
                    )),
              ],
            ),
          ),
        ),
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
