import 'package:flutter/material.dart';
import 'package:sistem_kompen/login/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: DataScreen(),
      // home: HomePageDosen(),
      // home: ProfilePage(),
      home: LoginScreen(),
    );
  }
}


