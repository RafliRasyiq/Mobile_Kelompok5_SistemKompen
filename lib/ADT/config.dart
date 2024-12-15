import 'package:dio/dio.dart';

final dio = Dio(BaseOptions(
  followRedirects: true, // Enable automatic redirect
  maxRedirects: 5, // Limit the number of redirects
  validateStatus: (status) {
    // Allow status 302 without causing exceptions
    return (status != null && status >= 200 && status < 300) || status == 302;
  },
));

String urlDomain = "http://192.168.1.8:8000/";
//String urlAllData = urlDomain + "api/all_data";
//String urlShowData = urlDomain + "api/show_data";
//String urlUpdateStatus = urlDomain + "api/update_status";


String urlAllData = urlDomain + "api/all_data_p";
String urlShowData = urlDomain + "api/show_data_p";
String urlUpdateStatus = urlDomain + "api/update_data_p";

