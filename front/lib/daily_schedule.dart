import 'package:flutter/material.dart';

class DailySchedulePage extends StatelessWidget {
  const DailySchedulePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
      ),
      body: const Center(
        child: Text('Dashboard Page Content'),
      ),
    );
  }
}
