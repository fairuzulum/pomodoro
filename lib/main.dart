import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pomotime/views/login_page.dart';
import 'views/pomodoro_timer_screen.dart';
import 'dart:async'; // Import untuk Timer

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pomodoro Timer',
      theme: ThemeData(
        primaryColor: Color(0xFF3FA2F6),
        primarySwatch: createMaterialColor(Color(0xFF3FA2F6)),
      ),
      home: SplashScreen(), // Ganti home jadi SplashScreen
    );
  }
}

// Membuat halaman splash screen
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Timer untuk berpindah dari SplashScreen ke halaman LoginScreen
    Timer(Duration(seconds: 3), () {
      Get.off(LoginScreen()); // Pindah ke halaman LoginScreen setelah 3 detik
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3FA2F6), // Warna background splash
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Bisa diganti dengan logo aplikasi atau gambar lain
            Image.asset('assets/logo.png', height: 120.0), 
            SizedBox(height: 20.0),
          ],
        ),
      ),
    );
  }
}

// Fungsi untuk membuat MaterialColor
MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = {};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }
  strengths.forEach((strength) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  });
  return MaterialColor(color.value, swatch);
}
