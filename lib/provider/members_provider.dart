import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  Member? findMember(String id){
    for(var member in state){
      if(member.id == id) return member;
    }
    return null;
  }
}
final membersProvider =
StateNotifierProvider<MemberNotifier, List<Member>>((ref) {
  return MemberNotifier();
});
