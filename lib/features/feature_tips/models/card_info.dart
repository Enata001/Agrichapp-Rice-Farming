import 'dart:convert';

class CardInfo {
  final String tip;
  final String day;

  CardInfo({required this.tip, required this.day});

  Map<String, dynamic> toJson() {
    return {
      'tip': tip,
      'day': day,
    };
  }

  factory CardInfo.fromJson(Map<String, dynamic> json) {
    return CardInfo(
      day: json['day'],
      tip: json['tip'],
    );
  }

  factory CardInfo.fromString(String data) {
    return CardInfo.fromJson(
      jsonDecode(data),
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }



}
