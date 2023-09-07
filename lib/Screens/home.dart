import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:misaghe_noor/Screens/meetings.dart';
import 'package:misaghe_noor/Screens/members.dart';
import 'package:misaghe_noor/data/dummy_activity.dart';
import 'package:misaghe_noor/data/dummy_meeting.dart';
import 'package:misaghe_noor/data/dummy_presence.dart';

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

  void savePresence() async {
    final url = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'presences-list.json');
    for (var presence in dummyPresence) {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'meetingId': presence.meetingId,
            'memberId': presence.memberId,
            'time': presence.time,
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const MeetingsScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(102, 206, 203, 203),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 188, 148, 84)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                    child: const Text(
                      'جلسات',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'IranYekan',
                      ),
                    ),
                  ),
                ),
                const Divider(height: 36),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (ctx) => const MembersScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(102, 206, 203, 203),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 188, 148, 84)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                    child: const Text(
                      'اعضا',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'IranYekan',
                      ),
                    ),
                  ),
                ),
                const Divider(height: 36),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(102, 206, 203, 203),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 188, 148, 84)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                    child: const Text(
                      'گزارشات',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'IranYekan',
                      ),
                    ),
                  ),
                ),
                const Divider(height: 36),
                SizedBox(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton(
                    onPressed: savePresence,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(102, 206, 203, 203),
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                            color: Color.fromARGB(255, 188, 148, 84)),
                        borderRadius: BorderRadius.all(
                          Radius.circular(50),
                        ),
                      ),
                    ),
                    child: const Text(
                      'کاربران',
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'IranYekan',
                      ),
                    ),
                  ),
                ),
                const Divider(height: 65),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
