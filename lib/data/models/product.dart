/// Mahsulot modeli.
class Product {
  const Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.subcategory,
    required this.brand,
    required this.price,
    this.oldPrice,
    required this.rating,
    required this.reviewCount,
    required this.soldCount,
    required this.images,
    required this.description,
    required this.specs,
    required this.stock,
    required this.sellerName,
    this.tags = const [],
    this.createdAt,
  });

  final String id;
  final String name;
  final String categoryId;
  final String subcategory;
  final String brand;
  final int price;
  final int? oldPrice;
  final double rating;
  final int reviewCount;
  final int soldCount;
  final List<String> images;
  final String description;
  final Map<String, String> specs;
  final int stock;
  final String sellerName;
  final List<String> tags;
  final DateTime? createdAt;

  bool get inStock => stock > 0;
  bool get hasDiscount => oldPrice != null && oldPrice! > price;
  int get discountPercent =>
      hasDiscount ? (((oldPrice! - price) / oldPrice!) * 100).round() : 0;
  String get image => images.isNotEmpty ? images.first : '';

  /// Oyiga bo'lib to'lash (12 oy) taxminiy summasi.
  int get monthlyPayment => (price * 1.25 / 12).round();

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json['id'] as String,
        name: json['name'] as String,
        categoryId: json['categoryId'] as String,
        subcategory: json['subcategory'] as String? ?? '',
        brand: json['brand'] as String? ?? '',
        price: json['price'] as int,
        oldPrice: json['oldPrice'] as int?,
        rating: (json['rating'] as num?)?.toDouble() ?? 0,
        reviewCount: json['reviewCount'] as int? ?? 0,
        soldCount: json['soldCount'] as int? ?? 0,
        images: (json['images'] as List?)?.cast<String>() ?? const [],
        description: json['description'] as String? ?? '',
        specs: (json['specs'] as Map?)?.cast<String, String>() ?? const {},
        stock: json['stock'] as int? ?? 0,
        sellerName: json['sellerName'] as String? ?? '',
        tags: (json['tags'] as List?)?.cast<String>() ?? const [],
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'] as String)
            : null,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'categoryId': categoryId,
        'subcategory': subcategory,
        'brand': brand,
        'price': price,
        'oldPrice': oldPrice,
        'rating': rating,
        'reviewCount': reviewCount,
        'soldCount': soldCount,
        'images': images,
        'description': description,
        'specs': specs,
        'stock': stock,
        'sellerName': sellerName,
        'tags': tags,
        'createdAt': createdAt?.toIso8601String(),
      };
}
