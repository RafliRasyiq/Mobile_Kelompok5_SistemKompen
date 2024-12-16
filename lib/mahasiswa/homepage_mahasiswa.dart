// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sistem_kompen/controller/mahasiswa_controller.dart';
import 'package:sistem_kompen/login/login.dart';
import 'package:sistem_kompen/core/shared_prefix.dart';
import 'package:sistem_kompen/mahasiswa/profile.dart';
import 'package:sistem_kompen/mahasiswa/update_kompen_selesai.dart';
import 'package:sistem_kompen/tugas/list_tugas.dart';
import 'package:sistem_kompen/config.dart';
import 'package:http/http.dart' as http;

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
    fetchAllData();
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

  var allData = [];
  var searchQuery = "";

  Future<void> fetchAllData() async {
    final url = Uri.parse(Config.mahasiswa_kompen_selesai_endpoint);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          print(data['data']);
          setState(() {
            allData = (data['data'] as List)
                .map((item) {
                  return {
                    'tugas_nama': item['tugas']['tugas_nama']?.toString() ?? '',
                    'mahasiswa_nama':
                        item['mahasiswa']['mahasiswa_nama']?.toString() ?? '',
                    'tanggal': item['tanggal']?.toString() ?? '',
                    'status': item['status']?.toString() ?? '',
                  };
                })
                .take(2) // Limit to a maximum of 2 items
                .toList();
          });
        } else {
          print("Daftar tugas tidak ditemukan: ${response.body}");
          setState(() {
            allData = [];
          });
        }
      } else {
        print("Unexpected data format: ${response.body}");
        setState(() {
          allData = [];
        });
      }
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        allData = [];
      });
    }
  }

  // Function to filter data based on search query
  List<dynamic> getFilteredData() {
    if (searchQuery.isEmpty) {
      return allData; // Show all data if search query is empty
    }
    return allData.where((item) {
      String tugasNama = item['tugas_nama']?.toLowerCase() ?? '';
      String mahasiswaNama = item['mahasiswa_nama']?.toLowerCase() ?? '';
      return tugasNama.contains(searchQuery.toLowerCase()) ||
          mahasiswaNama.contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredData = getFilteredData();

    return Scaffold(
      // extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          // Background image covering the entire screen
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/background/bg-2.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Foreground content
          SingleChildScrollView(
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
                              icon: const Icon(Icons.menu_rounded,
                                  color: Colors.white),
                              onSelected: (item) =>
                                  onSelectedMenu(context, item),
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
                                      Icon(Icons.home_rounded,
                                          color: Colors.black),
                                      const SizedBox(width: 15),
                                      Text('Home'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 2,
                                  child: Row(
                                    children: [
                                      Icon(Icons.add_to_photos,
                                          color: Colors.black),
                                      const SizedBox(width: 15),
                                      Text('Daftar Tugas'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 3,
                                  child: Row(
                                    children: [
                                      Icon(Icons.view_timeline_rounded,
                                          color: Colors.black),
                                      const SizedBox(width: 15),
                                      Text('Progress Tugas'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 4,
                                  child: Row(
                                    children: [
                                      Icon(Icons.domain_verification_rounded,
                                          color: Colors.black),
                                      const SizedBox(width: 15),
                                      Text('Update Kompen Selesai'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 5,
                                  child: Row(
                                    children: [
                                      Icon(Icons.local_print_shop_rounded,
                                          color: Colors.black),
                                      const SizedBox(width: 15),
                                      Text('Cetak Hasil Kompen'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 6,
                                  child: Row(
                                    children: [
                                      Icon(Icons.document_scanner_rounded,
                                          color: Colors.black),
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
                              icon:
                                  const Icon(Icons.person, color: Colors.white),
                              onSelected: (item) => onSelected(context, item),
                              itemBuilder: (context) => [
                                PopupMenuItem<int>(
                                  value: 0,
                                  child: ListTile(
                                    leading: Icon(Icons.person),
                                    title: Text(nama,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                    subtitle: Text(nim,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis),
                                  ),
                                ),
                                PopupMenuDivider(),
                                PopupMenuItem<int>(
                                  value: 1,
                                  child: Row(
                                    children: [
                                      Icon(Icons.contact_phone_rounded,
                                          color: Colors.black),
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
                      height: 150,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Rectangle 9.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 16, top: 50, right: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(nama,
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
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
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      Container(
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
                                _buildTrackRecordItem(
                                    Icons.cloud_upload,
                                    'Sakit',
                                    '3',
                                    const Color.fromRGBO(130, 120, 171, 1)),
                                _buildTrackRecordItem(Icons.work, 'Izin', '12',
                                    const Color.fromRGBO(112, 101, 160, 1)),
                                _buildTrackRecordItem(Icons.check_circle,
                                    'Alpha', '103', const Color(0xFF2D2766)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Judul
                            Text(
                              'Tugas Anda',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(232, 120, 23, 1),
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 5), // Space after the title
                            // Menampilkan data atau pesan kosong
                            getFilteredData().isEmpty
                                ? const Center(
                                    child: Text(
                                      "Tidak ada data yang ditampilkan.\nSilakan buat tugas baru.",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: getFilteredData().length,
                                    itemBuilder: (context, index) {
                                      final item = getFilteredData()[index];
                                      return Card(
                                        elevation: 4,
                                        margin: const EdgeInsets.symmetric(
                                            vertical: 8),
                                        child: ListTile(
                                          title: Text(
                                            item['tugas_nama'], // Task name
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 18,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  'Nama Mahasiswa: ${item['mahasiswa_nama']}'),
                                              Text(
                                                  'Tanggal: ${item['tanggal']}'),
                                            ],
                                          ),
                                          trailing: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                item['status'] == 'terima'
                                                    ? Icons.check_circle
                                                    : item['status'] == 'tolak'
                                                        ? Icons.cancel
                                                        : Icons.hourglass_empty,
                                                color: item['status'] ==
                                                        'terima'
                                                    ? Colors.green
                                                    : item['status'] == 'tolak'
                                                        ? Colors.red
                                                        : Colors.yellow,
                                                size: 24,
                                              ),
                                              const SizedBox(width: 5),
                                              Text(
                                                item['status'] == 'terima'
                                                    ? 'Diterima'
                                                    : item['status'] == 'tolak'
                                                        ? 'Ditolak'
                                                        : 'Belum Dicek',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
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
              builder: (context) =>
                  ProfileMahasiswa(token: tokens, id: user_id)),
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
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => DaftarTugas(token: tokens)),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DataListScreen(token: tokens)),
        );
        break;
    }
  }
}
