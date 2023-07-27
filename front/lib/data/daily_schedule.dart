import 'dart:collection';
import 'package:flutter/material.dart';

class DailySchedule {
  String startTime;
  String endTime;
  String title;
  bool isRequired;
  String location;
  String description;
  Color color;
  HashSet<int> resource;

  DailySchedule({
    required this.startTime,
    required this.endTime,
    required this.title,
    required this.isRequired,
    required this.location,
    required this.description,
    required this.color,
    required this.resource
  });

  static Map<String, List<DailySchedule>> transformData(Map<String, dynamic> data) {
    Map<String, List<DailySchedule>> dailySchedules = {};
    data.forEach((key, values) {
      List<DailySchedule> dailySchedule = [];
      for (dynamic value in values) {
        dailySchedule.add(DailySchedule.fromJson(value));
      }
      dailySchedule.sort((a, b) => a.startTime.compareTo(b.startTime));
      dailySchedules[key] = dailySchedule;
    });
    return dailySchedules;
  }
  
  factory DailySchedule.fromJson(Map<String, dynamic> json) {
    return DailySchedule(
      startTime: json["start"].toString().split("T")[1],
      endTime: json["end"].toString().split("T")[1],
      title: json["title"],
      // check after actual endpoint connect
      description: json["description"],
      isRequired: json["isRequired"],
      color: Color(int.parse("0xFF${json["color"].substring(1, 7)}")), // , 
      resource: HashSet<int>()..addAll(json["resource"]),
      location: json["location"],
    );
  }
    
  @override
  String toString() {
    return "$title $startTime";
  }
}