/// main.dart
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front/storage/local_storage.dart';
import 'pages/main_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

Future<void> saveValue(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<String?> readValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<void> saveRecentGamesToShow(int recentGames) async {
  saveValue('numbersOfRecentGamesResultToShow', recentGames.toString());
}

Future<void> saveUpcomingGamesToShow(int upcomingGames) async {
  saveValue('numbersOfUpcomingGamesResultToShow', upcomingGames.toString());
}

Future<void> saveSortLostAndFoundBy(String sort) async {
  saveValue('sortLostAndFoundBy', sort);
}

Future<String?> getSortLostAndFoundBy() async {
  return await readValue('sortLostAndFoundBy');
}

Future<void> saveSettings(Settings settings) async {
  saveRecentGamesToShow(settings.recentGamesToShow);
  saveUpcomingGamesToShow(settings.upcomingGamesToShow);
  saveStarredSports(settings.starredSports.split(" "));
  saveSortLostAndFoundBy(settings.sortLostAndFoundBy);
}

Future<int> getRecentGamesToShow() async {
  int recentGames = int.parse(await readValue('numbersOfRecentGamesResultToShow') ?? '3');
  return recentGames;
}

Future<int> getUpcomingGamesToShow() async {
  int upcomingGames = int.parse(await readValue('numbersOfUpcomingGamesResultToShow') ?? '3');
  return upcomingGames;
}

  Future<void> saveStarredSports(List<String> sports) async {
    saveValue('starredSports', sports.join(' '));
  }

  Future<List<String>> getStarredSports() async {
    String? starredSports = await readValue('starredSports');
    if (starredSports == null) {
      return [];
    } else {
      return starredSports.split(' ');
    }
  }


void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Data localData = Data(users: [], dailySchedules: [], foodMenus: [], lostAndFounds: [], storeItems: [], sportsInfo: [], gameInfo: [], settings: Settings(recentGamesToShow: 3, upcomingGamesToShow: 3, starredSports: '', sortLostAndFoundBy: 'date'));

  // Sports data
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Baseball',
    teamCategory: TeamCategory.varsity,
    season: Season.winter,
    coachNames: ['Coach John', 'Coach Jane'],
    coachContacts: ['john@example.com', 'jane@example.com'],
    roster: ['Player 1', 'Player 2', 'Player 3'],
  ));

  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Lacrosse',
    teamCategory: TeamCategory.jv,
    season: Season.fall,
    coachNames: ['Coach Michael', 'Coach Sarah'],
    coachContacts: ['michael@example.com', 'sarah@example.com'],
    roster: ['Player A', 'Player B', 'Player C'],
  ));
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Track and Field',
    teamCategory: TeamCategory.varsity,
    season: Season.winter,
    coachNames: ['Coach John', 'Coach Jane'],
    coachContacts: ['john@example.com', 'jane@example.com'],
    roster: ['Player 1', 'Player 2', 'Player 3'],
  ));

  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Tennis',
    teamCategory: TeamCategory.jv,
    season: Season.fall,
    coachNames: ['Coach Michael', 'Coach Sarah'],
    coachContacts: ['michael@example.com', 'sarah@example.com'],
    roster: ['Player A', 'Player B', 'Player C'],
  ));
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Golf',
    teamCategory: TeamCategory.varsity,
    season: Season.winter,
    coachNames: ['Coach John', 'Coach Jane'],
    coachContacts: ['john@example.com', 'jane@example.com'],
    roster: ['Player 1', 'Player 2', 'Player 3'],
  ));

  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Hockey',
    teamCategory: TeamCategory.jv,
    season: Season.fall,
    coachNames: ['Coach Michael', 'Coach Sarah'],
    coachContacts: ['michael@example.com', 'sarah@example.com'],
    roster: ['Player A', 'Player B', 'Player C'],
  ));
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Basketball',
    teamCategory: TeamCategory.varsity,
    season: Season.winter,
    coachNames: ['Coach John', 'Coach Jane'],
    coachContacts: ['john@example.com', 'jane@example.com'],
    roster: ['Player 1', 'Player 2', 'Player 3'],
  ));

  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Basketball',
    teamCategory: TeamCategory.jv,
    season: Season.winter,
    coachNames: ['Coach John', 'Coach Jane'],
    coachContacts: ['john@example.com', 'jane@example.com'],
    roster: ['Player 1', 'Player 2', 'Player 3'],
  ));
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Basketball',
    teamCategory: TeamCategory.thirds,
    season: Season.winter,
    coachNames: ['Coach John', 'Coach Jane'],
    coachContacts: ['john@example.com', 'jane@example.com'],
    roster: ['Player 1', 'Player 2', 'Player 3'],
  ));

  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Wrestling',
    teamCategory: TeamCategory.jv,
    season: Season.fall,
    coachNames: ['Coach Michael', 'Coach Sarah'],
    coachContacts: ['michael@example.com', 'sarah@example.com'],
    roster: ['Player A', 'Player B', 'Player C'],
  ));
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Squash',
    teamCategory: TeamCategory.varsity,
    season: Season.winter,
    coachNames: ['Coach John', 'Coach Jane'],
    coachContacts: ['john@example.com', 'jane@example.com'],
    roster: ['Player 1', 'Player 2', 'Player 3'],
  ));

  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Swimming',
    teamCategory: TeamCategory.jv,
    season: Season.fall,
    coachNames: ['Coach Michael', 'Coach Sarah'],
    coachContacts: ['michael@example.com', 'sarah@example.com'],
    roster: ['Player A', 'Player B', 'Player C'],
  ));
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Football',
    teamCategory: TeamCategory.varsity,
    season: Season.winter,
    coachNames: ['Coach John', 'Coach Jane'],
    coachContacts: ['john@example.com', 'jane@example.com'],
    roster: ['Player 1', 'Player 2', 'Player 3'],
  ));
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Soccer',
    teamCategory: TeamCategory.varsity,
    season: Season.fall,
    coachNames: ['Coach Michael', 'Coach Sarah'],
    coachContacts: ['michael@example.com', 'sarah@example.com'],
    roster: ['Player A', 'Player B', 'Player C'],
  ));
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Soccer',
    teamCategory: TeamCategory.jv,
    season: Season.fall,
    coachNames: ['Coach Michael', 'Coach Sarah'],
    coachContacts: ['michael@example.com', 'sarah@example.com'],
    roster: ['Player A', 'Player B', 'Player C'],
  ));
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Soccer',
    teamCategory: TeamCategory.thirds,
    season: Season.fall,
    coachNames: ['Coach Michael', 'Coach Sarah'],
    coachContacts: ['michael@example.com', 'sarah@example.com'],
    roster: ['Player A', 'Player B', 'Player C'],
  ));
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Soccer',
    teamCategory: TeamCategory.fourth,
    season: Season.fall,
    coachNames: ['Coach Michael', 'Coach Sarah'],
    coachContacts: ['michael@example.com', 'sarah@example.com'],
    roster: ['Player A', 'Player B', 'Player C'],
  ));
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Soccer',
    teamCategory: TeamCategory.fifth,
    season: Season.fall,
    coachNames: ['Coach Michael', 'Coach Sarah'],
    coachContacts: ['michael@example.com', 'sarah@example.com'],
    roster: ['Player A', 'Player B', 'Player C'],
  ));
  localData.sportsInfo.add(SportsInfo(
    sportsName: 'Cross Country',
    teamCategory: TeamCategory.varsity,
    season: Season.winter,
    coachNames: ['Coach John', 'Coach Jane'],
    coachContacts: ['john@example.com', 'jane@example.com'],
    roster: ['Player 1', 'Player 2', 'Player 3'],
  ));

  // Game data
  localData.gameInfo.add(GameInfo(
    sportsName: 'Basketball',
    teamCategory: TeamCategory.varsity,
    gameLocation: 'Sailsbury',
    opponent: 'Sailsbury',
    isHomeGame: true,
    matchResult: '65-40',
    gameDate: '2023-04-10T16:00',
    coachComment: 'Great job, team!',
  ));

  localData.gameInfo.add(GameInfo(
    sportsName: 'Basketball',
    teamCategory: TeamCategory.jv,
    gameLocation: 'Home',
    opponent: 'Suffield',
    isHomeGame: true,
    matchResult: '74-16',
    gameDate: '2023-04-11T16:00',
    coachComment: 'Great job, team!',
  ));

  localData.gameInfo.add(GameInfo(
    sportsName: 'Basketball',
    teamCategory: TeamCategory.varsity,
    gameLocation: 'Home',
    opponent: 'Dual',
    isHomeGame: true,
    matchResult: 'Win',
    gameDate: '2023-04-12T16:00',
    coachComment: 'Great job, team!',
  ));

  localData.gameInfo.add(GameInfo(
    sportsName: 'Basketball',
    teamCategory: TeamCategory.jv,
    gameLocation: 'Pomfret',
    opponent: 'Pomfret',
    isHomeGame: false,
    matchResult: 'Loss',
    gameDate: '2024-04-15T16:00',
    coachComment: 'Great job, team!',
  ));

  localData.gameInfo.add(GameInfo(
    sportsName: 'Basketball',
    teamCategory: TeamCategory.varsity,
    gameLocation: 'Blair',
    opponent: 'Blair',
    isHomeGame: false,
    matchResult: 'Win',
    gameDate: '2024-04-10T16:00',
    coachComment: 'Great job, team!',
  ));

  localData.gameInfo.add(GameInfo(
    sportsName: 'Basketball',
    teamCategory: TeamCategory.jv,
    gameLocation: 'Home',
    opponent: 'Sailsbury',
    isHomeGame: false,
    matchResult: 'Loss',
    gameDate: '2024-04-15T16:00',
    coachComment: 'Great job, team!',
  ));

  for (int i = 1; i <= 5; i++) {
    localData.dailySchedules.add(
      DailySchedule(
        id: i,
        date: '2023-04-0$i',
        imagePath: 'assets/daily_schedule/IMG_0992.jpeg',
      ),
    );
  }
  
  // generate lost and found example datas
  for (int i = 1; i <= 5; i++) {
    localData.lostAndFounds.add(
      LostItem(
        id: i,
        name: 'Lost item $i',
        dateFound: '2023-04-0$i',
        locationFound: 'Location $i',
        status: FoundStatus.lost,
        imagePath: 'assets/lost_and_found/diamond.jpg',
        description: 'This is lost item $i',
      ),
    );
  }
  for (int i = 1; i <= 5; i++) {
    localData.lostAndFounds.add(
      LostItem(
        id: i,
        name: 'Lost item $i',
        dateFound: '2023-04-0$i',
        locationFound: 'Location $i',
        status: FoundStatus.returned,
        imagePath: 'assets/lost_and_found/diamond.jpg',
        description: 'This is lost item $i',
      ),
    );
  }

  // generate store example datas
  localData.storeItems.add(
    StoreItem(
      id: 1,
      name: 'pizza',
      itemType: ItemType.food,
      price: 100,
      stock: 10,
      description: 'some description',
      imagePath: 'https://cdn.newspenguin.com/news/photo/202007/2106_6019_954.jpg',
      dateAdded: '2023-03-31 09:00:00',
    ),
  );
  localData.storeItems.add(
    StoreItem(
      id: 2,
      name: 'gatorade',
      itemType: ItemType.drink,
      price: 100,
      stock: 10,
      description: 'some description',
      imagePath: 'https://cdn.newspenguin.com/news/photo/202007/2106_6019_954.jpg',
      dateAdded: '2023-03-31 09:00:00',
    ),
  );
  localData.storeItems.add(
    StoreItem(
      id: 3,
      name: 'chicken',
      itemType: ItemType.food,
      price: 100,
      stock: 10,
      description: 'some description',
      imagePath: 'https://cdn.newspenguin.com/news/photo/202007/2106_6019_954.jpg',
      dateAdded: '2023-03-31 09:00:00',
    ),
  );
  localData.storeItems.add(
    StoreItem(
      id: 5,
      name: 'avon hoodie',
      itemType: ItemType.goods,
      price: 100,
      stock: 10,
      description: 'some description',
      imagePath: 'https://cdn.newspenguin.com/news/photo/202007/2106_6019_954.jpg',
      dateAdded: '2023-03-31 09:00:00',
    ),
  );
  
  // sort the games by date
  localData.gameInfo.sort((a, b) => a.gameDate.compareTo(b.gameDate));
  // sort the sports by name
  localData.sportsInfo.sort((a, b) => a.sportsName.compareTo(b.sportsName));

  localData.settings.recentGamesToShow = await getRecentGamesToShow();
  localData.settings.upcomingGamesToShow = await getUpcomingGamesToShow();
  localData.settings.starredSports = (await getStarredSports()).join(' ');

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(StudentManagementApp(localData: localData));
}

class StudentManagementApp extends StatefulWidget {
  final Data localData;
  const StudentManagementApp({Key? key, required this.localData}) : super(key: key);

  @override
  StudentManagementAppState createState() => StudentManagementAppState();
}

class StudentManagementAppState extends State<StudentManagementApp> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    print('app disposed');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      saveSettings(widget.localData.settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentMainMenu(localData: widget.localData),
    );
  }
}
