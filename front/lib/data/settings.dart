class Settings {
  int recentGamesToShow;
  int upcomingGamesToShow;
  String starredSports;
  String sortLostAndFoundBy;
  static String baseUrl = '';

  Settings({
    required this.recentGamesToShow, 
    required this.upcomingGamesToShow, 
    required this.starredSports, 
    required this.sortLostAndFoundBy, 
  });
}