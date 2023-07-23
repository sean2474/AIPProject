import 'package:flutter/material.dart';
import 'package:front/data/daily_schedule.dart';

class DailyScheduleViewPage extends StatefulWidget {
  final List<DailySchedule> dailySchedules;
  final bool isTimelineMode;

  const DailyScheduleViewPage({
    Key? key, 
    required this.dailySchedules,
    required this.isTimelineMode,
  }) : super(key: key);

  @override
  DailyScheduleViewPageState createState() => DailyScheduleViewPageState();
}

class DailyScheduleViewPageState extends State<DailyScheduleViewPage> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }
  @override
  Widget build(BuildContext context) {
    if (widget.isTimelineMode) {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          controller: _scrollController,
          itemCount: 19,
          itemBuilder: (context, index) {
            List<DailySchedule> dailySchedules = widget.dailySchedules.where((schedule) {
              return int.parse(schedule.startTime.split(':')[0]) == index + 5;
            }).toList();
            return _TimeLineItem(time: '${(index+5).toString().padLeft(2, '0')}:00', dailySchedules: dailySchedules,);
          },
        ),
      );
    } else {
      return Container(
        margin: EdgeInsets.only(top: 10),
        child: ListView.builder(
          itemCount: 24,
          itemBuilder: (context, index) {
            var children = <Widget>[];

            widget.dailySchedules.where((schedule) {
              return int.parse(schedule.startTime.split(':')[0]) == index;
            }).forEach((schedule) {
              children.add(
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: schedule.color,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.white,
                        offset: Offset(-4, -4),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.grey.shade500,
                        offset: Offset(4, 4),
                        blurRadius: 5,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: ListTile(
                    title: Text(schedule.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                    subtitle: Text(schedule.location, style: TextStyle(fontSize: 10, color: Colors.white)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(schedule.startTime, style: TextStyle(fontSize: 12, color: Colors.white)),
                        Text(schedule.endTime, style: TextStyle(fontSize: 12, color: Colors.white)),
                      ]
                    ),
                  ),
                )
              );
            });

            return Column(children: children);
          },
        ),
      );
    }
  }
}

class _TimeLineItem extends StatelessWidget {
  final String time;
  final List<DailySchedule> dailySchedules;

  _TimeLineItem({required this.time, required this.dailySchedules});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      margin: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(time, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          ),
          Expanded(
            flex: 9,
            child: Row(
              children: dailySchedules.map<Widget>((schedule) {
                return Expanded(
                  child: Container(
                    height: 100,
                    margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: schedule.color,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.white,
                          offset: Offset(-4, -4),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                        BoxShadow(
                          color: Colors.grey.shade500,
                          offset: Offset(4, 4),
                          blurRadius: 5,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                    child: Text(schedule.title, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }
}
