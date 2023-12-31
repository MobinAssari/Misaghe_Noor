import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/Screens/authentication.dart';
import 'package:misaghe_noor/helper/ConnectToDataBase.dart';
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
  late String memberId;
  @override
  void dispose() {

    super.dispose();
  }

  @override
  Widget build(context) {
    var isEdit = widget.isEdit;
    if (isEdit) {
      member = ref.read(membersProvider.notifier).findMember(widget.memberId);
      lastChangedUser =
          ref.read(usersProvider.notifier).findUser(member!.lastChangedUserId!);
    }
    void Submit() async {
      if (_form.currentState!.validate()) {
        setState(() {
          isSending = true;
        });
        _form.currentState!.save();
        if (isEdit) {
          memberId = member!.id;
          connectToDataBase.patchMember(Member(
              id: member!.id,
              name: inputName,
              family: inputFather,
              fatherName: inputFather,
              meliNumber: inputMeli,
              shenasnameNumber: inputShShenasname,
              address: inputAddress,
              phone: inputPhone,
              mobile: inputMobile,
              lastChangedUserId: enteredUserId));
          ref.read(membersProvider.notifier).removeMember(member!);
        } else {

          memberId = await connectToDataBase.postMember(Member(
              id: '',
              name: inputName,
              family: inputFather,
              fatherName: inputFather,
              meliNumber: inputMeli,
              shenasnameNumber: inputShShenasname,
              address: inputAddress,
              phone: inputPhone,
              mobile: inputMobile,
              lastChangedUserId: enteredUserId));
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
                  lastChangedUserId: enteredUserId),
            );
        Navigator.of(context).pop();
      }
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text('مشخصات عضو'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
              top: 0, bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
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
                              border: OutlineInputBorder(),
                              label: Text('نام'),
                            ),
                            validator: (value) {
                              if (value!.isEmpty)
                                return "لطفا نام را وارد کنید";
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
                              border: OutlineInputBorder(),
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
                        initialValue: isEdit ? member?.fatherName ?? '' : '',
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('نام پدر'),
                        ),
                        validator: (value) {
                          if (value!.isEmpty)
                            return "لطفا نام پدر را وارد کنید";
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
                              border: OutlineInputBorder(),
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
                            initialValue:
                                isEdit ? member?.shenasnameNumber : '',
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
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
                              border: OutlineInputBorder(),
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
                              border: OutlineInputBorder(),
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
                        maxLines: 10,
                        minLines: null,
                        initialValue: isEdit ? member?.address : '',
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          label: Text('آدرس'),
                        ),
                        onSaved: (value) => inputAddress = value!,
                      ),
                    ),
                    // SizedBox(height: 24,),
                    Row(
                      children: [
                        ElevatedButton(
                          onPressed: () =>
                              isSending ? null : Navigator.of(context).pop(),
                          child: const Text('لغو'),
                        ),
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
                                ? const SizedBox(
                                    width: 1,
                                  )
                                : Text(
                                    ' آخرین تغییر توسط ${lastChangedUser!.name} ${lastChangedUser!.family}',
                                  )
                            : const SizedBox(
                                width: 1,
                              ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
