import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:misaghe_noor/provider/activity_provider.dart';

import '../models/activity.dart';

class NewActivityScreen extends ConsumerStatefulWidget {
  NewActivityScreen({super.key});

  @override
  ConsumerState<NewActivityScreen> createState() => _NewActivityScreenState();
}

class _NewActivityScreenState extends ConsumerState<NewActivityScreen> {
  List<Activity> activityList = [];
  var textController = TextEditingController();
  String userId = '';

  void _saving() async {
    if (textController.text.trim().isNotEmpty) {
      final url = Uri.https(
          'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
          'activities-list.json');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': textController.text.trim(),
          },
        ),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      userId = resData['name'];
      ref.read(activityProvider.notifier).addActivity(
            Activity(
              id: userId,
              name: textController.text.trim(),
            ),
          );
      textController.text = '';
    }
  }

  @override
  Widget build(context) {
    activityList = ref.watch(activityProvider).reversed.toList();
    return Scaffold(
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
                  child: Icon(Icons.add),
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                  ),
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
                                showDialog(
                                  context: context,
                                  builder: (context) => Directionality(
                                    textDirection: TextDirection.rtl,
                                    child: AlertDialog(
                                      content: Text('فعالیت حذف شود؟'),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              final url = Uri.https(
                                                  'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
                                                  'activities-list/${activityList[index].id}.json');
                                              http.delete(url);
                                              ref
                                                  .read(
                                                      activityProvider.notifier)
                                                  .removeActivity(
                                                      activityList[index]);
                                              /*activityList
                                                  .remove(activityList[index]);*/
                                              Navigator.pop(context);
                                            },
                                            child: Text('بله')),
                                        TextButton(
                                            onPressed: () =>
                                                Navigator.pop(context),
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
            ),
          ),
        ]),
      ),
    );
  }
}
