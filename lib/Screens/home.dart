import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:misaghe_noor/data/dummy_member.dart';
import 'package:misaghe_noor/data/dummy_user.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void save() async {
    final url = Uri.https(
        'misaghe-noor-default-rtdb.asia-southeast1.firebasedatabase.app',
        'members-list.json');
    for (var user in dummyMember) {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(
          {
            'name': user.name,
            'fatherName': user.fatherName,
            'meliNumber': user.meliNumber,
            'shenasnameNumber': user.shenasnameNumber,
            'address': user.address,
            'phone': user.phone,
            'mobile': user.mobile,
            'lastChangeUsreId': user.lastChangeUsreId,
          },
        ),
      );
      print(response.body);
    }
  }

  @override
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 70,
              width: 300,
              child: ElevatedButton(
                onPressed: save,
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                ),
                child: const Text('جلسات'),
              ),
            ),
            SizedBox(
              height: 70,
              width: 250,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('اعضا'),
              ),
            ),
            SizedBox(
              height: 70,
              width: 250,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('گزارشات'),
              ),
            ),
            SizedBox(
              height: 70,
              width: 250,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('؟؟'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
