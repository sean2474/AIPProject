import 'package:flutter/material.dart';
import 'package:front/data/sports.dart';
import 'package:intl/intl.dart';
import 'method.dart';

class GameInfoPage extends StatelessWidget {
  final GameInfo gameData;
  const GameInfoPage({Key? key, required this.gameData}) : super(key: key);

  Widget infoBox(String title, String info, int topMargin) {
    return Container(
      margin: EdgeInsets.only(top: topMargin.toDouble()),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 5),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.grey[200],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                info,
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: (gameData.gameDate != 'N/A') 
              ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    '  ${gameData.sportsName} - ${getCategoryToString(gameData.teamCategory)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ), 
                  SizedBox(height: 10),
                    infoBox(' Game Date:', ' ${DateFormat('yyyy-MM-dd hh:mm a').format(DateTime.parse(gameData.gameDate)).toString()}', 10),
                    infoBox(' Game Location:', ' ${gameData.gameLocation}', 10),
                    infoBox(' Opponent:', ' ${gameData.opponent}', 10),
                    if (gameData.matchResult != '') infoBox(' Match Result:', ' ${gameData.matchResult}', 10),
                    if (gameData.coachComment != '') infoBox(' Coach Comment:', ' ${gameData.coachComment}', 10),
                ],
              )
              : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Text(
                    '  ${gameData.sportsName} - ${getCategoryToString(gameData.teamCategory)}',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ), 
                  SizedBox(height: 10),
                    infoBox(' Game Date:', ' N/A', 10),
                    infoBox(' Game Location:', ' N/A', 10),
                    infoBox(' Opponent:', ' ${gameData.opponent}', 10),
                    if (gameData.matchResult != '') infoBox(' Match Result:', ' N/A', 10),
                    if (gameData.coachComment != '') infoBox(' Coach Comment:', ' N/A', 10),
                ],
              )
          ),
        ),
      ),
    );
  }
}
