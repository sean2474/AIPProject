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
            preferredSize:
            Size.fromHeight(MediaQuery.of(context).size.height * 0.3),
            child: Stack(
              children: [
                AppBar(
                  backgroundColor: const Color.fromRGBO(17, 32, 51, 1),
                  elevation: 0,
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
                    GestureDetector(
                      onTap: () {
                        // Handle menu icon tap
                        print('menu');
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: const Icon(Icons.menu)),
                      ),
                    ),
                  ],
                ),
                Positioned(
                  left: 20,
                  bottom: 40,
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
          body: Container(
            margin: const EdgeInsets.only(top: 30),
            child: Stack(
              children: [
                Column(
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
              ],
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.3 - 28,//10 46
          left: MediaQuery.of(context).size.width * 0.1,
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
        Positioned(
          bottom: 0,
          left: MediaQuery.of(context).size.width * 0.1,
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
