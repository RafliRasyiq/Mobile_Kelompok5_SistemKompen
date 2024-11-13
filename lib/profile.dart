import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final dio = Dio();
// var user_data;
Map<String, dynamic> user_data = {
  'username': '',
  'mahasiswa_nama': '',
  'nim': '',
  'jurusan': '',
  'prodi': '',
  'kelas': '',
  'no_telp': ''
};
final TextEditingController idController = TextEditingController();
final TextEditingController nameController = TextEditingController();
final TextEditingController usernameController = TextEditingController();
final TextEditingController phoneController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final TextEditingController confirmPasswordController = TextEditingController();

String url_domain = "http://192.168.1.4:8000/";
String url_user_data = url_domain + "api/user_data/1";
String url_update_data = url_domain + "api/edit_data";
String url_delete_data = url_domain + "api/delete_data";

class ProfilePage extends StatefulWidget {
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    fetchProfileData(); // Fetch data when the screen loads
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
      fetchProfileData();
    }
  }

  void fetchProfileData() async {
    try {
      final response = await dio.post(url_user_data);
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
        title: Text("Profile"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 20),
            CircleAvatar(
              radius: 50,
              child: Text(
                "RS",
                style: TextStyle(fontSize: 40),
              ),
            ),
            SizedBox(height: 20),
            ProfileInfoField(label: "Username", value: user_data["username"]),
            ProfileInfoField(
                label: "Nama Lengkap",
                value: user_data['mahasiswa_nama'] ?? ""),
            ProfileInfoField(
                label: "NIM", value: user_data['nim']?.toString() ?? ""),
            ProfileInfoField(
                label: "Jurusan", value: user_data['jurusan'] ?? ""),
            ProfileInfoField(
                label: "Program Studi", value: user_data['prodi'] ?? ""),
            ProfileInfoField(label: "Kelas", value: user_data['kelas'] ?? ""),
            ProfileInfoField(
                label: "No. Telephone",
                value: user_data['no_telp']?.toString() ?? ""),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _showEditProfileDialog(context),
              child: Text("Ubah Profil"),
            ),
            ElevatedButton(
              onPressed: () => _showEditPasswordDialog(context),
              child: Text("Ubah Password"),
            ),
            ElevatedButton(
              onPressed: () => _logout(context),
              child: Text("Log out"),
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

  ProfileInfoField({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(value),
        ],
      ),
    );
  }
}

class EditProfileDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ubah Profil'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: 'Nama Lengkap'),
            ),
            TextField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'No Telepon'),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            // Save profile changes logic here
            Navigator.of(context).pop();
          },
          child: Text("Ubah"),
        ),
      ],
    );
  }
}

class EditPasswordDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Ubah Password'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password Baru'),
              obscureText: true,
            ),
            TextField(
              controller: confirmPasswordController,
              decoration:
                  InputDecoration(labelText: 'Konfirmasi Password Baru'),
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
          child: Text("Batal"),
        ),
        ElevatedButton(
          onPressed: () {
            // Save new password logic here
            Navigator.of(context).pop();
          },
          child: Text("Ubah"),
        ),
      ],
    );
  }
}

/// 2. Update Profile Data Function
void updateProfileData(String username, String name, String noTelepon) async {
  try {
    Response response;
    response = await dio.post(
      url_update_data,
      queryParameters: {
        'mahasiswa_id': 1,
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
void updatePassword(String newPassword) async {
  try {
    Response response = await dio.post(
      url_update_data, // Replace with your actual Laravel controller URL
      queryParameters: {
        'password': newPassword,
      },
    );
    // Clear the password field after successful update
    passwordController.text = "";
    print("Password updated: ${response.data}");
  } catch (e) {
    print("Error updating password: $e");
  }
}
