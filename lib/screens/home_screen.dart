import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:stock_price_app/models/search_symbol.dart';
import 'package:stock_price_app/screens/search_stock_data.dart';
import 'package:stock_price_app/widgets/popular_tile.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<String> symbol = [
    'aapl',
    'ibm',
    'ba',

  ];
  List<Datum> retrieveItems = [];


  Future<void> _fetchSearch(String symbol) async {
    if (symbol.isEmpty) {
      setState(() {
        retrieveItems = [];
      });
      return;
    }
    String uri =
        "https://api.twelvedata.com/symbol_search?symbol=$symbol&source=docs";
    http.Response response = await http.get(Uri.parse(uri));
    if (response.statusCode == 200 && response.body != null) {
      final jsonMap = jsonDecode(response.body);
      if (jsonMap['data'] != null) {
        SearchSymbol searchSymbol = searchSymbolFromMap(response.body);
        setState(() {
          retrieveItems = searchSymbol.data;
        });
      } else {
        setState(() {
          retrieveItems = [];
        });
      }
    } else {
      setState(() {
        retrieveItems = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String currentDateTime = DateFormat('d MMMM, hh:mm a').format(DateTime.now());  // Format current date and time
    return Scaffold(
      backgroundColor: Colors.grey[500],
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.grey.shade800,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('S T O C K   Q U O T E',
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                    Text(currentDateTime,
                        style: const TextStyle(color: Colors.white, fontSize: 16)),
                  ],
                ),
                expandedHeight: 180,
                floating: true,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  background: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 90),
                        TextField(
                          onChanged: (value) async {

                            if (value.isEmpty) {
                              setState(() {
                                retrieveItems = [];
                              });
                            } else {
                              await _fetchSearch(value);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter stock symbol',
                            hintStyle: TextStyle(color: Colors.grey[600]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[00],
                            prefixIcon:
                            Icon(Icons.search, color: Colors.grey[600]),
                            contentPadding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: const BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                              BorderSide(color: Colors.grey.shade100),
                            ),
                          ),
                          style: const TextStyle(color: Colors.black, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    String currentSymbol = symbol[index];
                    return PopularTile(symbol: currentSymbol);
                  },
                  childCount: symbol.length,
                ),
              ),
            ],
          ),
          if(retrieveItems.isNotEmpty)
            Positioned(
              top: 170,
              left: 25,
              right: 25,
              child: Container(
                constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.32, // Constrain the height
    ),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView.builder(
                    itemCount: retrieveItems.length,
                    shrinkWrap: true,
                    physics: const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      Datum item = retrieveItems[index];
                      return ListTile(
                        title: Text(item.symbol),
                        subtitle: Text(item.instrumentName),
                        onTap: () => Get.to(() => SearchStockData(symbol: item.symbol)),
                      );
                    }),
              ),
            ),
        ],
      ),
    );
  }
}
