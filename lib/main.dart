import 'package:flutter/material.dart';
import 'package:sistem_kompen/pages/deskripsi_tugas.dart';
import 'package:sistem_kompen/pages/list_tugas.dart';

// import 'package:sistem_kompen/pages/form_kumpul_tugas.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Kompen',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    
      home: DaftarTugas(),
    );
  }
}
