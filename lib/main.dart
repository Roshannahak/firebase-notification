import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    title: "FCM test app",
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreen();
  }
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("firebase notification"),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(child: Text("FCM")),
      ),
    );
  }
}
