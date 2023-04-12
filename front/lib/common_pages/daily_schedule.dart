import 'package:flutter/material.dart';
import '../storage/local_storage.dart';

class DailySchedulePage extends StatefulWidget {
  final Data? localData;
  const DailySchedulePage({Key? key, this.localData}) : super(key: key);

  @override
  DailySchedulePageState createState() => DailySchedulePageState();
}

class DailySchedulePageState extends State<DailySchedulePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
