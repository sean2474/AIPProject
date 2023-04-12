/// school_store.dart
import 'package:flutter/material.dart';
import '../storage/local_storage.dart';
import '../widgets/assets.dart';

enum ItemCategory { food, drink, goods, other }

class SchoolStorePage extends StatefulWidget {
  final Data? localData;
  const SchoolStorePage({Key? key, this.localData}) : super(key: key);

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

  List<Map<String, dynamic>> items = [
    {
      'ID': '109fm0qwikf',
      'name': 'pizza',
      'category': ItemCategory.food,
      'price': 100,
      'stock': 10,
      'description': 'some description',
      'image_url':
          'https://cdn.newspenguin.com/news/photo/202007/2106_6019_954.jpg',
      'date_added': '2023-03-31 09:00:00',
    },
    {
      'ID': '902jiqla',
      'name': 'gatorade',
      'category': ItemCategory.drink,
      'price': 100,
      'stock': 10,
      'description': 'some description',
      'image_url':
          'https://cdn.newspenguin.com/news/photo/202007/2106_6019_954.jpg',
      'date_added': '2023-03-31 09:00:00',
    },
    {
      'ID': '902jiqla',
      'name': 'avon hoodie',
      'category': ItemCategory.goods,
      'price': 100,
      'stock': 10,
      'description': 'some description',
      'image_url':
          'https://cdn.newspenguin.com/news/photo/202007/2106_6019_954.jpg',
      'date_added': '2023-03-31 09:00:00',
    },
  ];

  int itemCounter(ItemCategory category) {
    int counter = 0;
    for (var item in items) {
      if (item['category'] == category) {
        counter++;
      }
    }
    return counter;
  }

  Map<String, dynamic> getItemFrom(int index, ItemCategory category) {
    int counter = 0;
    for (var item in items) {
      if (item['category'] == category) {
        if (counter == index) {
          return item;
        }
        counter++;
      }
    }
    return {};
  }

  Widget itemBox(Map<String, dynamic> data) {
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
                child: Image.network(
                  data['image_url'],
                  height: 150,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                data['name'],
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
                    '\$${data['price']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.green[700],
                    ),
                  ),
                  Text(
                    'Stock: ${data['stock']}',
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
    return Scaffold(
      backgroundColor: const Color(0xFFF7F6FB),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Stack(
          children: [
            AppBar(
              backgroundColor: Color(0xFF0E1B2A),
              elevation: 0,
              automaticallyImplyLeading: false,
              actions: [
                Assets(currentPage: SchoolStorePage()).menuBarButton(context),
              ],
            ),
            Container(
              margin: EdgeInsets.all(30),
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
            Positioned(
                bottom: 5,
                left: MediaQuery.of(context).size.width / 20,
                right: -MediaQuery.of(context).size.width / 20,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: const Assets().textButton(context,
                          text: "FOOD",
                          onTap: () => _selectTab(0),
                          color: Colors.white),
                    ),
                    Expanded(
                      child: const Assets().textButton(context,
                          text: "DRINK",
                          onTap: () => _selectTab(1),
                          color: Colors.white),
                    ),
                    Expanded(
                      child: const Assets().textButton(context,
                          text: "GOODS",
                          onTap: () => _selectTab(2),
                          color: Colors.white),
                    ),
                    Expanded(
                      child: const Assets().textButton(context,
                          text: "OTHER",
                          onTap: () => _selectTab(3),
                          color: Colors.white),
                    ),
                  ],
                )),
            Stack(
              children: [
                Positioned(
                  bottom: 6,
                  left: MediaQuery.of(context).size.width / 8 - 8,
                  child: Opacity(
                    opacity: _selectedTabIndex == 0 ? _animation.value : 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3eb9e4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  left: MediaQuery.of(context).size.width * 3 / 8 - 6,
                  child: Opacity(
                    opacity: _selectedTabIndex == 1 ? _animation.value : 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3eb9e4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  left: MediaQuery.of(context).size.width * 5 / 8 - 3,
                  child: Opacity(
                    opacity: _selectedTabIndex == 2 ? _animation.value : 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3eb9e4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 6,
                  left: MediaQuery.of(context).size.width * 7 / 8 - 3,
                  child: Opacity(
                    opacity: _selectedTabIndex == 3 ? _animation.value : 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: const Color(0xFF3eb9e4),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      drawer: const Assets(
        currentPage: SchoolStorePage(),
      ).build(context),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: GridView.builder(
          key: ValueKey<int>(_selectedTabIndex),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 2 /
                2.5, // You can adjust this to change the width and height ratio of the item boxes
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          padding: const EdgeInsets.all(10),
          itemCount: () {
            if (_selectedTabIndex == 0) {
              return itemCounter(ItemCategory.food);
            } else if (_selectedTabIndex == 1) {
              return itemCounter(ItemCategory.drink);
            } else if (_selectedTabIndex == 2) {
              return itemCounter(ItemCategory.goods);
            } else if (_selectedTabIndex == 3) {
              return itemCounter(ItemCategory.other);
            }
            return 0;
          }(),
          itemBuilder: (context, index) {
            Map<String, dynamic> item = getItemFrom(index, ItemCategory.other);
            if (_selectedTabIndex == 0) {
              item = getItemFrom(index, ItemCategory.food);
            } else if (_selectedTabIndex == 1) {
              item = getItemFrom(index, ItemCategory.drink);
            } else if (_selectedTabIndex == 2) {
              item = getItemFrom(index, ItemCategory.goods);
            }
            return itemBox(item);
          },
        ),
      ),
    );
  }
}

class ItemPage extends StatelessWidget {
  final Map<String, dynamic> itemData;

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
                  child: Image.network(
                    itemData['image_url'],
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
                      itemData['name'],
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
                          '\$${itemData['price']}',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green[700],
                          ),
                        ),
                        Text(
                          'Stock: ${itemData['stock']}',
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
                  itemData['description'], // Add the description text
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
