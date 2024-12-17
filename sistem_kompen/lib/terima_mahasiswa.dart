// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class TerimaMahasiswa extends StatefulWidget {
  const TerimaMahasiswa({super.key});

  @override
  _TerimaMahasiswaState createState() => _TerimaMahasiswaState();
}

class _TerimaMahasiswaState extends State<TerimaMahasiswa> {
  List<Map<String, String>> tasks = [
    {
      'title': 'Bersihkan ruangan RT05',
      'description':
          'Rapikan dan bersihkan ruangan, dan pastikan tidak ada sampah tertinggal.',
      'dosen': 'Nama Dosen',
      'poin': '20 jam',
      'deadline': '5 hari',
      'imageUrl':
          'https://via.placeholder.com/150', // Placeholder for room image
    },
    {
      'title': 'Bersihkan ruangan RT06',
      'description':
          'Pastikan semua alat sudah dibereskan dan tidak ada sampah.',
      'dosen': 'Nama Dosen 2',
      'poin': '15 jam',
      'deadline': '3 hari',
      'imageUrl':
          'https://via.placeholder.com/150', // Placeholder for room image
    },
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2D2766), // Purple background color
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/homepage');
          },
        ),
        title: Text(
          'Daftar Mahasiswa',
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
      backgroundColor: Color(0xFFEEE1FF), // Light purple background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF2D2766),
              Colors.white,
            ],
            stops: [0.5, 0.5],
          ),
        ),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          padding: EdgeInsets.all(7),
          decoration: BoxDecoration(
            color: Color(0xFF7065A0),
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
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildSearchAndFilterRow(),
                SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (context, index) {
                      final task = tasks[index];
                      if (searchQuery.isEmpty ||
                          task['title']!
                              .toLowerCase()
                              .contains(searchQuery.toLowerCase())) {
                        return _buildTaskCard(
                          task['title']!,
                          task['description']!,
                          task['dosen']!,
                          task['poin']!,
                          task['deadline']!,
                          task['imageUrl']!,
                        );
                      }
                      return SizedBox
                          .shrink(); // Return an empty space if no match
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Search bar and filter row
  Widget _buildSearchAndFilterRow() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                spreadRadius: 2,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: IconButton(
            icon: const Icon(
              Icons.filter_list,
              size: 30,
              color: Colors.black,
            ),
            onPressed: _showFilterDialog,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value;
              });
            },
            decoration: InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Cari...',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(7),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: EdgeInsets.symmetric(vertical: 10),
            ),
          ),
        ),
      ],
    );
  }

  // Task card item with image
  Widget _buildTaskCard(String title, String description, String dosen,
      String poin, String deadline, String imageUrl) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            // Task details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(description, style: TextStyle(fontSize: 12),),
                  SizedBox(height: 8),
                  Text('Dosen: $dosen', style: TextStyle(color: Colors.grey)),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(poin, style: TextStyle(color: Colors.grey)),
                      Text('Dl: $deadline',
                          style: TextStyle(color: Colors.grey)),
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

  void _showFilterDialog() {
    showDialog(
      context: context,
      barrierColor: Colors.black54,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.yellow,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Filter Berdasarkan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF4B367C),
                  ),
                ),
                const SizedBox(height: 10),
                const Text('Berdasarkan Status'),
                const SizedBox(height: 5),
                const Text('Berdasarkan Bobot Jam/Poin: Dari Kecil - Besar'),
                const SizedBox(height: 5),
                const Text('Berdasarkan Bobot Jam/Poin: Dari Besar - Kecil'),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Tutup'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
