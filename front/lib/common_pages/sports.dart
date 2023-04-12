/// sports.dart
import 'package:flutter/material.dart';
import '../storage/local_storage.dart';
import '../widgets/assets.dart';
import 'package:intl/intl.dart';

class SportsPage extends StatefulWidget {
  final Data? localData;
  const SportsPage({Key? key, this.localData}) : super(key: key);
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

  Widget sportsInfoBox(SportsInfo sports, Widget child) {
    return InkWell(
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
                child: SportsInfoPage(sportsData: sports),
              ),
            );
          },
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.25,
          height: MediaQuery.of(context).size.height * 0.25,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              child,
              Text(
                sports.sportsName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  List<GameInfo> getGames(List<GameInfo> gameData, int recentGamesCount, int upcomingGamesCount) {
    DateTime currentTime = DateTime.now();
    List<GameInfo> recentGames = [];
    List<GameInfo> upcomingGames = [];

    for (GameInfo game in gameData.toList()) {
      DateTime gameTime = DateTime.parse(game.gameDate);
      if (gameTime.isBefore(currentTime)) {
        recentGames.add(game);
      } else {
        upcomingGames.add(game);
      }
    }

    GameInfo naGame = GameInfo(
      sportsName : 'N/A',
      teamCategory : TeamCategory.na,
      gameLocation : 'N/A',
      opponent : 'N/A',
      matchResult : 'N/A',
      gameDate : 'N/A',
      coachComment : 'N/A',
      isHomeGame: false,
    );

    int recentGamesToFill = recentGamesCount - recentGames.length;
    int upcomingGamesToFill = upcomingGamesCount - upcomingGames.length;

    for (int i = 0; i < recentGamesToFill; i++) {
      recentGames.add(naGame);
    }

    for (int i = 0; i < upcomingGamesToFill; i++) {
      upcomingGames.add(naGame);
    }

    // if delete coachComment and matchResult of upcomingGames
    for(GameInfo game in upcomingGames) {
      game.coachComment = '';
      game.matchResult = '';
    }

    return List<GameInfo>.from([
      ...upcomingGames.reversed.take(upcomingGamesCount),
      ...recentGames.reversed.take(recentGamesCount),
    ]);
  }

  String getCategoryToString(TeamCategory category) {
    // enum TeamCategory { varsity, jv, vb, thirds, thirdsBlue, thirdsRed, fourth, fifth, na }
    switch (category) {
      case TeamCategory.fifth:
        return 'Fifth';
      case TeamCategory.fourth:
        return 'Fourth';
      case TeamCategory.thirds:
        return 'Thirds';
      case TeamCategory.thirdsBlue:
        return 'Thirds Blue';
      case TeamCategory.thirdsRed:
        return 'Thirds Red';
      case TeamCategory.jv:
        return 'JV';
      case TeamCategory.vb:
        return 'VARSITY B';
      case TeamCategory.varsity:
        return 'VARSITY';
      default:
        return 'N/A';
    }
  }

  @override
  Widget build(BuildContext context) {
    Data? localData = widget.localData;
    int recentGametoDisplay, upcomingGametoDisplay;
    List<SportsInfo> sportsInfo;
    List<GameInfo> gameInfo;
    Assets assets = const Assets(currentPage: SportsPage());
    List<GameInfo> games;
    
    if (localData != null) {
      recentGametoDisplay = localData.settings.recentGamesToShow;
      upcomingGametoDisplay = localData.settings.upcomingGamesToShow;
      sportsInfo = localData.sportsInfo;
      gameInfo = localData.gameInfo;
    } else {
      recentGametoDisplay = 3;
      upcomingGametoDisplay = 3;
      sportsInfo = [];
      gameInfo = [];
    }

    games = getGames(gameInfo, recentGametoDisplay, upcomingGametoDisplay);
    
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
                            width: MediaQuery.of(context).size.width * 0.8,
                            height: MediaQuery.of(context).size.height * 0.5, 
                            child: SettingPage(
                              sportsData: sportsInfo,
                            ),
                          ),
                        );
                      },
                    );
                  },
                  child: const Icon(Icons.settings)
                ),
                assets.menuBarButton(context),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15, left: 30),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Sports",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: assets.build(context),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0E1B2A),
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
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
                            child: assets.textButton(
                              context,
                              text: "STARRED",
                              onTap: () => _selectTab(0),
                              color: Colors.white
                            ),
                          ),
                          Expanded(
                            child: assets.textButton(
                              context,
                              text: "ALL",
                              onTap: () => _selectTab(1),
                              color: Colors.white
                            ),
                          ),
                        ],
                      )
                    ),
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
                          left: MediaQuery.of(context).size.width * 3.5 / 5 + 20,
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
                )
              ),
              Container(
                margin: const EdgeInsets.only(top: 40,),
                decoration: const BoxDecoration(
                  color: Color(0xFFF7F6FB),
                ),
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: FadeTransition(
                        opacity: _animation,
                        child: ListView.builder(
                          key: ValueKey<int>(_selectedTabIndex),
                          itemCount: recentGametoDisplay + upcomingGametoDisplay,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return games[index].gameDate == 'NA'
                              ? assets.boxButton(
                                context,
                                title: "NA",
                                borderColor: Colors.grey,
                                onTap: () => {
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
                                          child: GameInfoPage(gameData: games[index]),
                                        ),
                                      );
                                    },
                                  )
                                },
                                margin: const EdgeInsets.only(top: 10, left: 10),
                              )
                              : const Assets().boxButton(
                                context,
                                title: "${games[index].sportsName} - ${getCategoryToString(games[index].teamCategory)}",
                                borderColor: games[index].matchResult == ''
                                ? Colors.red.shade400
                                : Colors.lightBlue.shade200,
                                text: '${DateFormat('yyyy-MM-dd').format(DateTime.parse(games[index].gameDate))}, ${games[index].opponent}, ${games[index].gameLocation}${games[index].matchResult == '' ? '' : ', '}${games[index].matchResult}',
                                onTap: () => {
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
                                          child: GameInfoPage(gameData: games[index]),
                                        ),
                                      );
                                    },
                                  )
                                },
                                margin: const EdgeInsets.only(top: 10, left: 10),
                            );
                          }
                        ),
                      ),
                    ),
                    const Text(
                      'SPORTS INFO',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                      ),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                        ), 
                        itemCount: sportsInfo.length,
                        itemBuilder: (context, index) {
                          final String sportsName = sportsInfo[index].sportsName.toLowerCase().replaceAll(' ', '_');
                          const Color iconColor = Colors.black;
                          const double size = 80;
                    
                          Widget icon = const Icon(Icons.error);
                          switch (sportsName) {
                            case "football":
                              icon = const Icon(Icons.sports_football, color: iconColor, size: size);
                              break;
                            case "soccer":
                              icon = const Icon(Icons.sports_soccer, color: iconColor, size: size);
                              break;
                            case "cross_country":
                              icon = const Icon(Icons.directions_run, color: iconColor, size: size);
                              break;
                            case "hockey":
                              icon = const Icon(Icons.sports_hockey, color: iconColor, size: size);
                              break;
                            case "basketball":
                              icon = const Icon(Icons.sports_basketball, color: iconColor, size: size);
                              break;
                            case "squash":
                              icon = const ImageIcon(AssetImage('assets/sports_icons/squash.png'), color: iconColor, size: size);
                              break;
                            case "wrestling":
                              icon = const ImageIcon(AssetImage('assets/sports_icons/wrestling.png'), color: iconColor, size: size);
                              break;
                            case "swimming":
                              icon = const ImageIcon(AssetImage('assets/sports_icons/swimming.png'), color: iconColor, size: size);
                              break;
                            case "baseball":
                              icon = const Icon(Icons.sports_baseball, color: iconColor, size: size);
                              break;
                            case "lacrosse":
                              icon = const ImageIcon(AssetImage('assets/sports_icons/lacrosse.png'), color: iconColor, size: size);
                              break;
                            case "golf":
                              icon = const Icon(Icons.sports_golf, color: iconColor, size: size);
                              break;
                            case "track_and_field":
                              icon = const ImageIcon(AssetImage('assets/sports_icons/track_and_field.png'), color: iconColor, size: size);
                              break;
                            case "tennis":
                              icon = const Icon(Icons.sports_tennis, color: iconColor, size: size);
                              break;
                          }
                          return sportsInfoBox(
                            sportsInfo[index],
                            icon,
                          );
                        }
                      ),
                    )
                  ],
                )
              ),
            ],
          ),
        ),
      )
    );
  }
}

class SettingPage extends StatelessWidget {
  final List<SportsInfo> sportsData;
  const SettingPage({Key? key, required this.sportsData}) : super(key: key);  

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

class GameInfoPage extends StatelessWidget {
  final GameInfo gameData;

  const GameInfoPage({Key? key, required this.gameData}) : super(key: key);

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

class SportsInfoPage extends StatelessWidget {
  final SportsInfo sportsData;

  const SportsInfoPage({Key? key, required this.sportsData}) : super(key: key);

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
