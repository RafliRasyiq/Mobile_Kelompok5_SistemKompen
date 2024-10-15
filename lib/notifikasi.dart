// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF7D669E), // Purple background color as in the image
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context,
                    '/homepage');
          },
        ),
        title: Text(
          'Notifikasi',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.grey),
            ),
          )
        ],
      ),
      backgroundColor: Color(0xFFEEE1FF), // Light purple background from the image
      body:
        Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF7D669E),
                  Colors.white,
                ],
                stops: [0.5, 0.5],
              ),
            ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 7,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
            child: ListView(
              children: [
                _buildNotificationCard(
                  'Tugas 03',
                  'Tugas 03 yang anda input telah dipublish dan dapat diambil oleh mahasiswa.',
                  'Tgl',
                  Icons.desktop_mac,
                ),
                _buildNotificationCard(
                  'Tugas 02',
                  'Tugas 02 telah diambil oleh mahasiswa Rafi Rasyid. Tugas dalam proses pengerjaan.',
                  'Tgl',
                  Icons.assignment,
                ),
                _buildNotificationCard(
                  'Tugas 01',
                  'Tugas 01 telah diselesaikan oleh mahasiswa. Silahkan ditinjau dan beri persetujuan.',
                  'Tgl',
                  Icons.file_copy,
                ),
                _buildNotificationCard(
                  'Tugas 08',
                  'Tugas 08 telah anda tinjau dan setujui. Status tugas terupdate menjadi "selesai".',
                  'Tgl',
                  Icons.brush,
                ),
                _buildNotificationCard(
                  'Tugas 07',
                  'Tugas 07 telah anda tinjau dan setujui. Status tugas terupdate menjadi "selesai".',
                  'Tgl',
                  Icons.checklist,
                ),
                _buildNotificationCard(
                  'Tugas 06',
                  'Tugas 06 telah anda tinjau dan setujui. Status tugas terupdate menjadi "selesai".',
                  'Tgl',
                  Icons.article,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Widget for each notification card
  Widget _buildNotificationCard(
      String title, String description, String date, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Color.fromRGBO(248, 233, 36, 1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  icon,
                  size: 50,
                  color: Colors.grey[700],
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DecoratedBox(decoration: BoxDecoration(color: Colors.blue,)),
                      Text(
                        title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(description),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Divider(),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                '*Tap untuk selanjutnya.',
                style: TextStyle(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}