// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Center(
            child: Text(
          'HOME',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            // Handle menu press
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Handle profile button press
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Background Image (optional)
            Stack(
              children: [
                // Add a background image
                Container(
                  height: 302,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Rectangle 9.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 5, top: 85),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Picture
                      Row(
                        children: [
                          SizedBox(width: 16),
                          // User Information
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Rikat Setya Gusti Pangeran',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors
                                      .white, // white color on the background
                                ),
                              ),
                              Text(
                                '2241760112',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(
                                      0.8), // slightly transparent white
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Task Record (Track Record Tugas)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Title at the top-center
                    Text(
                      'Track Record Tugas', // Title Text
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(232, 120, 23, 1)
                      ),
                    ),
                    SizedBox(height: 10), // Space between title and row

                    // The row with track record items
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildTrackRecordItem(Icons.camera, 'Ditinjau', '2',
                            Color.fromRGBO(232, 120, 23, 1)),
                        _buildTrackRecordItem(Icons.cloud_upload, 'Terunggah',
                            '3', Color.fromRGBO(130, 120, 171, 1)),
                        _buildTrackRecordItem(Icons.work, 'Dikerjakan', '12',
                            Color.fromRGBO(112, 101, 160, 1)),
                        _buildTrackRecordItem(Icons.check_circle, 'Selesai',
                            '103', Color.fromRGBO(45, 39, 102, 1)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),

            // Notifications Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Notifikasi Teratas:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10),
            NotificationItem(
              title: 'Tugas Bersih.... perlu ditinjau',
              subtitle: 'Tugas 01 telah diselesaikan oleh mahasiswa.',
              time: '20 Jam',
            ),
            NotificationItem(
              title: 'Tugas Bers.... sedang dikerjakan',
              subtitle: 'Tugas 02 telah diambil oleh mahasiswa Rafli Rasyiq.',
              time: '20 Jam',
            ),
            NotificationItem(
              title: 'Tugas Bers.... sedang dikerjakan',
              subtitle: 'Tugas 01 telah diambil oleh mahasiswa Rafli Rasyiq.',
              time: '20 Jam',
            ),
            SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle view more press
                },
                child: Text('Lihat Semua >>'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackRecordItem(
      IconData icon, String label, String count, Color color) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              Text(count,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20)),
              Icon(icon, size: 30, color: Colors.white),
            ],
          ),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

class NotificationItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final String time;

  NotificationItem({
    required this.title,
    required this.subtitle,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600]),
            ),
            SizedBox(height: 10),
            Text(
              time,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }
}
