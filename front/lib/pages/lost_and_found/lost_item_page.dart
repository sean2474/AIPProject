import 'package:flutter/material.dart';
import 'package:front/color_schemes.g.dart';
import 'package:front/data/data.dart';
import 'package:front/data/lost_item.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

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


class ItemPage extends StatelessWidget {
  final LostItem itemData;

  const ItemPage({Key? key, required this.itemData}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: lightColorScheme.secondaryContainer,
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Hero(
                  tag: '${itemData.imageUrl}_${itemData.id}',
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: CachedNetworkImage(
                          imageUrl: itemData.imageUrl,
                          height: 150,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                      if (itemData.status == FoundStatus.returned)
                        Container(
                          height: 150,
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
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        itemData.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const SizedBox(height: 8),
                        SizedBox(
                          width: 160,
                          child: Text(
                            textAlign: TextAlign.right,
                            "Found in ${itemData.locationFound}",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Text(
                          dateFormat.format(DateTime.parse(itemData.dateFound)),
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
