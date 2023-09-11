import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:misaghe_noor/Screens/authentication.dart';
import 'package:misaghe_noor/models/member.dart';
import 'package:misaghe_noor/provider/members_provider.dart';
import 'package:misaghe_noor/provider/users_provider.dart';

import '../models/user.dart';

class MemberDetailsScreen extends ConsumerStatefulWidget {
  const MemberDetailsScreen(
      {super.key, required this.isEdit, required this.memberId});

  final bool isEdit;
  final String memberId;

  @override
  ConsumerState<MemberDetailsScreen> createState() =>
      _MemberDetailsScreenState();
}

class _MemberDetailsScreenState extends ConsumerState<MemberDetailsScreen> {
  Member? member;
  var isSending = false;
  final _form = GlobalKey<FormState>();
  var inputName = '';
  var inputFamily = '';
  var inputFather = '';
  var inputMeli = '';
  var inputShShenasname = '';
  var inputPhone = '';
  var inputMobile = '';
  var inputAddress = '';
  User? lastChangedUser;

  @override
  Widget build(context) {
    var isEdit = widget.isEdit;
    if (isEdit) {
      member = ref.read(membersProvider.notifier).findMember(widget.memberId);
      lastChangedUser =
          ref.read(usersProvider.notifier).findUser(member!.lastChangeUsreId!);
    }
    void Submit() async {
      if (_form.currentState!.validate()) {
        setState(() {
          isSending = true;
        });
        _form.currentState!.save();
        Object myBody = json.encode(
          {
            'name': inputName,
            'family': inputFamily,
            'fatherName': inputFather,
            'meliNumber': inputMeli,
            'shenasnameNumber': inputShShenasname,
            'address': inputAddress,
            'phone': inputPhone,
            'mobile': inputMobile,
            'lastChangeUsreId': enteredUserId,
          },
        );
        final memberId;
        if (isEdit) {
          final url = Uri.https(
              'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
              'members-list/${member?.id}.json');
          http.patch(url, body: myBody);
          memberId = member?.id;
          ref.read(membersProvider.notifier).removeMember(member!);
        } else {
          final url = Uri.https(
              'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
              'members-list.json');
          final response = await http.post(
            url,
            headers: {'Content-Type': 'application/json'},
            body: myBody,
          );
          print(response.statusCode);
          print(response.body);
          print(response.headers);
          final Map<String, dynamic> resData = json.decode(response.body);
          memberId = resData['name'];
        }
        ref.read(membersProvider.notifier).addMember(
              Member(
                  id: memberId,
                  name: inputName,
                  family: inputFamily,
                  fatherName: inputFather,
                  meliNumber: inputMeli,
                  shenasnameNumber: inputShShenasname,
                  address: inputAddress,
                  phone: inputPhone,
                  mobile: inputMobile,
                  lastChangeUsreId: enteredUserId),
            );
        Navigator.of(context).pop();
      }
    }

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
        child: Form(
          key: _form,
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: isEdit ? member?.name : '',
                        decoration: const InputDecoration(
                          label: Text('نام'),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) return "لطفا نام را وارد کنید";
                          return null;
                        },
                        onSaved: (value) => inputName = value!,
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: isEdit ? member?.family : '',
                        decoration: const InputDecoration(
                          label: Text('نام خانوادگی'),
                        ),
                        validator: (value) {
                          if (value!.isEmpty)
                            return "لطفا نام خانوادگی را وارد کنید";
                          return null;
                        },
                        onSaved: (value) => inputFamily = value!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  width: 160,
                  child: TextFormField(
                    initialValue: isEdit ? member?.fatherName : '',
                    decoration: const InputDecoration(
                      label: Text('نام پدر'),
                    ),
                    validator: (value) {
                      if (value!.isEmpty) return "لطفا نام پدر را وارد کنید";
                      return null;
                    },
                    onSaved: (value) => inputFather = value!,
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: isEdit ? member?.meliNumber : '',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('کد ملی'),
                        ),
                        onSaved: (value) => inputMeli = value!,
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: isEdit ? member?.shenasnameNumber : '',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('شماره شناسنامه'),
                        ),
                        onSaved: (value) => inputShShenasname = value!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: isEdit ? member?.phone : '',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('شماره تلفن'),
                        ),
                        onSaved: (value) => inputPhone = value!,
                      ),
                    ),
                    const SizedBox(
                      width: 24,
                    ),
                    Expanded(
                      child: TextFormField(
                        initialValue: isEdit ? member?.mobile : '',
                        keyboardType: TextInputType.number,
                        decoration: const InputDecoration(
                          label: Text('شماره همراه'),
                        ),
                        onSaved: (value) => inputMobile = value!,
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                  child: TextFormField(
                    initialValue: isEdit ? member?.address : '',
                    decoration: const InputDecoration(
                      label: Text('آدرس'),
                    ),
                    onSaved: (value) => inputAddress = value!,
                  ),
                ),
                // SizedBox(height: 24,),
                Expanded(
                  child: Row(
                    children: [
                      ElevatedButton(
                          onPressed: () =>
                              isSending ? null : Navigator.of(context).pop(),
                          child: const Text('لغو')),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: isSending
                            ? null
                            : () {
                                Submit();
                              },
                        child: const Text('ذخیره'),
                      ),
                      isEdit
                          ? lastChangedUser!.id.isEmpty
                              ? SizedBox(
                                  width: 1,
                                )
                              : Text(
                                  ' آخرین تغییر توسط ${lastChangedUser!.name} ${lastChangedUser!.family}')
                          : SizedBox(
                              width: 1,
                            ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
