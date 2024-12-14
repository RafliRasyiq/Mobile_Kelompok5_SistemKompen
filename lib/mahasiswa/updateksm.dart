// updateskm.dart
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'config.dart'; // Import Dio configuration and URLs

var allData = [];
String _searchQuery = ""; // Variable to store search query

class DataListScreen extends StatefulWidget {
  const DataListScreen({super.key});

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
    try {
      Response response = await dio.get(urlAllData);
      print("All Data Response: ${response.data}");
      setState(() {
        allData = response.data['data'] ?? [];
      });
    } catch (e) {
      print("Error fetching all data: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch data!')),
      );
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
        title: const Text('Status Penugasan'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
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
              child: RefreshIndicator(
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
