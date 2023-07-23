/// main.dart

/*
 if github commiting not working, try:
 1. move to ~/Desktop/AIPProject/.git/refs/remotes/origin
 2. remove all files in remotes
 cd ~/Desktop/AIPProject/.git/refs/remotes/origin || rm -rf *\

 I commented out the code that was throwing error for webview
 which is "package:webview_flutter_wkwebview/src/common/web_kit.g.dart:2789:7"
 if there is error, uncomment it, or try flutter clean and flutter pub get
*/

import 'dart:ui';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:front/api_service/api_service.dart';
import 'package:front/api_service/exceptions.dart';
import 'package:front/data/data.dart';
import 'package:front/data/lost_item.dart';
import 'package:front/data/school_store.dart';
import 'package:front/data/sports.dart';
import 'package:front/loading/loading.dart';
import 'package:front/main_menu/main_menu.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:front/data/food_menu.dart';
import 'firebase_options.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:front/data/sharedPreferenceStorage.dart';
import 'package:front/data/daily_schedule.dart';
import 'package:front/data/settings.dart';
import 'package:front/data/user_.dart';
import 'color_schemes.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MaterialApp(
    home: LoadingPage(),
  ));

  String baseUrl = 'http://35.169.229.180:8082';
  debugPrint("connecting to $baseUrl...");

  Settings.baseUrl = baseUrl;
  Data localData = Data(
    dailySchedules: {}, 
    foodMenus: {}, 
    lostAndFounds: [], 
    storeItems: [], 
    sportsInfo: [], 
    gameInfo: [], 
    settings: Settings(
      recentGamesToShow: await getRecentGamesToShow(),
      upcomingGamesToShow: await getUpcomingGamesToShow(), 
      starredSports: (await getStarredSports()).join(' '), 
      sortLostAndFoundBy: await getSortLostAndFoundBy() ?? 'date',
      showReturnedItem: await getShowReturnedItemsInLostAndFound(),
      isDailyScheduleTimelineMode: await getisDailyScheduleTimelineMode(),
    ), 
    apiService: ApiService(
      baseUrl: baseUrl
      )
    );

  while (true) {
    try {
      localData.user = await localData.apiService.login(await getUsername() ?? '', await getUserPassword() ?? '');
      break;
    // ignore: empty_catches
    } on Exception { }
    await Future.delayed(Duration(microseconds: 10));
  }

  // TODO: remove this after testing
  localData.user = await localData.apiService.login("johnsmith@example.com", "password1");
  localData.apiService.token = localData.user?.token;

  FirebaseAuth.instance.authStateChanges().listen((user) {
    if (localData.user != null && user == null) {
      debugPrint("signed in with local");
      Data.loggedIn = true;
    } else if (user != null) {
      debugPrint("signed in with google");
      print(user.uid);
      localData.user = User_(id: 0, token: user.uid, userType: UserType.student, name: '', password: '', email: user.email ?? '');
      Data.loggedIn = true;
    } else {
      debugPrint("user signed out");
      Data.loggedIn = false;
    }
  });
  
  /// endpoint connections to backend
  try {
    localData.gameInfo = GameInfo.transformData(await localData.apiService.getGames());
  } on NoSuchMethodError {
    debugPrint("failed to load games data");
  } on BadRequestException {
    debugPrint("bad request on games");
  } on NotFoundException {
    debugPrint("page not found on games");
  }
  try {
    localData.sportsInfo = SportsInfo.transformData(await localData.apiService.getSports());
  } on NoSuchMethodError {
    debugPrint("failed to load sports data");
  } on BadRequestException {
    debugPrint("bad request on sports");
  } on NotFoundException {
    debugPrint("page not found on sports");
  }
  try {
    localData.foodMenus = FoodMenu.transformData(await localData.apiService.getFoodMenu());
  } on NoSuchMethodError {
    debugPrint("failed to load food menu data");
  } on BadRequestException {
    debugPrint("bad request on food menu");
  } on NotFoundException {
    debugPrint("page not found on food menu");
  }

  try {
    localData.lostAndFounds = LostItem.transformData(await localData.apiService.getLostAndFound());
  } on NoSuchMethodError {
    debugPrint("failed to load lost and found data");
  } on BadRequestException {
    debugPrint("bad request on lost and found");
  } on NotFoundException {
    debugPrint("page not found on lost and found");
  }
  try {
    localData.storeItems = StoreItem.transformData(await localData.apiService.getSchoolStoreItems());
  } on NoSuchMethodError {
    debugPrint("failed to load store items data");
  } on BadRequestException {
    debugPrint("bad request on store items"); 
  } on NotFoundException {
    debugPrint("page not found on store items");
  }
  try {
    localData.dailySchedules = DailySchedule.transformData(await localData.apiService.getDailySchedule());
  } on NoSuchMethodError {
    debugPrint("failed to load daily schedule data");
  } on BadRequestException {
    debugPrint("bad request on daily schedule"); 
  } on NotFoundException {
    debugPrint("page not found on daily schedule");
  }

  localData.gameInfo.sort((a, b) => a.gameDate.compareTo(b.gameDate));

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
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      debugShowCheckedModeBanner: false,
      home: MainMenuPage(localData: widget.localData),
    );
  }
}
