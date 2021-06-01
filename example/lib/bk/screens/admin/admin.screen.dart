import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AdminScreen extends StatefulWidget {
  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Screen'),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () => Get.toNamed('admin-category'),
            child: Text('Forum Category'),
          ),
        ],
      ),
    );
  }
}
