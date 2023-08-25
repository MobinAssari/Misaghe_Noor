import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/data/dummy_activity.dart';
import 'package:misaghe_noor/models/activity.dart';

class ActivityNotifier extends StateNotifier<List<Activity>> {
  ActivityNotifier() : super([]);

  void addActivities(List<Activity> activityList) {
    state = [...activityList];
  }
  void addActivity(Activity activity) {
    state = [...state, activity];
  }

  void removeActivity(Activity activity) {
    state = state.where((m) => m.id != activity.id).toList();
  }
}
final activityProvider =
StateNotifierProvider<ActivityNotifier, List<Activity>>((ref) {
  return ActivityNotifier();
});
