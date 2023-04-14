/// main.dart
import 'package:flutter/material.dart';
import 'package:front/storage/local_storage.dart';
import 'student/main_menu.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  Data localData = Data(users: [], dailySchedules: [], foodMenus: [], lostAndFounds: [], storeItems: [], sportsInfo: [], gameInfo: [], settings: Settings(recentGamesToShow: 3, upcomingGamesToShow: 3, starredSports: ''));

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

  // sort the games by date
  localData.gameInfo.sort((a, b) => a.gameDate.compareTo(b.gameDate));
  // sort the sports by name
  localData.sportsInfo.sort((a, b) => a.sportsName.compareTo(b.sportsName));

  localData.settings.recentGamesToShow = await getRecentGamesToShow();
  localData.settings.upcomingGamesToShow = await getUpcomingGamesToShow();
  localData.settings.starredSports = (await getStarredSports()).join(' ');

  WidgetsFlutterBinding.ensureInitialized();
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
    print('App started');
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
      saveRecentGamesToShow(widget.localData.settings.recentGamesToShow);
      saveUpcomingGamesToShow(widget.localData.settings.upcomingGamesToShow);
      saveStarredSports(widget.localData.settings.starredSports.split(' '));
      print('Saved settings');
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
