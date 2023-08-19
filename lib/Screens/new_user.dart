import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:misaghe_noor/data/dummy_user.dart';
import 'package:misaghe_noor/models/member.dart';
import 'package:misaghe_noor/provider/members_provider.dart';

class NewMemberScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<NewMemberScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends ConsumerState<NewMemberScreen> {
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

  @override
  Widget build(context) {
    void Submit() async {
      if (_form.currentState!.validate()) {
        setState(() {
          isSending = true;
        });
        _form.currentState!.save();
        final url = Uri.https(
            'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
            'members-list.json');
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(
            {
              'name': inputName,
              'family': inputFamily,
              'fatherName': inputFather,
              'meliNumber': inputMeli,
              'shenasnameNumber': inputShShenasname,
              'address': inputAddress,
              'phone': inputPhone,
              'mobile': inputMobile,
              'lastChangeUsreId': dummyUser[0].id,
            },
          ),
        );
        final Map<String, dynamic> resData = json.decode(response.body);
        ref.read(membersProvider.notifier).addMember(Member(
            id: resData['name'],
            name: inputName,
            family: inputFamily,
            fatherName: inputFather,
            meliNumber: inputMeli,
            shenasnameNumber: inputShShenasname,
            address: inputAddress,
            phone: inputPhone,
            mobile: inputMobile,
            lastChangeUsreId: dummyUser[0].id));
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
                          onPressed: () => isSending ? null :  Navigator.of(context).pop(),
                          child: const Text('لغو')),
                      const SizedBox(
                        width: 8,
                      ),
                      ElevatedButton(
                        onPressed: isSending ? null: () {
                          Submit();
                        },
                        child: const Text('ذخیره'),
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
