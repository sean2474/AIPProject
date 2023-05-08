import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/data/sports.dart';
import 'package:intl/intl.dart';
import 'package:front/widgets/assets.dart';
import 'method.dart';

class SportsInfoPage extends StatefulWidget {
  final List<SportsInfo> sportsData;
  final List<GameInfo> gameData;
  final Data localData;

  const SportsInfoPage({Key? key, required this.sportsData, required this.gameData, required this.localData}) : super(key: key);

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

  Widget getSlidingAnimation(int index, Widget child) {
    return AnimatedSize(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      child: Stack(
        children: [
          ClipRect(
            child: Align(
              alignment: Alignment.topCenter,
              heightFactor: _expandedIndex == index ? _animation.value : 0,
              child: child,
            ),
          ),
          if (_expandedIndex == index)
            SizedBox(
              height: _animation.value == 1 ? 0 : double.infinity,
            ),
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    List<String> informations = ['Matches', 'Coaches', 'Roster'];
    List<String> teamCategories = widget.sportsData.map((e) => getCategoryToString(e.teamCategory)).toList();

    Widget getInformationContent(int index) {
      Color containerColor = Color.fromARGB(255, 236, 234, 241);
      switch (index) {
        case 0:
          List<GameInfo> filteredGameData = widget.gameData
              .where((game) =>
                  game.sportsName == widget.sportsData[_selectedCategoryIndex].sportsName &&
                  game.teamCategory == widget.sportsData[_selectedCategoryIndex].teamCategory)
              .toList();

          return Column(
            children: List.generate(filteredGameData.length, (index) {
              GameInfo gameData = filteredGameData[index];
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 5),
                    padding: EdgeInsets.all(10),
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: containerColor,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Game Date: ${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(gameData.gameDate)).toString()}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Game Location: ${gameData.gameLocation}',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          'Opponent: ${gameData.opponent}',
                          style: TextStyle(fontSize: 16),
                        ),
                        if (gameData.matchResult != '')
                          Text(
                            'Match Result: ${gameData.matchResult}',
                            style: TextStyle(fontSize: 16),
                          ),
                        if (gameData.coachComment != '')
                          Text(
                            'Coach Comment: ${gameData.coachComment}',
                            style: TextStyle(fontSize: 16),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            }),
          );
        case 1:
          return Column(
            children: widget.sportsData[_selectedCategoryIndex]
                .coachNames
                .asMap()
                .entries
                .map<Widget>((entry) {
                  String coachName = entry.value;
                  String coachContact = widget.sportsData[_selectedCategoryIndex].coachContacts[entry.key];
                  return Column(
                    children: [
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: containerColor,
                        ),
                        child: Text(
                          '$coachName : $coachContact',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                })
                .toList(),
          );
        case 2:
          return Column(
            children: widget.sportsData[_selectedCategoryIndex]
                .roster
                .asMap()
                .entries
                .map<Widget>((entry) {
                  String playerName = entry.value;
                  return Column(
                    children: [
                      SizedBox(height: 5),
                      Container(
                        padding: EdgeInsets.all(10),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: containerColor,
                        ),
                        child: Text(
                          playerName,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  );
                })
                .toList(),
          );
        default:
          return const SizedBox.shrink();
      }
    }

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
                  child: Assets(localData: widget.localData,).drawAppBarSelector(context: context, titles: teamCategories, selectTab: _selectTab, animation: _animation, selectedIndex: _selectedCategoryIndex)
                ),
              ),
            ),
          ),
        ),
        body: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: SingleChildScrollView( // Add SingleChildScrollView here
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
                    getSlidingAnimation(
                      index,
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        child: getInformationContent(index),
                      ),
                    )
                  ],
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
