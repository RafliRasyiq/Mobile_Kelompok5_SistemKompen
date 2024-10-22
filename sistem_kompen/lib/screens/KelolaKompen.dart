import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sistem_kompen/screens/profile_screen/profile_screen.dart';
import 'package:sistem_kompen/utils/colors_helper.dart';
import 'package:sistem_kompen/widgets/custom_text.dart';

class KelolaKompen extends StatefulWidget {
  const KelolaKompen({super.key});

  @override
  _KelolaKompenState createState() => _KelolaKompenState();
}

class _KelolaKompenState extends State<KelolaKompen> {
  String? selectedProdi = 'Prodi 1'; // Default selected value for Prodi
  String? selectedTingkat = 'Tingkat 1'; // Default selected value for Tingkat
  String? selectedKelas = 'Kelas A'; // Default selected value for Kelas

  final List<Map<String, dynamic>> mahasiswaList = List.generate(10, (index) {
    return {
      "nama": "Mahasiswa ${index + 1}",
      "kompen": index * 2,
      "prodi": "SIB", // Example Prodi
      "tingkat": "${index % 4 + 1}", // Example Tingkat (rotating from 1 to 4)
      "kelas": "B", // Example Kelas
      "imageUrl": "https://via.placeholder.com/50" // Placeholder image URL
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0, // No shadow for AppBar to give flat iOS look
        backgroundColor: Colors.white,
        toolbarHeight: 78.0, // Set the height of the AppBar to 78
        title: Text(
          'Kelola Kompen',
          style: TextStyle(
            color: Colors.black, // Set font color to black for modern look
            fontSize: 18.0,
            fontWeight: FontWeight.w600, // Heavier font for iOS feel
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Colors.black, // Black for iOS-like style
          ),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
      ),
      backgroundColor: Colors.grey[100], // Light background color for modern UI
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar with rounded edges
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Cari Mahasiswa...',
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  contentPadding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(16.0)),

            CustomText(
              text: 'Data Mahasiswa Tertanggung',
              color: Colors.black,
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: ScreenUtil().setHeight(16.0)),

            // Row containing three dropdown filters: Prodi, Tingkat, Kelas
            Row(
              children: [
                Expanded(
                  child: _buildDropdown(
                      selectedProdi, ['Prodi 1', 'Prodi 2', 'Prodi 3'], (newValue) {
                    setState(() {
                      selectedProdi = newValue;
                    });
                  }),
                ),
                SizedBox(width: ScreenUtil().setWidth(10.0)),
                Expanded(
                  child: _buildDropdown(selectedTingkat,
                      ['Tingkat 1', 'Tingkat 2', 'Tingkat 3'], (newValue) {
                    setState(() {
                      selectedTingkat = newValue;
                    });
                  }),
                ),
                SizedBox(width: ScreenUtil().setWidth(10.0)),
                Expanded(
                  child: _buildDropdown(
                      selectedKelas, ['Kelas A', 'Kelas B', 'Kelas C'], (newValue) {
                    setState(() {
                      selectedKelas = newValue;
                    });
                  }),
                ),
              ],
            ),

            SizedBox(height: ScreenUtil().setHeight(16.0)),

            // Expanded ListView containing total mahasiswa and list of mahasiswa
            Expanded(
              child: ListView(
                children: [
                  // Container showing the total number of students
                  Container(
                    padding: EdgeInsets.all(ScreenUtil().setWidth(16.0)),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: CustomText(
                      text: "Total Mahasiswa Tertanggung : ${mahasiswaList.length}",
                      color: Colors.black,
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                      textAlign: TextAlign.left, // Align text to the left
                    ),
                  ),

                  SizedBox(height: ScreenUtil().setHeight(16.0)),

                  // List of Mahasiswa
                  ...mahasiswaList.map((mahasiswa) {
                    return Card(
                      color: Colors.white,
                      elevation: 5,
                      margin: EdgeInsets.symmetric(vertical: 10.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20), // Rounded corners
                      ),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(mahasiswa['imageUrl']),
                          radius: 30.0, // Larger avatar for a modern feel
                        ),
                        title: Text(
                          mahasiswa['nama'],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Kompen Saat Ini: ${mahasiswa['kompen']} jam",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14.0,
                              ),
                            ),
                            Text(
                              "${mahasiswa['prodi']} ${mahasiswa['tingkat']}-${mahasiswa['kelas']}",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14.0,
                              ),
                            ),
                          ],
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.grey[400],
                        ),
                        onTap: () {
                          // Handle navigation to detailed view of Kompen for this student
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(
                                //mahasiswa: mahasiswa, // Pass mahasiswa data to ProfileScreen
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }).toList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdown(String? value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: Offset(0, 2), // Shadow position
          ),
        ],
      ),
      child: DropdownButton<String>(
        value: value,
        isExpanded: true,
        underline: SizedBox(),
        items: items.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: TextStyle(fontSize: 14)),
          );
        }).toList(),
        onChanged: onChanged,
        icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
      ),
    );
  }
}
