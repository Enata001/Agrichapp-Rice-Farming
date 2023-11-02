import 'dart:convert';

class Thumbnail {
  final String name;
  final String path;
  final String category;

  Thumbnail({
    required this.category,
    required this.name,
    required this.path,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'path': path,
      'category': category,
    };
  }

  factory Thumbnail.fromJson(Map<String, dynamic> json) {
    return Thumbnail(
        name: json['name'], path: json['path'], category: json['category']);
  }

  factory Thumbnail.fromString({required String data}) {
    return Thumbnail.fromJson(
      jsonDecode(data),
    );
  }

  @override
  String toString() {
    return jsonEncode(toJson());
  }
}