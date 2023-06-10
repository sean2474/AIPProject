import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';

class StudentMainMenu extends StatelessWidget {
  final Data localData;
  const StudentMainMenu({Key? key, required this.localData}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    Assets assets = Assets(currentPage: StudentMainMenu(localData: localData), localData: localData,);
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
        padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
        margin: const EdgeInsets.all(20),
        child: assets.buildMainMenuGridViewBuilder()
      ),
    );
  }
}
