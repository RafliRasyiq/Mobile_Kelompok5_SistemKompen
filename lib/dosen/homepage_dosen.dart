// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sistem_kompen/config.dart';
import 'package:sistem_kompen/controller/dosen_controller.dart';
import 'package:sistem_kompen/dosen/update_kompen_selesai.dart';
import 'package:sistem_kompen/kompen/daftar_mhs_alpha.dart';
import 'package:sistem_kompen/kompen/daftar_mhs_kompen.dart';
import 'package:sistem_kompen/login/login.dart';
import 'package:sistem_kompen/core/shared_prefix.dart';
import 'package:sistem_kompen/dosen/profile.dart';
import 'package:sistem_kompen/dosen/deskripsi_tugas.dart';
import 'package:sistem_kompen/dosen/list_tugas.dart';
import 'package:http/http.dart' as http;

class DashboardDosen extends StatefulWidget {
  final String token;
  final String id;

  const DashboardDosen({super.key, required this.token, required this.id});

  @override
  _DashboardDosenState createState() => _DashboardDosenState();
}

class _DashboardDosenState extends State<DashboardDosen> {
  String tokens = '';
  String user_id = '';
  String nama = 'Loading...';
  String nip = 'Loading...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _dashboardData();
    _showAllData();
  }

  var allData = [];

  Future<void> _showAllData() async {
    final url = Uri.parse(Config.list_tugas_dosenTendik_endpoint);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          print(data['data']);
          setState(() {
            allData = (data['data'] as List)
                .map((item) {
                  return {
                    'id': item['tugas_id']?.toString() ?? '',
                    'title': item['tugas_nama']?.toString() ?? '',
                    'description': item['deskripsi']?.toString() ?? '',
                    'lecturer': item['user']['nama']?.toString() ?? '',
                    'type': item['jenis']['jenis_nama']?.toString() ?? '',
                    'period':
                        item['periode']['periode_tahun']?.toString() ?? '',
                    'weight': item['tugas_bobot']?.toString() ?? '',
                    'due': item['tugas_tenggat']?.toString() ?? '',
                    'quota': item['kuota']?.toString() ?? '', // Placeholder
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

  Future<void> _dashboardData() async {
    try {
      // Ambil token dari SharedPreferences jika diperlukan
      final token = await Sharedpref.getToken();
      final userId = await Sharedpref.getUserId();

      if (token == '') {
        throw Exception('Token is missing');
      }

      final data = await DosenController.profile(token, userId);

      setState(() {
        tokens = token;
        user_id = data['user_id'] ?? '-';
        nama = data['nama'] ?? '-';
        nip = data['nip'] ?? '-';
      });
      print(data['message']);
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  var searchQuery = "";

  List<dynamic> getFilteredData() {
    if (searchQuery.isEmpty) {
      return allData; // Return all data if no search query
    }
    return allData.where((item) {
      String nama = item['title'].toLowerCase();
      return nama.contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredData = getFilteredData();

    return Scaffold(
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
                Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D2766),
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
                                      Text('Manage Kompen'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 3,
                                  child: Row(
                                    children: [
                                      Icon(Icons.list_rounded,
                                          color: Colors.black),
                                      const SizedBox(width: 15),
                                      Text('Daftar Mahasiswa Alpha'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 4,
                                  child: Row(
                                    children: [
                                      Icon(Icons.list_rounded,
                                          color: Colors.black),
                                      const SizedBox(width: 15),
                                      Text('Daftar Mahasiswa Kompen'),
                                    ],
                                  ),
                                ),
                                PopupMenuItem<int>(
                                  value: 5,
                                  child: Row(
                                    children: [
                                      Icon(Icons.domain_verification_outlined,
                                          color: Colors.black),
                                      const SizedBox(width: 15),
                                      Text('Update Kompen Selesai'),
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
                                  backgroundColor: Colors.transparent,
                                ),
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
                                    title: Text(
                                      nama,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    subtitle: Text(
                                      nip,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
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
                // Background Image and Track Record (adjusted with Stack and Positioned)
                Stack(
                  clipBehavior: Clip
                      .none, // to allow the overflow of the track record container
                  children: [
                    // Background Image
                    Container(
                      height: 150, // height of the image container
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/images/Rectangle 9.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    // Profile Information
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
                            nip,
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
                            // Title at the top-center
                            const Text(
                              'Track Record Tugas',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(232, 120, 23, 1)),
                            ),
                            const SizedBox(
                                height: 10), // Space between title and row
                            // The row with track record items
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                _buildTrackRecordItem(Icons.camera, 'Ditinjau',
                                    '2', const Color.fromRGBO(232, 120, 23, 1)),
                                _buildTrackRecordItem(
                                    Icons.cloud_upload,
                                    'Terunggah',
                                    '3',
                                    const Color.fromRGBO(130, 120, 171, 1)),
                                _buildTrackRecordItem(
                                    Icons.work,
                                    'Dikerjakan',
                                    '12',
                                    const Color.fromRGBO(112, 101, 160, 1)),
                                _buildTrackRecordItem(
                                    Icons.check_circle,
                                    'Selesai',
                                    '103',
                                    const Color.fromRGBO(45, 39, 102, 1)),
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
                            // Title
                            Text(
                              'Tugas buatan anda',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(232, 120, 23, 1),
                              ),
                            ),
                            const SizedBox(height: 5), // Space after the title
                            // Handle empty or populated data
                            filteredData.isEmpty
                                ? const Center(
                                    child: Text(
                                      "Tidak ada data yang ditampilkan.\nBuat sebuah tugas untuk menampilkan tugas yang baru anda buat",
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: filteredData.length,
                                    itemBuilder: (context, index) {
                                      final task = filteredData[index];
                                      return GestureDetector(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  DeskripsiDetailScreen(
                                                      task: task),
                                            ),
                                          );
                                        },
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Padding(
                                            padding: const EdgeInsets.all(14.0),
                                            child: Row(
                                              children: [
                                                Expanded(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        task['title'],
                                                        style: const TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 16),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(height: 4),
                                                      Text(
                                                        task['description'],
                                                        style: const TextStyle(
                                                            fontSize: 12),
                                                        maxLines: 2,
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                      const SizedBox(height: 8),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceBetween,
                                                        children: [
                                                          Text(
                                                            task['lecturer'],
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          Text(
                                                            'Jenis: ${task['type']}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                          Text(
                                                            'Kuota: ${task['quota']}',
                                                            style:
                                                                const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .grey),
                                                          ),
                                                        ],
                                                      ),
                                                      Text(
                                                        'Tenggat: ${task['due']}',
                                                        style: const TextStyle(
                                                            fontSize: 12,
                                                            color: Colors
                                                                .redAccent),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
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
              Icon(icon, size: 30, color: Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  onSelected(BuildContext context, int item) {
    switch (item) {
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ProfileDosen(token: tokens, id: user_id)),
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
              builder: (context) => DashboardDosen(token: tokens, id: user_id)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DaftarTugas(token: tokens, id: user_id)),
        );
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => MahasiswaAlphaPagge(token: tokens)),
        );
        break;
      case 4:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => KompenMahasiswaPage(token: tokens)),
        );
        break;
      case 5:
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  DataListScreen(token: tokens, id: widget.id)),
        );
        break;
    }
  }
}
