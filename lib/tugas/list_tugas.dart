import 'package:flutter/material.dart';
import 'package:sistem_kompen/tugas/deskripsi_tugas.dart';
import 'dart:convert';
import 'package:sistem_kompen/config.dart';
import 'package:http/http.dart' as http;

class DaftarTugas extends StatefulWidget {
  final String token;

  const DaftarTugas({super.key, required this.token});

  @override
  _DaftarTugasState createState() => _DaftarTugasState();
}

class _DaftarTugasState extends State<DaftarTugas> {
  var allData = [];

  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    _showAllData(); // Load data on initialization
  }

  void _showAllData() async {
    final url = Uri.parse(Config.list_tugas_mahasiswa_endpoint);
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
            allData = (data['data'] as List).map((item) {
              return {
                'id': item['tugas_id']?.toString() ?? '',
                'title': item['tugas_nama']?.toString() ?? '',
                'description': item['deskripsi']?.toString() ?? '',
                'lecturer': item['user']['nama']?.toString() ?? '',
                'type': item['jenis']['jenis_nama']?.toString() ?? '',
                'period': item['periode']['periode_tahun']?.toString() ?? '',
                'weight': item['tugas_bobot']?.toString() ?? '',
                'due': item['tugas_tenggat']?.toString() ?? '',
                'quota': item['kuota']?.toString() ?? '', // Placeholder
              };
            }).toList();
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
    }
  }

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
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 42, 6, 127),
        title: const Text(
          'DAFTAR TUGAS',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color.fromARGB(255, 42, 6, 127),
                  Colors.white,
                ],
                stops: [0.5, 0.5],
              ),
            ),
          ),
          Center(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 89, 58, 132),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Cari...',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
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
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: filteredData.isEmpty
                        ? const Center(
                            child: Text("Tidak ada data yang ditampilkan"))
                        : ListView.builder(
                            itemCount: filteredData.length,
                            itemBuilder: (filteredData, index) {
                              final task = allData[index];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          TaskDetailScreen(task: task),
                                    ),
                                  );
                                },
                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.0),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                task['title'],
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                task['description'],
                                                style: const TextStyle(
                                                    fontSize: 12),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              const SizedBox(height: 8),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    task['lecturer'],
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                  Text(
                                                    'Jenis: ${task['type']}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                    textAlign: TextAlign.left,
                                                  ),
                                                  Text(
                                                    'Kuota: ${task['quota']}',
                                                    style: const TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.grey),
                                                  ),
                                                ],
                                              ),
                                              Text(
                                                'Tenggat: ${task['due']}',
                                                style: const TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.redAccent),
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
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
