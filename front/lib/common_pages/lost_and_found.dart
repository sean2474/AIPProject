import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../storage/local_storage.dart';
import '../widgets/assets.dart';


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
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  data.imagePath,
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
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
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0E1B2A),
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
              color: Colors.white,
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
                      // change detail
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
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.localData.settings.sortLostAndFoundBy,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
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
                            color: Colors.white,
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
      drawer: assets.build(context),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
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

    );
  }
}

class ItemPage extends StatelessWidget {
  final LostItem itemData;

  const ItemPage({Key? key, required this.itemData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    itemData.imagePath,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      itemData.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          "Found in ${itemData.locationFound}",
                          style: const TextStyle(
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          itemData.dateFound,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        Text(
                          statusToString(itemData.status),
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  itemData.description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
