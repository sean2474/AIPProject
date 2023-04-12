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
    teamCategory: TeamCategory.jv,
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
    gameLocation: 'Home Stadium',
    opponent: 'Rival School',
    isHomeGame: true,
    matchResult: 'Win',
    gameDate: '2023-04-10',
    coachComment: 'Great job, team!',
  ));

  localData.gameInfo.add(GameInfo(
    sportsName: 'Soccer',
    teamCategory: TeamCategory.jv,
    gameLocation: 'Away Stadium',
    opponent: 'Another School',
    isHomeGame: false,
    matchResult: 'Loss',
    gameDate: '2023-04-15',
    coachComment: 'We need to practice more.',
  ));

localData.gameInfo.add(GameInfo(
    sportsName: 'Basketball',
    teamCategory: TeamCategory.varsity,
    gameLocation: 'Home Stadium',
    opponent: 'Rival School',
    isHomeGame: true,
    matchResult: 'Win',
    gameDate: '2023-04-10',
    coachComment: 'Great job, team!',
  ));

  localData.gameInfo.add(GameInfo(
    sportsName: 'Soccer',
    teamCategory: TeamCategory.jv,
    gameLocation: 'Away Stadium',
    opponent: 'Another School',
    isHomeGame: false,
    matchResult: 'Loss',
    gameDate: '2023-04-15',
    coachComment: 'We need to practice more.',
  ));

localData.gameInfo.add(GameInfo(
    sportsName: 'Basketball',
    teamCategory: TeamCategory.varsity,
    gameLocation: 'Home Stadium',
    opponent: 'Rival School',
    isHomeGame: true,
    matchResult: 'Win',
    gameDate: '2023-04-10',
    coachComment: 'Great job, team!',
  ));

  localData.gameInfo.add(GameInfo(
    sportsName: 'Soccer',
    teamCategory: TeamCategory.jv,
    gameLocation: 'Away Stadium',
    opponent: 'Another School',
    isHomeGame: false,
    matchResult: 'Loss',
    gameDate: '2023-04-15',
    coachComment: 'We need to practice more.',
  ));

  localData.gameInfo.add(GameInfo(
    sportsName: 'Basketball',
    teamCategory: TeamCategory.varsity,
    gameLocation: 'Home Stadium',
    opponent: 'Rival School',
    isHomeGame: true,
    matchResult: 'Win',
    gameDate: '2023-04-10',
    coachComment: 'Great job, team!',
  ));

  localData.gameInfo.add(GameInfo(
    sportsName: 'Soccer',
    teamCategory: TeamCategory.jv,
    gameLocation: 'Away Stadium',
    opponent: 'Another School',
    isHomeGame: false,
    matchResult: 'Loss',
    gameDate: '2023-04-15',
    coachComment: 'We need to practice more.',
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

class StudentManagementApp extends StatelessWidget {
  final Data? localData;
  const StudentManagementApp({Key? key, this.localData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StudentMainMenu(localData: localData),
    );
  }

  @override
  void dispose() {
    saveRecentGamesToShow(localData!.settings.recentGamesToShow);
    saveUpcomingGamesToShow(localData!.settings.upcomingGamesToShow);
    saveStarredSports(localData!.settings.starredSports.split(' '));
  }
}
