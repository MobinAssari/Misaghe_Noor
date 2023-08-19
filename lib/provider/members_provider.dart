import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/data/dummy_member.dart';
import 'package:misaghe_noor/models/member.dart';

class MemberNotifier extends StateNotifier<List<Member>> {
  MemberNotifier() : super([]);

  void addMembers(List<Member> memberList) {
    state = [...memberList];
  }
  void addMember(Member member) {
    state = [...state, member];
  }

  void removeMember(Member member) {
    state = state.where((m) => m.id != member.id).toList();
  }
}
final membersProvider =
StateNotifierProvider<MemberNotifier, List<Member>>((ref) {
  return MemberNotifier();
});
