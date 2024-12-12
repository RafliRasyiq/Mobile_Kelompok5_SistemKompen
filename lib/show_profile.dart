import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final dio = Dio();
// var user_data;
Map<String, dynamic> user_data = {
  'mahasiswa_id': '',
  'username': '',
  'mahasiswa_nama': '',
  'nim': '',
  'foto': '',
  'jurusan': '',
  'prodi': '',
  'kelas': '',
  'no_telp': '',
  'sakit': '',
  'izin': '',
  'alpha': '',
};

String url_domain = "http://192.168.67.179:8000/";
String url_show_data = "${url_domain}api/show_data";

class ShowProfilePage extends StatefulWidget {
  final String mahasiswaId;

  const ShowProfilePage({super.key, required this.mahasiswaId});

  @override
  State<ShowProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ShowProfilePage>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchProfileData(widget.mahasiswaId); // Use the provided ID
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void fetchProfileData(String id) async {
    try {
      final response = await dio.post(
        url_show_data,
        data: {'id': id}, // Pass the ID in the request body
      );
      if (response.data != null && response.data is Map<String, dynamic>) {
        setState(() {
          user_data = response.data;
        });
      } else {
        print("Unexpected data format: ${response.data}");
        setState(() {
          user_data = {}; // Set to an empty map to avoid null issues
        });
      }
    } catch (e) {
      print("Error loading data: $e");
      setState(() {
        user_data = {}; // Set to an empty map to avoid null issues
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/daftarAlpha');
          },
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              backgroundImage:
                  user_data['foto'] != null && user_data['foto'].isNotEmpty
                      ? NetworkImage(
                          "http://your-backend-domain/${user_data['foto']}")
                      : const AssetImage('public/images/default.jpg')
                          as ImageProvider,
              child: user_data['foto'] == null || user_data['foto'].isEmpty
                  ? const Text(
                      "RS",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    )
                  : null,
            ),
            const SizedBox(height: 20),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Column(
                    children: [
                      const Text(
                        "Alpha",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user_data['alpha']?.toString() ?? "?",
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Poin",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user_data['poin']?.toString() ?? "?",
                        style: const TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: <Widget>[
                  ProfileInfoField(
                      label: "Username", value: user_data["username"]),
                  ProfileInfoField(
                      label: "Nama Lengkap",
                      value: user_data['mahasiswa_nama'] ?? ""),
                  ProfileInfoField(
                      label: "NIM", value: user_data['nim']?.toString() ?? ""),
                  ProfileInfoField(
                      label: "Jurusan", value: user_data['jurusan'] ?? ""),
                  ProfileInfoField(
                      label: "Program Studi", value: user_data['prodi'] ?? ""),
                  ProfileInfoField(
                      label: "Kelas", value: user_data['kelas'] ?? ""),
                  ProfileInfoField(
                      label: "No. Telephone",
                      value: user_data['no_telp']?.toString() ?? ""),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    // Handle logout logic here
    Navigator.of(context).pushReplacementNamed('/login');
  }
}

class ProfileInfoField extends StatelessWidget {
  final String label;
  final String value;

  const ProfileInfoField({super.key, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
