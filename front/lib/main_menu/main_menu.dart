import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:front/admin/edit_daily_schedule/daily_schedule_edit.dart';
import 'package:front/admin/edit_lost_and_found/lost_and_found_edit.dart';
import 'package:front/admin/edit_school_store/school_store_edit.dart';
import 'package:front/color_schemes.g.dart';
import 'package:front/data/data.dart';
import 'package:front/data/sports.dart';
import 'package:front/pages/daily_schedule/daily_schedule.dart';
import 'package:front/pages/food_menu/food_menu.dart';
import 'package:front/pages/games/games.dart';
import 'package:front/pages/games/settings.dart';
import 'package:front/pages/lost_and_found/lost_and_found.dart';
import 'package:front/pages/school_store/school_store.dart';
import 'package:front/pages/sports/sports.dart';
import 'package:front/widgets/assets.dart';

class MainMenuPage extends StatefulWidget {
  final Data localData;
  const MainMenuPage({Key? key, required this.localData}) : super(key: key);

  @override
  MainMenuPageState createState() => MainMenuPageState();
}

class MainMenuPageState extends State<MainMenuPage> {

  static late StatefulWidget pageToDisplay;
  late HashMap<Type, Widget> settingButton;

  @override
  void initState() {
    super.initState();
    pageToDisplay = DailySchedulePage(localData: widget.localData);
    HashSet<String> sportsList = HashSet()..addAll(widget.localData.sportsInfo.map((e) => e.sportsName));
    settingButton = HashMap()..addAll({
      GamePage: IconButton(
        onPressed: () {
          showModalBottomSheet(
            context: context, 
            isScrollControlled: true, 
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
            builder: (BuildContext context) {
              return FractionallySizedBox(
                heightFactor: 0.35,
                child: SettingPage(
                  sportsList: sportsList.toList(),
                  localData: widget.localData,
                  onDialogClosed: () {
                    setState(() {
                      pageToDisplay = GamePage(localData: widget.localData);
                     });
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      setState(() {});
                    });
                  },
                ),
              );
            },
          );
        },
        icon: const Icon(Icons.settings)
      ),
      LostAndFoundPage: IconButton(onPressed: () => LostAndFoundPageState.showSetting(
          context,
          localData: widget.localData,
          onSwitchChange: (value) {
            setState(() {
              widget.localData.settings.showReturnedItem = value;
              pageToDisplay = LostAndFoundPage(localData: widget.localData);
            });
          },
          onSortChange: (sortOrder) {
            setState(() {
              widget.localData.settings.sortLostAndFoundBy = sortOrder;
              widget.localData.sortLostAndFoundBy(sortOrder);
              pageToDisplay = LostAndFoundPage(localData: widget.localData);
            });
            Navigator.pop(context);
          }
        ), 
        icon: Icon(Icons.settings), 
        alignment: Alignment.topRight,
      ),
    });
  }

  @override
  Widget build(BuildContext context) {
    HashMap<Type, String> pageTitles = HashMap()..addAll({
      DailySchedulePage: "Daily Schedule",
      FoodMenuPage: "Food Menu",
      GamePage: "Game Info",
      SportsPage: "Sports Info",
      LostAndFoundPage: "Lost and Found",
      SchoolStorePage: "Hawks Nest",
      EditLostAndFoundPage: "Edit Lost and Found",
      EditDailySchedulePage: "Edit Daily Schedule",
      EditSchoolStorePage: "Edit School Store",
    });

    Map<String, bool> sportsListMap = {};
    for(SportsInfo sports in widget.localData.sportsInfo) {
      sportsListMap[sports.sportsName] = true;
    }
    Assets assets = Assets(
      localData: widget.localData, 
      currentPage: MainMenuPage(localData: widget.localData,), 
      onPageChange: () => setState(() {})
    );
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Text(
            pageTitles[pageToDisplay.runtimeType] ?? "Daily Schedule",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          settingButton[pageToDisplay.runtimeType] ?? Container(),
          assets.menuBarButton(context),
        ],
      ),
      body: pageToDisplay,
      drawer: assets.buildDrawer(context),
      bottomNavigationBar: BottomAppBar(
        color: Colors.transparent,
        elevation: 0,
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 0,
                blurRadius: 3,
                offset: Offset(0, 3),
              )
            ],
            borderRadius: BorderRadius.all(Radius.circular(29)),
            color: lightColorScheme.secondaryContainer,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    pageToDisplay = DailySchedulePage(localData: widget.localData);
                  });
                },
                icon: Icon(Icons.calendar_today_outlined, color: pageToDisplay.runtimeType == DailySchedulePage ? lightColorScheme.primary : Colors.black,),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    pageToDisplay = FoodMenuPage(localData: widget.localData);
                  });
                },
                icon: Icon(Icons.fastfood_outlined, color: pageToDisplay.runtimeType == FoodMenuPage ? lightColorScheme.primary : Colors.black,),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    pageToDisplay = GamePage(localData: widget.localData);
                  });
                },
                icon: Icon(Icons.directions_run_outlined, color: pageToDisplay.runtimeType == GamePage ? lightColorScheme.primary : Colors.black,),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
