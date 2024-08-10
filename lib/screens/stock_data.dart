import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:stock_price_app/services/api_service.dart';

import '../models/global_quote.dart';

class StockData extends StatefulWidget {
  const StockData({super.key, required this.symbol});

  final String symbol;

  @override
  State<StockData> createState() => _StockDataState();
}

class _StockDataState extends State<StockData> {

   final WatchlistController watchlistController = Get.find();
  final ApiService fetchStockData = ApiService();
  late Future<GlobalQuote?> _futureQuote;
  late Future<double?> price;

  @override
  void initState() {
    super.initState();
    _futureQuote = fetchStockData.fetchStockQuote(widget.symbol);
    price = fetchStockData.fetchStockPrice(widget.symbol);
  }


  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait([
        _futureQuote,
        price,
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return Center(child: Text('No data available'));
        }

        final quote = snapshot.data![0] as GlobalQuote?;
        final priceValue = snapshot.data![1] as double?;

        // Handle cases where price or quote might be null
        final displayPrice = priceValue?.toStringAsFixed(2) ?? 'N/A';
        final change = double.tryParse(quote?.change ?? '0.0') ?? 0.0;
        final percentChange = double.tryParse(quote?.percentChange ?? '0.0') ?? 0.0;


        return Scaffold(
          backgroundColor: Colors.deepPurple[100],
          appBar: AppBar(
            title: const Text("S T O C K  D A T A"),
            backgroundColor: Colors.deepPurple,
            actions: [
              IconButton(onPressed: (){
              watchlistController.addSymbol(widget.symbol);
              print(watchlistController.watchlistSymbol);
              }, icon: Icon(Icons.add))
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                 quote?.name ?? 'N/A',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[800],
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      height: 400,
                      padding: const EdgeInsets.all(20),
                      color: Colors.deepPurple[200],
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          buildStockInfoRow("Current Price", displayPrice),
                          buildStockInfoRow("Percentage Change",  quote?.percentChange ?? 'N/A'),
                          buildStockInfoRow("Prev Close",  quote?.previousClose ?? 'N/A'),
                          buildStockInfoRow("Open",  quote?.open ?? 'N/A'),
                          buildStockInfoRow("High",  quote?.high ?? 'N/A'),
                          buildStockInfoRow("Low", quote?.low ?? 'N/A'),
                          buildStockInfoRow("Volume", quote?.volume ?? 'N/A'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }

  Widget buildStockInfoRow(String label, String value) {
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

class WatchlistController extends GetxController {
  var watchlistSymbol = <String>[].obs;

  void addSymbol(String symbol) {
    if (!watchlistSymbol.contains(symbol)) {
      watchlistSymbol.add(symbol);
    }
  }

  void removeSymbol(String symbol) {
    watchlistSymbol.remove(symbol);
  }
}


