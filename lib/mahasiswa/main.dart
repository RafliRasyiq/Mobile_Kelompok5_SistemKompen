// main.dart
import 'package:flutter/material.dart';
import 'updateksm.dart'; // Import the DataListScreen from updateskm.dart

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Status Penugasan',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const DataListScreen(), // Set DataListScreen as home screen
    );
  }
}
