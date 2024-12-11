import 'package:flutter/material.dart';
import 'mahasiswa/homepage_mahasiswa.dart';
import 'mahasiswa/profile.dart';

class MahasiswaPage extends StatefulWidget {
  final String token; // Tambahkan parameter token
  final int id;

  const MahasiswaPage({super.key, required this.token, required this.id});

  @override
  _MahasiswaPageState createState() => _MahasiswaPageState();
}

class _MahasiswaPageState extends State<MahasiswaPage> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Inisialisasi halaman dengan token
    _pages = [
      HomePageMHS(),
      ProfilePage(id: widget.id)
      //   Dashboard(token: widget.token), // Pass token ke Dashboard
      //   HistoryPage(),
      //   NotificationPage(),
      //   ProfilePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update halaman aktif
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Scaffold(
        body: SafeArea(
          child: _pages[_selectedIndex], // Menampilkan halaman yang dipilih
        ),
        // bottomNavigationBar: BottomNavBar(
        //   selectedIndex: _selectedIndex,
        //   onItemTapped: _onItemTapped, // Pass the callback function
        // ),
      ),
    );
  }
}
