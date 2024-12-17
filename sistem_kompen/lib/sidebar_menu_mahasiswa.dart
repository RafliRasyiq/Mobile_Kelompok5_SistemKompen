// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:flutter/material.dart';

class SidebarMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF2D2766),
      child: Column(
        children: [
          AppBar(
            backgroundColor: Color(0xFF2D2766),
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () {
                Navigator.pushReplacementNamed(context,
                    '/homepage');
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                const DrawerHeader(
                  decoration: BoxDecoration(
                    color: Color(0xFF2D2766),
                  ),
                  child: Center(
                    child: Text(
                      'Menu Mahasiswa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.home,
                      color: Colors.white),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context,
                    '/homepage');
                  },
                ),
                ExpansionTile(
                  leading: const Icon(Icons.assignment,
                      color: Colors.white), 
                  title: const Text(
                    'Tugas',
                    style: TextStyle(color: Colors.white),
                  ),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.assignment,
                          color: Colors.white),
                      title: const Text(
                        'Daftar Tugas',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {

                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.work,
                          color: Colors.white),
                      title: const Text(
                        'Sedang Berjalan',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {

                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.check,
                          color: Colors.white),
                      title: const Text(
                        'Riwayat Tugas',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {

                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.done,
                          color: Colors.white),
                      title: const Text(
                        'Tugas Selesai',
                        style: TextStyle(color: Colors.white),
                      ),
                      onTap: () {
                        
                      },
                    ),
                  ],
                ),
                ListTile(
                  leading: const Icon(Icons.home,
                      color: Colors.white),
                  title: const Text(
                    'Pengajuan Surat',
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    Navigator.pushReplacementNamed(context,
                    '/homepage');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
