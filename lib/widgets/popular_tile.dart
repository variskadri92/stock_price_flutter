import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stock_price_app/models/global_quote.dart';
import 'package:stock_price_app/screens/stock_data.dart';
import '../controller/watchlist_controller.dart';
import '../services/api_service.dart';

class PopularTile extends StatefulWidget {
  const PopularTile({
    super.key,
    required this.symbol,
    this.showRemoveButton = false,
  });

  final String symbol;
  final bool showRemoveButton;

  @override
  State<PopularTile> createState() => _PopularTileState();
}

class _PopularTileState extends State<PopularTile> {
  final ApiService fetchStockData = ApiService();
  late Future<GlobalQuote?> _futureQuote;
  late Future<double?> price;

  final WatchlistController watchlistController = Get.find();


  @override
  void initState() {
    super.initState();
    _futureQuote = fetchStockData.fetchStockQuote(widget.symbol);
    price = fetchStockData.fetchStockPrice(widget.symbol);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: Future.wait([
        _futureQuote,
        price,
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const  Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data == null) {
          return const Center(child: Text('No data available'));
        }

        final quote = snapshot.data![0] as GlobalQuote?;
        final priceValue = snapshot.data![1] as double?;

        final displayPrice = priceValue?.toStringAsFixed(2) ?? 'N/A';
        final change = double.tryParse(quote?.change ?? '0.0') ?? 0.0;
        final percentChange = double.tryParse(quote?.percentChange ?? '0.0') ?? 0.0;

        return InkWell(
          onTap: () {
            Get.to(() => StockData(
              symbol: widget.symbol,
              quote: quote,
              price: priceValue,
            ));
          },        child: Padding(
            padding: const EdgeInsets.all(15),
            child: Material(
              elevation: 10,
              borderRadius: BorderRadius.circular(16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade600,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.symbol,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            quote?.name ?? 'N/A',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [

                        Text(
                          displayPrice,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: change < 0
                                ? Colors.red.withOpacity(0.7)
                                : Colors.green.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${change.toStringAsFixed(2)} (${percentChange.toStringAsFixed(2)}%)',
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                    if (widget.showRemoveButton)
                      IconButton(
                        icon:const  Icon(Icons.remove_circle, color: Colors.red),
                        onPressed: () {
                          watchlistController.removeSymbol(widget.symbol);
                        },
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
