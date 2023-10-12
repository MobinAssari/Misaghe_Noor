import 'package:misaghe_noor/models/activity.dart';
import 'package:misaghe_noor/models/presence.dart';
import 'package:misaghe_noor/models/user.dart';
import '../models/meeting.dart';
import '../models/member.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide Presence, User;

class ConnectToDataBase {
  final SupabaseClient supabase = Supabase.instance.client;

  Future<List<Member>> loadMember() async {
    List<Member> list = [];
    try {
      final future =
          await supabase.from('member').select().order('id', ascending: true);
      for (var item in future) {
        list.add(Member.fromJson(item));
      }
      return list;
    } catch (e) {
      print(e.toString());
    }
    return list;
  }

  Future<List<Meeting>> loadMeeting() async {
    List<Meeting> list = [];
    try {
      final future = await supabase
          .from('meeting')
          .select()
          .order('id', ascending: true) as List<dynamic>;
      list = future.map<Meeting>((e) => Meeting.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
    }
    return list;
  }

  void patchMember(Member member) async {
    await supabase.from('member').upsert({
      'id': member.id,
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
  }

  void patchPresence(Presence presence) async {
    supabase.from('presence').upsert({
      'id': presence.id,
      'meetingId': presence.meetingId,
      'memberId': presence.meetingId,
      'time': presence.time,
      'enter': presence.enter,
      'exit': presence.exit,
    });
  }

  Future<String> postPresence(Presence presence) async {
    final response = await supabase.from('presence').insert({
      'meetingId': presence.meetingId,
      'memberId': presence.memberId,
      'time': presence.time,
      'enter': presence.enter,
      'exit': presence.exit,
    }).select();
    return response[0]['id'];
  }

  void updateMeeting(Meeting meeting) async {
    await supabase.from('meeting').upsert({
      'id': meeting.id,
      'activityName': meeting.activityName,
      'date': meeting.date.toString(),
      'description': meeting.description,
      'lastChangedUserId': meeting.lastChangedUserId,
    });
  }

  Future<String> postMeeting(Meeting meeting) async {
    final response = await supabase.from('meeting').insert({
      'date': meeting.date.toString(),
      'description': meeting.description,
      'lastChangedUserId': meeting.lastChangedUserId,
      'activityName': meeting.activityName,
    }).select();
    return response[0]['id'];
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
  }

  Future<String> postActivity(String activityName) async {
    var response = await supabase.from('activity').insert({
      'name': activityName,
    }).select();
    return response[0]['id'];
  }

  Future<List<Activity>> loadActivity() async {
    List<Activity> list = [];
    try {
      final future =
          await supabase.from('activity').select().order('id', ascending: true);
      list = future.map<Activity>((e) => Activity.fromJson(e)).toList();
    } catch (e) {
      print(e.toString());
    }
    return list;
  }

  void removeActivity(String activityId) async {
    await supabase.from('activity').delete().match({'id': activityId});
  }

  void removeMember(String id) async {
    await supabase.from('member').delete().match({'id': id});
  }
}

ConnectToDataBase connectToDataBase = ConnectToDataBase();
