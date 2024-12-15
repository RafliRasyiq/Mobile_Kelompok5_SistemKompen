import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'config.dart'; // Ensure to import the Dio and API configuration
import 'dart:io';
import 'package:image_picker/image_picker.dart';

var allData = [];
String _searchQuery = ""; // Search query for filtering

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

  // Function to filter data based on the search query
  List<dynamic> getFilteredData() {
    if (_searchQuery.isEmpty) {
      return allData; // Show all data if the search query is empty
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
    List<dynamic> filteredData =
        getFilteredData(); // Data after applying filter

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
            // Search Bar to filter the data based on task or student name
            TextField(
              decoration: const InputDecoration(
                hintText: 'Cari berdasarkan tugas atau mahasiswa...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value; // Update the search query
                });
              },
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: fetchAllData, // Refresh function to fetch data again
                child: ListView.builder(
                  itemCount: filteredData.length,
                  itemBuilder: (context, index) {
                    var data = filteredData[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(
                          data['tugas']['tugas_nama'], // Display task name
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
                        onTap: () {
                          // Navigate to Task Detail Screen on tap of the task
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(
                                  pengumpulanId: data['pengumpulan_id']),
                            ),
                          );
                        },
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            // When edit is pressed, open photo update options
                            showUpdatePhotoOptions(
                                context, data['pengumpulan_id']);
                          },
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

  // Show options to update photo (before/after)
  void showUpdatePhotoOptions(BuildContext context, int pengumpulanId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Foto'),
        content: const Text('Pilih foto yang ingin diperbarui:'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              pickAndUploadImage('foto_sebelum', pengumpulanId);
            },
            child: const Text('Foto Sebelum'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              pickAndUploadImage('foto_sesudah', pengumpulanId);
            },
            child: const Text('Foto Sesudah'),
          ),
        ],
      ),
    );
  }

  Future<void> pickAndUploadImage(String fotoType, int pengumpulanId) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File imageFile = File(pickedFile.path);

      try {
        // FormData should use the correct types
        FormData formData = FormData.fromMap({
          'pengumpulan_id': pengumpulanId
              .toString(), // Ensure it's a string, as API might expect string
          fotoType: await MultipartFile.fromFile(imageFile.path),
        });

        Response response = await dio.post(urlUpdateStatus, data: formData);

        // Check if response is successful
        if (response.statusCode == 200 && response.data['success'] == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Foto berhasil diupdate!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content:
                    Text('Gagal mengupdate foto! ${response.data['message']}')),
          );
        }
      } catch (e) {
        print("Error uploading image: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal mengupload foto!')),
        );
      }
    }
  }
}

class TaskDetailScreen extends StatefulWidget {
  final int pengumpulanId;

  const TaskDetailScreen({super.key, required this.pengumpulanId});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  var taskDetail;

  @override
  void initState() {
    super.initState();
    fetchTaskDetail();
  }

  // Fetch task details
  void fetchTaskDetail() async {
    try {
      Response response = await dio.post(urlShowData, data: {
        'pengumpulan_id': widget.pengumpulanId,
      });
      print("Task Detail Response: ${response.data}");
      if (response.data['success'] == true) {
        setState(() {
          taskDetail = response.data['data'];
        });
      } else {
        setState(() {
          taskDetail = null;
        });
      }
    } catch (e) {
      print("Error fetching task detail: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to fetch task detail!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (taskDetail == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Detail Tugas')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Nama Tugas: ${taskDetail['tugas']['tugas_nama']}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
                'Nama Mahasiswa: ${taskDetail['mahasiswa']['mahasiswa_nama']}'),
            const SizedBox(height: 10),
            Text('Tanggal Pengumpulan: ${taskDetail['tanggal']}'),
            const SizedBox(height: 10),

            // Display before photo
            const SizedBox(height: 20),
            Text('Foto Sebelum:'),
            taskDetail['foto_sebelum'] != null
                ? Image.network(taskDetail['foto_sebelum'])
                : const Text('Foto belum tersedia'),

            const SizedBox(height: 10),

            // Display after photo
            Text('Foto Sesudah:'),
            taskDetail['foto_sesudah'] != null
                ? Image.network(taskDetail['foto_sesudah'])
                : const Text('Foto belum tersedia'),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Status Penugasan',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const DataListScreen(),
    );
  }
}
