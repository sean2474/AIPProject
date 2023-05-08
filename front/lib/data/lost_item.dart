import 'settings.dart';
import 'data.dart';

class LostItem {
  int id;
  String name;
  String description;
  String imageUrl;
  String locationFound;
  String dateFound;
  FoundStatus status;
  int founderId;

  LostItem({
    required this.id, 
    required this.name, 
    required this.description, 
    required this.imageUrl, 
    required this.locationFound, 
    required this.dateFound, 
    required this.status,
    required this.founderId,
  });

  static List<LostItem> transformData(List<dynamic> data) {
    return data.map((json) => LostItem.fromJson(json)).toList();
  }

  factory LostItem.fromJson(Map<String, dynamic> json) {
    return LostItem(
      id: json['id'],
      name: json['item_name'],
      description: json['description'] ?? '',
      imageUrl: "${Settings.baseUrl}${json['image_url']}",
      locationFound: json['location_found'],
      dateFound: json['date_found'],
      status: json['status'] == null ? FoundStatus.na : FoundStatus.values[json['status'] - 1],
      founderId: json['submitter_id'],
    );
  }
}