/// sports.dart
import 'package:flutter/material.dart';
import '../widgets/assets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class SportsPage extends StatefulWidget {
  const SportsPage({Key? key}) : super(key: key);
  @override
  SportsPageState createState() => SportsPageState();
}

class SportsPageState extends State<SportsPage> with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  void _selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> saveValue(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<String?> readValue(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  Future<Map<String, int>> getRecentAndUpcomingGames() async {
    int recentGames =
        int.parse(await readValue('numbersOfRecentGamesResultToShow') ?? '3');
    int upcomingGames =
        int.parse(await readValue('numbersOfUpcomingGamesResultToShow') ?? '3');
    return {'recentGames': recentGames, 'upcomingGames': upcomingGames};
  }

  Future<List<Sports>> fetchSportsData() async {
    // Replace this example data with real data fetched from the database
    List<Sports> exampleData = [
      Sports(
        sportName: 'Basketball',
        category: 'Varsity',
        coachName: 'Coach John',
        coachContact: '+1 (123) 456-7890',
        games: {
          '2023-04-02T16:00': {
            'opponent': 'School A',
            'location': 'Home',
            'result': 'Win 78-68',
          },
          '2023-04-04T16:00': {
            'opponent': 'School B',
            'location': 'Away',
            'result': 'Loss 52-58',
          },
          '2023-04-08T16:00': {
            'opponent': 'School C',
            'location': 'Home',
            'result': 'Win 64-60',
          },
        },
        roster: {
          'Player 1': 'Point Guard',
          'Player 2': 'Shooting Guard',
          'Player 3': 'Small Forward',
          'Player 4': 'Power Forward',
          'Player 5': 'Center',
        },
      ),
      Sports(
        sportName: 'Soccer',
        category: 'Varsity',
        coachName: 'Coach Jane',
        coachContact: '+1 (234) 567-8901',
        games: {
          '2023-04-01T16:00': {
            'opponent': 'School D',
            'location': 'Away',
            'result': 'Win 3-2',
          },
          '2023-04-03T15:30': {
            'opponent': 'School E',
            'location': 'Home',
            'result': 'Draw 1-1',
          },
          '2023-04-10T16:00': {
            'opponent': 'School F',
            'location': 'Home',
            'result': 'Win 4-0',
          },
        },
        roster: {
          'Player 6': 'Goalkeeper',
          'Player 7': 'Defender',
          'Player 8': 'Midfielder',
          'Player 9': 'Forward',
          'Player 10': 'Striker',
        },
      ),
    ];

    for (Sports sport in exampleData) {
      sport.games = Map.fromEntries(
        sport.games.entries.toList()
          ..sort((e1, e2) => e1.key.compareTo(e2.key)),
      );
    }

    return exampleData;
  }

  List<Map<String, dynamic>> getGames(
      List<Sports> sportsData, int recentGamesCount, int upcomingGamesCount) {
    List<Map<String, dynamic>> allGames = [];
    for (Sports sport in sportsData) {
      sport.games.forEach((gameTime, gameDetails) {
        allGames.add({
          'sportName': sport.sportName,
          'category': sport.category,
          'gameTime': gameTime,
          ...gameDetails,
        });
      });
    }

    allGames.sort((a, b) {
      int timeComparison = DateTime.parse(a['gameTime'])
          .compareTo(DateTime.parse(b['gameTime']));
      if (timeComparison != 0) {
        return timeComparison;
      } else {
        return a['sportName'].compareTo(b['sportName']);
      }
    });

    DateTime currentTime = DateTime.now();
    List<Map<String, dynamic>> recentGames = [];
    List<Map<String, dynamic>> upcomingGames = [];

    for (Map<String, dynamic> game in allGames) {
      DateTime gameTime = DateTime.parse(game['gameTime']);
      if (gameTime.isBefore(currentTime)) {
        recentGames.add(game);
      } else {
        upcomingGames.add(game);
      }
    }

    Map<String, dynamic> naGame = {
      'sportName': 'NA',
      'category': 'NA',
      'gameTime': 'NA',
      'opponent': 'NA',
      'location': 'NA',
      'result': 'NA'
    };

    int recentGamesToFill = recentGamesCount - recentGames.length;
    int upcomingGamesToFill = upcomingGamesCount - upcomingGames.length;

    for (int i = 0; i < recentGamesToFill; i++) {
      recentGames.add(naGame);
    }

    for (int i = 0; i < upcomingGamesToFill; i++) {
      upcomingGames.add(naGame);
    }

    return List<Map<String, dynamic>>.from([
      ...recentGames.reversed.take(recentGamesCount),
      ...upcomingGames.take(upcomingGamesCount),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0xFFF7F6FB),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Stack(
            children: [
              AppBar(
                backgroundColor: const Color(0xFF0E1B2A),
                elevation: 0,
                automaticallyImplyLeading: false,
                actions: [
                  GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return Dialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width *
                                    0.8, // Adjust the width of the modal
                                height: MediaQuery.of(context).size.height *
                                    0.5, // Adjust the height of the modal
                                child: const SettingPage(),
                              ),
                            );
                          },
                        );
                      },
                      child: const Icon(Icons.settings)),
                  const Assets(currentPage: SportsPage())
                      .menuBarButton(context),
                ],
              ),
            ],
          ),
        ),
        drawer: const Assets(
          currentPage: SportsPage(),
        ).build(context),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
            decoration: const BoxDecoration(
              color: Color(0xFF0E1B2A),
            ),
            child: Stack(
              children: [
                Container(
                    margin: const EdgeInsets.only(top: 0, left: 0, right: 0),
                    height: 40,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0E1B2A),
                    ),
                    child: Stack(
                      children: [
                        Positioned(
                            bottom: 5,
                            left: MediaQuery.of(context).size.width / 5,
                            right: -MediaQuery.of(context).size.width / 5,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: const Assets().textButton(context,
                                      text: "STARRED",
                                      onTap: () => _selectTab(0),
                                      color: Colors.white),
                                ),
                                Expanded(
                                  child: const Assets().textButton(context,
                                      text: "ALL",
                                      onTap: () => _selectTab(1),
                                      color: Colors.white),
                                ),
                              ],
                            )),
                        Stack(
                          children: [
                            Positioned(
                              bottom: 6,
                              left: MediaQuery.of(context).size.width / 5 + 40,
                              child: Opacity(
                                opacity: _selectedTabIndex == 0
                                    ? _animation.value
                                    : 0,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3eb9e4),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                              bottom: 6,
                              left:
                                  MediaQuery.of(context).size.width * 3.5 / 5 +
                                      20,
                              child: Opacity(
                                opacity: _selectedTabIndex == 1
                                    ? _animation.value
                                    : 0,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF3eb9e4),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )),
                Container(
                    margin: const EdgeInsets.only(
                      top: 40,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF7F6FB),
                    ),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: FutureBuilder<List<Sports>>(
                        future: fetchSportsData(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox.shrink();
                          }

                          if (!snapshot.hasData || snapshot.data == null) {
                            return const Center(
                                child: Text('No data available'));
                          }

                          final sportsData = snapshot.data!;

                          return FutureBuilder(
                              future: getRecentAndUpcomingGames(),
                              builder: ((context, snapshot) {
                                int recentGametoDisplay;
                                int upcomingGametoDisplay;
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return const SizedBox.shrink();
                                }

                                if (!snapshot.hasData ||
                                    snapshot.data == null) {
                                  recentGametoDisplay = 3;
                                  upcomingGametoDisplay = 2;
                                }
                                recentGametoDisplay =
                                    snapshot.data!['recentGames']!;
                                upcomingGametoDisplay =
                                    snapshot.data!['upcomingGames']!;

                                final games = getGames(sportsData,
                                    recentGametoDisplay, upcomingGametoDisplay);

                                return FadeTransition(
                                  opacity: _animation,
                                  child: ListView.builder(
                                      key: ValueKey<int>(_selectedTabIndex),
                                      itemCount: recentGametoDisplay +
                                          upcomingGametoDisplay,
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemBuilder: (context, index) {
                                        return games[index]['gameTime'] == 'NA'
                                            ? const Assets().boxButton(context,
                                                title: "NA",
                                                borderColor: Colors.grey,
                                                onTap: () => {})
                                            : const Assets().boxButton(context,
                                                title:
                                                    "'${games[index]['sportName']} - ${games[index]['category']}'",
                                                borderColor:
                                                    Colors.red.shade400,
                                                text:
                                                    '${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(games[index]['gameTime']))}, ${games[index]['opponent']}, ${games[index]['location']}, ${games[index]['result']}',
                                                onTap: () => {});
                                      }),
                                );
                              }));
                        },
                      ),
                    )),
              ],
            ),
          ),
        ));
  }
}

class Sports {
  final String sportName;
  final String category;
  final String coachName;
  final String coachContact;
  Map<String, dynamic> games;
  final Map<String, String> roster; // player name and description

  Sports({
    required this.sportName,
    required this.category,
    required this.coachName,
    required this.coachContact,
    required this.games,
    required this.roster,
  });
}

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [],
            ),
          ),
        ),
      ],
    );
  }
}
