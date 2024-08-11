import 'package:get/get.dart';
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