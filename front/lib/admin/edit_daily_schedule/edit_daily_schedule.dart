// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';

class EditDailySchedulePage extends StatefulWidget {
  final Data localData;
  const EditDailySchedulePage({Key? key, required this.localData}) : super(key: key);

  @override
  EditDailySchedulePageState createState() => EditDailySchedulePageState();
}

class EditDailySchedulePageState extends State<EditDailySchedulePage>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    Assets assets = Assets(currentPage: EditDailySchedulePage(localData: widget.localData), localData: widget.localData,);
    return Scaffold(

    );
  }
}