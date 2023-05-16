// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'package:front/data/lost_item.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'item.dart';

class LostAndFoundPage extends StatefulWidget {
  final Data localData;
  const LostAndFoundPage({Key? key, required this.localData}) : super(key: key);

  @override
  LostAndFoundPageState createState() => LostAndFoundPageState();
}

class LostAndFoundPageState extends State<LostAndFoundPage>
    with TickerProviderStateMixin {
  late final AnimationController _animationController;
  String _searchText = "";
  final RefreshController _refreshController = RefreshController(initialRefresh: false);

  List<LostItem> selectedItem(List<LostItem> items, String keyWord) {
    if (keyWord == "") {
      return items;
    }

    List<LostItem> result = [];
    for (LostItem item in items) {
      String itemName = item.name.toLowerCase().replaceAll(" ", "");
      bool contains = false;
      for (String word in keyWord.split(" ")) {
        if (itemName.contains(word.toLowerCase())) {
          contains = true;
        } else {
          contains = false;
          break;
        }
      }
      if (contains) {
        result.add(item);
      }
    }
    return result;
  }
  
  @override 
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Widget itemBox(LostItem data) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width *
                    0.8, // Adjust the width of the modal
                height: MediaQuery.of(context).size.height *
                    0.5, // Adjust the height of the modal
                child: ItemPage(itemData: data),
              ),
            );
          },
        );
      },
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: data.imageUrl,
                      height: 130,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  if (data.status == FoundStatus.returned)
                    Container(
                      height: 130,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.black.withOpacity(0.5),
                      ),
                      child: Center(
                        child: Text(
                          'Returned',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                data.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "status: ${statusToString(data.status)}",
                      style: const TextStyle(
                        fontSize: 16,
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
    );
  }

  void _showOptions(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: const Text('Sort Options'),
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Sort by Status'),
            onPressed: () {
              setState(() {
                widget.localData.sortLostAndFoundBy("status");
                widget.localData.settings.sortLostAndFoundBy = "status";
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Sort by Date'),
            onPressed: () {
              setState(() {
                widget.localData.sortLostAndFoundBy("date");
                widget.localData.settings.sortLostAndFoundBy = "date";
              });
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Sort by Name'),
            onPressed: () {
              setState(() {
                widget.localData.sortLostAndFoundBy("name");
                widget.localData.settings.sortLostAndFoundBy = "name";
              });
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          isDefaultAction: true,
          onPressed: () {
            Navigator.pop(context);
          },
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Assets assets = Assets(currentPage: LostAndFoundPage(localData: widget.localData), localData: widget.localData,);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Container(
          margin: const EdgeInsets.only(left: 10),
          child: const Text(
            "Lost and Found",
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: [
          assets.menuBarButton(context),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 40,
                    child: TextField(
                      showCursor: false,
                      onChanged: (value) {
                        setState(() {
                          _searchText = value;
                        });
                      },
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Search items',
                        contentPadding: const EdgeInsets.all(8.0),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                GestureDetector(
                  onTap: () {
                    _showOptions(context);
                  },
                  child: Row(
                    children: [
                      Column(
                        children: [
                          const Text(
                            "Sorted by",
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            widget.localData.settings.sortLostAndFoundBy,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(3),
                        child: Container(
                          height: 40,
                          width: 40,
                          color: Colors.transparent,
                          child: const Icon(
                            Icons.sort,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      drawer: assets.buildDrawer(context),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: SmartRefresher(
          enablePullDown: true,
          enablePullUp: false,
          controller: _refreshController,
          header: assets.refreshHeader(indicatorColor: Colors.grey,),
          onRefresh: () => Future.delayed(const Duration(milliseconds: 500), () async {
            widget.localData.lostAndFounds = LostItem.transformData(await widget.localData.apiService.getLostAndFound());
            setState(() {});
            _refreshController.refreshCompleted();
          }),
          child: GridView.builder(
            key: ValueKey<String>(_searchText),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 2 / 2.5, 
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            padding: const EdgeInsets.all(10),
            itemCount: selectedItem(widget.localData.lostAndFounds, _searchText).length,
            itemBuilder: (context, index) {
              LostItem item = selectedItem(widget.localData.lostAndFounds, _searchText)[index];
              return itemBox(item);
            },
          ),
        ),
      ),

    );
  }
}