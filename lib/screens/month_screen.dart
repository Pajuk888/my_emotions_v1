import 'package:flutter/material.dart';

class MonthScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Month Screen'),
      ),
      body: Center(
        child: Text('Monthly emotions overview goes here.'),
      ),
    );
  }
}
