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
  const Assets({Key? key}) : super(key: key);

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
                _buildDrawerItem(context, Icons.dashboard, "DASHBOARD"),
                _buildDrawerItem(
                    context, Icons.directions_walk, "OFF CAMPUS REQUESTS"),
                _buildDrawerItem(context, Icons.schedule, "DAILY SCHEDULE"),
                _buildDrawerItem(context, Icons.class_, "CLASSES"),
                _buildDrawerItem(context, Icons.notifications, "NOTIFICATIONS"),
                _buildDrawerItem(
                    context, Icons.admin_panel_settings, "DUTY ADMINISTRATOR"),
                _buildDrawerItem(context, Icons.find_in_page, "LOST AND FOUND"),
                _buildDrawerItem(context, Icons.fastfood, "FOOD MENU"),
                _buildDrawerItem(context, Icons.warning, "EMERGENCIES",
                    textColor: const Color(0xFFe45765)),
              ],
            ),
          ),
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(left: 10, right: 20),
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

  Widget _buildDrawerItem(BuildContext context, IconData icon, String title,
      {Color textColor = Colors.white}) {
    return ListTile(
      leading: Icon(icon, color: textColor),
      title: Text(title, style: TextStyle(color: textColor)),
      onTap: () {
        print("$title tapped");
        Navigator.pop(context);
        // // Remove DrawerHeader from here
        // _buildDrawerItem(context, Icons.dashboard, "DASHBOARD"),
        // _buildDrawerItem(
        //     context, Icons.directions_walk, "OFF CAMPUS REQUESTS"),
        // _buildDrawerItem(context, Icons.schedule, "DAILY SCHEDULE"),
        // _buildDrawerItem(context, Icons.class_, "CLASSES"),
        // _buildDrawerItem(context, Icons.notifications, "NOTIFICATIONS"),
        // _buildDrawerItem(
        //     context, Icons.admin_panel_settings, "DUTY ADMINISTRATOR"),
        // _buildDrawerItem(context, Icons.find_in_page, "LOST AND FOUND"),
        // _buildDrawerItem(context, Icons.fastfood, "FOOD MENU"),
        // _buildDrawerItem(context, Icons.warning, "EMERGENCIES",
        //     textColor: const Color(0xFFe45765)),
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
    required String text,
    required Color borderColor,
    required VoidCallback onPressed,
  }) {
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
        onTap: onPressed,
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFFFF),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey, width: 1),
                  ),
                  child: const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.grey,
                    size: 14,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}