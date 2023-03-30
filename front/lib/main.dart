import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const StudentManagementApp());
}

class StudentManagementApp extends StatelessWidget {
  const StudentManagementApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const StudentMainMenu(),
    );
  }
}

class StudentMainMenu extends StatelessWidget {
  const StudentMainMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: PreferredSize(
            preferredSize: Size.fromHeight(150),
            child: Stack(
              children: [
                AppBar(
                  backgroundColor: const Color.fromRGBO(17, 32, 51, 1),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  actions: [
                    GestureDetector(
                      onTap: () {
                        // Handle notification icon tap
                        print('notification');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: const Icon(Icons.notifications)),
                      ),
                    ),
                    Builder(
                      builder: (BuildContext innerContext) {
                        return GestureDetector(
                          onTap: () {
                            // Handle menu icon tap
                            print('menu');
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
                    ),
                  ],
                ),
                Positioned(
                  left: 20,
                  bottom: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Current class',
                        style: TextStyle(
                          color: Color(0xFF868C95),
                          fontSize: 10,
                        ),
                      ),
                      Text(
                        'Mathematics',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          drawer: _buildDrawer(context),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 40),
                  margin: const EdgeInsets.only(top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      customButton(
                        context,
                        text: 'Check into Class/Event',
                        borderColor: const Color.fromRGBO(61, 185, 228, 1),
                        onPressed: () {
                          // Handle "Check into Class/Event" button press
                          print('Check into Class/Event');
                        },
                      ),
                      customButton(
                        context,
                        text: 'Day Pass',
                        borderColor: const Color(0xFF79D557),
                        onPressed: () {
                          // Handle "Day Pass" button press
                          print('Day Pass');
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color.fromRGBO(17, 32, 51, 1),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.all(10),
                  child: gradientRoundBorderButton(
                    context,
                    text: "I WANT TO GO SOMEWHERE",
                    startColor: Color(0xff4196fd),
                    endColor: Color(0xff3bb6e4),
                    onPressed: () {
                      // Handle "I WANT TO GO SOMEWHERE" button press
                      print('I WANT TO GO SOMEWHERE');
                    },
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  margin: const EdgeInsets.all(10),
                  child: gradientRoundBorderButton(
                    context,
                    text: "EMERGENCY RESPONSE",
                    startColor: Color(0xffe60527),
                    endColor: Color(0xfff24c5d),
                    onPressed: () {
                      // Handle "I WANT TO GO SOMEWHERE" button press
                      print('EMERGENCY RESPONSE');
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget gradientRoundBorderButton(
      BuildContext context, {
        required String text,
        required Color startColor,
        required Color endColor,
        required VoidCallback onPressed,
      }) {
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
                _buildDrawerItem(context, Icons.directions_walk, "OFF CAMPUS REQUESTS"),
                _buildDrawerItem(context, Icons.schedule, "DAILY SCHEDULE"),
                _buildDrawerItem(context, Icons.class_, "CLASSES"),
                _buildDrawerItem(context, Icons.notifications, "NOTIFICATIONS"),
                _buildDrawerItem(context, Icons.admin_panel_settings, "DUTY ADMINISTRATOR"),
                _buildDrawerItem(context, Icons.find_in_page, "LOST AND FOUND"),
                _buildDrawerItem(context, Icons.fastfood, "FOOD MENU"),
                _buildDrawerItem(context, Icons.warning, "EMERGENCIES", textColor: const Color(0xFFe45765)),
              ],
            ),
          ),
          Positioned(
            top: 0,
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
      },
    );
  }
}
