import '../models/review.dart';

/// Demo sharhlar. Har bir mahsulot uchun deterministik tarzda 3–5 ta sharh hosil qilinadi.
class DemoReviews {
  DemoReviews._();

  static const _names = [
    'Aziz T.', 'Malika R.', 'Jasur K.', 'Nilufar S.', 'Bobur M.', 'Dilnoza A.',
    'Sardor Y.', 'Gulnora H.', 'Otabek N.', 'Zarina Q.', 'Sherzod B.', 'Kamola I.',
  ];

  static const _comments = [
    "Sifati juda yaxshi, tavsiya qilaman. Yetkazib berish ham tez bo'ldi.",
    "Kutganimdan ham yaxshi chiqdi. Narxiga arziydi!",
    "Mahsulot rasmdagidek. Qadoqlash zo'r, hech qanday shikast yo'q.",
    "Yaxshi, lekin yetkazib berish biroz kechikdi. Umuman olganda mamnunman.",
    "Ikkinchi marta olyapman, oilam ham juda yoqtirdi.",
    "Narxi va sifati mos. Sotuvchi bilan aloqa yaxshi edi.",
    "Ajoyib! Do'stlarimga ham tavsiya qildim.",
    "O'rtacha. Ishlaydi, lekin kutganimdek premium emas.",
  ];

  static List<Review> forProduct(String productId, {double rating = 4.7}) {
    final seed = productId.codeUnits.fold<int>(0, (a, b) => a + b);
    final count = 3 + seed % 3;
    return List.generate(count, (i) {
      final r = (rating >= 4.7 ? 5 : 4) - ((seed + i) % 3 == 0 ? 1 : 0);
      return Review(
        id: '$productId-r$i',
        productId: productId,
        userName: _names[(seed + i * 7) % _names.length],
        rating: r.clamp(3, 5),
        comment: _comments[(seed + i * 3) % _comments.length],
        createdAt: DateTime(2026, 9, 19).subtract(Duration(days: 2 + i * 9 + seed % 5)),
      );
    });
  }
}
