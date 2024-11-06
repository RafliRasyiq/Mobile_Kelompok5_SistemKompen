import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

final dio = Dio();
var all_data = [];
final TextEditingController nameController = TextEditingController();
final TextEditingController bankController = TextEditingController();
final TextEditingController alamatController = TextEditingController();

final TextEditingController idController_update = TextEditingController();
final TextEditingController nameController_update = TextEditingController();
final TextEditingController bankController_update = TextEditingController();
final TextEditingController alamatController_update = TextEditingController();

String url_domain = "http://192.168.1.3:8000/";
String url_all_data = url_domain + "api/all_data";
String url_create_data = url_domain + "api/create_data";
String url_show_data = url_domain + "api/show_data";
String url_update_data = url_domain + "api/edit_data";
String url_delete_data = url_domain + "api/delete_data";
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
// This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: data_tes(),
    );
  }
}

class data_tes extends StatefulWidget {
  const data_tes({super.key});
  @override
  State<data_tes> createState() => _data_tesState();
}

class _data_tesState extends State<data_tes> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    show_all_data(); // Load data when the widget initializes
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('MyApp state = $state');
    if (state == AppLifecycleState.resumed) {
      show_all_data(); // Reload data when the app is resumed
    }
  }

  // Move show_all_data here so it can use setState
  void show_all_data() async {
  try {
    final response = await dio.post(url_all_data);

    if (response.data is List) {
      setState(() {
        all_data = (response.data as List).map((item) {
          return {
            'username': item['username']?.toString() ?? '',
            'mahasiswa_nama': item['mahasiswa_nama']?.toString() ?? '',
            'status': item['status']?.toString() ?? '',
          };
        }).toList();
      });
    } else {
      print("Unexpected data format: ${response.data}");
    }
  } catch (e) {
    print("Error loading data: $e");
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                height: 60,
                decoration: BoxDecoration(color: Colors.red),
                alignment: Alignment.center,
                child: Text(
                  'Daftar Mahasiswa Alpha',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              Container(
                alignment: Alignment.center,
                margin: const EdgeInsets.only(left: 10, right: 10),
                child: Table(
                  defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                  border: TableBorder.all(),
                  columnWidths: {
                    0: FlexColumnWidth(1.5),
                    1: FlexColumnWidth(5),
                    2: FlexColumnWidth(2)
                  },
                  children: [
                    TableRow(children: [
                      Text(
                        'Username',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Nama Mahasiswa',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Status',
                        textAlign: TextAlign.center,
                        style:
                            TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      )
                    ]),
                    for (var data in all_data)
                      TableRow(children: [
                        Text(
                          data['username'],
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          data['mahasiswa_nama'],
                          textAlign: TextAlign.center,
                        ),
                        Text(
                          data['status'],
                          textAlign: TextAlign.center,
                        )
                      ])
                  ],
                ),
              ),
              Container(
                child: MaterialButton(
                  color: Colors.grey,
                  height: 30,
                  minWidth: 20,
                  onPressed: show_all_data, // Refresh data on button press
                  child: Text("Refresh Data"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
