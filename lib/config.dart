class Config {
  //URL dasar
  static const String base_domain = 'http://192.168.101.220:8000';

  //Endpoint Login
  static const String login_endpoint = '$base_domain/api/login';

  //Endpoint get User Data
  static const String mahasiswa_endpoint = '$base_domain/api/mahasiswa/mahasiswa_data';
  static const String dosen_endpoint = '$base_domain/api/dosen/dosen_data';
  static const String tendik_endpoint = '$base_domain/api/tendik/tendik_data';

  
}
