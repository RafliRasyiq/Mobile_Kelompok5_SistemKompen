import 'package:flutter/material.dart';
import 'package:sistem_kompen/homepage_dosen.dart';
import 'package:sistem_kompen/homepage_mahasiswa.dart';
// import 'package:sistem_kompen/sidebar_menu_dosen.dart';
import 'package:sistem_kompen/sidebar_menu_mahasiswa.dart';
import 'package:sistem_kompen/notifikasi.dart';
import 'package:sistem_kompen/terima_mahasiswa.dart';
// import 'package:sistem_kompen/profile.dart';
import 'package:sistem_kompen/kelola_kompen.dart';
import 'package:sistem_kompen/profile.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: data_tes(),
      // home: HomePageDosen(),
      home: ProfilePage(),
      routes: {
        '/sidebar' : (context)=>SidebarMenu(),
        '/homepage' : (context)=>HomePageMHS(),
        // '/homepage' : (context)=>HomePageDosen(),
        '/notifikasi' : (context)=>NotificationPage(),
        '/terimamahasiswa' : (context)=>TerimaMahasiswa(),
      }
    );
  }
}


