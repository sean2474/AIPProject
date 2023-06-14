// ignore_for_file: use_build_context_synchronously
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:front/color_schemes.g.dart';
import 'package:front/data/data.dart';
import 'package:front/data/lost_item.dart';
import 'package:front/pages/lost_and_found/lost_item_page.dart';
import 'package:front/widgets/assets.dart';
import 'uploading_snackbar.dart';

class DeletePage extends StatefulWidget {
  final Data localData;

  DeletePage({super.key, required this.localData});

  @override
  State<DeletePage> createState() => _DeletePageState();
}

class _DeletePageState extends State<DeletePage> {
  double initial = 0.0;
  double distance = 0.0;

  double screenWidth = 0;
  double screenHeight = 0;

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  Widget build(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    Assets assets = Assets(currentPage: DeletePage(localData: widget.localData), localData: widget.localData,);
    UploadingSnackbar uploadingSnackbar = UploadingSnackbar(context, _scaffoldMessengerKey, "deleting", icon: Icons.delete_rounded);

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: GestureDetector(
        onVerticalDragStart: (DragStartDetails details) {
          initial = details.globalPosition.dy;
        },
        onVerticalDragUpdate: (DragUpdateDetails details) {
          distance = details.globalPosition.dy - initial;
          if (distance > 0.0) {
            Navigator.pop(context);
          }
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body:  Stack(
            children: [
              buildCardHero(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 10),
                  SizedBox(
                    height: 5.0,
                    width: 50.0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.grey[300],
                      ),
                    ),
                  ),
                  buildTitle(context),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 70),
                child: GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2 / 2.5, 
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  padding: const EdgeInsets.all(10),
                  itemCount: widget.localData.lostAndFounds.length,
                  itemBuilder: (context, index) {
                    widget.localData.sortLostAndFoundBy("status");
                    return assets.lostItemBox(widget.localData.lostAndFounds[index], context, () {
                      showDeleteCheckBox(widget.localData.lostAndFounds[index], uploadingSnackbar);
                    });
                  },
                ),
              ),
            ],
          )
        ),
      ),
    );
  }

  Hero buildCardHero() {
    return Hero(
      tag: "delete lost and found container",
      child: Container(
        decoration: BoxDecoration(
          color: lightColorScheme.background,
          borderRadius: BorderRadius.circular(15),
        ),
      ),
    );
  }

  Container buildTitle(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: Hero(
        tag: "delete lost and found title",
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Delete item",
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  void showDeleteCheckBox(LostItem itemToDelete, UploadingSnackbar uploadingSnackbar) {
    showDialog(
      context: context, 
      builder: (BuildContext context) {
        return Dialog(
          child: Container(
            decoration: BoxDecoration(
              color: lightColorScheme.background,
              borderRadius: BorderRadius.circular(15),
            ),
            width: MediaQuery.of(context).size.width * 0.5,
            height: MediaQuery.of(context).size.height * 0.5, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(25),
                  child: Text(
                    "Are you sure you want to delete this item?", 
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 15), 
                    textAlign: TextAlign.center
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  height: MediaQuery.of(context).size.height * 0.22,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: itemToDelete.imageUrl,
                                  height: 100,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              if (itemToDelete.status == FoundStatus.returned)
                                Container(
                                  height: 100,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.black.withOpacity(0.5),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Returned',
                                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        fontSize: 24,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(
                            itemToDelete.name,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "status: ${statusToString(itemToDelete.status)}",
                                  style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Column(
                  children: [
                    Divider(color: Colors.grey[200], height: 1,),
                    ListTile(
                      title: Text("Delete", style: TextStyle(color: Colors.red), textAlign: TextAlign.center),
                      onTap: () async {
                        Navigator.pop(context);
                        uploadingSnackbar.showUploading();

                        var result;
                        try {
                          result = await widget.localData.apiService.deleteLostAndFound("${itemToDelete.id}");
                        } catch (e) {
                          result = {"status": "fail"};
                        }
                        uploadingSnackbar.showUploadingResult(result["status"] == "success");
                        uploadingSnackbar.dismiss();
                        if (result == "success") {
                          setState(() {
                            widget.localData.lostAndFounds.removeWhere((element) => element.id == itemToDelete.id);
                          });
                        }
                      },
                    ),
                    Divider(color: Colors.grey[200], height: 1,),
                  ],
                ),
                ListTile(
                  title: Text("Cancel", style: TextStyle(color: Colors.black), textAlign: TextAlign.center),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            )
          ),
        );
      },
    );
  }
}