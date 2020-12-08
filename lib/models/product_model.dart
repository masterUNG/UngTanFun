import 'dart:convert';

class ProductModel {
  final int id;
  final String title;
  final String url;
  ProductModel({
    this.id,
    this.title,
    this.url,
  });

  ProductModel copyWith({
    int id,
    String title,
    String url,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'url': url,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
  
    return ProductModel(
      id: map['id'],
      title: map['title'],
      url: map['url'],
    );
  }

  String toJson() => json.encode(toMap());

  factory ProductModel.fromJson(String source) => ProductModel.fromMap(json.decode(source));

  @override
  String toString() => 'ProductModel(id: $id, title: $title, url: $url)';

  @override
  bool operator ==(Object o) {
    if (identical(this, o)) return true;
  
    return o is ProductModel &&
      o.id == id &&
      o.title == title &&
      o.url == url;
  }

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ url.hashCode;
}
