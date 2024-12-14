import 'package:flutter/material.dart';
import 'package:sistem_kompen/config.dart';
import 'package:sistem_kompen/controller/kompen_controller.dart';
import 'package:sistem_kompen/core/shared_prefix.dart';

class DetailMahasiswaAlpha extends StatefulWidget {
  final String token;
  final String id;

  const DetailMahasiswaAlpha(
      {super.key, required this.token, required this.id});

  @override
  _DetailAlphaPageState createState() => _DetailAlphaPageState();
}

class _DetailAlphaPageState extends State<DetailMahasiswaAlpha> {
  final url = Uri.parse(Config.base_domain);

  String userId = '';
  String username = 'Loading...';
  String nama = 'Loading...';
  String nim = 'Loading...';
  String foto = 'Loading...';
  String jurusan = 'Loading...';
  String prodi = 'Loading...';
  String kelas = 'Loading...';
  String noTelp = 'Loading...';
  String alpha = 'Loading...';
  String poin = 'Loading...';
  String status = 'Loading...';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _detailAlphaData(); // Use the provided ID
  }

  Future<void> _detailAlphaData() async {
    try {
      // Ambil token dari SharedPreferences jika diperlukan
      final token = await Sharedpref.getToken();

      if (token == '') {
        throw Exception('Token is missing');
      }

      final data = await KompenController.detailAlpha(token, widget.id);

      setState(() {
        userId = data['user_id'] ?? '-';
        username = data['username'] ?? '-';
        nama = data['nama'] ?? '-';
        nim = data['nim'] ?? '-';
        foto = data['foto'] ?? '-';
        jurusan = data['jurusan'] ?? '-';
        prodi = data['prodi'] ?? '-';
        kelas = data['kelas'] ?? '-';
        noTelp = data['no_telp'] ?? '-';
        alpha = data['alpha'] ?? '-';
        poin = data['poin'] ?? '-';
        status = data['status'] ?? '-';
      });
      print(data['message']);
    } catch (e) {
      print('Error loading dashboard data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: 100,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Rectangle 9.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 30,
                  right: 30,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: foto.isNotEmpty
                        ? NetworkImage("$url/$foto")
                        : const AssetImage('assets/images/default_profile.png')
                            as ImageProvider,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 60),
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
                        alpha,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
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
                        poin,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      const Text(
                        "Status",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        status,
                        style: const TextStyle(
                            fontSize: 16, color: Colors.black54),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 60),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                children: <Widget>[
                  ProfileInfoField(label: "Username", value: username),
                  ProfileInfoField(label: "Nama Lengkap", value: nama),
                  ProfileInfoField(label: "NIM", value: nim),
                  ProfileInfoField(label: "Jurusan", value: jurusan),
                  ProfileInfoField(label: "Program Studi", value: prodi),
                  ProfileInfoField(label: "Kelas", value: kelas),
                  ProfileInfoField(label: "No. Telephone", value: noTelp),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
