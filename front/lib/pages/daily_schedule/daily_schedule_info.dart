import 'package:flutter/material.dart';
import 'package:front/data/daily_schedule.dart';

class DailyScheduleInfoPage extends StatefulWidget {
  final DailySchedule dailySchedule;
  final String date;

  const DailyScheduleInfoPage({
    Key? key, 
    required this.dailySchedule,
    required this.date,
  }) : super(key: key);

  @override
  DailyScheduleInfoPageState createState() => DailyScheduleInfoPageState();
}

class DailyScheduleInfoPageState extends State<DailyScheduleInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Event Details",
          style: Theme.of(context).textTheme.headlineLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 23,
            color: Theme.of(context).brightness == Brightness.light 
              ? Colors.grey.shade800
              : null,
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.dailySchedule.title,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).brightness == Brightness.light 
                  ? Colors.grey.shade800
                  : null,
              ),
            ),
            widget.dailySchedule.location != "" 
            ? Text(
              "(in ${widget.dailySchedule.location})",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.light 
                  ? Colors.grey.shade800
                  : null,
              ),
            )
            : SizedBox(),
            SizedBox(height: 20),
            Text(
              "${widget.date} ${_getWeekday(widget.date)}",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).brightness == Brightness.light 
                  ? Colors.grey.shade800
                  : null,
              ),
            ),
            Text(
              "${widget.dailySchedule.startTime} ~ ${widget.dailySchedule.endTime}",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: Theme.of(context).brightness == Brightness.light 
                  ? Colors.grey.shade800
                  : null,
              ),
            ),
            SizedBox(height: 25),
            Container(
              width: double.infinity,
              height: 200,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.dailySchedule.description,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontSize: 18,
                  color: Theme.of(context).brightness == Brightness.light 
                    ? Colors.grey.shade800
                    : null,
                ),
              ),
            ),
            Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: TextButton(
                style: ButtonStyle(
                  splashFactory: NoSplash.splashFactory,
                  overlayColor: MaterialStateColor.resolveWith((states) => Theme.of(context).colorScheme.secondaryContainer.withOpacity(0.2)),
                ),
                onPressed: widget.dailySchedule.isRequired ? null : () {
                  showDeleteCheckBox();
                },
                child: Text(
                  "Delete Event",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 18,
                    color: widget.dailySchedule.isRequired 
                      ? Theme.of(context).colorScheme.outline 
                      : Theme.of(context).colorScheme.primary,
                  ),
                )
              )
            )
          ],
        ),
      )
    );
  }

  String _getWeekday(String date) {
    switch (DateTime.parse(date).weekday) {
      case 1:
        return "Monday";
      case 2:
        return "Tuesday";
      case 3:
        return "Wednsday";
      case 4:
        return "Thursday";
      case 5:
        return "Friday";
      case 6:
        return "Saturday";
      default:
        return "Sunday";
    }
  }

  void showDeleteCheckBox() {
    ColorScheme colorScheme = Theme.of(context).colorScheme;
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: colorScheme.background,
              borderRadius: BorderRadius.circular(15),
            ),
            width: 300,
            height: 250,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Spacer(),
                Container(
                  padding: EdgeInsets.all(30),
                  child: Text(
                    "Are you sure you want to delete this event?", 
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15), 
                    textAlign: TextAlign.center
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    Divider(                
                      color: Theme.of(context).brightness == Brightness.light 
                        ? Colors.grey.shade300 
                        : const Color.fromARGB(255, 41, 39, 39),
                      height: 1,
                    ),
                    ListTile(
                      title: Text("Delete", style: TextStyle(color: Colors.red), textAlign: TextAlign.center),
                      onTap: () {
                      }
                    ),
                    Divider(                
                      color: Theme.of(context).brightness == Brightness.light 
                        ? Colors.grey.shade300 
                        : const Color.fromARGB(255, 41, 39, 39),
                      height: 1,
                    ),
                  ],
                ),
                ListTile(
                  title: Text("Cancel", textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ),
        );
      },
    );
  }
}