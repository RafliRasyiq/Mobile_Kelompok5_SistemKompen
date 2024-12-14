import 'package:flutter/material.dart';
import 'package:sistem_kompen/controller/mahasiswa_controller.dart';
import 'package:sistem_kompen/core/shared_prefix.dart';
import 'package:sistem_kompen/mahasiswa/homepage_mahasiswa.dart';
import 'package:sistem_kompen/login/login.dart';
import '../config.dart';

final TextEditingController _idController = TextEditingController();

class ProfileMahasiswa extends StatefulWidget {
  final String token;
  final String id;

  const ProfileMahasiswa({super.key, required this.token, required this.id});

  @override
  _ProfileMahasiswaState createState() => _ProfileMahasiswaState();
}

class _ProfileMahasiswaState extends State<ProfileMahasiswa> {
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

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _profileData(); // Fetch data when the screen loads
  }

  Future<void> _profileData() async {
    try {
      // Ambil token dari SharedPreferences jika diperlukan
      final token = await Sharedpref.getToken();
      final user_id = await Sharedpref.getUserId();

      if (token == '') {
        throw Exception('Token is missing');
      }

      final data = await MahasiswaController.profile(token, user_id);

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
        backgroundColor: const Color(0xFF2D2766),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      DashboardMahasiswa(token: widget.token, id: widget.id)),
            );
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
            ElevatedButton(
              onPressed: () {
                _idController.text = userId;
                _showEditProfileDialog(context);
              },
              child: const Text("Ubah Profil"),
            ),
            ElevatedButton(
              onPressed: () {
                _idController.text = userId;
                _showEditPasswordDialog(context);
              },
              child: const Text("Ubah Password"),
            ),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text("Log out"),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProfileDialog(token: widget.token, id: widget.id);
      },
    );
  }

  void _showEditPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPasswordDialog(token: widget.token, id: widget.id);
      },
    );
  }

  void _logout(BuildContext context) {
    // Handle logout logic here
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
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

class EditProfileDialog extends StatelessWidget {
  final String token;
  final String id;

  EditProfileDialog({super.key, required this.token, required this.id});

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _teleponController = TextEditingController();
  final MahasiswaController _mahasiswaController =
      MahasiswaController(Config.mahasiswa_update_profile_endpoint);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah Profil'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
              minLines: 1,
              maxLength: 50,
            ),
            TextField(
              controller: _usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
              minLines: 1,
              maxLength: 20,
            ),
            TextField(
              controller: _teleponController,
              decoration: const InputDecoration(labelText: 'No Telepon'),
              minLines: 1,
              maxLength: 20,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_usernameController.text == "" ||
                _nameController.text == "" ||
                _teleponController.text == "") {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Inputan masih kosong')),
              );
              Navigator.of(context).pop();
            } else {
              _mahasiswaController.updateProfileData(
                  token,
                  _idController.text,
                  _usernameController.text,
                  _nameController.text,
                  _teleponController.text);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfileMahasiswa(token: token, id: id)),
              );
            }
          },
          child: const Text("Ubah"),
        ),
      ],
    );
  }
}

class EditPasswordDialog extends StatelessWidget {
  final String token;
  final String id;

  EditPasswordDialog({super.key, required this.token, required this.id});

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final MahasiswaController _mahasiswaController =
      MahasiswaController(Config.mahasiswa_update_profile_endpoint);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah Password'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: _passwordController,
              decoration: const InputDecoration(labelText: 'Password Baru'),
              obscureText: true,
              minLines: 1,
              maxLength: 20,
            ),
            TextField(
              controller: _confirmPasswordController,
              decoration:
                  const InputDecoration(labelText: 'Konfirmasi Password Baru'),
              obscureText: true,
              minLines: 1,
              maxLength: 20,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            if (_passwordController.text == "") {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Inputan masih kosong')),
              );
            } else if (_passwordController.text !=
                _confirmPasswordController.text) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Konfirmasi password tidak sesuai')),
              );
            } else {
              _mahasiswaController.updatePassword(
                  token, _idController.text, _passwordController.text);
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfileMahasiswa(token: token, id: id)),
              );
            }
          },
          child: const Text("Ubah"),
        ),
      ],
    );
  }
}
