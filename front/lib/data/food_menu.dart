class FoodMenu {
  int id;
  String date;
  String breakFast;
  String lunch;
  String dinner;

  FoodMenu({
    required this.id, 
    required this.date, 
    required this.breakFast, 
    required this.lunch, 
    required this.dinner
  });

  static List<FoodMenu> transformData(List<dynamic> data) {
    return data.map((json) => FoodMenu.fromJson(json)).toList();
  }

  factory FoodMenu.fromJson(Map<String, dynamic> json) {
    return FoodMenu(
      id: json['id'],
      date: json['date'],
      breakFast: json['breakfast'],
      lunch: json['lunch'],
      dinner: json['dinner'],
    );
  }

  @override
  String toString() { 
    return 'FoodMenu(id: $id, date: $date, breakFast: $breakFast, lunch: $lunch, dinner: $dinner)';
  }
}