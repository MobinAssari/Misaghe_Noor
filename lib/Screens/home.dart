import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:misaghe_noor/Screens/meetings.dart';
import 'package:misaghe_noor/Screens/members.dart';
import 'package:misaghe_noor/data/dummy_activity.dart';
import 'package:misaghe_noor/data/dummy_meeting.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void saveMeeting() async {
    final url = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'meetings-list.json');
    for (var meeting in dummyMeeting) {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
        {
            'date': meeting.date.toString(),
            'description': meeting.description,
            'lastChangeUserId': meeting.lastChangeUserId,
            'activityName': meeting.activityName,
        },
        ),
      );

      print(response.body);
    }
  }
  void saveActivity() async {
    final url = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'activities-list.json');
    for (var activity in dummyActivity) {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': activity.name,
          },
        ),
      );

      print(response.body);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/wallpaper6.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  height: 70,
                  width: 300,
                  child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (ctx) => const MeetingsScreen(),
                          ),
                        );
                      },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          const Color.fromARGB(194, 206, 203, 203),),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(50)),
                        ),
                      ),
                    ),
                    child: const Text('جلسات'),
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => MembersScreen(),
                        ),
                      );
                    },
                    child: const Text('اعضا'),
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('گزارشات'),
                  ),
                ),
                SizedBox(
                  height: 70,
                  width: 250,
                  child: ElevatedButton(
                    onPressed: saveActivity,
                    child: const Text('؟؟'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
