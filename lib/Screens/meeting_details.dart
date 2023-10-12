import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:misaghe_noor/Screens/authentication.dart';
import 'package:misaghe_noor/helper/ConnectToDataBase.dart';
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
  bool _isSaving = false;
  bool _isLoading = true;
  Meeting? meeting;
  User? lastChangedUser;
  String inputActivity = '';
  List<Activity> activityList = [];
  String dropdownValue = '';
  var descriptionController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    _loadItem();

    if (widget.isEdit) {
      meeting =
          ref.read(meetingsProvider.notifier).findMeeting(widget.meetingId);
      descriptionController.text = meeting!.description!;
      inputActivity = meeting!.activityName!;
    }
    super.initState();
  }

  void _loadItem() async {
    activityList = await ref.read(activityProvider);
    dropdownValue = activityList.first.name;
    inputActivity = dropdownValue;
    setState(
      () {
        _isLoading = false;
      },
    );
  }

  DateTime? _selectedDate;
  late String meetingId;

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
      meeting!.date = _selectedDate.toString();
    }
  }

  void _saving() async {
    if (inputActivity.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        _selectedDate != null) {
      setState(() {
        _isSaving = true;
      });
      if (widget.isEdit) {
        connectToDataBase.updateMeeting(Meeting(
            id: meeting!.id,
            activityName: inputActivity,
            date: _selectedDate.toString(),
            description: descriptionController.text,
            lastChangedUserId: enteredUserId));
        ref.read(meetingsProvider.notifier).removeMeeting(meeting!);
        meetingId = meeting!.id;
      } else {
        meetingId = await connectToDataBase.postMeeting(Meeting(
            id: '',
            activityName: inputActivity,
            date: _selectedDate.toString(),
            description: descriptionController.text,
            lastChangedUserId: enteredUserId));
      }

      ref.read(meetingsProvider.notifier).addMeeting(Meeting(
          id: meetingId,
          activityName: inputActivity,
          date: _selectedDate.toString(),
          description: descriptionController.text,
          lastChangedUserId: enteredUserId));
      Navigator.of(context).pop();
    } else {}
  }

  @override
  Widget build(context) {
    activityList = ref.watch(activityProvider);
    List<String> activityNameList = activityList.map((e) => e.name).toList();
    var isEdit = widget.isEdit;

    if (isEdit) {
      if (!activityNameList.contains(meeting!.activityName)) {
        activityList.add(Activity(id: '', name: meeting!.activityName!));
        ref
            .read(activityProvider.notifier)
            .addActivity(Activity(id: '', name: meeting!.activityName!));
      }
      dropdownValue = meeting!.activityName!;

      _selectedDate = DateTime.tryParse(meeting!.date!);

      lastChangedUser = ref
          .read(usersProvider.notifier)
          .findUser(meeting!.lastChangedUserId!);
    }

    if (_isLoading) {
      return const Scaffold(
          body: Center(
        child: CircularProgressIndicator(),
      ));
    } else {
      return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('جزئیات جلسه'),
          ),
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
                        Flexible(
                          child: DropdownButton(
                              isExpanded: true,
                              value: dropdownValue,
                              items: activityList
                                  .map((e) => e.name)
                                  .toList()
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
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
                        ),
                        IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                    MaterialPageRoute(
                                      builder: (ctx) => NewActivityScreen(),
                                    ),
                                  )
                                  .then((_) => setState(() async {
                                        _isLoading = true;
                                        _loadItem();
                                      }));
                            },
                            icon: const Icon(Icons.add)),
                        const SizedBox(
                          width: 50,
                        ),
                        IconButton(
                            onPressed: _showDatePicker,
                            icon: const Icon(Icons.calendar_month_outlined)),
                        Text(
                          _selectedDate == null
                              ? 'تاریخ را انتخاب کنید'
                              : '${_selectedDate!.year}/${_selectedDate!.month}/${_selectedDate!.day}',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'توضیحات جلسه'),
                      //initialValue: isEdit ? meeting?.description : '',
                      controller: descriptionController,
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: _isSaving ? () {} : _saving,
                          child: _isSaving
                              ? const SizedBox(
                                  height: 50.0,
                                  width: 50.0,
                                  child: Center(
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    ),
                                  ),
                                )
                              : const Text('ذخیره'),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }
  }
}
