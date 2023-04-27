/// main.dart
import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front/api_service/api_service.dart';
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

  String baseUrl = "http://127.0.0.1:8082";
  Data localData = Data(users: [], dailySchedules: [], foodMenus: [], lostAndFounds: [], storeItems: [], sportsInfo: [], gameInfo: [], settings: Settings(recentGamesToShow: 3, upcomingGamesToShow: 3, starredSports: '', sortLostAndFoundBy: 'date', baseUrl: baseUrl), apiService: ApiService(baseUrl: baseUrl));

  print(localData.apiService.getSports());
  print(localData.apiService.getGames());
  
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
