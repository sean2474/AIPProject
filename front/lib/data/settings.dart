class Settings {
  int recentGamesToShow;
  int upcomingGamesToShow;
  String starredSports;
  String sortLostAndFoundBy;
  bool showReturnedItem;
  static String baseUrl = '';
  
  Settings({
    required this.recentGamesToShow, 
    required this.upcomingGamesToShow, 
    required this.starredSports, 
    required this.sortLostAndFoundBy, 
    required this.showReturnedItem,
  });
}