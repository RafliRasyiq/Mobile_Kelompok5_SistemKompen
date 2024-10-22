import 'package:flutter/material.dart';
import 'package:sistem_kompen/screens/profile_screen/profile_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay selama 3 detik sebelum navigasi ke halaman berikutnya
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Ambil lebar layar
          double screenWidth = MediaQuery.of(context).size.width;

          // Set ukuran logo minimal 200 dan maksimal sebesar 60% dari lebar layar
          double logoWidth = screenWidth * 0.6;
          if (logoWidth < 200) {
            logoWidth = 200;
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/Logo_Splash Screen.png',
                  width: logoWidth,
                  // Tinggi gambar disesuaikan proporsional dengan lebarnya
                  height: logoWidth,
                ),
                SizedBox(height: 20),
                CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
