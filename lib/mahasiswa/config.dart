// config.dart
import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  followRedirects: true, // Enable automatic redirection
  maxRedirects: 5, // Limit the number of redirects
  validateStatus: (status) {
    // Allow 302 status code without causing exception
    return (status != null && status >= 200 && status < 300) || status == 302;
  },
));

String urlDomain = "http://192.168.1.8:8000/";
String urlAllData = urlDomain + "api/all_data_m"; // URL to fetch all data
