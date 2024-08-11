import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/global_quote.dart';

class ApiService {
  final String _baseUrl = 'https://api.twelvedata.com';
  final String _apiKey = '527e668da5164066af5ff2e7e6aa5696';

  Future<GlobalQuote?> fetchStockQuote(String symbol) async {
    final url = Uri.parse('$_baseUrl/quote?symbol=$symbol&apikey=$_apiKey');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        if (json.containsKey('symbol')) {
          return GlobalQuote.fromMap(json);
        } else {
          print('Error fetching data: ${json['message']}');
          return null;
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }
  Future<double?> fetchStockPrice(String symbol) async {
    final url = Uri.parse('$_baseUrl/price?symbol=$symbol&apikey=$_apiKey&source=docs');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        if (json.containsKey('price')) {
          return double.tryParse(json['price']);
        } else {
          print('Error fetching data: ${json['message']}');
          return null;
        }
      } else {
        print('Failed to load data. Status code: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('An error occurred: $e');
      return null;
    }
  }
}
