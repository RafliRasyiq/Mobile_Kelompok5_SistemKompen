class Config {
  //URL dasar
  static const String base_domain = 'http://192.168.1.5:8000';

  //Endpoint Login
  static const String login_endpoint = '$base_domain/api/login';

  //Endpoint get User Data
  static const String mahasiswa_endpoint = '$base_domain/api/mahasiswa/mahasiswa_data';
  static const String dosen_endpoint = '$base_domain/api/dosen/dosen_data';
  static const String tendik_endpoint = '$base_domain/api/tendik/tendik_data';


  static const String list_mhs_kompen_endpoint = '$base_domain/api/kompen/list_mhs_kompen';
  static const String show_mhs_kompen_endpoint = '$base_domain/api/kompen/show_list';

  static const String list_mhs_alpha_endpoint = '$base_domain/api/alpha/all_data';
  static const String show_mhs_alpha_endpoint = '$base_domain/api/alpha/show_data';

}
