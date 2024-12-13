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
String urlDomain = "http://192.168.1.8:8000/";
String urlAllData = urlDomain + "api/all_data";
String urlShowData = urlDomain + "api/show_data/";
String urlUpdateStatus = urlDomain + "api/update_status/";

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
        // Menambahkan rute untuk login
        '/login': (context) => const LoginScreen(),
      },
      onGenerateRoute: (settings) {
        // Menangani rute yang tidak dikenal
        if (settings.name == '/login') {
          return MaterialPageRoute(builder: (context) => const LoginScreen());
        }
        return null;
      },
      // Tentukan onUnknownRoute untuk menangani rute yang tidak dikenali
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (context) => const UnknownRouteScreen());
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
                                  taskId: data['pengumpulan_id']),
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
  final int taskId;

  const TaskDetailScreen({super.key, required this.taskId});

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
      Response response = await dio.get('$urlShowData${widget.taskId}');
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
      print("Error fetching task details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load task details!')),
      );
    }
  }

  // Full URL for image path
  String fullImageUrl(String? imagePath) {
    if (imagePath != null && !imagePath.startsWith('http')) {
      return urlDomain + imagePath; // Prepend domain to relative image path
    }
    return imagePath ?? '';
  }

  @override
  Widget build(BuildContext context) {
    if (taskDetail == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Loading...'),
          backgroundColor: Colors.deepPurple,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Tugas'),
        backgroundColor: Colors.deepPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  'Nama Mahasiswa: ${taskDetail['mahasiswa']['mahasiswa_nama']}'),
              Text('Nama Tugas: ${taskDetail['tugas']['tugas_nama']}'),
              Text('Deskripsi: ${taskDetail['tugas']['deskripsi']}'),
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Foto Sebelum'),
                            content: Image.network(
                                fullImageUrl(taskDetail['foto_sebelum'])),
                          );
                        },
                      );
                    },
                  ),
                  const Text('Foto Sebelum'),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Foto Sesudah'),
                            content: Image.network(
                                fullImageUrl(taskDetail['foto_sesudah'])),
                          );
                        },
                      );
                    },
                  ),
                  const Text('Foto Sesudah'),
                ],
              ),
              const SizedBox(height: 10),
              Text('Tanggal: ${taskDetail['tanggal']}'),
              const SizedBox(height: 10),
              Text('Status: ${taskDetail['status'] ?? 'Belum Diperbarui'}'),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: isTaskAccepted || isTaskRejected
                        ? null
                        : () {
                            updateStatus('terima');
                          },
                    child: const Text('Terima'),
                  ),
                  ElevatedButton(
                    onPressed: isTaskAccepted || isTaskRejected
                        ? null
                        : () {
                            updateStatus('tolak');
                          },
                    child: const Text('Tolak'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Update task status (accept/reject)
  void updateStatus(String status) async {
    String alasan = '';
    if (status == 'tolak') {
      // Dialog untuk memasukkan alasan penolakan
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Masukkan Alasan'),
            content: TextField(
              onChanged: (value) {
                alasan = value; // Menyimpan alasan dari inputan user
              },
              decoration: const InputDecoration(hintText: 'Alasan penolakan'),
            ),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  _sendUpdateStatus(status, alasan);
                },
                child: const Text('Kirim'),
              ),
            ],
          );
        },
      );
    } else {
      _sendUpdateStatus(status, alasan);
    }
  }

  // Send status update to the server
  void _sendUpdateStatus(String status, String alasan) async {
    try {
      var data = {
        'status': status,
        'alasan': alasan,
      };

      // Tidak perlu mengonversi taskId lagi, biarkan tetap int
      Response response = await dio.post(
        '$urlUpdateStatus${widget.taskId}', // Menggunakan taskId sebagai int dalam URL
        data: data,
      );

      print("Update Response: ${response.data}");

      // Memastikan response data sesuai dengan format yang diinginkan
      if (response.data['success'] == true) {
        setState(() {
          taskDetail['status'] = status;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Status berhasil diperbarui')),
        );
      } else {
        print('API response error: ${response.data}');
      }
    } catch (e) {
      print("Error updating status: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui status!')),
      );
    }
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
