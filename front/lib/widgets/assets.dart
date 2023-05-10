/// assets.dart
/// This file contains the assets used in the app.

import 'package:flutter/material.dart';
import 'package:front/pages/school_store/school_store.dart';
import 'package:front/pages/main_menu/main_menu.dart';
import 'package:front/pages/daily_schedule/daily_schedule.dart';
import 'package:front/pages/food_menu/food_menu.dart';
import 'package:front/pages/lost_and_found/lost_and_found.dart';
import 'package:front/pages/sports/sports.dart';
import 'package:front/data/data.dart';
import 'package:front/auth/login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Assets {
  final Widget? currentPage;
  final Data localData;
  final User? user = FirebaseAuth.instance.currentUser;

  Assets({this.currentPage, required this.localData});
  
  Widget buildDrawer(BuildContext context) {
    return StreamBuilder<User?> (
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (BuildContext context, AsyncSnapshot<User?> snapshot) {
        final User? currentUser = snapshot.data;
        return Drawer(
          child: Stack(
            children: [
              Container(
                color: const Color(0xFF0e1b2a), 
                child: ListView(
                  padding: const EdgeInsets.only(top: 150), // Add padding to ListView
                  children: [
                    _buildDrawerItem(context, Icons.dashboard, "DASHBOARD", currentPage: currentPage),
                    _buildDrawerItem(context, Icons.schedule, "DAILY SCHEDULE", currentPage: currentPage),
                    _buildDrawerItem(context, Icons.find_in_page, "LOST AND FOUND", currentPage: currentPage),
                    _buildDrawerItem(context, Icons.fastfood, "FOOD MENU", currentPage: currentPage),
                    _buildDrawerItem(context, Icons.store, "HAWKS NEST", currentPage: currentPage),
                    _buildDrawerItem(context, Icons.sports, "SPORTS", currentPage: currentPage),
                  ]
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.only(left: 10, right: 20, top: 70),
                  height: 100,
                  color: const Color(0xFF0e1b2a),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      GestureDetector(
                        onTap: () {
                          if (!Data.loggedIn) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginPage(localData: localData)),
                            );
                          } else {
                            FirebaseAuth.instance.signOut();
                            localData.apiService.logout(localData);
                            Data.loggedIn = false;
                            Navigator.pop(context);
                          }
                        },
                        child: Row(
                          children: [
                            Text(
                              !Data.loggedIn ? "SIGN IN" : "SIGN OUT",
                              style: const TextStyle(color: Colors.white, fontSize: 18),
                            ),
                            const SizedBox(width: 8),
                            const Icon(Icons.account_circle, color: Colors.white, size: 32),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  }

  /// This function returns a button that opens the drawer.
  /// 
  /// [drawer: assets.build(context)] must be added to the Scaffold for this to work.
  Widget menuBarButton(
    BuildContext context,
  ) {
    return Builder(
      builder: (BuildContext innerContext) {
        return GestureDetector(
          onTap: () {
            Scaffold.of(innerContext).openDrawer();
          },
          child: const Padding(
            padding: EdgeInsets.all(12),
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: Icon(Icons.menu)),
          ),
        );
      },
    );
  }

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title,
      {Color textColor = Colors.white, Widget? currentPage}) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor)),
      onTap: () {
        Navigator.pop(context);
        if (currentPage != null &&
            currentPage.runtimeType == _getPageType(title)) {
          // Do nothing if the user is already on the same page
          return;
        }
        if (title == 'DASHBOARD') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => StudentMainMenu(localData: localData)),
          );
        } else if (title == 'DAILY SCHEDULE') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DailySchedulePage(localData: localData)),
          );
        } else if (title == 'LOST AND FOUND') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LostAndFoundPage(localData: localData)),
          );
        } else if (title == 'FOOD MENU') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FoodMenuPage(localData: localData)),
          );
        } else if (title == 'HAWKS NEST') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SchoolStorePage(localData: localData)),
          );
        } else if (title == 'SPORTS') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SportsPage(localData: localData)),
          );
        } else {
          throw Exception('Invalid page type');
        }
      },
    );
  }

  Type _getPageType(String title) {
    switch (title) {
      case 'DASHBOARD':
        return StudentMainMenu;
      case 'DAILY SCHEDULE':
        return DailySchedulePage;
      case 'LOST AND FOUND':
        return LostAndFoundPage;
      case 'FOOD MENU':
        return FoodMenuPage;
      case 'HAWKS NEST':
        return SchoolStorePage;
      case 'SPORTS':
        return SportsPage;
      default:
        return Null;
    }
  }

  /// Returns a rounded button with a gradient background
  /// 
  /// [isRed] determines whether the button is red or blue
  /// [onPressed] is the function that is called when the button is pressed
  /// [text] is the text that is displayed on the button
  /// [context] is the context of the page
  Widget gradientRoundBorderButton(
    BuildContext context, {
    required String text,
    required bool isRed,
    required VoidCallback onPressed,
  }) {
    Color startColor, endColor;
    if (isRed) {
      startColor = const Color(0xffe60527);
      endColor = const Color(0xfff24c5d);
    } else {
      startColor = const Color(0xff4196fd);
      endColor = const Color(0xff3bb6e4);
    }
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [startColor, endColor],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          child: Text(
            text,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      )
    );
  }

  /// Returns a button with a border on the left side
  /// 
  /// [title] is the text to display on the button
  /// [borderColor] is the color of the border on the left side
  /// [onTap] is the function to call when the button is pressed
  /// [iconNextToArrow] is the icon to display next to the arrow
  /// [text] is the text to display under the title
  /// [margin] is the margin around the button
  Widget boxButton(
    BuildContext context, {
    required String title,
    required Color borderColor,
    required VoidCallback onTap,
    Icon? iconNextToArrow,
    String? text,
    EdgeInsets? margin = const EdgeInsets.only(left: 10, top: 20),
  }) {
  return Container(
    margin: margin,
    padding: const EdgeInsets.all(0),
    decoration: BoxDecoration(
      color: const Color(0xFFFFFFFF),
      border: Border(
        left: BorderSide(width: 4, color: borderColor),
      ),
    ),
    child: GestureDetector(
        onTap: onTap,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            margin:
                const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 35,
                  child: text == null
                      ? Container(
                          margin: const EdgeInsets.only(top: 8),
                          child: Text(
                            title,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flexible(
                              child: SingleChildScrollView(
                                child: Text(
                                  title,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Text(
                              text,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xffa1a8b5),
                              ),
                            ),
                          ],
                        ),
                ),
                iconNextToArrow == null
                  ? const Icon(
                      Icons.arrow_circle_right_outlined,
                      color: Colors.grey,
                      size: 30,
                    )
                  : Row(
                      children: [
                        iconNextToArrow,
                        const Icon(
                          Icons.arrow_circle_right_outlined,
                          color: Colors.grey,
                          size: 30,
                        ),
                      ],
                    ),
              ],
            ),
          ),
        )
      )
    );
  }

  /// Returns a [Widget] that displays a [text] button that calls [onTap] when pressed. 
  Widget textButton(
    BuildContext context, {
    required String text,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            text,
            // bold font
            style: TextStyle(
                color: color, fontSize: 14, fontWeight: FontWeight.bold
              ),
          ),
        ),
      ),
    );
  }

  /// Returns a [Widget] that displays a list of [titles] in a row, with the
  /// 
  /// [selectedIndex] being highlighted. The [selectTab] function is called when a tab is selected.
  /// [titles] is a list of strings that are the titles of each tab.
  /// [selectTab] should include the logic that changes the [selectedIndex] state and the page.
  Widget drawAppBarSelector({required BuildContext context, required List<String> titles, required Function(int) selectTab, required Animation<double> animation, required int selectedIndex}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: titles.asMap().entries.map((entry) {
        int index = entry.key;
        String category = entry.value;
        return GestureDetector(
          onTap: () => selectTab(index),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  category,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Opacity(
                  opacity: selectedIndex == index
                    ? animation.value
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
    );
  }
}
