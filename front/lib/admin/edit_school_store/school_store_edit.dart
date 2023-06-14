// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';

class EditSchoolStorePage extends StatefulWidget {
  final Data localData;
  const EditSchoolStorePage({Key? key, required this.localData}) : super(key: key);

  @override
  EditSchoolStorePageState createState() => EditSchoolStorePageState();
}

class EditSchoolStorePageState extends State<EditSchoolStorePage>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  Widget build(BuildContext context) {
    Assets assets = Assets(currentPage: EditSchoolStorePage(localData: widget.localData), localData: widget.localData,);
    // 3 parts to this page:
    // 1. Add new item
    // 2. Edit existing item
    // 3. Delete existing item
    return Scaffold(

    );
  }
}