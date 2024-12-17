import 'package:flutter/material.dart';
import 'package:sistem_kompen/kompen/daftar_mhs_kompen.dart';
import 'tendik/homepage_tendik.dart';
import 'tendik/profile.dart';

class TendikPage extends StatefulWidget {
  final String token; // Tambahkan parameter token
  final String id;

  const TendikPage({super.key, required this.token, required this.id});

  @override
  _TendikPageState createState() => _TendikPageState();
}

class _TendikPageState extends State<TendikPage> {
  int _selectedIndex = 0;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();

    // Inisialisasi halaman dengan token
    _pages = [
      DashboardTendik(token: widget.token, id: widget.id),
      ProfileTendik(token: widget.token, id: widget.id),
      KompenMahasiswaPage(token: widget.token)
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
