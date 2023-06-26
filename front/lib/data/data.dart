import 'package:front/api_service/api_service.dart';
import 'daily_schedule.dart';
import 'food_menu.dart';
import 'lost_item.dart';
import 'sports.dart';
import 'school_store.dart';
import 'user_.dart';
import 'settings.dart';

enum ItemType { food, drink, goods, others, na }
enum FoundStatus { returned, lost, na }
enum TeamCategory { varsity, jv, vb, thirds, thirdsBlue, thirdsRed, fourth, fifth, na }
enum Season { fall, winter, spring, na }
enum UserType { student, teacher, parent, admin }

class Data {
  User_? user;
  static bool loggedIn = false;
  List<DailySchedule> dailySchedules;
  Map<String, FoodMenu> foodMenus;
  List<LostItem> lostAndFounds;
  List<StoreItem> storeItems;
  List<SportsInfo> sportsInfo;
  List<GameInfo> gameInfo;

  ApiService apiService;

  Settings settings;

  static List<List<dynamic>> pageList = [];

  void sortStoreItem() {
    storeItems.sort((a, b) => a.itemType.toString().compareTo(b.itemType.toString()));
    storeItems.sort((a, b) => a.name.compareTo(b.name));
  }

  void sortLostAndFoundBy(String sortType) {
    switch (sortType) {
      case "date":
        lostAndFounds.sort((a, b) => a.status.toString().compareTo(b.status.toString()));
        lostAndFounds.sort((a, b) => a.name.compareTo(b.name));
        lostAndFounds.sort((a, b) => a.dateFound.compareTo(b.dateFound));
        break;
      case "status":
        lostAndFounds.sort((a, b) => a.dateFound.compareTo(b.dateFound));
        lostAndFounds.sort((a, b) => a.name.compareTo(b.name));
        lostAndFounds.sort((a, b) => a.status.toString().compareTo(b.status.toString()));
        break;
      case "name":
        lostAndFounds.sort((a, b) => a.dateFound.compareTo(b.dateFound));
        lostAndFounds.sort((a, b) => a.status.toString().compareTo(b.status.toString()));
        lostAndFounds.sort((a, b) => a.name.compareTo(b.name));
        break;
      default:
        print("sortLostAndFoundBy: no sort type found");
        lostAndFounds.sort((a, b) => a.dateFound.compareTo(b.dateFound));
    }
  }
  
  Data({
    this.user, 
    required this.dailySchedules, 
    required this.foodMenus,
    required this.lostAndFounds,
    required this.storeItems,
    required this.sportsInfo,
    required this.gameInfo,
    required this.settings,
    required this.apiService,
  });
}