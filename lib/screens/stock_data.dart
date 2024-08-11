import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/watchlist_controller.dart';
import '../models/global_quote.dart';

class StockData extends StatelessWidget {
  const StockData({
    super.key,
    required this.symbol,
    required this.quote,
    required this.price,
  });

  final String symbol;
  final GlobalQuote? quote;
  final double? price;


  @override
  Widget build(BuildContext context) {
    final WatchlistController watchlistController = Get.find();

    final displayPrice = price?.toStringAsFixed(2) ?? 'N/A';

    return Scaffold(
      backgroundColor: Colors.grey.shade500,
      appBar: AppBar(
        title: const Text("S T O C K  D A T A",style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.grey.shade800,
        actions: [
          IconButton(
            onPressed: () {
              watchlistController.addSymbol(symbol);
              var snackBar = SnackBar(
                behavior: SnackBarBehavior.floating,
                backgroundColor: Colors.grey.shade500,
                elevation: 0,
                content: Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(12)
                  ),
                  child: const Padding(
                    padding:  EdgeInsets.all(16),
                    child: Text('Stock Added to Watchlist'),
                  ),
                ),
              );

              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
            icon: const Icon(Icons.add,color: Colors.white,),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                quote?.name ?? 'N/A',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Material(
                  borderRadius: BorderRadius.circular(20),
                  elevation: 10,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      padding: const EdgeInsets.all(20),
                      color: Colors.grey.shade600,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          stockDataRow("Current Price", displayPrice),
                          stockDataRow("Percentage Change", quote?.percentChange ?? 'N/A'),
                          stockDataRow("Prev Close", quote?.previousClose ?? 'N/A'),
                          stockDataRow("Open", quote?.open ?? 'N/A'),
                          stockDataRow("High", quote?.high ?? 'N/A'),
                          stockDataRow("Low", quote?.low ?? 'N/A'),
                          stockDataRow("Volume", quote?.volume ?? 'N/A'),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget stockDataRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}

