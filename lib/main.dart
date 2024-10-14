import 'package:flutter/material.dart';
import 'screens/home_screen.dart'; // Import the home screen

void main() => runApp(MusicApp());

class MusicApp extends StatelessWidget {
  const MusicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false, // Main screen
    );
  }
}
