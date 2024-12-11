import 'dart:convert';
import 'package:sistem_kompen/config.dart';
import 'package:http/http.dart' as http;
import 'package:sistem_kompen/core/shared_prefix.dart';

class LoginController {
  final String base_domain;

  LoginController(this.base_domain);

  //method untuk login
  Future<Map<String, dynamic>> login(String username, String password) async{
    final url = Uri.parse(Config.login_endpoint);

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
        }),
      );

      print(response.body);

      // Memproses respons
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Menyimpan token ke shared preferences
        await Sharedpref.saveToken(data['token']);
        print('Token: ${data['token']}');
        return {
          'success': true,
          'data': data,
        };
      } else {
        final error = jsonDecode(response.body);
        return {
          'success': false,
          'message': error['message'] ?? 'Login Gagal',
        };
      }
    } catch (e) {
      // Menangani error
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }
}
