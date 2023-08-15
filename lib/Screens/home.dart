import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
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
                onPressed: () {},
                child: Text('جلسات'),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(50)),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('اعضا'),
              ),
              height: 70,
              width: 250,
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('گزارشات'),
              ),
              height: 70,
              width: 250,
            ),
            SizedBox(
              child: ElevatedButton(
                onPressed: () {},
                child: Text('؟؟'),
              ),
              height: 70,
              width: 250,
            ),
          ],
        ),
      ),
    );
  }
}
