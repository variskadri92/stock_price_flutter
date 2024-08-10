// To parse this JSON data, do
//
//     final searchSymbol = searchSymbolFromMap(jsonString);

import 'dart:convert';

SearchSymbol searchSymbolFromMap(String str) => SearchSymbol.fromMap(json.decode(str));

String searchSymbolToMap(SearchSymbol data) => json.encode(data.toMap());

class SearchSymbol {
  List<Datum> data;
  String status;

  SearchSymbol({
    required this.data,
    required this.status,
  });

  factory SearchSymbol.fromMap(Map<String, dynamic> json) => SearchSymbol(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromMap(x))),
    status: json["status"],
  );

  Map<String, dynamic> toMap() => {
    "data": List<dynamic>.from(data.map((x) => x.toMap())),
    "status": status,
  };
}

class Datum {
  String symbol;
  String instrumentName;
  String exchange;
  String micCode;
  String exchangeTimezone;
  InstrumentType instrumentType;
  String country;
  String currency;

  Datum({
    required this.symbol,
    required this.instrumentName,
    required this.exchange,
    required this.micCode,
    required this.exchangeTimezone,
    required this.instrumentType,
    required this.country,
    required this.currency,
  });

  factory Datum.fromMap(Map<String, dynamic> json) => Datum(
    symbol: json["symbol"] ?? 'N/A',
    instrumentName: json["instrument_name"] ?? 'N/A',
    exchange: json["exchange"] ?? 'N/A',
    micCode: json["mic_code"] ?? 'N/A',
    exchangeTimezone: json["exchange_timezone"] ?? 'N/A',
    instrumentType: instrumentTypeValues.map[json["instrument_type"]] ?? InstrumentType.COMMON_STOCK,
    country: json["country"] ?? 'N/A',
    currency: json["currency"] ?? 'N/A',
  );

  Map<String, dynamic> toMap() => {
    "symbol": symbol,
    "instrument_name": instrumentName,
    "exchange": exchange,
    "mic_code": micCode,
    "exchange_timezone": exchangeTimezone,
    "instrument_type": instrumentTypeValues.reverse[instrumentType],
    "country": country,
    "currency": currency,
  };
}


enum InstrumentType {
  CLOSED_END_FUND,
  COMMON_STOCK,
  ETF,
  PREFERRED_STOCK
}

final instrumentTypeValues = EnumValues({
  "Closed-end Fund": InstrumentType.CLOSED_END_FUND,
  "Common Stock": InstrumentType.COMMON_STOCK,
  "ETF": InstrumentType.ETF,
  "Preferred Stock": InstrumentType.PREFERRED_STOCK
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
