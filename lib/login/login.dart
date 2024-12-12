import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistem_kompen/dosen.dart';
import 'package:sistem_kompen/mahasiswa.dart';
import 'package:sistem_kompen/tendik.dart';
import '../config.dart';
import '../controller/login_controller.dart';
import '../dosen/homepage_dosen.dart';
import '../mahasiswa/homepage_mahasiswa.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            children: const [
              LoginForm(),
            ],
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LoginController _loginController = LoginController(Config.base_domain);
  final _formKey = GlobalKey<FormState>();

  final String _errorMessage = '';
  bool _isHelpVisible = false;

  Future<void> _handleLogin(BuildContext context) async {
    String username = _usernameController.text.trim();
    String password = _passwordController.text.trim();

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Username dan Password harus diisi')),
      );
      return;
    }

    final result = await _loginController.login(username, password);
    try {
      if (result['success']) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', result['data']['token']);
      await prefs.setString('user_id', result['data']['user']['user_id']!.toString());
      int levelId = result['data']['user']['level_id'];
      String userId = result['data']['user']['user_id']!.toString();
      if (levelId == 2) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DosenPage(token: result['data']['token'], id: userId)),
        );
      } else if (levelId == 3) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                TendikPage(token: result['data']['token'], id: userId),
          ),
        );
      } else if (levelId == 5) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MahasiswaPage(token: result['data']['token'], id: userId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pengguna tidak valid')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Login gagal')),
      );
    }
    } catch (e) {
      print("error $e");
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 44.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 122),
            if (!_isHelpVisible)
              const Column(
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
              const Column(
                children: [
                  SizedBox(height: 32),
                  Text(
                    'Silahkan hubungi admin untuk bantuan lebih lanjut.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            const SizedBox(height: 32),
            if (!_isHelpVisible)
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
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
                    const SizedBox(height: 14),
                    if (_errorMessage.isNotEmpty)
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 54),
            if (!_isHelpVisible)
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton(
                  onPressed: () {
                    _handleLogin(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D2766),
                  ),
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            const SizedBox(height: 54),
            if (!_isHelpVisible)
              GestureDetector(
                onTap: () {
                  _showHelpDialog(context);
                },
                child: const Row(
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
    );
  }

  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Bantuan'),
          content: const Column(
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
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }



  // @override
  // Widget build(BuildContext context) {
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final screenHeight = MediaQuery.of(context).size.height;

  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Text(
  //         'LOGIN',
  //         style: GoogleFonts.poppins(
  //           color: Colors.black,
  //           fontSize: 40,
  //           fontWeight: FontWeight.bold,
  //         ),
  //       ),
  //       SizedBox(height: screenHeight * 0.03),
  //       Container(
  //         width: screenWidth * 0.85,
  //         padding: const EdgeInsets.all(20.0),
  //         decoration: BoxDecoration(
  //           color: const Color(0xFF0D47A1),
  //           borderRadius: BorderRadius.circular(20),
  //         ),
  //         child: Column(
  //           children: [
  //             Align(
  //               alignment: Alignment.centerLeft,
  //               child: Text(
  //                 'Username',
  //                 style: GoogleFonts.montserrat(
  //                   color: Colors.white,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Container(
  //               height: 50,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: TextField(
  //                 controller: _usernameController,
  //                 decoration: const InputDecoration(
  //                   contentPadding: EdgeInsets.symmetric(horizontal: 20),
  //                   border: InputBorder.none,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 20),
  //             Align(
  //               alignment: Alignment.centerLeft,
  //               child: Text(
  //                 'Password',
  //                 style: GoogleFonts.montserrat(
  //                   color: Colors.white,
  //                   fontSize: 20,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 10),
  //             Container(
  //               height: 50,
  //               decoration: BoxDecoration(
  //                 color: Colors.white,
  //                 borderRadius: BorderRadius.circular(20),
  //               ),
  //               child: TextField(
  //                 controller: _passwordController,
  //                 obscureText: true,
  //                 decoration: const InputDecoration(
  //                   contentPadding: EdgeInsets.symmetric(horizontal: 20),
  //                   border: InputBorder.none,
  //                 ),
  //               ),
  //             ),
  //             const SizedBox(height: 30),
  //             ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: const Color(0xFFEFB509),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(20),
  //                 ),
  //                 minimumSize: const Size(100, 40),
  //               ),
  //               onPressed: () {
  //                 _handleLogin(context);
  //               },
  //               child: Text(
  //                 'LOGIN',
  //                 style: GoogleFonts.poppins(
  //                   color: Colors.black,
  //                   fontSize: 16,
  //                 ),
  //               ),
  //             ),
  //           ],
  //         ),
  //       ),
  //     ],
  //   );
  // }
}
