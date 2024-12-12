import 'dart:convert';
import 'dart:math';
import 'package:sistem_kompen/config.dart';
import 'package:http/http.dart' as http;
import 'package:sistem_kompen/core/shared_prefix.dart';

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
          final nama = data['mahasiswa_nama'];
          final nim = data['nim'].toString();
          print("$data");
          print("$nama");
          // Kembalikan semua data dari respons JSON
          return {
            'success': true,
            'user_id': userId,
            'nama': nama,
            'nim': nim,
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
}
