import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/provider/members_provider.dart';

class PresenceItem extends ConsumerWidget{
  const PresenceItem({super.key, required this.memberId});
  final String memberId;


  @override
  Widget build(context, ref) {
    final member = ref.read(membersProvider.notifier).findMember(memberId);
    return Container(padding: EdgeInsets.all(16),child: Row(children: [
      ListTile(title: Text(
          " ${member!.name} ${member.family}"),)
    ],),);
  }
}