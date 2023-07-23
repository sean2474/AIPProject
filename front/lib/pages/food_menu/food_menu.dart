// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/pages/food_menu/food_menu_view.dart';
import 'package:front/widgets/assets.dart';
import 'package:intl/intl.dart';

class FoodMenuPage extends StatefulWidget {
  final Data localData;

  const FoodMenuPage({Key? key, required this.localData}) : super(key: key);

  @override
  FoodMenuPageState createState() => FoodMenuPageState();
}

// TODO: add refresh indicator in body
class FoodMenuPageState extends State<FoodMenuPage> 
    with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  late final PageController _pageController;
  late final Map<String, int> _dateToIndex;

  // TODO: uncomment after testing
  // String displayDate = DateTime.now().toString().substring(0, 10);
  late String displayDate = widget.localData.foodMenus.values.toList()[0].date;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();

    _pageController = PageController();

    _pageController.addListener(() {
      int currentPage = _pageController.page!.round();
      if (currentPage != _dateToIndex[displayDate]) {
        setState(() {
          displayDate = widget.localData.foodMenus.values.toList()[currentPage].date;
        });
      }
    });

    _dateToIndex = {
      for (var i = 0; i < widget.localData.foodMenus.length; i++)
        widget.localData.foodMenus.values.toList()[i].date.substring(0, 10): i,
    };
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _selectTab(int index) {
    setState(() { 
      _selectedTabIndex = index;
    });
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    Assets assets = Assets(currentPage: FoodMenuPage(localData: widget.localData), localData: widget.localData,);
    return Column(
      children: [
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () {
              DateTime currentDate = DateTime.parse(displayDate);
              String previousDate = currentDate.subtract(Duration(days: 1)).toString().substring(0, 10);
              if (_dateToIndex.containsKey(previousDate)) {
                _pageController.previousPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }, icon: Icon(Icons.arrow_back_ios_new_rounded)),
            InkWell(
              onTap: () {
                showDatePicker(
                  context: context, 
                  initialDate: DateTime.parse(displayDate),
                  firstDate: DateTime.parse(widget.localData.foodMenus.values.toList()[0].date), 
                  lastDate: DateTime.parse(widget.localData.foodMenus.values.toList().last.date), 
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      displayDate = value.toString().substring(0, 10);
                    });
                    _pageController.animateToPage(
                      _dateToIndex[displayDate]!,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  }
                });
              },
              child: Text(
                DateFormat('yyyy-MM-dd').format(DateTime.parse(displayDate)).toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(onPressed: () {
              DateTime currentDate = DateTime.parse(displayDate);
              String nextDate = currentDate.add(Duration(days: 1)).toString().substring(0, 10);
              if (_dateToIndex.containsKey(nextDate)) {
                _pageController.nextPage(
                  duration: Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              }
            }, icon: Icon(Icons.arrow_forward_ios_rounded)),
          ],
        ),
        Container(
          margin: const EdgeInsets.symmetric(vertical: 10),
          child: assets.drawAppBarSelector(context: context, titles: ["BREAKFAST", "LUNCH", "DINNER"], selectTab: _selectTab, animation: _animation, selectedIndex: _selectedTabIndex)
        ),
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.localData.foodMenus.length,
            itemBuilder: (context, index) { 
              return FoodMenuViewPage(
                foodMenu: widget.localData.foodMenus.values.toList()[index], 
                mealType: _selectedTabIndex,
              );
            },
          ),
        ),
      ],
    );
  }
}