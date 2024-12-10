import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

final dio = Dio();
var all_data = [];

String url_domain = "http://192.168.1.11:8000/";
String url_all_data = url_domain + "api/all_data";
String url_create_data = url_domain + "api/save";
String url_show_data = url_domain + "api/detail/{id}";
String url_update_data = url_domain + "api/update/{id}";
String url_delete_data = url_domain + "api/delete/{id}";

class KegiatanTerprogramPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kegiatan Terprogram'),
        backgroundColor: Colors.yellow[700],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16.0),
        child: ListView(
          children: [
            for (var data in all_data)
            ActivityCard(
              title: data['kegiatan_nama'],
              status: data['status'],
              points: data['kegiatan_nama'],
              pic: data['kegiatan_nama'],
              jurusan: data['kegiatan_nama'],
              waktu: data['tanggal_mulai'] + data['tanggal_selesai'],
              imageUrl: 'assets/skripsi.jpeg', // Ganti dengan gambar sesuai
            ),
            // ActivityCard(
            //   title: 'SDM',
            //   status: 'Approve',
            //   points: '5 Poin',
            //   pic: 'Anggota (2 Pts)',
            //   jurusan: 'Jurusan (2 Pts)',
            //   waktu: '3 Hari (1 Pts)',
            //   imageUrl: 'assets/skripsi.jpeg', // Ganti dengan gambar sesuai
            // ),
            // Tambahkan lebih banyak kegiatan sesuai kebutuhan
          ],
        ),
      ),
    );
  }
}

class ActivityCard extends StatelessWidget {
  final String title;
  final String status;
  final String points;
  final String pic;
  final String jurusan;
  final String waktu;
  final String imageUrl;

  const ActivityCard({
    required this.title,
    required this.status,
    required this.points,
    required this.pic,
    required this.jurusan,
    required this.waktu,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.yellow[100],
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Column(
                children: [
                  Text(
                    status,
                    style: TextStyle(
                      color: status == 'Approve' ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(points),
                ],
              ),
            ],
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(pic),
              Text(jurusan),
              Text(waktu),
            ],
          ),
        ],
      ),
    );
  }
}

void show_all_data() async {
  Response response;
  response = await dio.post(
    url_all_data,
  );
  all_data = response.data;
  print(all_data);
  AppLifecycleState.resumed;
}
