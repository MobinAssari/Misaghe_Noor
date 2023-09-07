import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:misaghe_noor/models/member.dart';
import 'package:misaghe_noor/models/presence.dart';
import 'package:misaghe_noor/provider/members_provider.dart';
import 'package:misaghe_noor/provider/presence_provider.dart';


final formatter = intl.DateFormat.Hm();

class PresenceItem extends ConsumerStatefulWidget {
  const PresenceItem(
      {super.key, required this.isEdit, required this.meetingId});

  final bool isEdit;
  final String meetingId;

  @override
  ConsumerState<PresenceItem> createState() => _PresenceItemState();
}

class _PresenceItemState extends ConsumerState<PresenceItem> {
  List<TextEditingController> enterTimeControllers = [];
  List<TextEditingController> exitTimeControllers = [];
  List<TextEditingController> totalTimeControllers = [];
  List<TimeOfDay?> enterList = [];
  List<TimeOfDay?> exitList = [];

  @override
  Widget build(context) {
    /*enterTimeControllers.clear();
    exitTimeControllers.clear();
    totalTimeControllers.clear();*/
    final List<Presence> presenceList = ref
        .read(presencesProvider)
        .where((presence) => presence.meetingId == widget.meetingId)
        .toList();
    Member? member;
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Row(
            children: [
              const Spacer(),
              ElevatedButton(
                  onPressed: () {
                    showTimePicker(
                        context: context, initialTime: TimeOfDay.now());
                  },
                  child: Text('جدبد')),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: .7),
            ),
            padding: const EdgeInsets.only(top: 12, right: 12),
            child: SizedBox(
              height: 300,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: presenceList.length,
                itemBuilder: (ctx, index) {
                  enterTimeControllers.add(TextEditingController());
                  exitTimeControllers.add(TextEditingController());
                  totalTimeControllers.add(TextEditingController());

                  //return Text('data');
                  member = ref
                      .read(membersProvider.notifier)
                      .findMember(presenceList[index].memberId);
                  return Column(
                    children: [
                      ListTile(
                        title: Row(
                          children: [
                            member == null
                                ? Container()
                                : Text(" ${member!.name} ${member!.family}"),
                          ],
                        ),
                        trailing: Wrap(
                          children: [
                            SizedBox(
                              width: 80,
                              child: TextField(
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
                                  enterList.add( await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  ));
                                  if (enterList[index] != null) {
                                    setState(() {
                                      presenceList[index].enter =
                                          "${enterList[index]!.hour}:${enterList[index]!.minute}";
                                      enterTimeControllers[index]
                                          .text = presenceList[
                                              index]
                                          .enter;
                                      //set the value of text field.
                                      if (enterList[index] != null &&
                                          exitList[index] != null
                                      ) {

                                        totalTimeControllers[index].text = calculateDuration(enterList[index], exitList[index]).toString();
                                      }
                                    });
                                  } else {
                                    print("aارور");
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            SizedBox(
                              width: 40,
                              child: TextField(
                                controller: exitTimeControllers[index],
                                //editing controller of this TextField
                                decoration: const InputDecoration(
                                    //icon: Icon(Icons.timer), //icon of text field
                                    labelText: "خروج" //label text of field
                                    ),
                                readOnly: true,
                                //set it true, so that user will not able to edit text
                                onTap: () async {
                                  exitList.add(  await showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  ));
                                  print('after timepickerr');
                                  if (exitList[index]!= null) {
                                    print('in if');
                                    setState(() {
                                      presenceList[index].exit =
                                          "${exitList[index]!.hour}:${exitList[index]!.minute}";
                                      exitTimeControllers[index]
                                          .text = presenceList[
                                              index]
                                          .exit;
                                      if (enterList[index] != null &&
                                          exitList[index] != null
                                      ) {

                                        totalTimeControllers[index].text = calculateDuration(enterList[index], exitList[index]).toString();
                                      }
                                    });
                                  } else {
                                    print("ارور");
                                  }
                                },
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                              width: 40,
                              child: TextField(
                                enabled: false,
                                controller: totalTimeControllers[index],
                                //editing controller of this TextField
                                decoration: const InputDecoration(
                                    //icon: Icon(Icons.timer), //icon of text field
                                    labelText: "کل" //label text of field
                                    ),
                                readOnly: true,
                                //set it true, so that user will not able to edit text
                              ),
                            ),
                            //             IconButton(onPressed: (){}, icon: Icon(Icons.check,color: Colors.greenAccent,),)
                          ],
                        ),
                      ),
                      Divider(),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
int calculateDuration(TimeOfDay? start, TimeOfDay? end){
  int subMin = end!.minute - start!.minute;
  int subHour = end.hour - start.hour;
  if(subMin<0){
    subHour--;
    subMin = 60 + subMin;
  }
  if(subHour<0) return 0;
  int duration = (subHour*60 + subMin);
  return duration;
}
