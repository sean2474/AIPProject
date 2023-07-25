import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front/color_schemes.g.dart';
import 'package:front/data/data.dart';

class HomePage extends StatefulWidget {
  final Data localData;
  const HomePage({Key? key, required this.localData}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CachedNetworkImage(
            // imageUrl: widget.localData.apiService.baseUrl + "/data/daily-schedule/...",
            imageUrl: "https://files.worldwildlife.org/wwfcmsprod/images/Panda_in_Tree/hero_full/2wgwt9z093_Large_WW170579.jpg",
            fit: BoxFit.cover,
          ),
          // notification part
        ],
      )
    );
  }
}