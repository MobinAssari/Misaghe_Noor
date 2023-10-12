import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:misaghe_noor/Screens/authentication.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
void main() async {
  await Supabase.initialize(
      url: 'https://cwgclbxwviwrxlhodjio.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImN3Z2NsYnh3dml3cnhsaG9kamlvIiwicm9sZSI6ImFub24iLCJpYXQiOjE2OTU2MzY0MjEsImV4cCI6MjAxMTIxMjQyMX0.LtOSCRjTt-cQRS60E52ZeZq2buwHHshYHOVgAJXCNy0');
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: MaterialApp(
        theme: ThemeData(
          fontFamily: 'IranYekan',
        ),
        debugShowCheckedModeBanner: false,
        home: AuthenticationScreen(),
      ),
    );
  }
}
