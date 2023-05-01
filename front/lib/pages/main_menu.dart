import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'notifications.dart';

class StudentMainMenu extends StatelessWidget {
  final Data localData;
  const StudentMainMenu({Key? key, required this.localData}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Assets assets = Assets(currentPage: StudentMainMenu(localData: localData), localData: localData,);
    return Scaffold(
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => NotificationsPage(localData: localData,)),
                    );
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12),
                    child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Icon(Icons.notifications)),
                  ),
                ),
                assets.menuBarButton(context),
              ],
            ),
            Positioned(
              left: 20,
              bottom: 35,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Current Location',
                    style: TextStyle(
                      color: Color(0xFF868C95),
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '\n',
                    style: TextStyle(
                      fontSize: 3,
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
      drawer:  assets.buildDrawer(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(top: 40),
              margin: const EdgeInsets.only(top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  assets.boxButton(
                    context,
                    title: 'Check into Class/Event',
                    borderColor: const Color.fromRGBO(61, 185, 228, 1),
                    onTap: () {
                      // Handle "Check into Class/Event" button press
                      print('Check into Class/Event');
                    },
                  ),
                  assets.boxButton(
                    context,
                    title: 'Day Pass',
                    borderColor: const Color(0xFF79D557),
                    onTap: () {
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
              child: assets.gradientRoundBorderButton(
                context,
                text: "I WANT TO GO SOMEWHERE",
                isRed: false,
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
              child: assets.gradientRoundBorderButton(
                context,
                text: "EMERGENCY RESPONSE",
                isRed: true,
                onPressed: () {
                  // Handle "I WANT TO GO SOMEWHERE" button press
                  print('EMERGENCY RESPONSE');
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
