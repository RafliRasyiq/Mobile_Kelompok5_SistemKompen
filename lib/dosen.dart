import 'package:flutter/material.dart';
import 'package:sistem_kompen/kompen/daftar_mhs_alpha.dart';
import 'package:sistem_kompen/kompen/daftar_mhs_kompen.dart';
import 'dosen/homepage_dosen.dart';
import 'dosen/profile.dart';

class DosenPage extends StatefulWidget {
  final String token; // Tambahkan parameter token
  final String id;

  const DosenPage({super.key, required this.token, required this.id});

  @override
  _DosenPageState createState() => _DosenPageState();
}

class _DosenPageState extends State<DosenPage> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Inisialisasi halaman dengan token
    _pages = [
      DashboardDosen(token: widget.token, id: widget.id),
      ProfilePage(token: widget.token, id: widget.id),
      KompenMahasiswaPage(token: widget.token),
      MahasiswaAlphaPagge(token: widget.token)
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
