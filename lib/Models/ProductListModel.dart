class ProductListModel {
  int? id;
  String? title;
  double? price; // Use double for consistency
  String? description;
  String? category;
  String? image;
  Rating? rating;

  ProductListModel({
    this.id,
    this.title,
    this.price,
    this.description,
    this.category,
    this.image,
    this.rating,
  });

  ProductListModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    price = _toDouble(json['price']); // Convert to double
    description = json['description'];
    category = json['category'];
    image = json['image'];
    rating = json['rating'] != null ? Rating.fromJson(json['rating']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['description'] = description;
    data['category'] = category;
    data['image'] = image;
    if (rating != null) {
      data['rating'] = rating!.toJson();
    }
    return data;
  }

  /// Helper method to handle dynamic price conversion
  double? _toDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return null; // Handle unexpected types
    }
  }
}

class Rating {
  double? rate; // Use double for consistency
  int? count;

  Rating({this.rate, this.count});

  Rating.fromJson(Map<String, dynamic> json) {
    rate = _toDouble(json['rate']); // Convert to double
    count = json['count'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['rate'] = rate;
    data['count'] = count;
    return data;
  }

  /// Helper method to handle dynamic rate conversion
  double? _toDouble(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    } else {
      return null; // Handle unexpected types
    }
  }
}

