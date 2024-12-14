// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:sistem_kompen/controller/mahasiswa_controller.dart';
import 'package:sistem_kompen/login/login.dart';
import 'package:sistem_kompen/core/shared_prefix.dart';
import 'package:sistem_kompen/mahasiswa/profile.dart';

class DashboardMahasiswa extends StatefulWidget {
  final String token;
  final String id;

  const DashboardMahasiswa({super.key, required this.token, required this.id});

  @override
  _DashboardMahasiswaState createState() => _DashboardMahasiswaState();
}

class _DashboardMahasiswaState extends State<DashboardMahasiswa> {
  String tokens = '';
  String user_id = '';
  String nama = 'Loading...';
  String nim = 'Loading...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _dashboardData();
  }

  Future<void> _dashboardData() async {
    try {
      // Ambil token dari SharedPreferences jika diperlukan
      final token = await Sharedpref.getToken();
      final mahasiswaId = await Sharedpref.getUserId();

      if (token == '') {
        throw Exception('Token is missing');
      }

      final data = await MahasiswaController.profile(token, mahasiswaId);

      setState(() {
        tokens = token;
        user_id = data['user_id'] ?? '-';
        nama = data['nama'] ?? '-';
        nim = data['nim'] ?? '-';
      });
      print(data['message']);
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Custom Header
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFF2D2766), // Ensure no white overlay
              ),
              child: SafeArea(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        PopupMenuButton<int>(
                          icon: const Icon(Icons.menu_rounded, color: Colors.white),
                          onSelected: (item) => onSelectedMenu(context, item),
                          itemBuilder: (context) => [
                            PopupMenuItem<int>(
                              value: 0,
                              child: ListTile(
                                leading: Icon(Icons.menu_open_rounded),
                                title: Text('Menu'),
                              ),
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.home_rounded, color: Colors.black),
                                  const SizedBox(width: 15),
                                  Text('Home'),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.add_to_photos, color: Colors.black),
                                  const SizedBox(width: 15),
                                  Text('Daftar Tugas'),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 3,
                              child: Row(
                                children: [
                                  Icon(Icons.add_to_photos, color: Colors.black),
                                  const SizedBox(width: 15),
                                  Text('Update Progress Tugas'),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 4,
                              child: Row(
                                children: [
                                  Icon(Icons.add_to_photos, color: Colors.black),
                                  const SizedBox(width: 15),
                                  Text('Update Kompen Selesai'),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 5,
                              child: Row(
                                children: [
                                  Icon(Icons.add_to_photos, color: Colors.black),
                                  const SizedBox(width: 15),
                                  Text('Cetak Hasil Kompen'),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 6,
                              child: Row(
                                children: [
                                  Icon(Icons.add_to_photos, color: Colors.black),
                                  const SizedBox(width: 15),
                                  Text('Cek Validasi QR'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Center(
                          child: Text(
                            'HOME',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                backgroundColor: Colors.transparent),
                          ),
                        ),
                        PopupMenuButton<int>(
                          icon: const Icon(Icons.person, color: Colors.white),
                          onSelected: (item) => onSelected(context, item),
                          itemBuilder: (context) => [
                            PopupMenuItem<int>(
                              value: 0,
                              child: ListTile(
                                leading: Icon(Icons.person),
                                title: Text('$nama\n$nim'),
                              ),
                            ),
                            PopupMenuDivider(),
                            PopupMenuItem<int>(
                              value: 1,
                              child: Row(
                                children: [
                                  Icon(Icons.menu_book, color: Colors.black),
                                  const SizedBox(width: 15),
                                  Text('Profile'),
                                ],
                              ),
                            ),
                            PopupMenuItem<int>(
                              value: 2,
                              child: Row(
                                children: [
                                  Icon(Icons.logout, color: Colors.black),
                                  const SizedBox(width: 15),
                                  Text('Logout'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 302,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Rectangle 9.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 85),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        nim,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 200,
                  left: 32,
                  right: 32,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text(
                          'Silahkan Lakukan Kompen',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(232, 120, 23, 1)),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTrackRecordItem(Icons.cloud_upload, 'Sakit',
                                '3', const Color.fromRGBO(130, 120, 171, 1)),
                            _buildTrackRecordItem(Icons.work, 'Izin', '12',
                                const Color.fromRGBO(112, 101, 160, 1)),
                            _buildTrackRecordItem(Icons.check_circle, 'Alpha',
                                '103', const Color(0xFF2D2766)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Remaining body content
            const SizedBox(height: 100),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Notifikasi Teratas:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            NotificationItem(
              title: 'Tugas Bersih.... perlu ditinjau',
              subtitle: 'Tugas 01 telah diselesaikan oleh mahasiswa.',
              time: '20 Jam',
            ),
            NotificationItem(
              title: 'Tugas Bers.... sedang dikerjakan',
              subtitle: 'Tugas 02 telah diambil oleh mahasiswa Rafli Rasyiq.',
              time: '20 Jam',
            ),
            NotificationItem(
              title: 'Tugas Bers.... sedang dikerjakan',
              subtitle: 'Tugas 01 telah diambil oleh mahasiswa Rafli Rasyiq.',
              time: '20 Jam',
            ),
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/notifikasi');
                },
                child: const Text('Lihat Semua >>'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackRecordItem(
      IconData icon, String label, String count, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              Text(count,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20)),
              Text(
                label,
                style: const TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }

  onSelected(BuildContext context, int item) {
    switch (item) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileMahasiswa(token: tokens, id: user_id)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
        );

        break;
    }
  }

  onSelectedMenu(BuildContext context, int item) {
    switch (item) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DashboardMahasiswa(token: tokens, id: user_id)),
        );
        break;
      case 2:
        // Handle Logout action
        break;
    }
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;

  const NotificationItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
            Text(
              time,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
