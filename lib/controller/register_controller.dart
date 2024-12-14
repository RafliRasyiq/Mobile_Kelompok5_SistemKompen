import 'dart:convert';
import 'package:sistem_kompen/config.dart';
import 'package:http/http.dart' as http;
import 'package:sistem_kompen/core/shared_prefix.dart';

class RegisterController {
  final String base_domain;

  RegisterController(this.base_domain);

  Future<Map<String, dynamic>> register(
      String username,
      String password,
      String mahasiswa_nama,
      String nim,
      String no_telp,
      String jurusan,
      String prodi,
      String kelas) async {
    final url = Uri.parse(Config.register_endpoint);

    try {
      // Mengirim request POST
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'username': username,
          'password': password,
          'mahasiswa_nama': mahasiswa_nama,
          'nim': nim,
          'no_telp': no_telp,
          'jurusan': jurusan,
          'prodi': prodi,
          'kelas': kelas,
        }),
      );

      print("respon body= ${response.body}");

      // Memproses respons
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        print("Printed data $data");
        return {
          'status': true,
          'data': data,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'status': false,
          'message': error['message'] ?? 'Register Gagal',
        };
      }
    } catch (e) {
      // Menangani error
      return {
        'status': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}
