import 'package:flutter/material.dart';
import '../storage/local_storage.dart';

class LostAndFoundPage extends StatefulWidget {
  final Data? localData;
  const LostAndFoundPage({Key? key, this.localData}) : super(key: key);

  @override
  LostAndFoundPageState createState() => LostAndFoundPageState();
}

class LostAndFoundPageState extends State<LostAndFoundPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
