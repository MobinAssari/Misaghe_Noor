import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/models/meeting.dart';

import '../models/presence.dart';

class PresenceNotifier extends StateNotifier<List<Presence>> {
  PresenceNotifier() : super([]);

  void addPresences(List<Presence> presenceList) {
    state = [...presenceList];
  }
  void addPresence(Presence presence) {
    state = [...state, presence];
  }

  void removePresence(Presence presence) {
    state = state.where((m) => m.id != presence.id).toList();
  }
  Presence? findPresence(String id){
    for(var presence in state){
      if(presence.id == id) return presence;
    }
    return null;
  }
}
final presencesProvider =
StateNotifierProvider<PresenceNotifier, List<Presence>>((ref) {
  return PresenceNotifier();
});
