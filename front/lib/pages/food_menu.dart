import 'package:flutter/material.dart';
import '../storage/local_storage.dart';

class FoodMenuPage extends StatefulWidget {
  final Data? localData;
  const FoodMenuPage({Key? key, this.localData}) : super(key: key);

  @override
  FoodMenuPageState createState() => FoodMenuPageState();
}

class FoodMenuPageState extends State<FoodMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
