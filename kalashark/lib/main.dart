import 'package:flutter/material.dart';
import 'package:kalashark/screens/Kalashark_Ui.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:kalashark/screens/Kalashark_Ui.dart';
import 'screens/about_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _requestPermissions();
  runApp(const MyApp());
}

Future<void> _requestPermissions() async {
  await [
    Permission.location,
    Permission.bluetooth,
    Permission.bluetoothScan,
    Permission.bluetoothConnect,
  ].request();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KalaShark Cyberpunk',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0D0D),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A1A1A),
          foregroundColor: Colors.cyanAccent,
          titleTextStyle: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(
            color: Colors.white70,
            fontFamily: 'ShareTechMono',
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1A1A1A),
          selectedItemColor: Colors.cyanAccent,
          unselectedItemColor: Colors.white30,
        ),
      ),
      home: const KalaSharkScreen(),
      routes: {'/about': (context) => const AboutScreen()},
    );
  }
}
