import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_price_app/screens/stock_data.dart';

import '../widgets/popular_tile.dart';

class WatchlistScreen extends StatelessWidget {
  WatchlistScreen({super.key});

  final WatchlistController watchlistController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],

      appBar: AppBar(
        title: const Text("Wishlist"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Obx(() {
        if (watchlistController.watchlistSymbol.isEmpty) {
          return Center(child: Text('No symbols in wishlist.'));
        } else {
          return ListView.builder(
            itemCount: watchlistController.watchlistSymbol.length,
            itemBuilder: (context, index) {
              final symbol = watchlistController.watchlistSymbol[index];
              return PopularTile(symbol: symbol, showRemoveButton: true,);
            },
          );
        }
      }),
    );
  }
}