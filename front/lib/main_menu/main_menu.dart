import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:front/admin/edit_lost_and_found/lost_and_found_edit.dart';
import 'package:front/admin/edit_school_store/school_store_edit.dart';
import 'package:front/color_schemes.g.dart';
import 'package:front/data/data.dart';
import 'package:front/data/sports.dart';
import 'package:front/pages/daily_schedule/daily_schedule.dart';
import 'package:front/pages/food_menu/food_menu.dart';
import 'package:front/pages/games/games.dart';
import 'package:front/pages/games/settings.dart';
import 'package:front/pages/home/home.dart';
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
  late HashMap<Type, Widget> settingButton;
  static late List<StatefulWidget> pages;
  static int pageIndex = 0;

  @override
  void initState() {
    super.initState();

    pages = [
      HomePage(localData: widget.localData), 
      DailySchedulePage(localData: widget.localData), 
      FoodMenuPage(localData: widget.localData), 
      GamePage(localData: widget.localData),
      SportsPage(localData: widget.localData),
      LostAndFoundPage(localData: widget.localData),
      SchoolStorePage(localData: widget.localData),
      EditLostAndFoundPage(localData: widget.localData),
      EditSchoolStorePage(localData: widget.localData),
    ];

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
            });
          },
          onSortChange: (sortOrder) {
            setState(() {
              widget.localData.settings.sortLostAndFoundBy = sortOrder;
              widget.localData.sortLostAndFoundBy(sortOrder);
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
      HomePage: "Home",
      DailySchedulePage: "Daily Schedule",
      FoodMenuPage: "Food Menu",
      GamePage: "Game Info",
      SportsPage: "Sports Info",
      LostAndFoundPage: "Lost and Found",
      SchoolStorePage: "Hawks Nest",
      EditLostAndFoundPage: "Edit Lost and Found",
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
            pageTitles[pages[pageIndex].runtimeType] ?? "Daily Schedule",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          settingButton[pages[pageIndex].runtimeType] ?? Container(),
          assets.menuBarButton(context),
        ],
      ),
      body: pages[pageIndex],
      drawer: assets.buildDrawer(context),
      bottomNavigationBar: Container(
        width: double.infinity,
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade300,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            NoSplashCustomBarItem(
              icon: Icons.home_outlined,
              activeIcon: Icons.home,
              isActive: pageIndex == 0,
              onTap: () => setState(() { pageIndex = 0; }),
              size: 32,
            ),
            NoSplashCustomBarItem(
              icon: Icons.calendar_today_outlined,
              activeIcon: Icons.calendar_today,
              isActive: pageIndex == 1,
              onTap: () => setState(() { pageIndex = 1; }),
            ),
            NoSplashCustomBarItem(
              icon: Icons.fastfood_outlined,
              activeIcon: Icons.fastfood,
              isActive: pageIndex == 2,
              onTap: () => setState(() { pageIndex = 2; }),
            ),
            NoSplashCustomBarItem(
              icon: Icons.directions_run_outlined,
              activeIcon: Icons.directions_run,
              isActive: pageIndex == 3,
              onTap: () => setState(() { pageIndex = 3; }),
            ),
          ],
        ),
      ),
    );
  }
}

class NoSplashCustomBarItem extends StatelessWidget {
  final IconData icon;
  final IconData activeIcon;
  final bool isActive;
  final VoidCallback onTap;
  final double? size;

  const NoSplashCustomBarItem({
    Key? key,
    required this.icon,
    required this.activeIcon,
    this.isActive = false,
    required this.onTap,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.only(left: 35, right: 35, bottom: 30, top: 10),
          child: Icon(
            isActive ? activeIcon : icon, 
            color: isActive ? lightColorScheme.primary : Colors.black,
            size: size ?? 28,
          ),
        ),
      ),
    );
  }
}
