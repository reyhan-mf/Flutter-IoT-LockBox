import 'package:flutter/material.dart';
import 'package:lockboxx/home.dart';
import 'package:lockboxx/login.dart';
import 'package:lockboxx/profile.dart';
import 'package:lockboxx/rent.dart';
import 'package:lockboxx/navigation.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Poppins'),
      home: LogInScreen(),
    );
  }
}
