import 'package:flutter/material.dart';
import 'package:front/color_schemes.g.dart';
import 'package:front/data/daily_schedule.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';

class DailySchedulePage extends StatefulWidget {
  final Data localData;
  const DailySchedulePage({Key? key, required this.localData}): super(key: key);
  @override
  DailySchedulePageState createState() => DailySchedulePageState();
}

class DailySchedulePageState extends State<DailySchedulePage> with TickerProviderStateMixin{
  @override
  Widget build(BuildContext context) {  
    return Container(
      decoration: BoxDecoration(
        color: lightColorScheme.background,
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }

}