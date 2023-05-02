enum TeamCategory { varsity, jv, vb, thirds, thirdsBlue, thirdsRed, fourth, fifth, na }
enum Season { fall, winter, spring, na }

class SportsInfo {
  int id;
  String sportsName;
  TeamCategory teamCategory;
  Season season;
  List<String> coachNames;
  List<String> coachContacts;
  List<String> roster;

  SportsInfo({
    required this.id,
    required this.sportsName, 
    required this.teamCategory, 
    required this.season, 
    required this.coachNames, 
    required this.coachContacts, 
    required this.roster
  });

  static List<SportsInfo> transformData(List<Map<String, dynamic>> data) {
    return data.map((json) => SportsInfo.fromJson(json)).toList();
  }

  factory SportsInfo.fromJson(Map<String, dynamic> json) {
    int? categoryIndex = json['category'];
    TeamCategory teamCategory = TeamCategory.na;

    if (categoryIndex != null && categoryIndex >= 0 && categoryIndex < TeamCategory.values.length) {
      teamCategory = TeamCategory.values[categoryIndex];
    }

    int? seasonIndex = json['season'];
    Season season = Season.na;

    if (seasonIndex != null && seasonIndex >= 0 && seasonIndex < Season.values.length) {
      season = Season.values[seasonIndex];
    }

    return SportsInfo(
      id: json['id'],
      sportsName: json['sport_name'],
      teamCategory: teamCategory,
      season: season,
      coachNames: json['coach_name']?.split("/"),
      coachContacts: json['coach_contact']?.split("/"),
      roster: json['roster']?.split("/"),
    );
  }
}

class GameInfo {
  int id;
  String sportsName;
  TeamCategory teamCategory;
  String gameLocation;
  String opponent;
  bool isHomeGame;
  String matchResult;
  String gameDate;
  String coachComment;

  GameInfo({
    required this.id,
    required this.sportsName,
    required this.teamCategory,
    required this.gameLocation,
    required this.opponent,
    required this.isHomeGame,
    required this.matchResult,
    required this.gameDate,
    required this.coachComment,
  });

  static List<GameInfo> transformData(List<Map<String, dynamic>> data) {
    return data.map((json) => GameInfo.fromJson(json)).toList();
  }

  factory GameInfo.fromJson(Map<String, dynamic> json) {
    int? categoryIndex = json['category'];
    TeamCategory teamCategory = TeamCategory.na;

    if (categoryIndex != null && categoryIndex >= 0 && categoryIndex < TeamCategory.values.length) {
      teamCategory = TeamCategory.values[categoryIndex];
    }

    return GameInfo(
      id: json['id'],
      sportsName: json['sport_name'],
      teamCategory: teamCategory,
      gameLocation: json['game_location'],
      opponent: json['opponent_school'],
      isHomeGame: json['home_or_away'] == 1,
      matchResult: json['match_result'],
      gameDate: json['game_schedule'],
      coachComment: json['coach_comment'],
    );
  }

  @override
  String toString() {
    return 'GameInfo(id: $id, sportsName: $sportsName, teamCategory: $teamCategory, gameLocation: $gameLocation, opponent: $opponent, isHomeGame: $isHomeGame, matchResult: $matchResult, gameDate: $gameDate, coachComment: $coachComment)';
  }
}