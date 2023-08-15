import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/data/dummy_activity.dart';
import 'package:misaghe_noor/models/activity.dart';

class ActivityNotifier extends StateNotifier<List<Activity>> {
  ActivityNotifier() : super(dummyActivity);

  void addMember(Activity activity) {
    state = [...state, activity];
  }

  void removeMember(Activity activity) {
    state = state.where((m) => m.id != activity.id).toList();
  }
}
final activityProvider =
StateNotifierProvider<ActivityNotifier, List<Activity>>((ref) {
  return ActivityNotifier();
});
