import 'package:flutter/material.dart';
// import 'package:sistem_kompen/controller/daftar_controller.dart';
import 'package:sistem_kompen/config.dart';
import 'package:sistem_kompen/core/shared_prefix.dart';

class KompenMahasiswaPage extends StatefulWidget {
  final String token;

  const KompenMahasiswaPage({super.key, required this.token});

  @override
  _KompenMahasiswaPageState createState() => _KompenMahasiswaPageState();
}

class _KompenMahasiswaPageState extends State<KompenMahasiswaPage> {
  // Map<String, dynamic> mahasiswa = [] as Map<String, dynamic>;
  String id = '';
  String nama = '-';
  String nim = '-';
  String poin = '-';
  String status = '-';
  var show_data = [];
  // Dropdown values
  String? selectedProdi;
  String? selectedTingkat;
  String? selectedKelas;

  // @override
  // void initState() {
  //   super.initState();
  //   _daftarMhsKompen();
  // }

  // Future<void> _daftarMhsKompen() async {
  //   try {
  //     final token = await Sharedpref.getToken();

  //     if (token == '') {
  //       throw Exception('Token is missing');
  //     }

  //     final data = await DaftarController.getMahasiswaKompen(token);
  //     setState(() {
  //       id = data['id'];
  //       nama = data['nama'];
  //       nim = data['nim'];
  //       poin = data['poin'];
  //       status = data['status'];
  //     });
  //     print(data);
  //   } catch (e) {
  //     print('Error loading dashboard data: $e');
  //   }
  // }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     _daftarMhsKompen(); // Reload data when app resumes
  //   }
  // }

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

  // void filterMahasiswa() {
  //   setState(() {
  //     filteredMahasiswa = mahasiswa.where((m) {
  //       final prodiMatch = selectedProdi == null || m['prodi'] == selectedProdi;
  //       final tingkatMatch =
  //           selectedTingkat == null || m['tingkat'] == selectedTingkat;
  //       final kelasMatch = selectedKelas == null || m['kelas'] == selectedKelas;

  //       print(
  //           'Filter Mahasiswa: $selectedProdi, $selectedTingkat, $selectedKelas');
  //       return prodiMatch && tingkatMatch && kelasMatch;
  //     }).toList();
  //   });
  // }

  // void resetFilters() {
  //   setState(() {
  //     selectedProdi = null;
  //     selectedTingkat = null;
  //     selectedKelas = null;
  //     filteredMahasiswa = mahasiswa;
  //   });
  // }

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
  //   } catch (e) {
  //     return {
  //       'success': false,
  //       'message': 'An error occurred: $e',
  //     };
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: const Text(
          'Kompen Mahasiswa',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white)),
      ),
      body: show_data.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                              // selectedKelas = value;
                              // filterMahasiswa();
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
                          for (var i = 0; i < show_data.length; i++)
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
                                    nama,
                                    textAlign: TextAlign.left,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    poin,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ElevatedButton(
                                    onPressed: () {
                                      // Navigasi ke detail
                                      print('Detail untuk $nama');
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

                  // Text(
                  //   'Total Mahasiswa : ${filteredMahasiswa.length}',
                  //   style: const TextStyle(fontWeight: FontWeight.bold),
                  // ),
                ],
              ),
            ),
    );
  }
}
