import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final dio = Dio();
// var user_data;
Map<String, dynamic> user_data = {
  'mahasiswa_id': '',
  'username': '',
  'mahasiswa_nama': '',
  'nim': '',
  'jurusan': '',
  'prodi': '',
  'kelas': '',
  'no_telp': '',
  'password': '',
  'foto': ''
};
final TextEditingController idController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController usernameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

String url_domain = "http://192.168.67.179:8000/";
String url_user_data = "${url_domain}api/user_data";
String url_update_data = "${url_domain}api/edit_data";
String url_update_pass = "${url_domain}api/edit_pass";

class ProfilePage extends StatefulWidget {
  final String token;
  final String id;

  const ProfilePage({super.key, required this.token, required this.id});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchProfileData(widget.token); // Fetch data when the screen loads
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('MyApp state = $state');
    if (state == AppLifecycleState.resumed) {
      fetchProfileData(widget.token);
    }
  }

  void fetchProfileData(String token) async {
    try {
      final response = await dio.post(url_user_data, data: {'token': token});
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
              backgroundImage: user_data['foto'] != null &&
                      user_data['foto'].isNotEmpty
                  ? NetworkImage(
                      "http://your-backend-domain/${user_data['foto']}")
                  : const AssetImage('public/images/default.jpg') as ImageProvider,
              child: user_data['foto'] == null || user_data['foto'].isEmpty
                  ? const Text(
                      "RS",
                      style: TextStyle(fontSize: 40, color: Colors.white),
                    )
                  : null,
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                idController.text = user_data['mahasiswa_id'].toString();
                nameController.text = user_data['mahasiswa_nama'];
                usernameController.text = user_data['username'];
                phoneController.text = user_data['no_telp'].toString();
                _showEditProfileDialog(context);
                fetchProfileData;
              },
              child: const Text("Ubah Profil"),
            ),
            ElevatedButton(
              onPressed: () {
                idController.text = user_data['mahasiswa_id'].toString();
                _showEditPasswordDialog(context);
                fetchProfileData;
              },
              child: const Text("Ubah Password"),
            ),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: const Text("Log out"),
            ),
            // MaterialButton(
            //   color: Colors.grey,
            //   height: 40,
            //   minWidth: 100,
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //           builder: (context) =>
            //               ProfilePage(token: user_data['mahasiswa_id'])),
            //     );
            //   },
            //   child: const Text(
            //     "Refresh Data",
            //     style: TextStyle(color: Colors.white),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditProfileDialog();
      },
    );
  }

  void _showEditPasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditPasswordDialog();
      },
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

class EditProfileDialog extends StatelessWidget {
  const EditProfileDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah Profil'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Nama Lengkap'),
            ),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(labelText: 'No Telepon'),
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
            print("object");
            if (idController == "" ||
                usernameController == "" ||
                nameController == "" ||
                phoneController == "") {
              print("zero");
            } else {
              updateProfileData(idController.text, usernameController.text,
                  nameController.text, phoneController.text);
              Navigator.of(context).pop();
              AppLifecycleState.resumed;
            }
          },
          child: const Text("Ubah"),
        ),
      ],
    );
  }
}

class EditPasswordDialog extends StatelessWidget {
  const EditPasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Ubah Password'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password Baru'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration:
                  const InputDecoration(labelText: 'Konfirmasi Password Baru'),
              obscureText: true,
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
            print("object");
            if (idController == "" || passwordController == "") {
              print("zero");
            } else {
              updatePassword(idController.text, passwordController.text);
              Navigator.of(context).pop();
              AppLifecycleState.resumed;
            }
          },
          child: const Text("Ubah"),
        ),
      ],
    );
  }
}

/// 2. Update Profile Data Function
void updateProfileData(
    String id, String username, String name, String noTelepon) async {
  try {
    Response response;
    response = await dio.post(
      url_update_data,
      queryParameters: {
        'mahasiswa_id': id,
        'username': username,
        'mahasiswa_nama': name,
        'no_telp': noTelepon,
      },
    );
    idController.text = "";
    usernameController.text = "";
    nameController.text = "";
    phoneController.text = "";
    print("Profile updated: ${response.data}");
  } catch (e) {
    print("Error updating profile data: $e");
  }
}

/// 3. Update Password Function
void updatePassword(String id, String newPassword) async {
  try {
    Response response = await dio.post(
      url_update_pass, // Replace with your actual Laravel controller URL
      queryParameters: {
        'mahasiswa_id': id,
        'password': newPassword,
      },
    );
    // Clear the password field after successful update
    idController.text = "";
    passwordController.text = "";
    print("Password updated: ${response.data}");
  } catch (e) {
    print("Error updating password: $e");
  }
}
