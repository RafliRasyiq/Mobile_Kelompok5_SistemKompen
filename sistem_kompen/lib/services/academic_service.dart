import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../mahasiswa/academic_period.dart';
import '../config.dart';
import 'package:path_provider/path_provider.dart';

class AcademicService {
  static const String baseUrl = Config.base_domain;

  Future<List<AcademicPeriod>> getAcademicPeriods() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    final response = await http.post(
      Uri.parse('$baseUrl/api/kompen/list_mhs_kompen'),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> jsonResponse = json.decode(response.body);
      if (jsonResponse['success']) {
        return (jsonResponse['data'] as List)
            .map((item) => AcademicPeriod.fromJson(item))
            .toList();
      }
    } else if (response.statusCode == 401) {
      throw Exception('Unauthorized access');
    }
    throw Exception('Failed to load academic periods');
  }

  Future<String> downloadPdf(int mahasiswaId) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) {
      throw Exception('Token not found');
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/kompen/hasil/$mahasiswaId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        Directory? downloadsDir;
        if (Platform.isAndroid) {
          downloadsDir = Directory('/storage/emulated/0/Download');
        } else if (Platform.isIOS) {
          downloadsDir = await getApplicationDocumentsDirectory();
        }

        if (downloadsDir == null) {
          throw Exception('Could not access downloads directory');
        }

        final timestamp = DateTime.now().millisecondsSinceEpoch;
        final filename = 'surat_kompen_${mahasiswaId}_$timestamp.pdf';
        final filePath = '${downloadsDir.path}/$filename';

        final file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        return filePath;
      } else {
        throw Exception('Failed to download PDF: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error downloading PDF: $e');
    }
  }
}
