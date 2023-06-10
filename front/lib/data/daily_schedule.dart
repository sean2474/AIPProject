class DailySchedule {
  String date;
  String url;

  DailySchedule({
    required this.date, 
    required this.url,
  });

  static List<DailySchedule> transformData(List<Map<String, dynamic>> data) {
    return data.map((json) => DailySchedule.fromJson(json)).toList();
  }
  
  factory DailySchedule.fromJson(Map<String, dynamic> json) {
      return DailySchedule(
        date: json['date'],
        url: json['url'],
      );
    }
  }