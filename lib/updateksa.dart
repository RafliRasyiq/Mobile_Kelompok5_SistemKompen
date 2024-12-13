import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  followRedirects: true, // Mengaktifkan pengalihan otomatis
  maxRedirects: 5, // Batasi jumlah pengalihan
  validateStatus: (status) {
    // Mengizinkan status 302 tanpa menyebabkan exception
    return (status != null && status >= 200 && status < 300) || status == 302;
  },
));

var allData = [];
String urlDomain = "http://192.168.189.218:8000/";
String urlAllData = urlDomain + "api/all_data";
String urlShowData = urlDomain + "api/show_data";
String urlUpdateStatus = urlDomain + "api/update_status";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Status',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const DataListScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
      },
    );
  }
}

// Screen to display all tasks
class DataListScreen extends StatefulWidget {
  const DataListScreen({super.key});

  @override
  _DataListScreenState createState() => _DataListScreenState();
}

class _DataListScreenState extends State<DataListScreen> {
  String _searchQuery = ""; // Variabel untuk menyimpan query pencarian

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

  // Fungsi untuk menyaring data berdasarkan query pencarian
  List<dynamic> getFilteredData() {
    if (_searchQuery.isEmpty) {
      return allData; // Tampilkan semua data jika pencarian kosong
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
    List<dynamic> filteredData = getFilteredData(); // Data hasil filter

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
                  _searchQuery = value; // Perbarui query pencarian
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
                          data['tugas']['tugas_nama'], // Nama tugas
                          style: const TextStyle(
                            fontWeight:
                                FontWeight.bold, // Membuat nama tugas bold
                            fontSize: 18, // Memperbesar ukuran teks
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
                          mainAxisSize:
                              MainAxisSize.min, // Menjaga trailing tetap kecil
                          children: [
                            Icon(
                              data['status'] == 'terima' // Kondisi status
                                  ? Icons.check_circle
                                  : data['status'] == 'tolak'
                                      ? Icons.cancel
                                      : Icons
                                          .hourglass_empty, // Icon berubah sesuai status
                              color: data['status'] == 'terima'
                                  ? Colors.green // Warna hijau untuk diterima
                                  : data['status'] == 'tolak'
                                      ? Colors.red // Warna merah untuk ditolak
                                      : Colors
                                          .yellow, // Warna kuning untuk belum diperbarui
                              size: 24, // Ukuran ikon
                            ),
                            const SizedBox(
                                width: 5), // Memberi jarak antara ikon dan teks
                            Text(
                              data['status'] == 'terima'
                                  ? 'Diterima'
                                  : data['status'] == 'tolak'
                                      ? 'Ditolak'
                                      : 'Belum Dicek', // Status dalam teks
                              style: const TextStyle(
                                fontSize: 16, // Memperbesar ukuran teks
                                fontWeight:
                                    FontWeight.bold, // Membuat teks bold
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

// Screen to display task details and update status
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
      Response response = await dio.post(urlShowData, data: {
        'pengumpulan_id': widget.pengumpulanId,
      });
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

  // Update task status to 'terima' without reason
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

  // Update task status to 'tolak' with reason
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

  // Dialog for tolak button to enter reason
  void showTolakDialog() {
    final TextEditingController alasanController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Masukkan Alasan Tolak'),
        content: TextField(
          controller: alasanController,
          maxLines: 3,
          decoration: const InputDecoration(hintText: "Alasan"),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              String alasan = alasanController.text.trim();
              if (alasan.isNotEmpty) {
                updateStatusTolak(alasan);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Alasan tidak boleh kosong!')),
                );
              }
            },
            child: const Text('kirim'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (taskDetail == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Task Detail'),
          centerTitle: true,
          backgroundColor: Colors.deepPurple,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            Text('Tugas: ${taskDetail['tugas']['tugas_nama']}'),
            const SizedBox(height: 10),
            Text(
                'Nama Mahasiswa: ${taskDetail['mahasiswa']['mahasiswa_nama']}'),
            const SizedBox(height: 10),
            Text('Tanggal Pengumpulan: ${taskDetail['tanggal']}'),
            const SizedBox(height: 10),
            Text('Status: ${taskDetail['status'] ?? 'Belum Dicek'}'),
            const SizedBox(height: 20),
            if (!isTaskAccepted && !isTaskRejected)
              ElevatedButton(
                onPressed: updateStatusTerima, // Directly accept without reason
                child: const Text('Terima Tugas'),
              ),
            if (!isTaskAccepted && !isTaskRejected)
              ElevatedButton(
                onPressed:
                    showTolakDialog, // Show dialog for entering rejection reason
                child: const Text('Tolak Tugas'),
              ),
          ],
        ),
      ),
    );
  }
}

// Login Screen (example)
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Example navigation
            Navigator.pushReplacementNamed(context, '/');
          },
          child: const Text('Login'),
        ),
      ),
    );
  }
}

// Unknown Route Screen
class UnknownRouteScreen extends StatelessWidget {
  const UnknownRouteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Unknown Route'),
        backgroundColor: Colors.deepPurple,
      ),
      body: const Center(
        child: Text('Route not found!'),
      ),
    );
  }
}
