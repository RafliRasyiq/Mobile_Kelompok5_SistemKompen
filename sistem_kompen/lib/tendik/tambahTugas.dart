import 'package:flutter/material.dart';
import 'package:sistem_kompen/config.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sistem_kompen/core/shared_prefix.dart';
import 'package:sistem_kompen/tendik/list_tugas.dart';

var jenis_data = [];
var periode_data = [];

class TambahTugas extends StatefulWidget {
  final String token;
  final String id;

  const TambahTugas({super.key, required this.token, required this.id});

  @override
  _TambahTugasState createState() => _TambahTugasState();
}

class _TambahTugasState extends State<TambahTugas> {
  final TextEditingController namaTugasController = TextEditingController();
  final TextEditingController deskripsiTugasController =
      TextEditingController();
  final TextEditingController bobotTugasController = TextEditingController();
  final TextEditingController tenggatWaktuController = TextEditingController();
  final TextEditingController kuotaController = TextEditingController();

  String? jenisTugas;
  String? periodeTugas;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final url = Uri.parse(Config.jenis_periode_tugas_endpoint);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
      );
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final jenisList = data['jenis'] as List;
        final periodeList = data['periode'] as List;

        print("ini data dari body: $data");
        print("Ini jenis list: $jenisList");
        print("Ini periode list: $periodeList");
        setState(() {
          // Check for null or empty data before processing
          jenis_data = jenisList.isNotEmpty
              ? jenisList.map((item) {
                  return {
                    'jenis_id': item['jenis_id'].toString(),
                    'jenis_nama': item['jenis_nama'] ?? 'Unknown',
                  };
                }).toList()
              : [];

          periode_data = periodeList.isNotEmpty
              ? periodeList.map((item) {
                  return {
                    'periode_id': item['periode_id'].toString(),
                    'periode_tahun': item['periode_tahun'] ?? 'Unknown',
                    'periode_semester': item['periode_semester'] ?? 'Unknown',
                  };
                }).toList()
              : [];

          // Default values set after data loading
          periodeTugas =
              periode_data.isNotEmpty ? periode_data.first['periode_id'] : null;

          jenisTugas =
              jenis_data.isNotEmpty ? jenis_data.first['jenis_id'] : null;
        });
      } else {
        print("Unexpected data format: ${response.body}");
      }
    } catch (e) {
      print("Error loading data: $e");
    }
  }

  void tambahTugas() async {
    final url = Uri.parse(Config.tambah_tugas_endpoint);
    try {
      var response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          "jenis_id": jenisTugas,
          "periode_id": periodeTugas,
          "tugas_nama": namaTugasController.text,
          "deskripsi": deskripsiTugasController.text,
          "tugas_bobot": bobotTugasController.text,
          "tugas_tenggat": tenggatWaktuController.text,
          "kuota": kuotaController.text,
        }),
      );
      if (response.statusCode == 200) {
        _showSuccessDialog();
      } else {
        throw Exception("Gagal menambahkan tugas");
      }
    } catch (e) {
      print(e);
    }
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const Text(
              'Apakah anda sudah yakin dan memeriksa detail tugas yang anda buat? Pastikan semuanya sudah benar.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                tambahTugas();
              },
              child: const Text('Lanjutkan'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Berhasil'),
          content: const Text('Tugas berhasil ditambahkan!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DaftarTugas(token: widget.token, id: widget.id)),
                );
              },
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Tugas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    value: jenisTugas,
                    onChanged: (value) {
                      setState(() {
                        jenisTugas = value;
                      });
                    },
                    items: jenis_data.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item['jenis_id'], // String value
                        child: Text(item['jenis_nama'] ?? 'Unknown'),
                      );
                    }).toList(),
                    decoration: const InputDecoration(labelText: "Jenis Tugas"),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: namaTugasController,
                    decoration: InputDecoration(labelText: "Nama Tugas"),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: deskripsiTugasController,
                    maxLines: 3,
                    decoration: InputDecoration(labelText: "Deskripsi Tugas"),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: bobotTugasController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Bobot Tugas (Jam)"),
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: tenggatWaktuController,
                    decoration: InputDecoration(
                      labelText: "Tenggat Waktu",
                      hintText: "Pilih tanggal",
                    ),
                    readOnly:
                        true, // Prevents typing in the field, only allow date picking
                    onTap: () async {
                      DateTime? selectedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (selectedDate != null) {
                        setState(() {
                          tenggatWaktuController.text =
                              "${selectedDate.toLocal()}".split(' ')[0];
                        });
                      }
                    },
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: kuotaController,
                    decoration: InputDecoration(labelText: "Kuota"),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              Card(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: DropdownButtonFormField<String>(
                    value: periodeTugas,
                    onChanged: (value) {
                      setState(() {
                        periodeTugas = value;
                      });
                    },
                    items: periode_data.map<DropdownMenuItem<String>>((item) {
                      return DropdownMenuItem<String>(
                        value: item['periode_id'],
                        child: Text(item['periode_tahun'] +
                                " " +
                                item['periode_semester'] ??
                            'Unknown'),
                      );
                    }).toList(),
                    decoration:
                        const InputDecoration(labelText: "Periode Tugas"),
                  ),
                ),
              ),
              SizedBox(
                width: double.infinity, // Tombol memenuhi lebar layar
                child: ElevatedButton(
                  onPressed: _showConfirmationDialog,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2C2260), // Warna tombol
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0), // Padding vertikal
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0), // Border tombol
                    ),
                  ),
                  child: const Text(
                    'Lanjutkan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
