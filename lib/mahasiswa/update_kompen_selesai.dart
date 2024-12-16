// updateskm.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sistem_kompen/config.dart';
import 'package:http/http.dart' as http;

var allData = [];
String _searchQuery = ""; // Variable to store search query

class DataListScreen extends StatefulWidget {
  final String token;
  const DataListScreen({super.key, required this.token});

  @override
  _DataListScreenState createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  // Fetch all tasks data
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
        print(data);
        if (data['success']) {
          print("masuk ke success");
          setState(() {
            // Parse the data['data'] list and assign it to allData
            allData = data['data'] as List<dynamic>;
          });
        } else {
          print("Data tidak ditemukan: ${response.body}");
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
    if (_searchQuery.isEmpty) {
      return allData; // Show all data if search query is empty
    }
    return allData.where((item) {
      String tugasNama = item['tugas']['tugas_nama']?.toLowerCase() ?? '';
      String mahasiswaNama =
          item['mahasiswa']['mahasiswa_nama']?.toLowerCase() ?? '';
      return tugasNama.contains(_searchQuery.toLowerCase()) ||
          mahasiswaNama.contains(_searchQuery.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredData = getFilteredData(); // Data after filtering

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Status Penugasan',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF2D2766),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                hintText: 'Cari berdasarkan tugas atau mahasiswa...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; // Update search query
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: allData.isEmpty
                  ? const Center(child: Text("Tidak ada data yang ditampilkan"))
                  : RefreshIndicator(
                      onRefresh: fetchAllData, // Refresh function
                      child: ListView.builder(
                        itemCount: filteredData.length,
                        itemBuilder: (context, index) {
                          var data = filteredData[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                data['tugas']['tugas_nama'], // Task name
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                                maxLines: 2, // Restrict to 1 line
                                overflow: TextOverflow.ellipsis,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                      'Nama Mahasiswa: ${data['mahasiswa']['mahasiswa_nama']}'),
                                  Text('Tanggal: ${data['tanggal']}'),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    data['status'] == 'terima'
                                        ? Icons.check_circle
                                        : data['status'] == 'tolak'
                                            ? Icons.cancel
                                            : Icons.hourglass_empty,
                                    color: data['status'] == 'terima'
                                        ? Colors.green
                                        : data['status'] == 'tolak'
                                            ? Colors.red
                                            : Colors.yellow,
                                    size: 24,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    data['status'] == 'terima'
                                        ? 'Diterima'
                                        : data['status'] == 'tolak'
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
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
