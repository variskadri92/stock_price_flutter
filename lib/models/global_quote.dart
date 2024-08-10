// To parse this JSON data, do
//
//     final globalQuote = globalQuoteFromMap(jsonString);

import 'dart:convert';

GlobalQuote globalQuoteFromMap(String str) => GlobalQuote.fromMap(json.decode(str));

String globalQuoteToMap(GlobalQuote data) => json.encode(data.toMap());

class GlobalQuote {
  String symbol;
  String name;
  String exchange;
  String micCode;
  String currency;
  DateTime datetime;
  int timestamp;
  String open;
  String high;
  String low;
  String close;
  String volume;
  String previousClose;
  String change;
  String percentChange;
  String averageVolume;
  bool isMarketOpen;
  FiftyTwoWeek fiftyTwoWeek;

  GlobalQuote({
    required this.symbol,
    required this.name,
    required this.exchange,
    required this.micCode,
    required this.currency,
    required this.datetime,
    required this.timestamp,
    required this.open,
    required this.high,
    required this.low,
    required this.close,
    required this.volume,
    required this.previousClose,
    required this.change,
    required this.percentChange,
    required this.averageVolume,
    required this.isMarketOpen,
    required this.fiftyTwoWeek,
  });

  factory GlobalQuote.fromMap(Map<String, dynamic> json) => GlobalQuote(
    symbol: json["symbol"],
    name: json["name"],
    exchange: json["exchange"],
    micCode: json["mic_code"],
    currency: json["currency"],
    datetime: DateTime.parse(json["datetime"]),
    timestamp: json["timestamp"],
    open: json["open"],
    high: json["high"],
    low: json["low"],
    close: json["close"],
    volume: json["volume"],
    previousClose: json["previous_close"],
    change: json["change"],
    percentChange: json["percent_change"],
    averageVolume: json["average_volume"],
    isMarketOpen: json["is_market_open"],
    fiftyTwoWeek: FiftyTwoWeek.fromMap(json["fifty_two_week"]),
  );

  Map<String, dynamic> toMap() => {
    "symbol": symbol,
    "name": name,
    "exchange": exchange,
    "mic_code": micCode,
    "currency": currency,
    "datetime": "${datetime.year.toString().padLeft(4, '0')}-${datetime.month.toString().padLeft(2, '0')}-${datetime.day.toString().padLeft(2, '0')}",
    "timestamp": timestamp,
    "open": open,
    "high": high,
    "low": low,
    "close": close,
    "volume": volume,
    "previous_close": previousClose,
    "change": change,
    "percent_change": percentChange,
    "average_volume": averageVolume,
    "is_market_open": isMarketOpen,
    "fifty_two_week": fiftyTwoWeek.toMap(),
  };
}

class FiftyTwoWeek {
  String low;
  String high;
  String lowChange;
  String highChange;
  String lowChangePercent;
  String highChangePercent;
  String range;

  FiftyTwoWeek({
    required this.low,
    required this.high,
    required this.lowChange,
    required this.highChange,
    required this.lowChangePercent,
    required this.highChangePercent,
    required this.range,
  });

  factory FiftyTwoWeek.fromMap(Map<String, dynamic> json) => FiftyTwoWeek(
    low: json["low"],
    high: json["high"],
    lowChange: json["low_change"],
    highChange: json["high_change"],
    lowChangePercent: json["low_change_percent"],
    highChangePercent: json["high_change_percent"],
    range: json["range"],
  );

  Map<String, dynamic> toMap() => {
    "low": low,
    "high": high,
    "low_change": lowChange,
    "high_change": highChange,
    "low_change_percent": lowChangePercent,
    "high_change_percent": highChangePercent,
    "range": range,
  };
}
