import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/watchlist_controller.dart';
import '../models/global_quote.dart';
import '../services/api_service.dart';

class SearchStockData extends StatelessWidget {
  const SearchStockData({super.key, required this.symbol});

  final String symbol;

  @override
  Widget build(BuildContext context) {
    final WatchlistController watchlistController = Get.find();
    final ApiService fetchStockData = ApiService();

    // Fetch stock data using the API service
    final Future<GlobalQuote?> futureQuote = fetchStockData.fetchStockQuote(symbol);
    final Future<double?> price = fetchStockData.fetchStockPrice(symbol);

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
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(16),
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
      body: FutureBuilder(
        future: Future.wait([futureQuote, price]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data available'));
          }

          final quote = snapshot.data![0] as GlobalQuote?;
          final priceValue = snapshot.data![1] as double?;

          // Handle cases where price or quote might be null
          final displayPrice = priceValue?.toStringAsFixed(2) ?? 'N/A';

          return Padding(
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
                              searchStockDataRow("Current Price", displayPrice),
                              searchStockDataRow("Percentage Change", quote?.percentChange ?? 'N/A'),
                              searchStockDataRow("Prev Close", quote?.previousClose ?? 'N/A'),
                              searchStockDataRow("Open", quote?.open ?? 'N/A'),
                              searchStockDataRow("High", quote?.high ?? 'N/A'),
                              searchStockDataRow("Low", quote?.low ?? 'N/A'),
                              searchStockDataRow("Volume", quote?.volume ?? 'N/A'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget searchStockDataRow(String label, String value) {
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
