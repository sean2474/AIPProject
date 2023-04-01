import 'package:flutter/material.dart';
import 'assets.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({Key? key}) : super(key: key);

  @override
  NotificationsPageState createState() => NotificationsPageState();
}

class NotificationsPageState extends State<NotificationsPage>
    with TickerProviderStateMixin {
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

  List<Map<String, dynamic>> messages = [
    {
      'title':
          'Some long message Some long message Some long message Some long message Some long message something something something. something something something something something somethslaidfalsdkj laksjdaksjldfkasj kasdf asdfas afsd asd fadsf  adsf adsf adsdf ',
      'date': '2023-03-31 08:00:00',
      'sender': 'Sender 1',
      'alert_priority': 1,
      'message': 'This is a test message 1',
      'isRead': false,
    },
    {
      'title': 'Test Message 2',
      'date': '2023-03-31 09:00:00',
      'sender': 'Sender 2',
      'alert_priority': 2,
      'message': 'This is a test message 2',
      'isRead': false,
    },
    {
      'title': 'Test Message 3',
      'date': '2023-03-31 10:00:00',
      'sender': 'Sender 3',
      'alert_priority': 3,
      'message': 'This is a test message 3',
      'isRead': false,
    },
  ];

  List<Map<String, dynamic>> get unreadMessages =>
      messages.where((message) => !(message['isRead'] ?? false)).toList();

  void _markAsRead(int index) {
    setState(() {
      messages[index]['isRead'] = true;
    });
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
                Assets(currentPage: NotificationsPage()).menuBarButton(context),
              ],
            ),
            Container(
                padding: EdgeInsets.only(top: 50, left: 20),
                margin: EdgeInsets.only(bottom: 50, right: 30),
                child: Assets().textButton(context, text: "mark all as read",
                    onTap: () {
                  // mark all messages as read
                }, color: Colors.white)),
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
        currentPage: NotificationsPage(),
      ).build(context),
      body: AnimatedSwitcher(
        duration: Duration(milliseconds: 300),
        child: ListView.builder(
          key: ValueKey<int>(_selectedTabIndex),
          itemCount:
              _selectedTabIndex == 0 ? unreadMessages.length : messages.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> message = _selectedTabIndex == 0
                ? unreadMessages[index]
                : messages[index];
            return Assets(currentPage: NotificationsPage()).customButton(
              context,
              title: message['title'],
              onTap: () {
                _markAsRead(messages.indexOf(message));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagePage(
                      messageData: message,
                    ),
                  ),
                );
              },
              date: message['date'],
              borderColor: Colors.white,
              alertPriority: message['alert_priority'],
            );
          },
        ),
      ),
    );
  }
}

class MessagePage extends StatelessWidget {
  final Map<String, dynamic> messageData;

  MessagePage({Key? key, required this.messageData}) : super(key: key);

  String formatDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return DateFormat('E, MMMM d').format(date);
  }

  String formatTime(String timeString) {
    DateTime time = DateTime.parse(timeString);
    return DateFormat('h:mm').format(time);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7F6FB),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(350),
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Color(0xFF0E1B2A),
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            Positioned(
              left: 20,
              top: 65,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(Icons.arrow_back, color: Colors.white)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 40),
              padding:
                  EdgeInsets.only(left: 20, right: 20, top: 60, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Text(
                      formatDate(messageData['date']),
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              messageData['title'],
                              style:
                                  TextStyle(fontSize: 24, color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Icon(Icons.error_outline,
                              color: messageData['alert_priority'] == 1
                                  ? Color(0xFF51CF7C)
                                  : messageData['alert_priority'] == 2
                                      ? Color(0xFFFBD03A)
                                      : Color(0xFFF26678),
                              size: 40),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      Icon(Icons.access_time,
                          size: 14, color: Color(0xff9fa5b5)),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${formatTime(messageData['date'])} - ${messageData['sender']}',
                          style: TextStyle(fontSize: 14, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      drawer: Assets(
        currentPage: MessagePage(
          messageData: const {},
        ),
      ).build(context),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 40,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(17, 32, 51, 1),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              width: MediaQuery.of(context).size.width * 0.9,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(messageData['message']),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
