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

  @override
  Widget build(BuildContext context) {
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
                hintText: 'Cari...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: RefreshIndicator(
                onRefresh: fetchAllData, // Refresh function
                child: ListView.builder(
                  itemCount: allData.length,
                  itemBuilder: (context, index) {
                    var data = allData[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        title: Text(data['tugas']['tugas_nama']),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                                'Nama Mahasiswa: ${data['mahasiswa']['mahasiswa_nama']}'),
                            Text('Tanggal: ${data['tanggal']}'),
                            Text(
                                'Status: ${data['status'] ?? 'Belum Diperbarui'}'),
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
            Text('Status: ${taskDetail['status'] ?? 'Belum Diperbarui'}'),
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
