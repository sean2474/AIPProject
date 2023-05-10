/// notifications.dart
import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'package:flutter/cupertino.dart';
import 'message.dart';

class NotificationsPage extends StatefulWidget {
  final Data localData;
  const NotificationsPage({Key? key, required this.localData}) : super(key: key);

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
      'id': '2qijodsalkv',
      'title':
          'Some long message Some long message Some long message Some long message Some long message something something something. something something something something something somethslaidfalsdkj laksjdaksjldfkasj kasdf asdfas afsd asd fadsf  adsf adsf adsdf ',
      'date': '2023-03-31 08:00:00',
      'sender': 'Sender 1',
      'alert_priority': 1,
      'message':
          '1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qweras www.naver.com dfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv1234qwerasdfzxcv',
      'isRead': false,
    },
    {
      'id': 'alsdjfioawe',
      'title': 'Test Message 2',
      'date': '2023-03-31 09:00:00',
      'sender': 'Sender 2',
      'alert_priority': 2,
      'message': 'This is a test message 2',
      'isRead': false,
    },
    {
      'id': '2039ejialals',
      'title': 'Test Message 3',
      'date': '2023-03-31 10:00:00',
      'sender': 'Sender 3',
      'alert_priority': 3,
      'message': 'This is a test message 3',
      'isRead': false,
    },
  ];

  Future<void> _markAllAsRead() async {
    bool? confirm = await _showConfirmationDialog();

    if (confirm == true) {
      setState(() {
        for (var i = 0; i < messages.length; i++) {
          messages[i]['isRead'] = true;
        }
      });
    }
  }

  Future<bool?> _showConfirmationDialog() async {
    if (Theme.of(context).platform == TargetPlatform.iOS) {
      return await showCupertinoDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: const Text('Confirm',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
            content: const Text(
                'Are you sure you want to mark all notifications as read?'),
            actions: <Widget>[
              CupertinoDialogAction(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              CupertinoDialogAction(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
    } else {
      return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Confirm'),
            content: const Text(
                'Are you sure you want to mark all messages as read?'),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        },
      );
    }
  }

  List<Map<String, dynamic>> get unreadMessages =>
      messages.where((message) => !(message['isRead'] ?? false)).toList();

  void _markAsRead(int index) {
    setState(() {
      messages[index]['isRead'] = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    Assets assets = Assets(currentPage: NotificationsPage(localData: widget.localData), localData: widget.localData,);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
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
              padding: const EdgeInsets.only(top: 50, left: 20),
              margin: const EdgeInsets.only(bottom: 50, right: 30),
              child: assets.textButton(
                context, 
                text: "Mark All as Read", 
                onTap: () {
                  _markAllAsRead();
                }, color: Colors.white
              )
            ),
            Positioned(
                bottom: 5,
                left: MediaQuery.of(context).size.width / 5,
                right: -MediaQuery.of(context).size.width / 5,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: assets.textButton(context,
                          text: "UNREAD",
                          onTap: () => _selectTab(0),
                          color: Colors.white),
                    ),
                    Expanded(
                      child: assets.textButton(context,
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
                        color: const Color(0xFF3eb9e4),
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
                        color: const Color(0xFF3eb9e4),
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
      drawer: assets.buildDrawer(context),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: ListView.builder(
          key: ValueKey<int>(_selectedTabIndex),
          itemCount:
              _selectedTabIndex == 0 ? unreadMessages.length : messages.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> message = _selectedTabIndex == 0
                ? unreadMessages[index]
                : messages[index];
            return assets.boxButton(
              context,
              title: message['title'],
              onTap: () {
                _markAsRead(messages.indexOf(message));
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MessagePage(
                      messageData: message, localData: widget.localData,
                    ),
                  ),
                );
              },
              text: message['date'],
              borderColor: Colors.white,
              iconNextToArrow: Icon(Icons.error_outline,
                  color: alertColors[message['alert_priority']], size: 30),
            );
          },
        ),
      ),
    );
  }
}