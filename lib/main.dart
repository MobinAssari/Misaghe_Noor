import 'package:flutter/material.dart';
import 'package:misaghe_noor/Screens/authentication.dart';

void main() {
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        home: AuthenticationScreen(),
      ),
    );
  }
}
