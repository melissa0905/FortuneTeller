import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const FortuneTellerApp());
}

class FortuneTellerApp extends StatelessWidget {
  const FortuneTellerApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fortune Teller - Tarot Reading',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      home: const HomeScreen(),
    );
  }
}
