import 'package:flutter/material.dart';
import 'package:front/data/daily_schedule.dart';
import 'package:front/data/data.dart';

class DailyScheduleViewPage extends StatefulWidget {
  final List<DailySchedule> dailySchedules;

  const DailyScheduleViewPage({
    Key? key, 
    required this.dailySchedules,
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
    Color? textColor = Theme.of(context).brightness == Brightness.light 
      ? Colors.grey.shade800
      : null;
    if (Data.settings.isDailyScheduleTimelineMode) {
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
                    color: schedule.color.withAlpha(50),
                    border: Border.all(
                      color: schedule.color,
                      width: 2,
                    ),
                  ),
                  child: ListTile(
                    title: Text(schedule.title, style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: textColor)),
                    subtitle: Text(schedule.location, style: TextStyle(fontSize: 12, color: textColor)),
                    trailing: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(schedule.startTime, style: TextStyle(fontSize: 14, color: textColor)),
                        Text(schedule.endTime, style: TextStyle(fontSize: 14, color: textColor)),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 1,
            child: Text(
              time, 
              style: TextStyle(
                fontSize: 12, 
                fontWeight: FontWeight.bold, 
                color: Colors.grey
              ),
            ),
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
                      color: schedule.color.withAlpha(50),
                      border: Border.all(
                        color: schedule.color,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      schedule.title, 
                      style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontSize: 14, 
                        fontWeight: FontWeight.bold, 
                        color: Theme.of(context).brightness == Brightness.light 
                          ? Colors.grey.shade800
                          : null,
                      )
                    ),
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
