import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:sistem_kompen/profile.dart';

final dio = Dio();
String url_domain = "http://192.168.67.74:8000/";
String url_login = url_domain + "api/login";

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String _errorMessage = '';
  bool _isHelpVisible = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 44.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 122),
              if (!_isHelpVisible)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Selamat Datang",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    Text(
                      "Silahkan login terlebih dahulu",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              if (_isHelpVisible)
                Column(
                  children: [
                    SizedBox(height: 32),
                    Text(
                      'Silahkan hubungi admin untuk bantuan lebih lanjut.',
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              SizedBox(height: 32),
              if (!_isHelpVisible)
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "Username",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 20,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan username terlebih dahulu';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 14),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: "Password",
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 20,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Masukkan password terlebih dahulu';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 14),
                      if (_errorMessage.isNotEmpty)
                        Text(
                          _errorMessage,
                          style: TextStyle(color: Colors.red),
                        ),
                    ],
                  ),
                ),
              SizedBox(height: 54),
              if (!_isHelpVisible)
                SizedBox(
                  width: double.infinity,
                  height: 58,
                  child: ElevatedButton(
                    onPressed: () {
                      _loginAction(_usernameController.text = '',
                          _passwordController.text = '');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF2D2766),
                    ),
                    child: Text(
                      "Login",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              SizedBox(height: 54),
              if (!_isHelpVisible)
                GestureDetector(
                  onTap: () {
                    _showHelpDialog(context);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Tidak bisa login?",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 4),
                      Text(
                        "Bantuan",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.orange,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _loginAction(String username, String password) async {
    try {
      Response response = await dio.post(url_login, queryParameters: {
        "username": username,
        "password": password,
      });
      usernameController.text = "";
      passwordController.text = "";
      if (response.data["status"] == "success") {
        print("data berhasil");
        String id = response.data["mahasiswa_id"];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ProfilePage(id: id)),
        );
      } else {
        print("gagal");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.data["Login Gagal"]),
            backgroundColor: Colors.red,
          ),
        );
      }
      ;
    } catch (e) {
      print("Error $e");
    }
    ;
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Bantuan'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Silahkan hubungi admin'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _isHelpVisible = false;
                });
              },
              child: Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
