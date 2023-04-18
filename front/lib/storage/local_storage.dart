// local_storage.dart
enum UserType {
  student,
  teacher,
  parent,
  admin,
}
class User {
  int id;
  String token;
  UserType userType;
  String name;
  String password;

  User({required this.id, required this.token, required this.userType, required this.name, required this.password});
}

class DailySchedule {
  int id;
  String date;
  String imagePath;

  DailySchedule({required this.id, required this.date, required this.imagePath});
}


class FoodMenu {
  int id;
  String date;
  String breakFast;
  String lunch;
  String dinner;

  FoodMenu({required this.id, required this.date, required this.breakFast, required this.lunch, required this.dinner});
}

enum FoundStatus { returned, lost, na }
class LostItem {
  int id;
  String name;
  String description;
  String imagePath;
  String locationFound;
  String dateFound;
  FoundStatus status;

  LostItem({required this.id, required this.name, required this.description, required this.imagePath, required this.locationFound, required this.dateFound, required this.status});
}

enum TeamCategory { varsity, jv, vb, thirds, thirdsBlue, thirdsRed, fourth, fifth, na }
enum Season { fall, winter, spring, na }

class SportsInfo {
  String sportsName;
  TeamCategory teamCategory;
  Season season;
  List<String> coachNames;
  List<String> coachContacts;
  List<String> roster;

  SportsInfo({required this.sportsName, required this.teamCategory, required this.season, required this.coachNames, required this.coachContacts, required this.roster});
}

class GameInfo {
  String sportsName;
  TeamCategory teamCategory;
  String gameLocation;
  String opponent;
  bool isHomeGame;
  String matchResult;
  String gameDate;
  String coachComment;

  @override
  String toString() {
    return 'GameInfo(sportsName: $sportsName, teamCategory: $teamCategory, gameLocation: $gameLocation, opponent: $opponent, isHomeGame: $isHomeGame, matchResult: $matchResult, gameDate: $gameDate, coachComment: $coachComment)';
  }

  GameInfo({required this.sportsName, required this.teamCategory, required this.gameLocation, required this.opponent, required this.isHomeGame, required this.matchResult, required this.gameDate, required this.coachComment});

  copyWith({required String coachComment, required String matchResult}) {}
}

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

  StoreItem({required this.id, required this.name, required this.itemType, required this.description, required this.imagePath, required this.price, required this.stock, required this.dateAdded});
}

class Settings {
  int recentGamesToShow;
  int upcomingGamesToShow;
  String starredSports;
  String sortLostAndFoundBy;

  Settings({required this.recentGamesToShow, required this.upcomingGamesToShow, required this.starredSports, required this.sortLostAndFoundBy});
}
class Data {
  List<User> users;
  List<DailySchedule> dailySchedules;
  List<FoodMenu> foodMenus;
  List<LostItem> lostAndFounds;
  List<StoreItem> storeItems;
  List<SportsInfo> sportsInfo;
  List<GameInfo> gameInfo;

  Settings settings;

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
  
  Data({required this.users, required this.dailySchedules, required this.foodMenus, required this.lostAndFounds, required this.storeItems, required this.sportsInfo, required this.gameInfo, required this.settings});
}