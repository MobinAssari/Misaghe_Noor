import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/provider/members_provider.dart';

import '../data/dummy_presence.dart';

class PresenceItem extends ConsumerWidget {
  const PresenceItem({super.key, required this.isEdit});

  final bool isEdit;

  @override
  Widget build(context, ref) {
    var member;
    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          Row(
            children: [
              Spacer(),
              ElevatedButton(onPressed: () {}, child: Text('جدبد')),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              border: Border.all(width: .7),
            ),
            padding: const EdgeInsets.all(12),
            child: Expanded(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: dummyPresence.length,
                  itemBuilder: (ctx, index) {
                    //return Text('data');
                     member = ref
                        .read(membersProvider.notifier)
                        .findMember(dummyPresence[index].memberId);
                    return ListTile(
                      title: Row(
                        children: [
                          member==null ? Container() : Text(" ${member!.name} ${member.family}"),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
