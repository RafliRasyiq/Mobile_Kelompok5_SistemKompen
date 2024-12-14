import 'dart:convert';
import 'dart:math';
import 'package:sistem_kompen/config.dart';
import 'package:http/http.dart' as http;

class KompenController {
  final String base_domain;

  KompenController(this.base_domain);
  static Future<Map<String, dynamic>> detailAlpha(
      String token, String id) async {
    final url = Uri.parse(Config.show_mhs_alpha_endpoint);
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
          final userId = data['mahasiswa_id'].toString();
          final username = data['username'];
          final nama = data['mahasiswa_nama'];
          final nim = data['nim'].toString();
          final foto = data['foto'];
          final jurusan = data['jurusan'];
          final prodi = data['prodi'];
          final kelas = data['kelas'];
          final no_telp = data['no_telp'];
          final alpha = data['alpha'].toString();
          final poin = data['poin'].toString();
          final status = data['status'].toString();
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
            'alpha': alpha,
            'poin': poin,
            'status': status,
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
