import 'package:flutter/material.dart';
import 'package:sistem_kompen/kompen/detail_mhs_alpha.dart';
import 'dart:convert';
import 'package:sistem_kompen/config.dart';
import 'package:http/http.dart' as http;

class MahasiswaAlphaPagge extends StatefulWidget {
  final String token;

  const MahasiswaAlphaPagge({super.key, required this.token});

  @override
  _AlphaMahasiswaState createState() => _AlphaMahasiswaState();
}

class _AlphaMahasiswaState extends State<MahasiswaAlphaPagge> {
  final TextEditingController idMahasiswaAlpha = TextEditingController();
  var all_data = [];

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _showAllData(widget.token); // Load data when the widget initializes
  }

  void _showAllData(String token) async {
    final url = Uri.parse(Config.list_mhs_alpha_endpoint);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success']) {
          setState(() {
            all_data = (data['data'] as List).map((item) {
              return {
                'no': item['no']?.toString() ?? '',
                'mahasiswa_id': item['mahasiswa_id']?.toString() ?? '',
                'mahasiswa_nama': item['mahasiswa_nama']?.toString() ?? '',
                'alpha': item['alpha']?.toString() ?? "?",
              };
            }).toList();
          });
        } else {
          print("Data tidak ditemukan: ${response.body}");
          setState(() {
            all_data = [];
          });
        }
      } else {
        print("Unexpected data format: ${response.body}");
        setState(() {
          all_data = [];
        });
      }
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        all_data = [];
      });
    }
  }

  List<dynamic> getFilteredData() {
    if (searchQuery.isEmpty) {
      return all_data; // Return all data if no search query
    }
    return all_data.where((item) {
      String nama = item['mahasiswa_nama'].toLowerCase();
      return nama.contains(searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredData = getFilteredData();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar Mahasiswa Alpha'),
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 20),
        backgroundColor: const Color(0xFF2D2766), // Dark blue
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Container(
        color: const Color(0xFF8278AB), // Light blue background
        child: Column(
          children: [
            // Search bar (fixed)
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Mahasiswa...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (value) {
                  setState(() {
                    searchQuery = value; // Update the search query
                  });
                },
              ),
            ),
            const SizedBox(height: 10),
            // Rounded white container
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  child: Container(
                    color: Colors.white, // White container background
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15),
                        ),
                        child: Column(
                          children: [
                            // Table header (fixed inside the container)
                            Container(
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: const Color(0xFFEEEEEE)),
                                  color: const Color(0xFFEEEEEE)),
                              padding: const EdgeInsets.all(8.0),
                              child: const Row(
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: Text(
                                      'Nama Lengkap',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      '(i)',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Text(
                                      'Alpha',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Scrollable table body
                            Expanded(
                              child: filteredData.isEmpty
                                  ? const Center(
                                      child: Text(
                                          "Tidak ada data yang ditampilkan"))
                                  : ListView.builder(
                                      itemCount: filteredData.length,
                                      itemBuilder: (context, index) {
                                        final row = filteredData[index];
                                        return Container(
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFEEEEEE))),
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              // Nama Lengkap (truncated)
                                              Expanded(
                                                flex: 5,
                                                child: Text(
                                                  row['mahasiswa_nama'],
                                                  textAlign: TextAlign.left,
                                                  maxLines:
                                                      1, // Restrict to 1 line
                                                  overflow: TextOverflow
                                                      .ellipsis, // Ellipses for overflow
                                                ),
                                              ),
                                              // Open button
                                              Expanded(
                                                flex: 1,
                                                child: IconButton(
                                                  icon: const Icon(Icons
                                                      .open_in_full_rounded),
                                                  onPressed: () {
                                                    String id =
                                                        row['mahasiswa_id'];
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            DetailMahasiswaAlpha(
                                                                token: widget
                                                                    .token,
                                                                id: id),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                              // Alpha
                                              Expanded(
                                                flex: 2,
                                                child: Text(
                                                  row['alpha'],
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
