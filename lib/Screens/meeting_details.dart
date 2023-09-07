import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:misaghe_noor/helper/loadingFromFireBase.dart';
import 'package:misaghe_noor/models/activity.dart';
import 'package:misaghe_noor/provider/activity_provider.dart';
import 'package:persian_datetime_picker/persian_datetime_picker.dart';
import '../models/meeting.dart';
import '../models/user.dart';
import '../provider/meetings_provider.dart';
import '../provider/users_provider.dart';
import 'new_activity.dart';

final formatter = intl.DateFormat.yMd();

class MeetingDetailsScreen extends ConsumerStatefulWidget {
  const MeetingDetailsScreen(
      {super.key, required this.isEdit, required this.meetingId});

  final bool isEdit;
  final String meetingId;

  @override
  ConsumerState<MeetingDetailsScreen> createState() =>
      _MeetingDetailsScreenState();
}

class _MeetingDetailsScreenState extends ConsumerState<MeetingDetailsScreen> {
  // late Activity _selectedActivity =
  bool _isLoading = true;
  Meeting? meeting;
  User? lastChangedUser;
  String inputDescription = '';
  String inputActivity = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    var loading = LoadingFromFirebase();
    final loadedItems = await loading.loadActivity();
    ref
        .read(activityProvider.notifier)
        .addActivities(loadedItems.cast<Activity>());
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  DateTime? _selectedDate;

  void _showDatePicker() async {
    var pickedDate = await showPersianDatePicker(
      context: context,
      initialDate: Jalali.now(),
      firstDate: Jalali(1400, 1),
      lastDate: Jalali(1450, 12),
    );
    if (pickedDate != null) {
      setState(
        () {
          _selectedDate =
              DateTime(pickedDate.year, pickedDate.month, pickedDate.day);
        },
      );
    }
  }
  bool isSaving = false;
  void _saving(){
    setState(() {
      isSaving = true;
    });

  }

  @override
  Widget build(context) {
    var isEdit = widget.isEdit;
    if (isEdit) {
      meeting =
          ref.read(meetingsProvider.notifier).findMeeting(widget.meetingId);
      lastChangedUser =
          ref.read(usersProvider.notifier).findUser(meeting!.lastChangeUserId);
    }

    var activityList = ref.read(activityProvider);
    List<String> activityName = [];
    for (var activity in activityList) {
      activityName.add(activity.name);
    }
    String dropdownValue = activityName.first;

    return Scaffold(
      appBar: AppBar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: Form(
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    DropdownButton(
                        value: dropdownValue,
                        items: activityName
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                            ),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(
                            () {
                              dropdownValue = newValue!;
                              inputActivity = newValue;
                            },
                          );
                        }),
                    IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .push(
                                MaterialPageRoute(
                                  builder: (ctx) => NewActivityScreen(),
                                ),
                              )
                              .then((_) => setState(() {}));
                        },
                        icon: const Icon(Icons.add)),
                    const SizedBox(
                      width: 80,
                    ),
                    IconButton(
                        onPressed: _showDatePicker,
                        icon: const Icon(Icons.calendar_month_outlined)),
                    Text(
                      _selectedDate == null
                          ? 'تاریخ جلسه'
                          : '${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}',
                    ),
                  ],
                ),
                TextFormField(initialValue: isEdit ? meeting?.description : ''),
                const SizedBox(
                  height: 8,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ElevatedButton(onPressed: () {}, child: const Text('ذخیره'))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
