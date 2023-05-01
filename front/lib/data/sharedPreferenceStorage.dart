import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';
import 'user_.dart';

class SharedPreferenceKeys {
  static const String username = 'username';
  static const String userPassword = 'userPassword';
  static const String numbersOfRecentGamesResultToShow = 'numbersOfRecentGamesResultToShow';
  static const String numbersOfUpcomingGamesResultToShow = 'numbersOfUpcomingGamesResultToShow';
  static const String starredSports = 'starredSports';
  static const String sortLostAndFoundBy = 'sortLostAndFoundBy';
}

Future<void> saveValue(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString(key, value);
}

Future<String?> readValue(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

Future<void> saveRecentGamesToShow(int recentGames) async {
  saveValue(SharedPreferenceKeys.numbersOfRecentGamesResultToShow, recentGames.toString());
}

Future<void> saveUpcomingGamesToShow(int upcomingGames) async {
  saveValue(SharedPreferenceKeys.numbersOfUpcomingGamesResultToShow, upcomingGames.toString());
}

Future<void> saveSortLostAndFoundBy(String sort) async {
  saveValue(SharedPreferenceKeys.sortLostAndFoundBy, sort);
}

Future<String?> getSortLostAndFoundBy() async {
  return await readValue(SharedPreferenceKeys.sortLostAndFoundBy);
}

Future<void> saveSettings(Settings settings) async {
  saveRecentGamesToShow(settings.recentGamesToShow);
  saveUpcomingGamesToShow(settings.upcomingGamesToShow);
  saveStarredSports(settings.starredSports.split(" "));
  saveSortLostAndFoundBy(settings.sortLostAndFoundBy);
}

Future<int> getRecentGamesToShow() async {
  int recentGames = int.parse(await readValue(SharedPreferenceKeys.numbersOfRecentGamesResultToShow) ?? '3');
  return recentGames;
}

Future<int> getUpcomingGamesToShow() async {
  int upcomingGames = int.parse(await readValue(SharedPreferenceKeys.numbersOfUpcomingGamesResultToShow) ?? '3');
  return upcomingGames;
}

Future<void> saveStarredSports(List<String> sports) async {
  saveValue(SharedPreferenceKeys.starredSports, sports.join(' '));
}

Future<List<String>> getStarredSports() async {
  String? starredSports = await readValue(SharedPreferenceKeys.starredSports);
  if (starredSports == null) {
    return [];
  } else {
    return starredSports.split(' ');
  }
}

Future<void> saveUser(User_ user) async {
  saveValue(SharedPreferenceKeys.username, user.email);
  saveValue(SharedPreferenceKeys.userPassword, user.password);
}

Future<String?> getUsername() async {
  return await readValue(SharedPreferenceKeys.username);
}

Future<String?> getUserPassword() async {
  return await readValue(SharedPreferenceKeys.userPassword);
}