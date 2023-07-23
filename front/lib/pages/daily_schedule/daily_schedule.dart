import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'package:intl/intl.dart';

import 'daily_schedule_view.dart';

class DailySchedulePage extends StatefulWidget {
  final Data localData;
  const DailySchedulePage({Key? key, required this.localData}): super(key: key);
  @override
  DailySchedulePageState createState() => DailySchedulePageState();
}

class DailySchedulePageState extends State<DailySchedulePage> with TickerProviderStateMixin{
  late final PageController _pageController;
  late final Map<String, int> _dateToIndex;

  // TODO: uncomment after testing
  // String displayDate = DateTime.now().toString().substring(0, 10);
  late String? displayDate;

  @override
  void initState() {
    super.initState();
    if (widget.localData.dailySchedules.isNotEmpty) {
      displayDate = widget.localData.dailySchedules.keys.toList().first;
    } else {
      displayDate = null;
    }
    _pageController = PageController();
    _pageController.addListener(() {
      int currentPage = _pageController.page!.round();
      if (currentPage != _dateToIndex[displayDate]) {
        setState(() {
          displayDate = widget.localData.dailySchedules.keys.toList()[currentPage];
        });
      }
    });

    _dateToIndex = {
      for (var i = 0; i < widget.localData.dailySchedules.length; i++)
        widget.localData.dailySchedules.keys.toList()[i]: i,
    };
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {  
    Data localData = widget.localData;
    Size screen = MediaQuery.of(context).size;
    Assets assets = Assets(currentPage: DailySchedulePage(localData: localData), localData: localData);
    if (displayDate == null) {
      return Container(
        margin: EdgeInsets.only(top: 10, left: 20, right: 20),
        child: Column(
          children: const [
            Expanded(
              child: Center(
                child: Text(
                  "Daily Schedule not found",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            )
          ],
        )
      );
    }
    return Column(
      children: [
        SizedBox(height: 10,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(onPressed: () {
              DateTime currentDate = DateTime.parse(displayDate!);
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
                  initialDate: DateTime.parse(displayDate!),
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
                DateFormat('yyyy-MM-dd').format(DateTime.parse(displayDate!)).toString(),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            IconButton(onPressed: () {
              DateTime currentDate = DateTime.parse(displayDate!);
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
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.localData.dailySchedules.length,
            itemBuilder:(context, index) {
              return DailyScheduleViewPage(
                dailySchedules: widget.localData.dailySchedules.values.toList()[index],
                isTimelineMode: true //  widget.localData.settings.isDailyScheduleTimelineMode,
              );
            },
          ),
        )
      ],
    );
  }
}