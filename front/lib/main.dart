import 'package:flutter/material.dart';
import 'assets.dart';

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
          drawer: const Assets(
            currentPage: StudentMainMenu(),
          ).build(context),
          body: Stack(
            children: [
              SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.only(top: 40),
                  margin: const EdgeInsets.only(top: 0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Assets(
                        currentPage: StudentMainMenu(),
                      ).customButton(
                        context,
                        text: 'Check into Class/Event',
                        borderColor: const Color.fromRGBO(61, 185, 228, 1),
                        onPressed: () {
                          // Handle "Check into Class/Event" button press
                          print('Check into Class/Event');
                        },
                      ),
                      const Assets(
                        currentPage: StudentMainMenu(),
                      ).customButton(
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
                  child: const Assets(
                    currentPage: StudentMainMenu(),
                  ).gradientRoundBorderButton(
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
                  child: const Assets(
                    currentPage: StudentMainMenu(),
                  ).gradientRoundBorderButton(
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
        ),
      ],
    );
  }
}
