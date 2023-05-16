import 'package:flutter/material.dart';
import 'package:front/data/daily_schedule.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class DailySchedulePage extends StatefulWidget {
  final Data localData;
  const DailySchedulePage({Key? key, required this.localData}): super(key: key);
  @override
  DailySchedulePageState createState() => DailySchedulePageState();
}

class DailySchedulePageState extends State<DailySchedulePage> with TickerProviderStateMixin{
  int _currentIndex = 0;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  final RefreshController _refreshController = RefreshController(initialRefresh: false);
  
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
        preferredSize: const Size.fromHeight(100),
        child: Stack(
          children: [
            AppBar(
              elevation: 0,
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: Container(
                margin: const EdgeInsets.only(left: 10),
                child: const Text(
                  "Daily Schedule",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10,),
                  child: assets.drawAppBarSelector(context: context, titles: ["YESTERDAY", "TODAY", "TOMORROW"], selectTab: _scrollToIndex, animation: _animation, selectedIndex: _currentIndex)
                ),
              ),
              actions: [
                assets.menuBarButton(context),
              ],
            ),
          ],
        ),
      ),
      drawer: assets.buildDrawer(context),
      body: SmartRefresher(
        enablePullUp: false,
        enablePullDown: true,
        controller: _refreshController,
        header: assets.refreshHeader(indicatorColor: Colors.grey,),
        onRefresh: () => Future.delayed(const Duration(milliseconds: 0), () async {
          widget.localData.dailySchedules = DailySchedule.transformData(await widget.localData.apiService.getDailySchedule());
          setState(() { });
          _refreshController.refreshCompleted();
        }),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                    height: MediaQuery.of(context).size.height * 0.7,
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _controller,
                      itemCount: localData.dailySchedules.length,
                      onPageChanged: (int index) {
                        setState(() {
                          _currentIndex = index;
                        });
                      },
                      itemBuilder: (BuildContext context, int index) {
                        return localData.dailySchedules[index].imageWidget;
                      },
      
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.7 * 0.5 - 36,
                    left: 10,
                    child: GestureDetector(
                      onTap: _currentIndex > 0
                          ? () => _scrollToIndex(_currentIndex - 1)
                          : null,
                      child: const Icon(Icons.arrow_back_ios, size: 24,),
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.7 * 0.5 - 36,
                    right: 10,
                    child: GestureDetector(
                      onTap: _currentIndex < localData.dailySchedules.length - 1
                          ? () => _scrollToIndex(_currentIndex + 1)
                          : null,
                      child: const Icon(Icons.arrow_forward_ios, size: 24,),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}