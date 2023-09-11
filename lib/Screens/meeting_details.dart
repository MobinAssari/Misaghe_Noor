import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart' as intl;
import 'package:http/http.dart' as http;
import 'package:misaghe_noor/Screens/authentication.dart';
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
    super.initState();
    _loadItem();

    if (widget.isEdit) {

      meeting =
          ref.read(meetingsProvider.notifier).findMeeting(widget.meetingId);
      descriptionController.text = meeting!.description;
      inputActivity = meeting!.activityName;


    } else {
      _isLoading = false;
    }
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
          meeting!.date = _selectedDate.toString();
        },
      );
    }
  }

  bool isSaving = false;

  void _saving() async {
    if (inputActivity.isNotEmpty &&
        descriptionController.text.isNotEmpty &&
        _selectedDate != null) {
      setState(() {
        isSaving = true;
      });
      if (widget.isEdit) {
        final url = Uri.https(
            'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
            'meetings-list/${meeting?.id}.json');
        final response = await http.patch(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {
              'date': _selectedDate.toString(),
              'description': descriptionController.text,
              'lastChangeUserId': enteredUserId,
              'activityName': inputActivity,
            },
          ),
        );
        ref.read(meetingsProvider.notifier).removeMeeting(meeting!);
        meetingId = meeting!.id;
      } else {
        final url = Uri.https(
            'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
            'meetings-list.json');

        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {
              'date': _selectedDate.toString(),
              'description': descriptionController.text,
              'lastChangeUserId': enteredUserId,
              'activityName': inputActivity,
            },
          ),

        );print(response.statusCode);
        final Map<String, dynamic> resData = json.decode(response.body);
        meetingId = resData['name'];
      }

      ref.read(meetingsProvider.notifier).addMeeting(Meeting(
          id: meetingId,
          activityName: inputActivity,
          date: _selectedDate.toString(),
          description: descriptionController.text,
          lastChangeUserId: enteredUserId));
      Navigator.of(context).pop();
    } else {}
  }

  @override
  Widget build(context) {
    activityList = ref.watch(activityProvider);
    var isEdit = widget.isEdit;

    if (isEdit) {
      _selectedDate = DateTime.tryParse(meeting!.date);

      lastChangedUser =
          ref.read(usersProvider.notifier).findUser(meeting!.lastChangeUserId);
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
                        DropdownButton(
                            value: dropdownValue,
                            items: activityList
                                .map((e) => e.name)
                                .toList()
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
                    SizedBox(height: 8,),
                    TextFormField(

                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),labelText: 'توضیحات جلسه'),
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
                            onPressed: _saving, child: const Text('ذخیره'),),
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
