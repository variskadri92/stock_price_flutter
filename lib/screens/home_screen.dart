import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:stock_price_app/models/search_symbol.dart';
import 'package:stock_price_app/screens/stock_data.dart';
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
    return Scaffold(
      backgroundColor: Colors.deepPurple[100],
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                backgroundColor: Colors.deepPurple,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('S T O C K  Q U O T E',
                        style: TextStyle(color: Colors.white, fontSize: 24)),
                    Text('8 August',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
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
                        SizedBox(height: 90),
                        TextField(
                          onChanged: (value) async {
                            await _fetchSearch(value);
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter stock symbol',
                            hintStyle: TextStyle(color: Colors.grey[400]),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            filled: true,
                            fillColor: Colors.grey[200],
                            prefixIcon:
                            Icon(Icons.search, color: Colors.grey[600]),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 20),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide:
                              BorderSide(color: Colors.deepPurpleAccent),
                            ),
                          ),
                          style: TextStyle(color: Colors.black, fontSize: 16),
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
              left: 20,
              right: 20,
              child: Container(
                constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.32, // Constrain the height
    ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: ListView.builder(
                    itemCount: retrieveItems.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      Datum item = retrieveItems[index];
                      return ListTile(
                        title: Text(item.symbol),
                        subtitle: Text(item.instrumentName),
                        onTap: () => Get.to(() => StockData(symbol: item.symbol)),
                      );
                    }),
              ),
            ),
        ],
      ),
    );
  }
}
