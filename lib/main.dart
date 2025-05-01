import 'package:flutter/material.dart';

import 'Home.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'CURRENCY COVERTER',

      theme:ThemeData(
        primarySwatch: Colors.blue
        
      ),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
