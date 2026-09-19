import '../models/models.dart';
import '../sources/demo_products.dart';
import '../sources/demo_reviews.dart';

/// Saralash turlari.
enum SortOption { popular, priceAsc, priceDesc, rating, newest }

extension SortOptionX on SortOption {
  String get label => switch (this) {
        SortOption.popular => 'Mashhurligi',
        SortOption.priceAsc => 'Arzonidan qimmatiga',
        SortOption.priceDesc => 'Qimmatidan arzoniga',
        SortOption.rating => "Reyting bo'yicha",
        SortOption.newest => 'Yangilari',
      };
}

/// Filtr parametrlari.
class ProductFilter {
  const ProductFilter({
    this.query = '',
    this.categoryId,
    this.subcategory,
    this.brands = const {},
    this.minPrice,
    this.maxPrice,
    this.minRating,
    this.onlyDiscount = false,
    this.onlyInStock = false,
    this.tag,
    this.sort = SortOption.popular,
  });

  final String query;
  final String? categoryId;
  final String? subcategory;
  final Set<String> brands;
  final int? minPrice;
  final int? maxPrice;
  final double? minRating;
  final bool onlyDiscount;
  final bool onlyInStock;
  final String? tag;
  final SortOption sort;

  int get activeCount {
    var n = 0;
    if (brands.isNotEmpty) n++;
    if (minPrice != null || maxPrice != null) n++;
    if (minRating != null) n++;
    if (onlyDiscount) n++;
    if (onlyInStock) n++;
    if (categoryId != null) n++;
    return n;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! ProductFilter) return false;
    if (brands.length != other.brands.length || !brands.containsAll(other.brands)) return false;
    return query == other.query &&
        categoryId == other.categoryId &&
        subcategory == other.subcategory &&
        minPrice == other.minPrice &&
        maxPrice == other.maxPrice &&
        minRating == other.minRating &&
        onlyDiscount == other.onlyDiscount &&
        onlyInStock == other.onlyInStock &&
        tag == other.tag &&
        sort == other.sort;
  }

  @override
  int get hashCode => Object.hash(
        query,
        categoryId,
        subcategory,
        Object.hashAllUnordered(brands),
        minPrice,
        maxPrice,
        minRating,
        onlyDiscount,
        onlyInStock,
        tag,
        sort,
      );

  ProductFilter copyWith({
    String? query,
    String? categoryId,
    bool clearCategory = false,
    String? subcategory,
    bool clearSubcategory = false,
    Set<String>? brands,
    int? minPrice,
    int? maxPrice,
    bool clearPrice = false,
    double? minRating,
    bool clearRating = false,
    bool? onlyDiscount,
    bool? onlyInStock,
    String? tag,
    SortOption? sort,
  }) =>
      ProductFilter(
        query: query ?? this.query,
        categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
        subcategory: clearSubcategory ? null : (subcategory ?? this.subcategory),
        brands: brands ?? this.brands,
        minPrice: clearPrice ? null : (minPrice ?? this.minPrice),
        maxPrice: clearPrice ? null : (maxPrice ?? this.maxPrice),
        minRating: clearRating ? null : (minRating ?? this.minRating),
        onlyDiscount: onlyDiscount ?? this.onlyDiscount,
        onlyInStock: onlyInStock ?? this.onlyInStock,
        tag: tag ?? this.tag,
        sort: sort ?? this.sort,
      );
}

/// Mahsulotlar repozitoriysi (abstrakt interfeys).
/// Backend ulanganda [RemoteProductRepository] yaratib, providerni almashtiring.
abstract class ProductRepository {
  Future<List<Product>> getAll();
  Future<Product?> getById(String id);
  Future<List<Product>> getByCategory(String categoryId);
  Future<List<Product>> getByTag(String tag, {int limit = 10});
  Future<List<Product>> search(ProductFilter filter);
  Future<List<Review>> getReviews(String productId);
  Future<List<String>> getBrands({String? categoryId});
  Future<List<String>> getPopularSearches();
}

/// Demo (lokal) implementatsiya.
class DemoProductRepository implements ProductRepository {
  /// Real tarmoq kechikishini taqlid qilish (loading holatlarini ko'rsatish uchun).
  static const _latency = Duration(milliseconds: 350);

  @override
  Future<List<Product>> getAll() async {
    await Future<void>.delayed(_latency);
    return DemoProducts.all;
  }

  @override
  Future<Product?> getById(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return DemoProducts.byId(id);
  }

  @override
  Future<List<Product>> getByCategory(String categoryId) async {
    await Future<void>.delayed(_latency);
    return DemoProducts.all.where((p) => p.categoryId == categoryId).toList();
  }

  @override
  Future<List<Product>> getByTag(String tag, {int limit = 10}) async {
    await Future<void>.delayed(_latency);
    final list = DemoProducts.all.where((p) => p.tags.contains(tag)).toList();
    if (tag == 'new') {
      list.sort((a, b) => (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    } else if (tag == 'bestseller') {
      list.sort((a, b) => b.soldCount.compareTo(a.soldCount));
    } else if (tag == 'sale') {
      list.sort((a, b) => b.discountPercent.compareTo(a.discountPercent));
    }
    return list.take(limit).toList();
  }

  @override
  Future<List<Product>> search(ProductFilter f) async {
    await Future<void>.delayed(_latency);
    final q = _normalize(f.query);
    final tokens = q.split(' ').where((t) => t.isNotEmpty).toList();

    Iterable<Product> list = DemoProducts.all;

    if (f.categoryId != null) list = list.where((p) => p.categoryId == f.categoryId);
    if (f.subcategory != null) list = list.where((p) => p.subcategory == f.subcategory);
    if (f.tag != null) list = list.where((p) => p.tags.contains(f.tag));
    if (f.brands.isNotEmpty) list = list.where((p) => f.brands.contains(p.brand));
    if (f.minPrice != null) list = list.where((p) => p.price >= f.minPrice!);
    if (f.maxPrice != null) list = list.where((p) => p.price <= f.maxPrice!);
    if (f.minRating != null) list = list.where((p) => p.rating >= f.minRating!);
    if (f.onlyDiscount) list = list.where((p) => p.hasDiscount);
    if (f.onlyInStock) list = list.where((p) => p.inStock);

    if (tokens.isNotEmpty) {
      final scored = <MapEntry<Product, int>>[];
      for (final p in list) {
        final score = _score(p, tokens);
        if (score > 0) scored.add(MapEntry(p, score));
      }
      if (f.sort == SortOption.popular) {
        scored.sort((a, b) {
          final c = b.value.compareTo(a.value);
          return c != 0 ? c : b.key.soldCount.compareTo(a.key.soldCount);
        });
        return scored.map((e) => e.key).toList();
      }
      list = scored.map((e) => e.key);
    }

    final result = list.toList();
    switch (f.sort) {
      case SortOption.popular:
        result.sort((a, b) => b.soldCount.compareTo(a.soldCount));
      case SortOption.priceAsc:
        result.sort((a, b) => a.price.compareTo(b.price));
      case SortOption.priceDesc:
        result.sort((a, b) => b.price.compareTo(a.price));
      case SortOption.rating:
        result.sort((a, b) {
          final c = b.rating.compareTo(a.rating);
          return c != 0 ? c : b.reviewCount.compareTo(a.reviewCount);
        });
      case SortOption.newest:
        result.sort((a, b) =>
            (b.createdAt ?? DateTime(0)).compareTo(a.createdAt ?? DateTime(0)));
    }
    return result;
  }

  @override
  Future<List<Review>> getReviews(String productId) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final p = DemoProducts.byId(productId);
    return DemoReviews.forProduct(productId, rating: p?.rating ?? 4.5);
  }

  @override
  Future<List<String>> getBrands({String? categoryId}) async {
    final set = <String>{};
    for (final p in DemoProducts.all) {
      if (categoryId == null || p.categoryId == categoryId) set.add(p.brand);
    }
    final l = set.toList()..sort();
    return l;
  }

  @override
  Future<List<String>> getPopularSearches() async => const [
        'iPhone', 'Krossovka', 'Televizor', 'Atir', 'Olma', 'Blender',
        'Erkaklar kiyimi', 'Quloqchin', 'Noutbuk', 'Kofe',
      ];

  // ---------- Qidiruv yordamchilari ----------

  /// O'zbekcha apostrof/qo'shtirnoqlarni va katta-kichik harflarni normallashtiradi.
  static String _normalize(String s) => s
      .toLowerCase()
      .replaceAll(RegExp("[ʻʼ'`’‘]"), '')
      .replaceAll(RegExp(r'[^a-z0-9а-яёўқғҳ\s]'), ' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();

  /// Sinonimlar: foydalanuvchi yozgan so'zni mahsulot matnidagi so'zlarga bog'laydi.
  static const Map<String, List<String>> _synonyms = {
    'telefon': ['iphone', 'samsung galaxy', 'redmi', 'telefonlar', 'smartfon'],
    'smartfon': ['iphone', 'galaxy', 'redmi', 'telefonlar'],
    'ayfon': ['iphone'],
    'noutbuk': ['macbook', 'vivobook', 'noutbuklar', 'laptop'],
    'kompyuter': ['macbook', 'vivobook', 'noutbuklar'],
    'televizor': ['tv', 'televizorlar'],
    'quloqchin': ['airpods', 'quloqchinlar', 'headphones'],
    'naushnik': ['airpods', 'quloqchinlar'],
    'soat': ['watch'],
    'erkaklar': ['erkaklar kiyimi'],
    'ayollar': ['ayollar kiyimi'],
    'kiyim': ['futbolka', 'shim', 'koylak', 'hoodie', 'kostyum', 'kiyimi'],
    'krossovka': ['krossovka', 'krossovkalar', 'air max', 'ultraboost'],
    'oyoq': ['krossovka', 'tufli', 'etik'],
    'atir': ['edt', 'edp', 'parfyumeriya', 'atiri'],
    'parfyum': ['edt', 'edp', 'parfyumeriya'],
    'kosmetika': ['tonal', 'krem', 'kosmetika'],
    'meva': ['olma', 'banan', 'meva'],
    'sabzavot': ['pomidor', 'sabzavotlar'],
    'ichimlik': ['cola', 'suv', 'ichimliklar'],
    'suv': ['suv', 'pure life'],
    'changyutgich': ['dyson v15', 'changyutgich'],
    'kir': ['kir yuvish', 'ariel'],
    'mashina': ['kir yuvish mashinasi', 'avtomobil'],
    'avto': ['avtomobil', 'videoregistrator', 'dash cam', 'orindiq'],
    'bola': ['bolalar', 'lego', 'pampers', 'samokat'],
    'bolalar': ['bolalar', 'lego', 'pampers', 'samokat'],
    'sport': ['yoga', 'gantel', 'futbol', 'sport'],
    'kitob': ['odatlar', 'kitob'],
    'divan': ['divan'],
    'mebel': ['divan', 'matras'],
    'oshxona': ['qozon', 'tova', 'blender', 'choy', 'oshxona'],
    'kofe': ['kofe', 'lavazza'],
    'shokolad': ['ferrero', 'shokolad'],
    'kamera': ['videoregistrator', 'kamera'],
    'drel': ['drel', 'shurupovert'],
  };

  static int _score(Product p, List<String> tokens) {
    final name = _normalize(p.name);
    final brand = _normalize(p.brand);
    final sub = _normalize(p.subcategory);
    final desc = _normalize(p.description);
    final cat = _normalize(p.categoryId);
    var total = 0;
    for (final t in tokens) {
      var s = 0;
      if (name.contains(t)) s += 10;
      if (brand.contains(t)) s += 8;
      if (sub.contains(t)) s += 6;
      if (cat.contains(t)) s += 4;
      if (desc.contains(t)) s += 2;
      // Sinonimlar (prefiks orqali: "telefonlar" -> "telefon")
      for (final entry in _synonyms.entries) {
        if (t.startsWith(entry.key) || (entry.key.startsWith(t) && t.length >= 4)) {
          for (final syn in entry.value) {
            final n = _normalize(syn);
            if (name.contains(n) || sub.contains(n) || brand.contains(n) || desc.contains(n)) {
              s += 5;
              break;
            }
          }
        }
      }
      if (s == 0) return 0; // har bir so'z mos kelishi shart
      total += s;
    }
    return total;
  }
}
