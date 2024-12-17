class AcademicPeriod {
  final String year;
  final String semester;
  final bool isAvailable;
  final int mahasiswaId;
  final String nim;
  final String mahasiswaNama;
  final int poin;

  AcademicPeriod({
    required this.year,
    required this.semester,
    required this.isAvailable,
    required this.mahasiswaId,
    required this.nim,
    required this.mahasiswaNama,
    required this.poin,
  });

  factory AcademicPeriod.fromJson(Map<String, dynamic> json) {
    return AcademicPeriod(
      year: json['periode_tahun'],
      semester: json['periode_semester'],
      isAvailable: json['status'] == 'Lunas',
      mahasiswaId: json['mahasiswa_id'],
      nim: json['nim'].toString(),
      mahasiswaNama: json['mahasiswa_nama'],
      poin: json['poin'],
    );
  }
}
