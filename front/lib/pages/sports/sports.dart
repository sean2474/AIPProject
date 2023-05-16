/// sports.dart

// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../data/data.dart';
import '../../widgets/assets.dart';
import 'package:intl/intl.dart';
import 'package:front/data/sports.dart';
import 'settings.dart';
import 'method.dart';
import 'sports_info.dart';
import 'game_info.dart';
import 'package:front/color_schemes.g.dart';

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
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  final GameInfo naGame = GameInfo(
    id: -1,
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
              Flexible(
                child: Text(
                  textAlign: TextAlign.center,
                  sports.sportsName,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  List<GameInfo> getGames({
    required List<GameInfo> gameData, 
    required int recentGamesCount, 
    required int upcomingGamesCount, 
    required bool getStarredGames
  }) {
    DateTime currentTime = DateTime.now();
    List<GameInfo> recentGames = [];
    List<GameInfo> upcomingGames = [];

    List<String> starredSportsSet = widget.localData.settings.starredSports.split(" ").toList();

    // Filter the game data based on the getStarredGames flag
    List<GameInfo> filteredGameData = getStarredGames
      ? gameData.where((game) {
          String key = '${game.sportsName.toLowerCase().replaceAll(" ", "_")}_${getCategoryToString(game.teamCategory).toLowerCase()}';
          return starredSportsSet.contains(key);
        }).toList()
      : gameData;

    // Separate recent and upcoming games
    for (GameInfo game in filteredGameData.toList()) {
      DateTime gameTime = DateTime.parse(game.gameDate);
      if (gameTime.isBefore(currentTime)) {
        recentGames.add(game);
      } else {
        upcomingGames.add(game);
      }
    }

    // Reverse recent games and ensure the length matches recentGamesCount by adding placeholder games (naGame)
    recentGames = recentGames.reversed.toList();
    for (int i = recentGames.length; i < recentGamesCount; i++) {
      recentGames.add(naGame);
    }
    recentGames = recentGames.reversed.toList();

    // Ensure the length of upcomingGames matches upcomingGamesCount by adding placeholder games (naGame)
    for (int i = upcomingGames.length; i < upcomingGamesCount; i++) {
      upcomingGames.add(naGame);
    }

    // Clear coachComment and matchResult of upcomingGames
    for (GameInfo game in upcomingGames) {
      game.coachComment = '';
      game.matchResult = '';
    }

    // Combine the recent and upcoming games lists and return
    return List<GameInfo>.from([
      ...upcomingGames.reversed.take(upcomingGamesCount),
      ...recentGames.reversed.take(recentGamesCount),
    ]);
  }

  // TODO: game date is weird
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
                      width: MediaQuery.of(context).size.width * 0.8, 
                      height: MediaQuery.of(context).size.height * 0.6, 
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
            title: " ${gamesList[index].sportsName.trim()} - ${getCategoryToString(gamesList[index].teamCategory)} vs. ${gamesList[index].opponent}",
            borderColor: gamesList[index].matchResult == ''
            ? Colors.grey
            : lightColorScheme.secondary,
            text: '${DateFormat('yyyy-MM-dd').format(DateTime.parse(gamesList[index].gameDate)).toString()}, ${gamesList[index].gameLocation}${gamesList[index].matchResult == '' ? '' : ', ${gamesList[index].matchResult}'}',
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
    Size screen = MediaQuery.of(context).size;
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
      backgroundColor: lightColorScheme.background,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Stack(
          children: [
            AppBar(
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
                            height: MediaQuery.of(context).size.height * 0.6, 
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: assets.buildDrawer(context),
      body: SmartRefresher(
        enablePullUp: false,
        enablePullDown: true,
        controller: _refreshController,
        header: assets.refreshHeader(indicatorColor: Colors.grey,),
        onRefresh: () => Future.delayed(const Duration(milliseconds: 0), () async {
          String errorMessage = '';
          try {
            widget.localData.gameInfo = GameInfo.transformData(await widget.localData.apiService.getGames());
          } catch (e) {
            errorMessage = 'Failed to load game data';
          }
          try {
            widget.localData.sportsInfo = SportsInfo.transformData(await widget.localData.apiService.getSports());
          } catch (e) {
            if (errorMessage != '') {
              errorMessage = '$errorMessage\n';
            }
            errorMessage = '${errorMessage}Failed to load sports data';
          }

          if (errorMessage != '') {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Center(
                child: Text(
                  errorMessage, 
                  textAlign: TextAlign.center, 
                  style: const TextStyle(
                    fontSize: 15, 
                  ),
                )
              ),
              duration: Duration(seconds: 1),
              backgroundColor: const Color(0xfff24c5d),
              behavior: SnackBarBehavior.floating,
              shape: StadiumBorder(),
              width: screen.width * 0.6,
              
            ));
          }
          setState(() { });
          _refreshController.refreshCompleted();
        }),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Stack(
            children: [
              Container(
                margin: const EdgeInsets.only(top: 0, left: 0, right: 0,),
                padding: const EdgeInsets.only(bottom: 10),
                height: 50,
                child: assets.drawAppBarSelector(context: context, titles: ["STARRED", "ALL"], selectTab: _selectTab, animation:_animation, selectedIndex: _selectedTabIndex) 
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
                          Color iconColor = lightColorScheme.secondary;
                          const double size = 80;
                          List<SportsInfo> sportsCategoryList = [];
                          sportsCategoryList = sportsInfo.where((element) => element.sportsName == sportsList[index]).toList();
                          sportsCategoryList.sort((a, b) {
                              int aIndex = sortOrder.indexOf(a.teamCategory);
                              int bIndex = sortOrder.indexOf(b.teamCategory);
                              return aIndex.compareTo(bIndex);
                          });
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
                                      height: MediaQuery.of(context).size.height * 0.6,
                                      child: SportsInfoPage(
                                        sportsData: sportsCategoryList,
                                        gameData: gameInfo,
                                        localData: localData,
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

