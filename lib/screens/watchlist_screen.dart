import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/watchlist_controller.dart';
import '../widgets/popular_tile.dart';

class WatchlistScreen extends StatelessWidget {
  const WatchlistScreen({super.key});


  @override
  Widget build(BuildContext context) {
    final WatchlistController watchlistController = Get.find();

    return Scaffold(
      backgroundColor: Colors.grey.shade500,

      appBar: AppBar(
        title: const Text("Wishlist",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey.shade800,

      ),
      body: Obx(() {
        if (watchlistController.watchlistSymbol.isEmpty) {
          return const Center(child: Text('No symbols in wishlist.'));
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
