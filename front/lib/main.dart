/// main.dart
/// 
/*
 running in emulator
 flutter run --no-sound-null-safety
 
 running in my iphone ...
 flutter run -d 00008110-00184D620E22801E --no-sound-null-safety
 
 checking for connected devices
 flutter devices
 
 if github commiting not working, try:
 1. move to ~/Desktop/AIPProject/.git/refs/remotes/origin
 2. remove all files in remotes
 cd ~/Desktop/AIPProject/.git/refs/remotes/origin || rm -rf *
*/
import 'dart:io';
import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front/api_service/api_service.dart';
import 'package:front/data/data.dart';
import 'package:front/data/food_menu.dart';
import 'package:front/data/lost_item.dart';
import 'package:front/data/school_store.dart';
import 'package:front/data/sports.dart';
import 'package:front/utils/loading.dart';
import 'package:front/pages/main_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:front/data/sharedPreferenceStorage.dart';
import 'package:front/data/daily_schedule.dart';
import 'package:front/data/settings.dart';
import 'package:front/data/user_.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: LoadingPage(),
  ));

  // String baseUrl = 'http://127.0.0.1:8082';
  String baseUrl = 'http://52.91.153.106:8082';
  Settings.baseUrl = baseUrl;
  Data localData = Data(dailySchedules: [], foodMenus: [], lostAndFounds: [], storeItems: [], sportsInfo: [], gameInfo: [], settings: Settings(recentGamesToShow: 3, upcomingGamesToShow: 3, starredSports: '', sortLostAndFoundBy: 'date'), apiService: ApiService(baseUrl: baseUrl));

  try {
  localData.user = await localData.apiService.login(await getUsername() ?? '', await getUserPassword() ?? '');
  } on SocketException {
    debugPrint("server not running");
    rethrow;
  }
  // localData.user = await localData.apiService.login("johnsmith@example.com", "password1");

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (localData.user != null && user == null) {
      debugPrint("signed in with local");
      Data.loggedIn = true;
    } else if (user != null) {
      debugPrint("signed in with google");
      localData.user = User_(id: 0, token: user.uid, userType: UserType.student, name: '', password: '', email: user.email ?? '');
      Data.loggedIn = true;
    } else {
      debugPrint("signed out");
      Data.loggedIn = false;
    }
  });
  
  if (await localData.apiService.checkAuth(localData.user)) {
    debugPrint("user is authenticated");
  } else {
    debugPrint("user is not authenticated");
  }
  
  /// endpoint connections to backend
  localData.gameInfo = GameInfo.transformData(await localData.apiService.getGames());
  localData.sportsInfo = SportsInfo.transformData(await localData.apiService.getSports());
  localData.dailySchedules = DailySchedule.transformData(await localData.apiService.getDailySchedule());
  // localData.foodMenus = FoodMenu.transformData(await localData.apiService.getFoodMenu());
  localData.lostAndFounds = LostItem.transformData(await localData.apiService.getLostAndFound());
  localData.storeItems = StoreItem.transformData(await localData.apiService.getSchoolStoreItems());
  
  localData.gameInfo.sort((a, b) => a.gameDate.compareTo(b.gameDate));
  localData.sportsInfo.sort((a, b) => a.sportsName.compareTo(b.sportsName));

  localData.settings.recentGamesToShow = await getRecentGamesToShow();
  localData.settings.upcomingGamesToShow = await getUpcomingGamesToShow();
  localData.settings.starredSports = (await getStarredSports()).join(' ');

  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  debugPrint("lanching app");
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
    debugPrint('app disposed');
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.detached) {
      saveSettings(widget.localData.settings);
      if (widget.localData.user != null) {
        saveUser(widget.localData.user!);
      }
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
