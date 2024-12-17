import 'dart:convert';
import 'dart:math';
import 'package:sistem_kompen/config.dart';
import 'package:http/http.dart' as http;

class MahasiswaController {
  final String base_domain;

  MahasiswaController(this.base_domain);

  static Future<Map<String, dynamic>> profile(String token, String id) async {
    final url = Uri.parse(Config.mahasiswa_endpoint);

    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': id,
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        data['message'] = 'success';
        print("bagian ini sudah masuk");
        if (data['message'] == 'success') {
          final userId = data['user_id'].toString();
          final username = data['username'];
          final nama = data['mahasiswa_nama'];
          final nim = data['nim'].toString();
          final foto = data['foto'];
          final jurusan = data['jurusan'];
          final prodi = data['prodi'];
          final kelas = data['kelas'];
          final no_telp = data['no_telp'];
          print("$data");
          print("$nama");
          // Kembalikan semua data dari respons JSON
          return {
            'success': true,
            'user_id': userId,
            'username': username,
            'nama': nama,
            'nim': nim,
            'foto': '$foto',
            'jurusan': jurusan,
            'prodi': prodi,
            'kelas': kelas,
            'no_telp': no_telp,
            'message': "Data telah ditemukan"
          };
        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Data User tidak ditemukan.',
          };
        }
      } else {
        return {
          'success': false,
          'message':
              'Gagal mengambil data. Kode status: ${response.statusCode}',
        };
      }
    } catch (e) {}
    return {
      'success': false,
      'message': 'An error occurred: $e',
    };
  }

  Future<Map<String, dynamic>> updateProfileData(
      String token, String id, String username, String nama, String no_telp) async {
    final url = Uri.parse(Config.mahasiswa_update_profile_endpoint);
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': id,
          'username': username,
          'nama': nama,
          'no_telp': no_telp,
        }),
      );
      print("Profile updated: ${response.body}");
      final data = jsonDecode(response.body);
      return {
          'success': true,
          'data': data,
        };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  Future<Map<String, dynamic>> updatePassword(String token, String id, String password) async {
    final url = Uri.parse(Config.mahasiswa_update_password_endpoint);
    try {
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id': id,
          'password': password,
        }),
      );
      print("Profile updated: ${response.body}");
      final data = jsonDecode(response.body);
      return {
          'success': true,
          'data': data,
        };
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}
