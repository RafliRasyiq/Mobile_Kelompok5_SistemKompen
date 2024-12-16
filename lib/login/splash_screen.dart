import 'package:flutter/material.dart';
import 'package:sistem_kompen/login/login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
        (Route<dynamic> route) => false,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          // Get screen width
          double screenWidth = MediaQuery.of(context).size.width;

          // Set minimum logo size to 200 and max to 80% of screen width
          double logoWidth = screenWidth * 0.8;
          logoWidth = logoWidth < 200 ? 200 : logoWidth;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/Logo_Splash Screen.png',
                  width: logoWidth,
                  height: logoWidth,
                ),
                const SizedBox(height: 20),
                const CircularProgressIndicator(
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
