import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:misaghe_noor/models/activity.dart';
import 'package:misaghe_noor/models/presence.dart';
import 'package:misaghe_noor/models/user.dart';

import '../models/meeting.dart';
import '../models/member.dart';

class LoadingFromFirebase {
  Future<List<Member>> loadMember() async {
    final url = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'members-list.json');
    final response = await http.get(url);
    if (response.body == 'null') {
      return Future.error('error');
    }
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<Member> loadedItems = [];
    for (final item in listData.entries) {
      loadedItems.add(
        Member(
          id: item.key,
          name: item.value['name'],
          family: item.value['family'],
          fatherName: item.value['fatherName'],
          meliNumber: item.value['meliNumber'],
          shenasnameNumber: item.value['shenasnameNumber'],
          address: item.value['address'],
          phone: item.value['phone'],
          mobile: item.value['mobile'],
          lastChangeUsreId: item.value['lastChangeUsreId'],
        ),
      );
    }
    return loadedItems;
  }


  Future<List<Meeting>> loadMeeting() async {
    final meetingUrl = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'meetings-list.json');
    final meetingResponse = await http.get(meetingUrl);
    if (meetingResponse.body == 'null') {
      return Future.error('error');
    }
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
    }
    return loadedMeetings;
  }

  Future<List<Activity>> loadActivity() async {
    final url = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'activities-list.json');
    final response = await http.get(url);
    if (response.body == 'null') {
      return Future.error('error');
    }
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<Activity> loadedItems = [];
    for (final item in listData.entries) {
      loadedItems.add(
        Activity(
          id: item.key,
          name: item.value['name'],
        ),
      );
    }
    return loadedItems;
  }

  Future<List<Presence>> loadPresence() async {
    final presenceUrl = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'presences-list.json');
    final presenceResponse = await http.get(presenceUrl);
    if (presenceResponse.body == 'null') {
      return Future.error('error');
    }
    final Map<String, dynamic> presenceListData = json.decode(presenceResponse.body);
    final List<Presence> loadedPresences = [];
    for (final item in presenceListData.entries) {
      loadedPresences.add(
        Presence(
          id: item.key,
          meetingId: item.value['meetingId'],
          memberId: item.value['memberId'],
          time: item.value['time'],
          enter: item.value['enter'],
          exit: item.value['exit'],
        ),
      );
    }
    return loadedPresences;
  }


  Future<List<User>> loadUser() async {
    final url = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'users-list.json');
    final response = await http.get(url);
    if (response.body == 'null') {
      return Future.error('error');
    }
    final Map<String, dynamic> listData = json.decode(response.body);
    final List<User> loadedItems = [];
    for (final item in listData.entries) {
      loadedItems.add(
        User(
            id: item.key,
            name: item.value['name'],
            family: item.value['family'],
            userName: item.value['userName'],
            password: item.value['password'],
            isAdmin: item.value['isAdmin']),
      );
    }
    return loadedItems;

  }
}
