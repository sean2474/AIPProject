// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:front/admin/edit_lost_and_found/uploading_snackbar.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'edit_page.dart';
import 'add_page.dart';
import 'delete_page.dart';

class EditLostAndFoundPage extends StatefulWidget {
  final Data localData;
  const EditLostAndFoundPage({Key? key, required this.localData}) : super(key: key);

  @override
  EditLostAndFoundPageState createState() => EditLostAndFoundPageState();
}

class EditLostAndFoundPageState extends State<EditLostAndFoundPage>
    with TickerProviderStateMixin {

  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
      
  @override
  Widget build(BuildContext context) {
    UploadingSnackbar uploadingSnackbar = UploadingSnackbar(context, _scaffoldMessengerKey, "uploading");
    Assets assets = Assets(currentPage: EditLostAndFoundPage(localData: widget.localData), localData: widget.localData,);
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(100),
          child: Stack(
            children: [
              AppBar(
                elevation: 0,
                automaticallyImplyLeading: false,
                actions: [
                  assets.menuBarButton(context),
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(50),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(30),
                child: const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Edit Lost and Found",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        drawer: assets.buildDrawer(context),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            buildEditCard("Add item", const Icon(Icons.add), "add lost and found", () {
              assets.pushDialogPage(context, AddPage(
                  localData: widget.localData, 
                  showUploadingSnackBar: uploadingSnackbar.showUploading, 
                  dismissSnackBar: uploadingSnackbar.dismiss,
                  showUploadingResultSnackBar: uploadingSnackbar.showUploadingResult,
                ), 
                haveDialog: false
              );
            }),
            buildEditCard("Edit item", const Icon(Icons.edit), "edit lost and found", () {
              assets.pushDialogPage(context, EditPage(
                localData: widget.localData
              ), haveDialog: false);
            }),
            buildEditCard("Delete item", const Icon(Icons.delete), "delete lost and found", () {
              assets.pushDialogPage(context, DeletePage(
                localData: widget.localData,
              ), haveDialog: false);
            }),
          ],
        ),
      ),
    );
  }

  Widget buildEditCard(String title, Icon icon, String tag, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Stack(
        children: [
          Hero(
            tag: "$tag container",
            child: Card(
              child: SizedBox(
                height: 70,
                width: double.infinity,
              ),
            ),
          ),
          InkWell(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 25),
              child: Hero(
                tag: "$tag title",
                child: Row(
                  children: [
                    const SizedBox(width: 20),
                    icon,
                    const SizedBox(width: 20),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}