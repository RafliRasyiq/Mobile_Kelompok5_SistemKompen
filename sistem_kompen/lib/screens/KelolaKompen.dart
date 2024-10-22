import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      "imageUrl": "https://via.placeholder.com/50" // Placeholder image URL
    };
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF2D2766), // Updated color to #2D2766
        toolbarHeight: 78.0, // Set the height of the AppBar to 78
        title: Text(
          'Kelola Kompen',
          style: TextStyle(
            color: Colors.white, // Set font color to white
            fontSize: 18.0,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white, // Set back icon color to white
          ),
          onPressed: () {
            Navigator.pop(context); // Navigates back to the previous screen
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(ScreenUtil().setWidth(16.0)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Cari Mahasiswa...',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.search),
              ),
            ),
            SizedBox(height: ScreenUtil().setHeight(16.0)),
            CustomText(
              text: 'Data Mahasiswa Tertanggung',
              color: ColorsHelper.black(),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
            SizedBox(height: ScreenUtil().setHeight(16.0)),

            // Row containing three dropdown filters: Prodi, Tingkat, Kelas
            Row(
              children: [
                // Prodi Dropdown
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedProdi,
                    isExpanded: true,
                    items: <String>['Prodi 1', 'Prodi 2', 'Prodi 3']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedProdi = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(10.0)),

                // Tingkat Dropdown
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedTingkat,
                    isExpanded: true,
                    items: <String>['Tingkat 1', 'Tingkat 2', 'Tingkat 3']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedTingkat = newValue;
                      });
                    },
                  ),
                ),
                SizedBox(width: ScreenUtil().setWidth(10.0)),

                // Kelas Dropdown
                Expanded(
                  child: DropdownButton<String>(
                    value: selectedKelas,
                    isExpanded: true,
                    items: <String>['Kelas A', 'Kelas B', 'Kelas C']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedKelas = newValue;
                      });
                    },
                  ),
                ),
              ],
            ),

            SizedBox(height: ScreenUtil().setHeight(16.0)),

            // List of Mahasiswa
            Expanded(
              child: ListView.builder(
                itemCount: mahasiswaList.length,
                itemBuilder: (context, index) {
                  final mahasiswa = mahasiswaList[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(mahasiswa['imageUrl']),
                        radius: 25.0, // Set the size of the avatar
                      ),
                      title: CustomText(
                        text: mahasiswa['nama'],
                        color: ColorsHelper.black(),
                        fontSize: 14.0,
                        fontWeight: FontWeight.w400,
                      ),
                      subtitle: CustomText(
                        text: "Kompen Saat Ini: ${mahasiswa['kompen']} jam",
                        color: ColorsHelper.darkGrey(),
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: ColorsHelper.darkGrey(),
                      ),
                      onTap: () {
                        // Handle navigation to detailed view of Kompen for this student
                      },
                    ),
                  );
                },
              ),
            ),

            // Total Mahasiswa Tertanggung at the bottom of the page
            Padding(
              padding: EdgeInsets.symmetric(vertical: 14.0),
              child: Align(
                alignment: Alignment.center,
                child: CustomText(
                  text: "Total Mahasiswa Tertanggung : ${mahasiswaList.length}",
                  color: ColorsHelper.black(),
                  fontSize: 14.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
