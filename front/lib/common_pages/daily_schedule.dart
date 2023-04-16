import 'package:flutter/material.dart';
import 'package:front/storage/local_storage.dart';
import 'package:front/widgets/assets.dart';

class DailySchedulePage extends StatefulWidget {
  final Data localData;
  const DailySchedulePage({Key? key, required this.localData})
      : super(key: key);
  @override
  DailySchedulePageState createState() => DailySchedulePageState();
}

class DailySchedulePageState extends State<DailySchedulePage> {
  int _currentIndex = 0;

  final PageController _controller = PageController(initialPage: 0);

  void _scrollToIndex(int index) {
    _controller.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Data localData = widget.localData;
    Assets assets = Assets(localData: localData);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(75),
        child: Stack(
          children: [
            AppBar(
              backgroundColor: const Color(0xFF0E1B2A),
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                assets.menuBarButton(context),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(bottom: 15, left: 30),
              child: const Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  "Daily Schedule",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: assets.build(context),
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              height: 1674,
              child: PageView.builder(
                controller: _controller,
                itemCount: localData.dailySchedules.length,
                onPageChanged: (int index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                      Image.asset(localData.dailySchedules[index].imagePath),
                  );
                },
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                onPressed: _currentIndex > 0
                    ? () => _scrollToIndex(_currentIndex - 1)
                    : null,
                child: Icon(Icons.arrow_back),
              ),
              ElevatedButton(
                onPressed: _currentIndex < localData.dailySchedules.length - 1
                    ? () => _scrollToIndex(_currentIndex + 1)
                    : null,
                child: Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ],
      ),
    );
  }
}