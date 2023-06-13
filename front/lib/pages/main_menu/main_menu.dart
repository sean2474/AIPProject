import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';

class StudentMainMenuPage extends StatefulWidget {
  final Data localData;
  const StudentMainMenuPage({Key? key, required this.localData}) : super(key: key);
  @override
  StudentMainMenuState createState() => StudentMainMenuState();
}

class StudentMainMenuState extends State<StudentMainMenuPage> {
  @override
  Widget build(BuildContext context) {
    Assets assets = Assets(currentPage: StudentMainMenuPage(localData: widget.localData), localData: widget.localData, onUserChanged: () => setState(() {
      
    }),);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Stack(
          children: [
            AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                assets.menuBarButton(context),
              ],
            ),
            Container(
              margin: const EdgeInsets.all(30),
              child: const Align(
                alignment: Alignment.bottomCenter,
                child: Text(
                  "Dashboard",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: assets.buildDrawer(context),
      body: Container(
        padding: const EdgeInsets.only(right: 30, left: 30),
        child: SingleChildScrollView(child: assets.buildMainMenuGridViewBuilder())
      ),
    );
  }
}
