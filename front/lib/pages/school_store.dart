/// school_store.dart
import 'package:flutter/material.dart';
import 'package:front/data/data.dart';
import 'package:front/widgets/assets.dart';
import 'package:front/data/school_store.dart';
import 'package:cached_network_image/cached_network_image.dart';

String itemTypeToString(ItemType type) {
  switch (type) {
    case ItemType.food:
      return 'food';
    case ItemType.drink:
      return 'drink';
    case ItemType.goods:
      return 'goods';
    case ItemType.other:
      return 'other';
    default:
      return 'na';
  }
}

class SchoolStorePage extends StatefulWidget {
  final Data localData;
  const SchoolStorePage({Key? key, required this.localData}) : super(key: key);

  @override
  SchoolStorePageState createState() => SchoolStorePageState();
}

class SchoolStorePageState extends State<SchoolStorePage>
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

  int itemCounter(ItemType itemType) {
    int counter = 0;
    for (var item in widget.localData.storeItems) {
      if (item.itemType == itemType) {
        counter++;
      }
    }
    return counter;
  }

  List<StoreItem> getItemsOfType(ItemType itemType) {
    List<StoreItem> items = [];
    for (var item in widget.localData.storeItems) {
      if (item.itemType == itemType) {
        items.add(item);
      }
    }
    return items;
  }

  Widget itemBox(StoreItem storeItem) {
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
                child: ItemPage(itemData: storeItem),
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
                child: CachedNetworkImage(
                  imageUrl: storeItem.imagePath,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                storeItem.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '\$${storeItem.price}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  Text(
                    'Stock: ${storeItem.stock}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
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

  @override
  Widget build(BuildContext context) {
    Assets assets = Assets(currentPage: SchoolStorePage(localData: widget.localData), localData: widget.localData,);
    List<StoreItem> items = getItemsOfType(ItemType.values[_selectedTabIndex]);
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
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  child: assets.drawAppBarSelector(context: context, titles: ["FOOD", "DRINK", "GOODS", "OTHER"], selectTab: _selectTab, animation: _animation, selectedIndex: _selectedTabIndex)
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.all(30),
              child: const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Hawks Nest",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: assets.buildDrawer(context),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: GridView.builder(
          key: ValueKey<int>(_selectedTabIndex),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 / 2.5, 
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(10),
          itemCount: items.length,
          itemBuilder: (context, index) {
            return itemBox(items[index]);
          },
        ),
      ),
    );
  }
}

class ItemPage extends StatelessWidget {
  final StoreItem itemData;

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
                  child: CachedNetworkImage(
                    imageUrl: itemData.imagePath,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Icon(Icons.error),
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
                          '\$${itemData.price}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        Text(
                          'Stock: ${itemData.stock}',
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
                LimitedBox(
                  maxHeight: 175, // Adjust this value based on your desired maximum height
                  child: SingleChildScrollView(
                    child: Text(
                      itemData.description, // Add the description text
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
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
