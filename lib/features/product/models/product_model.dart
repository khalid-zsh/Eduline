class ProductModel{
  final String? id;
  final String? userId;
  final String name;
  final String description;
  final double price;
  final int stock;
  final String category;
  final String brand;
  final bool isDiscounted;
  final double discountPercent;
  final List<String> tags;
  final bool isActive;
  final double weight;
  final List<String> colors;
  final String dimensions;
  final String imageUrl;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProductModel({
    this.id,
    this.userId,
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.category,
    required this.brand,
    required this.isDiscounted,
    required this.discountPercent,
    required this.tags,
    required this.isActive,
    required this.weight,
    required this.colors,
    required this.dimensions,
    required this.imageUrl,
    this.createdAt,
    this.updatedAt,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['_id'] ?? json['id'] ?? '',
      userId: json['userId']?.toString(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      category: json['category'] ?? '',
      brand: json['brand'] ?? '',
      isDiscounted: json['isDiscounted'] ?? false,
      discountPercent: (json['discountPercent'] as num?)?.toDouble() ?? 0.0,
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      isActive: json['isActive'] ?? true,
      weight: (json['weight'] as num?)?.toDouble() ?? 0.0,
      colors: json['colors'] != null ? List<String>.from(json['colors']) : [],
      dimensions: json['dimensions'] ?? '',
      imageUrl: json['image'] ?? json['imageUrl'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      if (userId != null) 'userId': userId,
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'category': category,
      'brand': brand,
      'isDiscounted': isDiscounted,
      'discountPercent': discountPercent,
      'tags': tags,
      'isActive': isActive,
      'weight': weight,
      'colors': colors,
      'dimensions': dimensions,
      'image': imageUrl,
    };
  }

  double get finalPrice {
    if (isDiscounted && discountPercent > 0) {
      return price - (price * discountPercent / 100);
    }
    return price;
  }

  ProductModel copyWith({
    String? id,
    String? userId,
    String? name,
    String? description,
    double? price,
    int? stock,
    String? category,
    String? brand,
    bool? isDiscounted,
    double? discountPercent,
    List<String>? tags,
    bool? isActive,
    double? weight,
    List<String>? colors,
    String? dimensions,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      stock: stock ?? this.stock,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      isDiscounted: isDiscounted ?? this.isDiscounted,
      discountPercent: discountPercent ?? this.discountPercent,
      tags: tags ?? this.tags,
      isActive: isActive ?? this.isActive,
      weight: weight ?? this.weight,
      colors: colors ?? this.colors,
      dimensions: dimensions ?? this.dimensions,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}