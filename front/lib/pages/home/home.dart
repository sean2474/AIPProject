import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'setting_modal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  static void showSetting(BuildContext context) {
    
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
    ),
    builder: (BuildContext context) {
      return SettingModal();
    },
  );
}
  
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