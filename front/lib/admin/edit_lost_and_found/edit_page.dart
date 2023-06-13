import 'package:flutter/material.dart';
import 'package:front/color_schemes.g.dart';
import 'package:front/data/data.dart';
import 'package:front/data/lost_item.dart';
import 'package:intl/intl.dart';

String statusToString(FoundStatus status) {
  switch (status) {
    case FoundStatus.lost:
      return "Lost";
    case FoundStatus.returned:
      return "Returned";
    default: 
      return "N/A";
  }
}

class EditPage extends StatelessWidget {
  final List<LostItem> itemDataList;

  const EditPage({Key? key, required this.itemDataList}) : super(key: key);
  // TODO: text fields - name, description, location, date
  // TODO: submit button
  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return Stack(
      children: [
        Hero(
          tag: "edit lost and found container",
          child: Container(
            decoration: BoxDecoration(
              color: lightColorScheme.background,
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              alignment: Alignment.topCenter,
              margin: EdgeInsets.only(top: 20),
              child: Hero(
                tag: "edit lost and found title",
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Edit item",
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]
                ),
              ),
            )
          ],
        ),
      ],
    );
  }
}
