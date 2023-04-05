/// notifications.dart
import 'package:flutter/material.dart';
import '../widgets/assets.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

class SportsPage extends StatefulWidget {
  const SportsPage({Key? key}) : super(key: key);

  @override
  SportsPageState createState() => SportsPageState();
}

class SportsPageState extends State<SportsPage> with TickerProviderStateMixin {
  int _selectedTabIndex = 0;
  late final AnimationController _animationController;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _selectTab(int index) {
    setState(() {
      _selectedTabIndex = index;
    });
    _animationController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F6FB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Color(0xFF0E1B2A),
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                Assets(currentPage: SportsPage()).menuBarButton(context),
              ],
            ),
            Container(
                padding: EdgeInsets.only(top: 50, left: 20),
                margin: EdgeInsets.only(bottom: 50, right: 30),
                child: Assets().textButton(context,
                    text: "Mark All as Read",
                    onTap: () {},
                    color: Colors.white)),
            Positioned(
                bottom: 5,
                left: MediaQuery.of(context).size.width / 5,
                right: -MediaQuery.of(context).size.width / 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Assets().textButton(context,
                          text: "UNREAD",
                          onTap: () => _selectTab(0),
                          color: Colors.white),
                    ),
                    Expanded(
                      child: Assets().textButton(context,
                          text: "ALL",
                          onTap: () => _selectTab(1),
                          color: Colors.white),
                    ),
                  ],
                )),
            Stack(
              children: [
                Positioned(
                  bottom: 6,
                  left: MediaQuery.of(context).size.width / 5 + 33,
                  child: Opacity(
                    opacity: _selectedTabIndex == 0 ? _animation.value : 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFF3eb9e4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  left: MediaQuery.of(context).size.width * 3.5 / 5 + 18,
                  child: Opacity(
                    opacity: _selectedTabIndex == 1 ? _animation.value : 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(0xFF3eb9e4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: const Assets(
        currentPage: SportsPage(),
      ).build(context),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: ListView.builder(
          key: ValueKey<int>(_selectedTabIndex),
          itemCount: 1,
          //_selectedTabIndex == 0 ? unreadMessages.length : Items.length,
          itemBuilder: (context, index) {
            // Map<String, dynamic> message = _selectedTabIndex == 0 ? unreadMessages[index] : Items[index];
            return Assets(currentPage: SportsPage()).boxButton(
              context,
              title: "Sports",
              onTap: () {},
              borderColor: Colors.white,
            );
          },
        ),
      ),
    );
  }
}
