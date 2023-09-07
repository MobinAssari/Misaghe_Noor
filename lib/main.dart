import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/Screens/authentication.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(theme: ThemeData(


          fontFamily: 'IranYekan',
        ),

        debugShowCheckedModeBanner: false,
        home: AuthenticationScreen(),
      ),
    );
  }
}
