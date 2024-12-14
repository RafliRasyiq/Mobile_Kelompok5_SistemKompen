import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'config.dart'; // import the Dio and URLs

var allData = [];
String _searchQuery = ""; // Search query for filtering

class DataListScreen extends StatefulWidget {
  const DataListScreen({super.key});

  @override
  _DataListScreenState createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    fetchAllData();
  }

  // Fetch all tasks data
  // Fetch all tasks data
  Future<void> fetchAllData() async {
    try {
      Response response = await dio.get(
        urlAllData,
        options: Options(
          headers: {
            'Authorization':
                'Bearer $userToken',
          },
        ),
      );
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TaskDetailScreen(
                                  pengumpulanId: data['pengumpulan_id']),
                            ),
                          );
                        },
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

class TaskDetailScreen extends StatefulWidget {
  final int pengumpulanId;

  const TaskDetailScreen({super.key, required this.pengumpulanId});

  @override
  _TaskDetailScreenState createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  var taskDetail;
  bool isTaskAccepted = false;
  bool isTaskRejected = false;

  @override
  void initState() {
    super.initState();
    fetchTaskDetail();
  }

  // Fetch task details
  void fetchTaskDetail() async {
    try {
      Response response = await dio.post(
        urlShowData,
        data: {
          'pengumpulan_id': widget.pengumpulanId,
        },
        options: Options(
          headers: {
            'Authorization':
                'Bearer $userToken',
          },
        ),
      );
      print("Task Detail Response: ${response.data}");
      if (response.data['success'] == true) {
        setState(() {
          taskDetail = response.data['data'];
          isTaskAccepted = taskDetail['status'] == 'terima';
          isTaskRejected = taskDetail['status'] == 'tolak';
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

  // Update task status to 'terima' (accepted)
  void updateStatusTerima() async {
    try {
      Response response = await dio.post(urlUpdateStatus, data: {
        'status': 'terima',
        'pengumpulan_id': widget.pengumpulanId,
      });

      if (response.data['success'] == true) {
        fetchTaskDetail(); // Refresh task detail after update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status updated to Terima!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update status!')),
        );
      }
    } catch (e) {
      print("Error updating status to 'terima': $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status!')),
      );
    }
  }

  // Update task status to 'tolak' (rejected) with reason
  void updateStatusTolak(String alasan) async {
    try {
      Response response = await dio.post(urlUpdateStatus, data: {
        'status': 'tolak',
        'alasan': alasan,
        'pengumpulan_id': widget.pengumpulanId,
      });

      if (response.data['success'] == true) {
        fetchTaskDetail(); // Refresh task detail after update
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status updated to Tolak!')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update status!')),
        );
      }
    } catch (e) {
      print("Error updating status to 'tolak': $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status!')),
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
            Text('Status: ${taskDetail['status']}'),
            const SizedBox(height: 10),

            // Conditionally show the rejection reason (alasan) if the status is 'tolak'
            if (taskDetail['status'] == 'tolak')
              Text('Alasan Tolak: ${taskDetail['alasan']}'),
            const SizedBox(height: 20),
// Display Foto Sebelum and Foto Sesudah images if available
            if (taskDetail['foto_sebelum'] != null &&
                taskDetail['foto_sebelum'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Foto Sebelum:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 200, // Adjust width as needed
                    height: 200, // Adjust height as needed
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: taskDetail['foto_sebelum'] != null &&
                                taskDetail['foto_sebelum'].isNotEmpty
                            ? NetworkImage(
                                "http://your-backend-domain/${taskDetail['foto_sebelum']}")
                            : const AssetImage('assets/images/default.jpg')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius
                          .zero, // This makes it a square with sharp edges
                      border: Border.all(
                        color: Colors.grey, // Optional: Add border if you want
                        width: 1,
                      ),
                    ),
                    child: taskDetail['foto_sebelum'] == null ||
                            taskDetail['foto_sebelum'].isEmpty
                        ? const Center(
                            child: Text(
                              "FS", // Placeholder text
                              style:
                                  TextStyle(fontSize: 40, color: Colors.white),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            const SizedBox(height: 20),
            if (taskDetail['foto_sesudah'] != null &&
                taskDetail['foto_sesudah'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Foto Sesudah:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Container(
                    width: 200, // Adjust width as needed
                    height: 200, // Adjust height as needed
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: taskDetail['foto_sesudah'] != null &&
                                taskDetail['foto_sesudah'].isNotEmpty
                            ? NetworkImage(
                                "http://your-backend-domain/${taskDetail['foto_sesudah']}")
                            : const AssetImage('assets/images/default.jpg')
                                as ImageProvider,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius
                          .zero, // This makes it a square with sharp edges
                      border: Border.all(
                        color: Colors.grey, // Optional: Add border if you want
                        width: 1,
                      ),
                    ),
                    child: taskDetail['foto_sesudah'] == null ||
                            taskDetail['foto_sesudah'].isEmpty
                        ? const Center(
                            child: Text(
                              "FS", // Placeholder text
                              style:
                                  TextStyle(fontSize: 40, color: Colors.white),
                            ),
                          )
                        : null,
                  ),
                ],
              ),
            const SizedBox(height: 20),

            // Buttons for changing the status
            if (!isTaskAccepted && !isTaskRejected)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: updateStatusTerima,
                    child: const Text('Terima'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      // Show dialog to get rejection reason
                      String alasan = '';
                      final result = await showDialog<String>(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: const Text('Alasan Tolak'),
                          content: TextField(
                            autofocus: true,
                            decoration: const InputDecoration(
                              hintText: 'Masukkan alasan',
                            ),
                            onChanged: (value) {
                              setState(() {
                                alasan = value;
                              });
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context, ''),
                              child: const Text('Batal'),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pop(context, alasan),
                              child: const Text('Tolak'),
                            ),
                          ],
                        ),
                      );

                      // If a reason is provided, update the status to 'tolak'
                      if (result != null && result.isNotEmpty) {
                        updateStatusTolak(result);
                      }
                    },
                    child: const Text('Tolak'),
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
