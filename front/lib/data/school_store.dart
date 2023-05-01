import 'package:front/data/data.dart';
import 'package:front/data/settings.dart';

enum ItemType { food, drink, goods, other }
class StoreItem {
  int id;
  String name;
  ItemType itemType;
  String description;
  String imagePath;
  int price;
  int stock;
  String dateAdded;

  StoreItem({
    required this.id, 
    required this.name, 
    required this.itemType, 
    required this.description, 
    required this.imagePath, 
    required this.price, 
    required this.stock, 
    required this.dateAdded
  });

  static List<StoreItem> transformData(List<dynamic> data) {
    return data.map((json) => StoreItem.fromJson(json)).toList();
  }

  factory StoreItem.fromJson(Map<String, dynamic> json) {
    return StoreItem(
      id: json['ID'],
      name: json['Product_Name'],
      itemType: ItemType.values[json['Category']],
      description: json['Description'],
      imagePath: "${Settings.baseUrl}school-store/image/${json['ID']}",
      price: json['Price'],
      stock: json['Stock'],
      dateAdded: json['Date_Added'],
    );
  }
}