/// sports.dart
// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import '../storage/local_storage.dart';
import '../widgets/assets.dart';
import 'package:intl/intl.dart';

getSportsIcon(String sportsName, Color iconColor, double size) {
  Widget icon;
  switch (sportsName) {
    case "football":
      icon = Icon(Icons.sports_football, color: iconColor, size: size);
      break;
    case "soccer":
      icon = Icon(Icons.sports_soccer, color: iconColor, size: size);
      break;
    case "cross_country":
      icon = Icon(Icons.directions_run, color: iconColor, size: size);
      break;
    case "hockey":
      icon = Icon(Icons.sports_hockey, color: iconColor, size: size);
      break;
    case "basketball":
      icon = Icon(Icons.sports_basketball, color: iconColor, size: size);
      break;
    case "squash":
      icon = ImageIcon(AssetImage('assets/sports_icons/squash.png'), color: iconColor, size: size);
      break;
    case "wrestling":
      icon = ImageIcon(AssetImage('assets/sports_icons/wrestling.png'), color: iconColor, size: size);
      break;
    case "swimming":
      icon = ImageIcon(AssetImage('assets/sports_icons/swimming.png'), color: iconColor, size: size);
      break;
    case "baseball":
      icon = Icon(Icons.sports_baseball, color: iconColor, size: size);
      break;
    case "lacrosse":
      icon = ImageIcon(AssetImage('assets/sports_icons/lacrosse.png'), color: iconColor, size: size);
      break;
    case "golf":
      icon = Icon(Icons.sports_golf, color: iconColor, size: size);
      break;
    case "track_and_field":
      icon = ImageIcon(AssetImage('assets/sports_icons/track_and_field.png'), color: iconColor, size: size);
      break;
    case "tennis":
      icon = Icon(Icons.sports_tennis, color: iconColor, size: size);
      break;
    default:
      icon = Icon(Icons.sports, color: iconColor, size: size);
      break;
  }
  return icon;
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
      return 'Varsity B';
    case TeamCategory.varsity:
      return 'Varsity';
    default:
      return 'N/A';
  }
}
class SportsPage extends StatefulWidget {
  final Data localData;
  const SportsPage({Key? key, required this.localData}) : super(key: key);
  @override
  SportsPageState createState() => SportsPageState();
}

class SportsPageState extends State<SportsPage> with SingleTickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  final GameInfo naGame = GameInfo(
      sportsName : 'N/A',
      teamCategory : TeamCategory.na,
      gameLocation : 'N/A',
      opponent : 'N/A',
      matchResult : 'N/A',
      gameDate : 'N/A',
      coachComment : 'N/A',
      isHomeGame: false,
  );

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

  Widget sportsInfoBox({required SportsInfo sports, required Widget child, required Function() onTap}) {
    return InkWell(
      onTap: onTap,
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

  List<GameInfo> getGames({required List<GameInfo> gameData, required int recentGamesCount, required int upcomingGamesCount, required bool getStarredGames}) {
    DateTime currentTime = DateTime.now();
    List<GameInfo> recentGames = [];
    List<GameInfo> upcomingGames = [];

    List<String> starredSportsList = widget.localData.settings.starredSports.split(' ');

    List<GameInfo> filteredGameData = getStarredGames
      ? gameData.where((game) => starredSportsList.contains(game.sportsName.toLowerCase().replaceAll(" ", "_"))).toList()
      : gameData;

    for (GameInfo game in filteredGameData.toList()) {
      DateTime gameTime = DateTime.parse(game.gameDate);
      if (gameTime.isBefore(currentTime)) {
        recentGames.add(game);
      } else {
        upcomingGames.add(game);
      }
    }

    for(int i = recentGames.length; i < recentGamesCount; i++) {
      recentGames.add(naGame);
    }

    upcomingGames = upcomingGames.reversed.toList();
    for(int i = upcomingGames.length; i < upcomingGamesCount; i++) {
      upcomingGames.add(naGame);
    }
    upcomingGames = upcomingGames.reversed.toList();

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

  ListView buildGamesList(List<GameInfo> gamesList, Assets assets) {
    return ListView.builder(
      key: ValueKey<int>(_selectedTabIndex),
      itemCount: gamesList.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return gamesList[index].sportsName == 'N/A'
          ? assets.boxButton(
            context,
            title: "N/A",
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
                      child: GameInfoPage(gameData: gamesList[index]),
                    ),
                  );
                },
              )
            },
            margin: const EdgeInsets.only(top: 10, left: 10),
          )
          : assets.boxButton(
            context,
            title: " ${gamesList[index].sportsName} - ${getCategoryToString(gamesList[index].teamCategory)} vs. ${gamesList[index].opponent}",
            borderColor: gamesList[index].matchResult == ''
            ? Colors.red.shade400
            : Colors.lightBlue.shade200,
            text: '${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(gamesList[index].gameDate)).toString()}, ${gamesList[index].gameLocation}${gamesList[index].matchResult == '' ? '' : ', '}${gamesList[index].matchResult}',
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
                      child: GameInfoPage(gameData: gamesList[index]),
                    ),
                  );
                },
              )
            },
            margin: const EdgeInsets.only(top: 10, left: 10),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    Data localData = widget.localData;
    Assets assets = Assets(currentPage: SportsPage(localData: localData), localData: localData);
    int recentGametoDisplay = localData.settings.recentGamesToShow;
    int upcomingGametoDisplay = localData.settings.upcomingGamesToShow;
    List<SportsInfo> sportsInfo = localData.sportsInfo;
    List<GameInfo> gameInfo = localData.gameInfo;
    Map<String, bool> sportsListMap = {};

    for(SportsInfo sports in sportsInfo) {
      sportsListMap[sports.sportsName] = true;
    }

    List<String> sportsList = sportsListMap.keys.toList();

    List<GameInfo> games = getGames(
      gameData: gameInfo, 
      recentGamesCount: recentGametoDisplay, 
      upcomingGamesCount: upcomingGametoDisplay, 
      getStarredGames: false
    );

    List<GameInfo> starredGames = getGames(
      gameData: gameInfo, 
      recentGamesCount: recentGametoDisplay, 
      upcomingGamesCount: upcomingGametoDisplay, 
      getStarredGames: true,
    );

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
                            height: MediaQuery.of(context).size.height * 0.8, 
                            child: SettingPage(
                              sportsList: sportsList,
                              localData: localData,
                              onDialogClosed: () {
                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                  setState(() {});
                                });
                              },
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
                        child: _selectedTabIndex == 0
                          ? buildGamesList(starredGames, assets)
                          : buildGamesList(games, assets),
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
                        itemCount: sportsList.length,
                        itemBuilder: (context, index) {
                          final String sportsName = sportsList[index].toLowerCase().replaceAll(' ', '_');
                          const Color iconColor = Colors.black;
                          const double size = 80;
                          List<SportsInfo> sportsCategoryList = [];
                          sportsCategoryList = sportsInfo.where((element) => element.sportsName == sportsList[index]).toList();
                    
                          return sportsInfoBox(
                            sports: sportsCategoryList[0],
                            child: getSportsIcon(sportsName, iconColor, size),
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Dialog(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: MediaQuery.of(context).size.height,
                                      child: SportsInfoPage(
                                        sportsData: sportsCategoryList,
                                        gameData: gameInfo,
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
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

// 설정
class SettingPage extends StatefulWidget {
  final List<String> sportsList;
  final Data localData;
  final VoidCallback? onDialogClosed;

  const SettingPage({Key? key, required this.sportsList, required this.localData, this.onDialogClosed }) : super(key: key);

  @override
  SettingPageState createState() => SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  Map<String, bool> selectedCards = {};

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
            padding: const EdgeInsets.all(5),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 2,
                crossAxisSpacing: 2,
              ),
              itemCount: widget.sportsList.length,
              itemBuilder: (context, index) {
                final String sportsName = widget.sportsList[index].toLowerCase().replaceAll(' ', '_');
                const double size = 50;
                bool selected = selectedCards[sportsName] ?? false;
  
                return InkWell(
                  onTap: () {
                    setState(() {
                      selectedCards[sportsName] = !selected;
                    });
                  },
                  child: Card(
                    elevation: selected ? 5 : 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: BorderSide(
                        color: selected ? Colors.yellow : Colors.transparent,
                        width: 1.0,
                      ),
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.3,
                      height: MediaQuery.of(context).size.height * 0.3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          getSportsIcon(sportsName, selected ? Colors.yellow : Colors.black, size),
                          Text(
                            widget.sportsList[index],
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    // save starred sports to localData
    String starredSports = '';
    for (String sportsName in selectedCards.keys) {
      if (selectedCards[sportsName]!) {
        starredSports += '${sportsName.toLowerCase().replaceAll(" ", "_")} ';
      }
    }
    widget.localData.settings.starredSports = starredSports;

    // Call the callback function if provided
    if (widget.onDialogClosed != null) {
      widget.onDialogClosed!();
    }
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

class SportsInfoPage extends StatefulWidget {
  final List<SportsInfo> sportsData;
  final List<GameInfo> gameData;

  const SportsInfoPage({Key? key, required this.sportsData, required this.gameData}) : super(key: key);

  @override
  SportsInfoPageState createState() => SportsInfoPageState();
}

class SportsInfoPageState extends State<SportsInfoPage> with SingleTickerProviderStateMixin {
  int _expandedIndex = -1;
  int _selectedCategoryIndex = 0;

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
      _selectedCategoryIndex = index;
    });
    _animationController.forward(from: 0);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> informations = ['Matches', 'Coaches', 'Roster'];
    List<String> teamCategories = widget.sportsData.map((e) => getCategoryToString(e.teamCategory)).toList();
  
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Scaffold(
        backgroundColor: const Color(0xFFF7F6FB),
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(5),
            child: AppBar(
              elevation: 5,
              backgroundColor: Color(0xFF0E1B2A),
              automaticallyImplyLeading: false,
              centerTitle: false,
              actions: [
                Container(
                  margin: EdgeInsets.only(right: 10, top: 10),
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                )
              ],
              title: Container(
                margin: EdgeInsets.only(top: 20, bottom: 10, left: 10),
                child: Text(
                  widget.sportsData[0].sportsName,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(40),
                child: Container(
                  margin: EdgeInsets.only(bottom: 10, top: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: teamCategories.asMap().entries.map((entry) {
                      int index = entry.key;
                      String category = entry.value;
                      return GestureDetector(
                        onTap: () => _selectTab(index),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                category,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Opacity(
                                opacity: _selectedCategoryIndex == index
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
                            ]
                          )
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: informations.asMap().entries.map<Widget>((entry) {
              int index = entry.key;
              String information = entry.value;
              return Column(
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        if (_expandedIndex == index) {
                          _expandedIndex = -1;
                        } else {
                          _expandedIndex = index;
                        }
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.only(top: 10),
                      padding: EdgeInsets.all(16.0),
                      width: MediaQuery.of(context).size.width * 0.9,
                      decoration: BoxDecoration(
                        color: Colors.grey[10],
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.grey,
                            width: 0.5,
                          ),
                        ),
                      ),
                      child: Text(
                        textAlign: TextAlign.center,
                        information,
                        style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  AnimatedCrossFade(
                    crossFadeState:
                        _expandedIndex == index ? CrossFadeState.showFirst : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 300),
                    firstChild: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      child: Text(
                        widget.gameData[index].coachComment, // Assuming description is a property of GameInfo class
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    secondChild: const SizedBox(height: 0),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}

