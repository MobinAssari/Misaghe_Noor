import 'package:misaghe_noor/models/activity.dart';
import 'package:misaghe_noor/models/presence.dart';
import 'package:misaghe_noor/models/user.dart';
import '../models/meeting.dart';
import '../models/member.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Presence, User;

class ConnectToDataBase {
  final SupabaseClient supabase = Supabase.instance.client;

  final dataBaseUrl =
      'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app';

  Future<List<Member>> loadMember() async {
    List<Member> list = [];
    try {
      final future =
          await supabase.from('member').select().order('id', ascending: true);
      print(future.toString());
      for (var item in future) {
        list.add(Member.fromJson(item));
      }
      return list;
    } catch (e) {
      print(e.toString());
    }
    return list;

    /* final url = Uri.https(dataBaseUrl, 'members-list.json');
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
          lastChangeUserId: item.value['lastChangeUsreId'],
        ),
      );
    }
    return loadedItems;*/
  }

  Future<List<Meeting>> loadMeeting() async {
    List<Meeting> list = [];
    try {
      final future = await supabase
          .from('meeting')
          .select()
          .order('id', ascending: true) as List<dynamic>;
      print(future.toString());
      list = future.map<Meeting>((e) => Meeting.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
    }
    return list;

    /*final meetingUrl = Uri.https(dataBaseUrl, 'meetings-list.json');
    final meetingResponse = await http.get(meetingUrl);
    if (meetingResponse.body == 'null') {
      return Future.error('error');
    }
    final Map<String, dynamic> meetingListData =
        json.decode(meetingResponse.body);
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
    return loadedMeetings;*/
  }

  void patchMember(Member member) async {
    await supabase.from('member').upsert({
      'id' : member.id,
      'name': member.name,
      'family': member.family,
      'fatherName': member.fatherName,
      'meliNumber': member.meliNumber,
      'shenasnameNumber': member.shenasnameNumber,
      'address': member.address,
      'phone': member.phone,
      'mobile': member.mobile,
      'lastChangedUserId': member.lastChangedUserId,
    });
    /*final url = Uri.https(dataBaseUrl, 'members-list/${member?.id}.json');
    final response = http.patch(url,
        body: json.encode(
          {
            'name': member.name,
            'family': member.family,
            'fatherName': member.fatherName,
            'meliNumber': member.meliNumber,
            'shenasnameNumber': member.shenasnameNumber,
            'address': member.address,
            'phone': member.phone,
            'mobile': member.mobile,
            'lastChangeUsreId': member.lastChangeUserId,
          },
        ));
    return response;*/
  }

  Future<String> postMember(Member member) async {
    final response = await supabase.from('member').insert({
      'name': member.name,
      'family': member.family,
      'fatherName': member.fatherName,
      'meliNumber': member.meliNumber,
      'shenasnameNumber': member.shenasnameNumber,
      'address': member.address,
      'phone': member.phone,
      'mobile': member.mobile,
    }).select();
    return response[0]['id'];

    //return response;
    /*final url = Uri.https(dataBaseUrl, 'members-list.json');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          'name': member.name,
          'family': member.family,
          'fatherName': member.fatherName,
          'meliNumber': member.meliNumber,
          'shenasnameNumber': member.shenasnameNumber,
          'address': member.address,
          'phone': member.phone,
          'mobile': member.mobile,
          'lastChangeUsreId': member.lastChangeUserId,
        },
      ),
    );
    return response;*/
  }

  void patchPresence(Presence presence) async {
    supabase.from('presence').upsert({
      'id' : presence.id,
      'meetingId': presence.meetingId,
      'memberId': presence.meetingId,
      'time': presence.time,
      'enter': presence.enter,
      'exit': presence.exit,
    });
    /*final url = Uri.https(dataBaseUrl, 'members-list/${presence.id}.json');
    final response = http.patch(
      url,
      body: json.encode(
        {
          'meetingId': presence.meetingId,
          'memberId': presence.meetingId,
          'time': presence.time,
          'enter': presence.enter,
          'exit': presence.exit,
        },
      ),
    );
    return response;*/
  }

  Future<String> postPresence(Presence presence) async {
    final response = await supabase.from('presence').insert({
      'meetingId': presence.meetingId,
      'memberId': presence.memberId,
      'time': presence.time,
      'enter': presence.enter,
      'exit': presence.exit,
    }).select();
    return response[0][
        'id']; /* final url = Uri.https(dataBaseUrl, 'presences-list.json');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          'meetingId': presence.meetingId,
          'memberId': presence.meetingId,
          'time': presence.time,
          'enter': presence.enter,
          'exit': presence.exit,
        },
      ),
    );
    return response;*/
  }

  void patchMeeting(Meeting meeting) async {
    supabase.from('meeting').upsert({
      'id' : meeting.id,
      'date': meeting.date.toString(),
      'description': meeting.description,
      'lastChangeUserId': meeting.lastChangeUserId,
      'activityName': meeting.activityName,
    });
   /* final url = Uri.https(dataBaseUrl, 'meetings-list/${meeting?.id}.json');
    final response = await http.patch(
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
    return response;*/
  }

  Future<String> postMeeting(Meeting meeting) async {
    final response = await supabase.from('meeting').insert({
      'date': meeting.date.toString(),
      'description': meeting.description,
      'lastChangedUserId': meeting.lastChangeUserId,
      'activityName': meeting.activityName,
    }).select();
    return response[0][
        'id']; /*final url = Uri.https(dataBaseUrl, 'meetings-list.json');
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
    return response;*/
  }

  Future<List<Presence>> loadPresence() async {
    List<Presence> list = [];
    try {
      final future =
          await supabase.from('presence').select().order('id', ascending: true);
      list = future.map<Presence>((e) => Presence.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
    }
    return list;
    /*final presenceUrl = Uri.https(dataBaseUrl, 'presences-list.json');
    final presenceResponse = await http.get(presenceUrl);
    if (presenceResponse.body == 'null') {
      return Future.error('error');
    }
    final Map<String, dynamic> presenceListData =
        json.decode(presenceResponse.body);
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
    return loadedPresences;*/
  }

  Future<List<dynamic>> loadUser() async {
    List<User> list = [];
    try {
      final future =
          await supabase.from('user').select().order('id', ascending: true);
      list = future.map<User>((e) => User.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
    }
    return list;

    /*final url = Uri.https(dataBaseUrl, 'users-list.json');
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
    return loadedItems;*/
  }

  Future<String> postActivity(String activityName) async {
    var response = await supabase.from('activity').insert({
      'name': activityName,
    }).select();
    return response[0]['id'];

    /*final url = Uri.https(dataBaseUrl, 'activities-list.json');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode(
        {
          'name': activityName,
        },
      ),
    );

    return response;*/
  }

  Future<List<Activity>> loadActivity() async {
    List<Activity> list = [];
    try {
      final future =
          await supabase.from('activity').select().order('id', ascending: true);
      print(future.toString());
      list = future.map<Activity>((e) => Activity.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
    }
    return list;
    /* final url = Uri.https(dataBaseUrl, 'activities-list.json');
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
    return loadedItems;*/
  }

  void removeActivity(String activityId) async {
    await supabase.from('activity').delete().match({'id' : activityId});
    /*final url = Uri.https(dataBaseUrl, 'activities-list/$activityId.json');
    final response = http.delete(url);
    return response;*/
  }
  void removeMember(String id) async {
    await supabase.from('member').delete().match({'id' : id});}
}

ConnectToDataBase connectToDataBase = ConnectToDataBase();
