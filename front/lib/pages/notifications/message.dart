import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:url_launcher/url_launcher.dart';

List<Color> alertColors = [
  Colors.black,
  const Color(0xFF51CF7C),
  const Color(0xFFFBD03A),
  const Color(0xFFF26678),
];


class MessagePage extends StatelessWidget {
  final Map<String, dynamic> messageData;
  final Data localData;

  const MessagePage({Key? key, required this.messageData,required this.localData}) : super(key: key);

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
    Assets assets = Assets(currentPage: MessagePage(messageData: const {}, localData: localData), localData: localData);
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(350),
        child: Stack(
          children: [
            AppBar(
              backgroundColor: const Color(0xFF0E1B2A),
              elevation: 0,
              automaticallyImplyLeading: false,
            ),
            Positioned(
              left: 20,
              top: 65,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: Icon(Icons.arrow_back, color: Colors.white)),
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 40),
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 60, bottom: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Flexible(
                    child: Text(
                      formatDate(messageData['date']),
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                  Flexible(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Text(
                              messageData['title'],
                              style: const TextStyle(
                                  fontSize: 24, color: Colors.white),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 16, right: 16),
                          child: Icon(Icons.error_outline,
                              color: alertColors[messageData['alert_priority']],
                              size: 40),
                        ),
                      ],
                    ),
                  ),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 14, color: Color(0xff9fa5b5)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          '${formatTime(messageData['date'])} - ${messageData['sender']}',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white),
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
      drawer: assets.buildDrawer(context),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: 40,
            decoration: const BoxDecoration(
              color: Color.fromRGBO(17, 32, 51, 1),
            ),
          ),
          // message box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              margin: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width * 0.05),
              width: MediaQuery.of(context).size.width * 0.9,
              height: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(minHeight: 1000),
                  child: Linkify(
                    onOpen: (link) async {
                      if (await canLaunch(link.url)) {
                        await launch(link.url);
                      } else {
                        throw 'Could not launch $link';
                      }
                    },
                    text: messageData['message'],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
