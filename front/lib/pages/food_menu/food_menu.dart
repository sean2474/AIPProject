// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';

class FoodMenuPage extends StatefulWidget {
  final Data localData;

  const FoodMenuPage({Key? key, required this.localData}) : super(key: key);

  @override
  FoodMenuPageState createState() => FoodMenuPageState();
}

// TODO: add refresh indicator in body
class FoodMenuPageState extends State<FoodMenuPage> {
  String _selectedMealTime = '';
  bool _isToday = true;
  String _menu = '';

  @override
  Widget build(BuildContext context) {
    String day = _isToday ? "Today's" : "Tomorrow's";
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1B2A),
        title: Text('$day Menu'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Menu:',
              style: TextStyle(fontSize: 18),
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '$_menu',
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _isToday ? 0 : 1,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_back),
            label: 'Yesterday',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_forward),
            label: 'Tomorrow',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            setState(() {
              _isToday = false;
            });
          } else {
            setState(() {
              _isToday = true;
            });
          }
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () => _updateMenu('Breakfast'),
              child: Text('Breakfast'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E1B2A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () => _updateMenu('Lunch'),
              child: Text('Lunch'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E1B2A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
            ElevatedButton(
              onPressed: () => _updateMenu('Dinner'),
              child: Text('Dinner'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0E1B2A),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                textStyle: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _updateMenu(String mealTime) {
    Data localData = widget.localData;
    Assets assets = Assets(localData: localData);

    setState(() {
      _selectedMealTime = mealTime;
      // Example data
      if (mealTime == 'Breakfast') {
        _menu = localData.foodMenus[0].breakFast;
      } else if (mealTime == 'Lunch') {
        _menu = localData.foodMenus[0].lunch;
      } else {
        _menu = localData.foodMenus[0].dinner;
      }
    });
  }
}