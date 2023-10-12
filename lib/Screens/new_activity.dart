import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:misaghe_noor/helper/ConnectToDataBase.dart';
import 'package:misaghe_noor/provider/activity_provider.dart';
import 'package:misaghe_noor/provider/meetings_provider.dart';

import '../models/activity.dart';

class NewActivityScreen extends ConsumerStatefulWidget {
  NewActivityScreen({super.key});

  @override
  ConsumerState<NewActivityScreen> createState() => _NewActivityScreenState();
}

class _NewActivityScreenState extends ConsumerState<NewActivityScreen> {
  List<Activity> activityList = [];
  var textController = TextEditingController();
  String activityId = '';

  void _saving() async {
    if (textController.text.trim().isNotEmpty) {
      activityId = await connectToDataBase
          .postActivity(textController.text.trim()) as dynamic;
      ref.read(activityProvider.notifier).addActivity(
            Activity(
              id: activityId,
              name: textController.text.trim(),
            ),
          );
      textController.text = '';
    }
  }

  @override
  Widget build(context) {
    activityList = ref.watch(activityProvider).reversed.toList();
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title: Text('لیست فعالیت')),
        body: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                //mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 250,
                    child: TextField(
                      decoration: const InputDecoration(
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.blueAccent),
                        ),
                      ),
                      controller: textController,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: _saving,
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                    ),
                    child: const Icon(Icons.add),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              child: Expanded(
                child: ListView.builder(
                  itemCount: activityList.length,
                  itemBuilder: (ctx, index) {
                    return Column(
                      children: [
                        ListTile(
                          // leading: const Icon(Icons.supervised_user_circle),
                          title: Text(" ${activityList[index].name}"),
                          trailing: Wrap(
                            children: [
                              IconButton(
                                onPressed: () {
                                  List<String> usedActivityList = ref
                                      .read(meetingsProvider)
                                      .map((e) => e.activityName!)
                                      .toList();
                                  if (usedActivityList
                                      .contains(activityList[index].name)) {
                                    showDialog(
                                      context: context,
                                      builder: (context) =>
                                           Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: AlertDialog(
                                          content: const Text('قابل حذف نیست'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('تایید'))
                                          ],
                                        ),
                                      ),
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      builder: (context) => Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: AlertDialog(
                                          content: Text('فعالیت حذف شود؟'),
                                          actions: [
                                            TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: const Text('خیر')),
                                            TextButton(
                                                onPressed: () {
                                                  connectToDataBase
                                                      .removeActivity(
                                                          activityList[index]
                                                              .id);
                                                  ref
                                                      .read(activityProvider
                                                          .notifier)
                                                      .removeActivity(
                                                          activityList[index]);
                                                  /*activityList
                                                    .remove(activityList[index]);*/
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('بله')),

                                          ],
                                        ),
                                      ),
                                    );
                                  }
                                },
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                              ),
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
          ]),
        ),
      ),
    );
  }
}
