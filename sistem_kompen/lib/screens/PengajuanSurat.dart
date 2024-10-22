import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sistem_kompen/screens/KelolaKompen.dart'; // Pastikan mengimpor halaman KelolaKompen

class PengajuanSuratScreen extends StatelessWidget {
  const PengajuanSuratScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pengajuan Surat',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
        // Tambahkan leading untuk tombol back
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Arahkan ke halaman KelolaKompen saat tombol back ditekan
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => KelolaKompen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cetak Surat Bebas Kompen',
              style: TextStyle(
                fontSize: 16.0, // Ukuran font judul
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Pilih tahun ajaran dan semester untuk mencetak surat bebas kompen Anda.',
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: MediaQuery.of(context).size.width > 600
                      ? 3 // 3 card per baris jika lebar layar > 600px
                      : 2, // 2 card per baris jika lebar layar < 600px
                  crossAxisSpacing: 16.0, // Jarak antar card secara horizontal
                  mainAxisSpacing: 16.0, // Jarak antar card secara vertikal
                  childAspectRatio: 3 / 4, // Proporsi card (lebar:tinggi)
                ),
                itemCount: 3, // Jumlah card
                itemBuilder: (context, index) {
                  // Data dummy untuk contoh
                  final data = [
                    {
                      'tahunAjaran': '2023/2024',
                      'semester': 'Ganjil',
                      'status': 'Tersedia',
                      'color': Colors.blueAccent.shade100,
                      'icon': Icons.check_circle_outline
                    },
                    {
                      'tahunAjaran': '2022/2023',
                      'semester': 'Genap',
                      'status': 'Belum Tersedia',
                      'color': Colors.redAccent.shade100,
                      'icon': Icons.remove_circle_outline
                    },
                    {
                      'tahunAjaran': '2021/2022',
                      'semester': 'Ganjil',
                      'status': 'Tersedia',
                      'color': Colors.greenAccent.shade100,
                      'icon': Icons.check_circle_outline
                    }
                  ];

                  return buildSuratCard(
                    context,
                    tahunAjaran: data[index]['tahunAjaran'] as String,
                    semester: data[index]['semester'] as String,
                    status: data[index]['status'] as String,
                    color: data[index]['color'] as Color,
                    icon: data[index]['icon'] as IconData,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to create a modern iOS-like Card view for each surat
  Widget buildSuratCard(
    BuildContext context, {
    required String tahunAjaran,
    required String semester,
    required String status,
    required Color color,
    required IconData icon,
  }) {
    return GestureDetector(
      onTap: () {
        if (status == 'Belum Tersedia') {
          // Tampilkan CupertinoAlertDialog jika status "Belum Tersedia"
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoAlertDialog(
                title: Text("Maaf Belum Tersedia"),
                content: Text("Silahkan selesaikan kompen!"),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        } else {
          // Logika saat status "Tersedia"
          // Misalnya navigasi ke halaman cetak surat
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        elevation: 5,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian atas dengan warna dan icon
            Container(
              height: 90,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              ),
              child: Center(
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
            // Bagian bawah untuk informasi tahun ajaran, semester, dan status
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tahun Ajaran: $tahunAjaran',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Semester: $semester',
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.grey[700],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        'Status: ',
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey[700],
                        ),
                      ),
                      Text(
                        status,
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                          color: status == 'Tersedia'
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
