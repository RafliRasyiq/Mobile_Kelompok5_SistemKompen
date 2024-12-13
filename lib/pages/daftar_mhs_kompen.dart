import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:sistem_kompen/config/config.dart';
import 'package:http/http.dart' as http;

final dio = Dio(
  BaseOptions(
    connectTimeout: Duration(seconds: 120),
    receiveTimeout: Duration(seconds: 10),
  ),
);

// String urlDomain = "http://192.168.63.168:8000/";
// String list_mhs_endpoint = urlDomain + "api/list_mhs_kompen";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: KompenMahasiswaPage(),
    );
  }
}

class KompenMahasiswaPage extends StatefulWidget {
  @override
  _KompenMahasiswaPageState createState() => _KompenMahasiswaPageState();
}

class _KompenMahasiswaPageState extends State<KompenMahasiswaPage>
    with WidgetsBindingObserver {
  // final Dio dio = Dio();
  // String urlDomain = "http://192.168.67.198:8000/";
  // String urlAllData = urlDomain + "api/list_mhs_kompen";

  List<Map<String, dynamic>> mahasiswa = [];
  List<Map<String, dynamic>> filteredMahasiswa = [];

  // Dropdown values
  String? selectedProdi;
  String? selectedTingkat;
  String? selectedKelas;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _showAllData(); // Load data on initialization
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _showAllData(); // Reload data when app resumes
    }
  }

  // Future<void> fetchMahasiswa() async {
  //   try {
  //     Response response = await dio.get(list_mhs_endpoint);
  //     if (response.statusCode == 200) {
  //       setState(() {
  //         mahasiswa = List<Map<String, dynamic>>.from(response.data);
  //         filteredMahasiswa = mahasiswa;
  //       });
  //     } else {
  //       throw Exception("Failed to fetch data");
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }

  void filterMahasiswa() {
    setState(() {
      filteredMahasiswa = mahasiswa.where((m) {
        final prodiMatch = selectedProdi == null || m['prodi'] == selectedProdi;
        final tingkatMatch =
            selectedTingkat == null || m['tingkat'] == selectedTingkat;
        final kelasMatch = selectedKelas == null || m['kelas'] == selectedKelas;

        print(
            'Filter Mahasiswa: $selectedProdi, $selectedTingkat, $selectedKelas');
        return prodiMatch && tingkatMatch && kelasMatch;
      }).toList();
    });
  }

  // void resetFilters() {
  //   setState(() {
  //     selectedProdi = null;
  //     selectedTingkat = null;
  //     selectedKelas = null;
  //     filteredMahasiswa = mahasiswa;
  //   });
  // }

  Future<Map<String, dynamic>> _showAllData() async {
    final url = Uri.parse(Config.list_mhs_endpoint);
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        data['message'] = 'success';
        print("bagian ini sudah masuk");
        if (data['message'] == 'success') {
          final id = data['mahasiswa_id'].toString();
          final nama = data['mahasiswa_nama'];
          print("$data");
          print("$nama");
          // Kembalikan semua data dari respons JSON
          return {
            'success': true,
            'id': data['mahasiswa_id']?.toString() ?? '-',
            'nim': data['nim']?.toString() ?? '-',
            'nama': data['mahasiswa_nama']?.toString() ?? '-',
            'poin': data['poin']?.toString() ?? '-',
            'status': data['status']?.toString() ?? '-',
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

      // if (response.data is List) {
      //   setState(() {
      //     mahasiswa = (response.data as List).map((item) {
      //       return {
      //         'id': item['mahasiswa_id']?.toString() ?? '-',
      //         'nim': item['nim']?.toString() ?? '-',
      //         'nama': item['mahasiswa_nama']?.toString() ?? '-',
      //         'alpha': item['t_absensi_mhs.alpha']?.toString() ?? '-',
      //         // 'poin': item['t_absensi_mhs.poin']?.toString() ?? 0,
      //         'poin': item['t_absensi_mhs.poin']?.toString() ?? '-',
      //         'status': item['t_absensi_mhs.status']?.toString() ?? '-',
      //       };
      //     }).toList();
      //   });
      // } else {
      //   print("Unexpected data format: ${response.data}");
      // }
    } catch (e) {
      return {
        'success': false,
        'message': 'An error occurred: $e',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Kompen Mahasiswa',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: const Icon(Icons.arrow_back, color: Colors.white),
      ),
      body: mahasiswa.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari Mahasiswa...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16.0),

                  // Filter row
                  Row(
                    children: [
                      // Prodi filter
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedProdi,
                          decoration: const InputDecoration(
                            labelText: 'Prodi',
                            border: OutlineInputBorder(),
                          ),
                          items: ['Informatika', 'Sistem Informasi']
                              .map((prodi) => DropdownMenuItem(
                                    value: prodi,
                                    child: Text(prodi),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedProdi = value;
                              filterMahasiswa();
                            });
                          },
                        ),
                      ),
                      const SizedBox(width: 8.0),

                      // Kelas filter
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: selectedKelas,
                          decoration: const InputDecoration(
                            labelText: 'Kelas',
                            border: OutlineInputBorder(),
                          ),
                          items: ['A', 'B', 'C']
                              .map((kelas) => DropdownMenuItem(
                                    value: kelas,
                                    child: Text(kelas),
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              selectedKelas = value;
                              filterMahasiswa();
                            });
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8.0),

                  // Hapus Filter button
                  Align(
                    alignment: Alignment.centerRight,
                    // child: TextButton.icon(
                    //   onPressed: resetFilters,
                    //   icon: const Icon(Icons.delete, color: Colors.red),
                    //   label: const Text(
                    //     'Hapus Filter',
                    //     style: TextStyle(color: Colors.red),
                    //   ),
                    // ),
                  ),
                  const SizedBox(height: 16.0),

                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10),
                  //   child: Table(
                  //     defaultVerticalAlignment:
                  //         TableCellVerticalAlignment.middle,
                  //     border: TableBorder.all(color: Colors.grey),
                  //     columnWidths: const {
                  //       0: FlexColumnWidth(5),
                  //       1: FlexColumnWidth(0.8),
                  //       2: FlexColumnWidth(1.2),
                  //     },
                  //     children: [
                  //       TableRow(
                  //         decoration: BoxDecoration(color: Colors.grey[200]),
                  //         children: const [
                  //           Padding(
                  //             padding: EdgeInsets.all(8.0),
                  //             child: Text(
                  //               'Nama Lengkap',
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(fontWeight: FontWeight.bold),
                  //             ),
                  //           ),
                  //           Padding(
                  //             padding: EdgeInsets.all(8.0),
                  //             child: Text(
                  //               '(i)',
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(fontWeight: FontWeight.bold),
                  //             ),
                  //           ),
                  //           Padding(
                  //             padding: EdgeInsets.all(8.0),
                  //             child: Text(
                  //               'alpha',
                  //               textAlign: TextAlign.center,
                  //               style: TextStyle(fontWeight: FontWeight.bold),
                  //             ),
                  //           ),
                  //         ],
                  //       ),
                  //       for (var i = 0; i < mahasiswa.length; i++)
                  //         TableRow(
                  //           children: [
                  //             Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Text(
                  //                 mahasiswa[i]['mahasiswa_nama'],
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //             ),
                  //             // MaterialButton(
                  //             //   padding: const EdgeInsets.all(1),
                  //             //   child: const Icon(Icons.open_in_full_rounded),
                  //             //   onPressed: () {
                  //             //     idController.text = all_data[i]['id'].toString();
                  //             //     print(all_data[i]['mahasiswa_id']);
                  //             //     String id = all_data[i]['mahasiswa_id'];
                  //             //     showProfileData(context, id);
                  //             //   },
                  //             // ),
                  //             Padding(
                  //               padding: const EdgeInsets.all(8.0),
                  //               child: Text(
                  //                 mahasiswa[i]['alpha'],
                  //                 textAlign: TextAlign.center,
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //     ],
                  //   ),
                  // ),

                  //Data table with Detail button
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Table(
                        defaultVerticalAlignment:
                            TableCellVerticalAlignment.middle,
                        border: TableBorder.all(color: Colors.grey),
                        columnWidths: const {
                          0: FlexColumnWidth(1), // Kolom untuk nomor
                          1: FlexColumnWidth(3), // Kolom untuk nama
                          2: FlexColumnWidth(1), // Kolom untuk poin
                          3: FlexColumnWidth(1), // Kolom untuk aksi
                        },
                        children: [
                          // Header Row
                          TableRow(
                            decoration: BoxDecoration(color: Colors.grey[200]),
                            children: const [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'No',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Nama Lengkap',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Poin',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text(
                                  'Aksi',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          // Data Rows
                          for (var i = 0; i < mahasiswa.length; i++)
                            TableRow(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    (i + 1).toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    mahasiswa[i]['mahasiswa_nama'],
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    mahasiswa[i]['poin'].toString(),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Navigasi ke detail
                                      print(
                                          'Detail untuk ${mahasiswa[i]['mahasiswa_nama']}');
                                    },
                                    child: const Text('Detail'),
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ),

                  // Expanded(
                  //   child: SingleChildScrollView(
                  //     scrollDirection: Axis.horizontal,
                  //     child: DataTable(
                  //       columns: const [
                  //         DataColumn(label: Text('No')),
                  //         DataColumn(label: Text('Nama Lengkap')),
                  //         DataColumn(label: Text('Poin')),
                  //         DataColumn(label: Text('Aksi')),
                  //       ],
                  //       rows: filteredMahasiswa
                  //           .asMap()
                  //           .entries
                  //           .map(
                  //             (entry) => DataRow(cells: [
                  //               DataCell(Text((entry.key + 1).toString())),
                  //               DataCell(Text(
                  //                 entry.value['nama'],
                  //                 maxLines: 1,
                  //                 overflow: TextOverflow.ellipsis,
                  //               )),
                  //               DataCell(Text(entry.value['poin'].toString())),
                  //               DataCell(
                  //                 ElevatedButton(
                  //                   onPressed: () {
                  //                     // Navigate to detail page
                  //                   },
                  //                   child: const Text('Detail'),
                  //                 ),
                  //               ),
                  //             ]),
                  //           )
                  //           .toList(),
                  //     ),
                  //   ),
                  // ),

                  Text(
                    'Total Mahasiswa : ${filteredMahasiswa.length}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
    );
  }
}
