import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback openDrawer;
  const HomeScreen({Key? key, required this.openDrawer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: openDrawer,
          icon: const Icon(
            Icons.apps,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        title: const Text(
          "DashBoard",
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: const Scaffold(
        backgroundColor: Colors.white,
      ),
    );
  }
}
