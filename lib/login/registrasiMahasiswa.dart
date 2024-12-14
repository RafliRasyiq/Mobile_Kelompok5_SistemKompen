import 'package:flutter/material.dart';
import 'package:sistem_kompen/controller/register_controller.dart';
import 'package:sistem_kompen/login/login.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../config.dart';
import '../controller/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: const [
              RegistrasiMahasiswa(),
            ],
          ),
        ),
      ),
    );
  }
}

class RegistrasiMahasiswa extends StatefulWidget {
  const RegistrasiMahasiswa({super.key});

  @override
  _RegistrasiMahasiswaState createState() => _RegistrasiMahasiswaState();
}

class _RegistrasiMahasiswaState extends State<RegistrasiMahasiswa> {
  final TextEditingController namaLengkapController = TextEditingController();
  final TextEditingController nimController = TextEditingController();
  final TextEditingController jurusanController = TextEditingController();
  final TextEditingController programStudiController = TextEditingController();
  final TextEditingController kelasController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController noTelponController = TextEditingController();
  final RegisterController _registrasiMahasiswa =
      RegisterController(Config.base_domain);

  String? selectedJurusan; // Untuk menyimpan pilihan jurusan
  String? selectedProgramStudi; // Untuk menyimpan pilihan program studi

  final List<String> jurusanOptions = [
    "Teknologi Informasi",
  ];

  final List<String> programStudiOptions = [
    "Teknik Informatika",
    "Sistem Informasi Bisnis",
  ];

  Future<void> _register(BuildContext context) async {
    final namaLengkap = namaLengkapController.text;
    final nim = nimController.text;
    final jurusan = jurusanController.text;
    final programStudi = programStudiController.text;
    final kelas = kelasController.text;
    final noTelpon = noTelponController.text;
    final username = usernameController.text;
    final password = passwordController.text;

    if (namaLengkap.isNotEmpty &&
        nim.isNotEmpty &&
        jurusan.isNotEmpty &&
        programStudi.isNotEmpty &&
        kelas.isNotEmpty &&
        username.isNotEmpty &&
        password.isNotEmpty) {
      try {
        final result = await _registrasiMahasiswa.register(username, password,
            namaLengkap, nim, noTelpon, jurusan, programStudi, kelas);
        print(result['success']);
        print(result['data']);
        if (result['success'] == true) {
          print('Pendaftaran berhasil!');
          // Call the success dialog
          // ignore: use_build_context_synchronously
          _showSuccessDialog(context); // Pass the context here
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(result['message'] ?? 'Registrasi gagal')),
          );
        }
      } catch (e) {
        print("error $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Terjadi kesalahan pada registrasi.')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua bidang wajib diisi!')),
      );
    }
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Registrasi berhasil!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                );
              },
              child: const Text('Ke halaman Login'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrasi Mahasiswa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              TextField(
                controller: namaLengkapController,
                decoration: InputDecoration(
                  labelText: "Nama Lengkap",
                  labelStyle: const TextStyle(
                    color: Color(0xFF2C2260), // Warna label
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2C2260), // Warna border saat fokus
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2C2260), // Warna border saat tidak fokus
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: nimController,
                decoration: InputDecoration(
                  labelText: "NIM",
                  labelStyle: const TextStyle(
                    color: Color(0xFF2C2260), // Warna label
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2C2260), // Warna border saat fokus
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2C2260), // Warna border saat tidak fokus
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: noTelponController,
                decoration: InputDecoration(
                  labelText: "Nomor Telepon",
                  labelStyle: const TextStyle(
                    color: Color(0xFF2C2260), // Warna label
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2C2260), // Warna border saat fokus
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2C2260), // Warna border saat tidak fokus
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Jurusan",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                value: selectedJurusan,
                items: jurusanOptions
                    .map((jurusan) => DropdownMenuItem(
                          value: jurusan,
                          child: Text(jurusan),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedJurusan = value;
                    jurusanController.text = value ?? "";
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Program Studi",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                value: selectedProgramStudi,
                items: programStudiOptions
                    .map((prodi) => DropdownMenuItem(
                          value: prodi,
                          child: Text(prodi),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedProgramStudi = value;
                    programStudiController.text = value ?? "";
                  });
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: kelasController,
                decoration: InputDecoration(
                  labelText: "Kelas",
                  labelStyle: const TextStyle(
                    color: Color(0xFF2C2260), // Warna label
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2C2260), // Warna border saat fokus
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2C2260), // Warna border saat tidak fokus
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: const TextStyle(
                    color: Color(0xFF2C2260), // Warna label
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2C2260), // Warna border saat fokus
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2C2260), // Warna border saat tidak fokus
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: const TextStyle(
                    color: Color(0xFF2C2260), // Warna label
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2C2260), // Warna border saat fokus
                      width: 2.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(
                      color: Color(0xFF2C2260), // Warna border saat tidak fokus
                      width: 1.0,
                    ),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity, // Tombol memenuhi lebar layar
                child: ElevatedButton(
                  onPressed: () {
                    _register(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2260), // Warna tombol
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0), // Padding vertikal
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Border tombol
                    ),
                  ),
                  child: const Text(
                    'Register',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
