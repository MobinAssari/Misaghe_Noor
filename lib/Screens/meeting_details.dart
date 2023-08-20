import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MeetingDetailsScreen extends ConsumerStatefulWidget{
  const MeetingDetailsScreen(
      {super.key, required this.isEdit, required this.userId});

  final bool isEdit;
  final String userId;
  @override
  ConsumerState<MeetingDetailsScreen> createState() => _MeetingDetailsScreenState();
}

class _MeetingDetailsScreenState extends ConsumerState<MeetingDetailsScreen> {
  @override
  Widget build( context) {
    return Container();
  }
}