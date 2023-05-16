// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:front/color_schemes.g.dart';
import 'package:front/data/data.dart';
import 'package:front/data/sports.dart';
import 'method.dart';

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
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: AppBar(
                  elevation: 5,
                  centerTitle: false,
                  title: Container(
                    margin: EdgeInsets.only(left: 15, top: 4),
                    child: const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  automaticallyImplyLeading: false,
                ),
              ),
              Positioned(
                top: 16,
                right: 15,
                child: GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Icon(
                    Icons.close,
                    size: 30, // You can adjust the icon size here
                  ),
                ),
              ),
            ],
          )
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        gameCountButton('Recent Games To Display', context, widget.localData),
                        gameCountButton('Upcoming Games To Display', context, widget.localData),
                      ],
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    height: 1,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          width: 0.5,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 10, right: 10),
                    child: Text(
                      textAlign: TextAlign.center,
                      'Select the sports that you want to mark.\nReceive the game information only what you want!',
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: SingleChildScrollView(
                      child: Column(
                        children: widget.sportsList.map<Widget>((sport) {
                          final String sportsName = sport.toLowerCase().replaceAll(' ', '_');
                          List<SportsInfo> sportsCategoryList = widget.localData.sportsInfo.where((element) => element.sportsName == sport).toList();
                          bool allSelected = true;
                          for (SportsInfo element in widget.localData.sportsInfo) {
                          }
                          for (SportsInfo element in sportsCategoryList) {
                            String categoryString = getCategoryToString(element.teamCategory).toLowerCase();
                            if (selectedCards['${sportsName}_$categoryString'] == null || selectedCards['${sportsName}_$categoryString'] == false) {
                              allSelected = false;
                              break;
                            }
                          }
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    if (allSelected) {
                                      for (SportsInfo element in sportsCategoryList) {
                                        String categoryString = getCategoryToString(element.teamCategory).toLowerCase();
                                        selectedCards['${sportsName}_$categoryString'] = false;
                                      }
                                    } else {
                                      for (SportsInfo element in sportsCategoryList) {
                                        String categoryString = getCategoryToString(element.teamCategory).toLowerCase();
                                        selectedCards['${sportsName}_$categoryString'] = true;
                                      }
                                    }
                                  });
                                },
                                child: Card(
                                  elevation: allSelected ? 10 : 2,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side: BorderSide(
                                      color: lightColorScheme.secondary,
                                      width: 1.0,
                                    ),
                                  ),
                                  child: SizedBox(
                                    width: 180,
                                    height: 180,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        getSportsIcon(sportsName, lightColorScheme.secondary, 130),
                                        Text(
                                          sport,
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10,),
                              Expanded(
                                child: Wrap(
                                  direction: Axis.horizontal,
                                  alignment: WrapAlignment.start,
                                  runAlignment: WrapAlignment.center,
                                  spacing: 5,
                                  children: sportsCategoryList.map<Widget>((sportsInfo) {
                                    String categoryString = getCategoryToString(sportsInfo.teamCategory).toLowerCase();
                                    bool categorySelected = selectedCards['${sportsName}_$categoryString'] ?? false;
                                    return ActionChip(
                                      avatar: Icon(categorySelected ? Icons.star : Icons.star_border, ),
                                      label: SizedBox(width: 80,child: Text(categoryString)),
                                      onPressed: () {
                                        setState(() {
                                          selectedCards['${sportsName}_$categoryString'] = !categorySelected;
                                        });
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget gameCountButton(String title, BuildContext context, Data localData) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          title,
        ),
        SizedBox(
          height: 60,
          width: MediaQuery.of(context).size.width * 0.3,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () {
                  if (title == 'Recent Games To Display') {
                    if (localData.settings.recentGamesToShow > 0) {
                      setState(() {
                        localData.settings.recentGamesToShow--;
                      });
                    }
                  } else if (title == 'Upcoming Games To Display') {
                    if (localData.settings.upcomingGamesToShow > 0) {
                      setState(() {
                        localData.settings.upcomingGamesToShow--;
                      });
                    }
                  }
                },
                child: const Icon(Icons.remove, size: 25),
              ),
              Text(
                title == 'Recent Games To Display' ? localData.settings.recentGamesToShow.toString() : localData.settings.upcomingGamesToShow.toString(),
                style: const TextStyle(
                  fontSize: 20,
                ),
              ),
              GestureDetector(
                onTap: () {
                  if (title == 'Recent Games To Display') {
                    if (localData.settings.recentGamesToShow < 5) {
                      setState(() {
                        localData.settings.recentGamesToShow++;
                      });
                    }
                  } else if (title == 'Upcoming Games To Display') {
                    if (localData.settings.upcomingGamesToShow < 5) {
                      setState(() {
                        localData.settings.upcomingGamesToShow++;
                      });
                    }
                  }
                },
                child: const Icon(Icons.add, size: 25),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void initState() {
    super.initState();
    selectedCards = widget.localData.settings.starredSports.split(" ").asMap().map((key, value) => MapEntry(value, true));
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
