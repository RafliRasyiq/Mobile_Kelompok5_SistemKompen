class Config {
  //URL dasar
  static const String base_domain = 'http://192.168.1.3:8000';

  //Endpoint Login
  static const String login_endpoint = '$base_domain/api/login';

  //Endpoint get User Data
  static const String mahasiswa_endpoint = '$base_domain/api/mahasiswa/mahasiswa_data';
  static const String mahasiswa_update_profile_endpoint = '$base_domain/api/mahasiswa/edit_profile';
  static const String mahasiswa_update_password_endpoint = '$base_domain/api/mahasiswa/edit_password';
  static const String mahasiswa_kompen_selesai_endpoint = '$base_domain/api/mahasiswa/show_kompen_selesai';


  static const String dosen_endpoint = '$base_domain/api/dosen/dosen_data';
  static const String dosen_update_profile_endpoint = '$base_domain/api/dosen/edit_profile';
  static const String dosen_update_password_endpoint = '$base_domain/api/dosen/edit_password';
  static const String dosen_kompen_selesai_endpoint = '$base_domain/api/dosen/show_kompen_selesai';
  static const String dosen_show_kompen_selesai_endpoint = '$base_domain/api/dosen/detail_kompen_selesai';
  static const String dosen_update_kompen_selesai_endpoint = '$base_domain/api/dosen/update_kompen_selesai';



  static const String tendik_endpoint = '$base_domain/api/tendik/tendik_data';
  static const String tendik_update_profile_endpoint = '$base_domain/api/tendik/edit_profile';
  static const String tendik_update_password_endpoint = '$base_domain/api/tendik/edit_password';
  static const String tendik_kompen_selesai_endpoint = '$base_domain/api/tendik/show_kompen_selesai';
  static const String tendik_show_kompen_selesai_endpoint = '$base_domain/api/tendik/detail_kompen_selesai';
  static const String tendik_update_kompen_selesai_endpoint = '$base_domain/api/tendik/update_kompen_selesai';



  static const String list_mhs_kompen_endpoint = '$base_domain/api/kompen/list_mhs_kompen';
  static const String show_mhs_kompen_endpoint = '$base_domain/api/kompen/show_list';

  static const String list_mhs_alpha_endpoint = '$base_domain/api/alpha/all_data';
  static const String show_mhs_alpha_endpoint = '$base_domain/api/alpha/show_data';

}
