import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/models/meeting.dart';

class MeetingNotifier extends StateNotifier<List<Meeting>> {
  MeetingNotifier() : super([]);

  void addMeetings(List<Meeting> meetingList) {
    state = [...meetingList];
  }
  void addMeeting(Meeting meeting) {
    state = [...state, meeting];
  }

  void removeMeeting(Meeting meeting) {
    state = state.where((m) => m.id != meeting.id).toList();
  }
  Meeting? findMeeting(String id){
    for(var meeting in state){
      if(meeting.id == id) return meeting;
    }
    return null;
  }
}
final meetingsProvider =
StateNotifierProvider<MeetingNotifier, List<Meeting>>((ref) {
  return MeetingNotifier();
});
