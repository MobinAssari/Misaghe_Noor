import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            ElevatedButton(onPressed: (){}, child: Text('اعضا')),
            ElevatedButton(onPressed: (){}, child: Text('اعضا')),
            ElevatedButton(onPressed: (){}, child: Text('اعضا')),
            ElevatedButton(onPressed: (){}, child: Text('اعضا')),
          ],
        ),
      ),
    );
  }
}
