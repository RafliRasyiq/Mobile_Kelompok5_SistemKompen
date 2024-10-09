import 'package:flutter/material.dart';
import 'package:sistem_kompen/sidebar_menu_dosen.dart';

class HomePageDosen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Center(
            child: Text(
          'HOME',
          style: TextStyle(color: Colors.white),
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/sidebar');
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              // Handle profile button press
            },
          ),
        ],
      ),
      drawer: SidebarMenu(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Background Image and Track Record (adjusted with Stack and Positioned)
            Stack(
              clipBehavior: Clip
                  .none, // to allow the overflow of the track record container
              children: [
                // Background Image
                Container(
                  height: 302, // height of the image container
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/Rectangle 9.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Profile Information
                Padding(
                  padding: const EdgeInsets.only(left: 16, top: 85),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Rikat Setya Gusti Pangeran',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        '2241760053',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                // Track Record Container Positioned
                Positioned(
                  top: 200, // position it to be half over the image
                  left: 32,
                  right: 32,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title at the top-center
                        const Text(
                          'Track Record Tugas',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color.fromRGBO(232, 120, 23, 1)),
                        ),
                        const SizedBox(
                            height: 10), // Space between title and row
                        // The row with track record items
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _buildTrackRecordItem(Icons.camera, 'Ditinjau', '2',
                                const Color.fromRGBO(232, 120, 23, 1)),
                            _buildTrackRecordItem(
                                Icons.cloud_upload,
                                'Terunggah',
                                '3',
                                const Color.fromRGBO(130, 120, 171, 1)),
                            _buildTrackRecordItem(Icons.work, 'Dikerjakan',
                                '12', const Color.fromRGBO(112, 101, 160, 1)),
                            _buildTrackRecordItem(Icons.check_circle, 'Selesai',
                                '103', const Color.fromRGBO(45, 39, 102, 1)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
                height:
                    100), // Space between the track record and notifications
            // Notifications Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                'Notifikasi Teratas:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
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
            const SizedBox(height: 10),
            Center(
              child: TextButton(
                onPressed: () {
                  // Handle view more press
                },
                child: const Text('Lihat Semua >>'),
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
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Column(
            children: [
              Text(count,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: 20)),
              Icon(icon, size: 30, color: Colors.white),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          label,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              subtitle,
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 10),
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
