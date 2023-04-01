import 'package:flutter/material.dart';
import 'classes.dart';
import 'daily_schedule.dart';
import 'duty_administrator.dart';
import 'emergencies.dart';
import 'food_menu.dart';
import 'lost_and_found.dart';
import 'main.dart';
import 'notifications.dart';
import 'off_campus_requests.dart';

class Assets extends StatelessWidget {
  final Widget? currentPage;
  const Assets({Key? key, this.currentPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _buildDrawer(context);
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Stack(
        children: [
          Container(
            color: const Color(0xFF0e1b2a), // Set background color here
            child: ListView(
              padding: EdgeInsets.only(top: 100), // Add padding to ListView
              children: [
                // Remove DrawerHeader from here
                _buildDrawerItem(context, Icons.dashboard, "DASHBOARD",
                    currentPage: currentPage),
                _buildDrawerItem(
                    context, Icons.directions_walk, "OFF CAMPUS REQUESTS",
                    currentPage: currentPage),
                _buildDrawerItem(context, Icons.schedule, "DAILY SCHEDULE",
                    currentPage: currentPage),
                _buildDrawerItem(context, Icons.class_, "CLASSES",
                    currentPage: currentPage),
                _buildDrawerItem(context, Icons.notifications, "NOTIFICATIONS",
                    currentPage: currentPage),
                _buildDrawerItem(
                    context, Icons.admin_panel_settings, "DUTY ADMINISTRATOR",
                    currentPage: currentPage),
                _buildDrawerItem(context, Icons.find_in_page, "LOST AND FOUND",
                    currentPage: currentPage),
                _buildDrawerItem(context, Icons.fastfood, "FOOD MENU",
                    currentPage: currentPage),
                _buildDrawerItem(context, Icons.warning, "EMERGENCIES",
                    textColor: const Color(0xFFe45765),
                    currentPage: currentPage),
              ],
            ),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 20, top: 20),
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
                  Row(
                    children: const [
                      Text(
                        "SEAN PARK",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      SizedBox(width: 8),
                      Icon(Icons.account_circle, color: Colors.white, size: 32),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget menuBarButton(
    BuildContext context,
  ) {
    return Builder(
      builder: (BuildContext innerContext) {
        return GestureDetector(
          onTap: () {
            Scaffold.of(innerContext).openDrawer();
          },
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: const Icon(Icons.menu)),
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
            MaterialPageRoute(builder: (context) => const StudentMainMenu()),
          );
        } else if (title == 'OFF CAMPUS REQUESTS') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const OffcampusRequestPage()),
          );
        } else if (title == 'DAILY SCHEDULE') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DailySchedulePage()),
          );
        } else if (title == 'CLASSES') {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const DutyAdministratorPage()),
          );
        } else if (title == 'NOTIFICATIONS') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NotificationsPage()),
          );
        } else if (title == 'DUTY ADMINISTRATOR') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ClassesPage()),
          );
        } else if (title == 'LOST AND FOUND') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const LostAndFoundPage()),
          );
        } else if (title == 'FOOD MENU') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const FoodMenuPage()),
          );
        } else if (title == 'EMERGENCIES') {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const EmergenciesPage()),
          );
        }
      },
    );
  }

  Type _getPageType(String title) {
    switch (title) {
      case 'DASHBOARD':
        return StudentMainMenu;
      case 'OFF CAMPUS REQUESTS':
        return OffcampusRequestPage;
      case 'DAILY SCHEDULE':
        return DailySchedulePage;
      case 'CLASSES':
        return DutyAdministratorPage;
      case 'NOTIFICATIONS':
        return NotificationsPage;
      case 'DUTY ADMINISTRATOR':
        return ClassesPage;
      case 'LOST AND FOUND':
        return LostAndFoundPage;
      case 'FOOD MENU':
        return FoodMenuPage;
      case 'EMERGENCIES':
        return EmergenciesPage;
      case 'MESSAGE PAGE':
        return MessagePage;
      default:
        return Null;
    }
  }

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
        ));
  }

  Widget customButton(
    BuildContext context, {
    required String title,
    required Color borderColor,
    required VoidCallback onTap,
    int alertPriority = 0,
    String date = '',
  }) {
    switch (alertPriority) {
      case 1:
        borderColor = const Color(0xFF51CF7C);
        break;
      case 2:
        borderColor = const Color(0xFFFBD03A);
        break;
      case 3:
        borderColor = const Color(0xFFF26678);
        break;
      default:
        borderColor = borderColor;
    }

    return Container(
      margin: const EdgeInsets.only(left: 10, top: 20),
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
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  height: 35,
                  child: alertPriority == 0
                      ? Container(
                          margin: EdgeInsets.only(top: 8),
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
                              date,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xffa1a8b5),
                              ),
                            ),
                          ],
                        ),
                ),
                alertPriority == 0
                    ? const Icon(
                        Icons.arrow_circle_right_outlined,
                        color: Colors.grey,
                        size: 30,
                      )
                    : Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: borderColor,
                            size: 30,
                          ),
                          SizedBox(width: 10),
                          Icon(
                            Icons.arrow_circle_right_outlined,
                            color: Colors.grey,
                            size: 30,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textButton(
    BuildContext context, {
    required String text,
    required VoidCallback onTap,
    required Color color,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Text(
            text,
            style: TextStyle(color: color, fontSize: 12),
          ),
        ),
      ),
    );
  }
}
