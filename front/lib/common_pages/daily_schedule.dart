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

  PageController _controller = PageController(initialPage: 0);

  void _scrollToIndex(int index) {
    _controller.animateToPage(
      index,
      duration: Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    Data localData = widget.localData;
    // get dailyschedul photo
    // localData.dailySchedules[index].imagePath;
    // localData.dailySchedules[index].date;
    Assets assets = Assets(localData: localData);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(17, 32, 51, 1),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text('flutt Schedule'),
        actions: [
          GestureDetector(
            onTap: () {
              // Handle notification icon tap
              print('notification');
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
      drawer: assets.build(context),
      body: Column(
        children: [
          Expanded(
            child: Container(
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
                    padding: EdgeInsets.all(8.0),
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
