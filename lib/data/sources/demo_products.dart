import '../models/product.dart';

/// Demo mahsulotlar (52 ta). Rasmlar `assets/images/products/` ichida.
/// Backend ulanganda [ProductRepository] shu ro'yxat o'rniga API dan oladi.
class DemoProducts {
  DemoProducts._();

  static const String _img = 'assets/images/products';

  static Product _p({
    required String id,
    required String name,
    required String cat,
    required String sub,
    required String brand,
    required int price,
    int? oldPrice,
    required double rating,
    required int reviews,
    required int sold,
    required String img,
    required String desc,
    required Map<String, String> specs,
    int stock = 25,
    required String seller,
    List<String> tags = const [],
    int daysAgo = 30,
  }) =>
      Product(
        id: id,
        name: name,
        categoryId: cat,
        subcategory: sub,
        brand: brand,
        price: price,
        oldPrice: oldPrice,
        rating: rating,
        reviewCount: reviews,
        soldCount: sold,
        images: ['$_img/$img.jpg'],
        description: desc,
        specs: specs,
        stock: stock,
        sellerName: seller,
        tags: tags,
        createdAt: DateTime(2026, 9, 19).subtract(Duration(days: daysAgo)),
      );

  static final List<Product> all = [
    // ================= ELEKTRONIKA =================
    _p(
      id: 'p001', name: 'iPhone 16 Pro 256GB, Natural Titanium', cat: 'electronics', sub: 'Telefonlar', brand: 'Apple',
      price: 15990000, oldPrice: 17490000, rating: 4.9, reviews: 1284, sold: 5320, img: 'iphone',
      desc: 'A18 Pro chip, 6.3" Super Retina XDR ProMotion displey, 48MP asosiy kamera va titan korpus. Apple Intelligence funksiyalari bilan.',
      specs: {'Displey': '6.3" OLED, 120Hz', 'Xotira': '256 GB', 'Protsessor': 'A18 Pro', 'Kamera': '48+48+12 MP', 'Batareya': '3582 mAh', 'Kafolat': '1 yil'},
      seller: 'iStore Uzbekistan', tags: ['popular', 'bestseller'], daysAgo: 60, stock: 14,
    ),
    _p(
      id: 'p002', name: 'Samsung Galaxy S25 Ultra 12/256GB, Titanium Black', cat: 'electronics', sub: 'Telefonlar', brand: 'Samsung',
      price: 14490000, oldPrice: 16290000, rating: 4.8, reviews: 942, sold: 3810, img: 'samsung',
      desc: '200MP kamera, S Pen, Snapdragon 8 Elite for Galaxy va 6.9" Dynamic AMOLED 2X displey. Galaxy AI bilan.',
      specs: {'Displey': '6.9" AMOLED, 120Hz', 'Xotira': '12/256 GB', 'Protsessor': 'Snapdragon 8 Elite', 'Kamera': '200 MP', 'Batareya': '5000 mAh', 'Kafolat': '1 yil'},
      seller: 'Samsung Brand Store', tags: ['popular', 'bestseller'], daysAgo: 45, stock: 20,
    ),
    _p(
      id: 'p003', name: 'Xiaomi Redmi Note 14 Pro 8/256GB, Midnight Black', cat: 'electronics', sub: 'Telefonlar', brand: 'Xiaomi',
      price: 3690000, oldPrice: 4290000, rating: 4.7, reviews: 2210, sold: 12400, img: 'xiaomi',
      desc: '200MP kamera, 6.67" AMOLED 120Hz displey, 5110 mAh batareya va 45W tez quvvatlash. Narx-sifat jihatidan eng yaxshi tanlov.',
      specs: {'Displey': '6.67" AMOLED', 'Xotira': '8/256 GB', 'Protsessor': 'Helio G100 Ultra', 'Kamera': '200 MP', 'Batareya': '5110 mAh'},
      seller: 'Mi Store Tashkent', tags: ['popular', 'bestseller', 'sale'], daysAgo: 20, stock: 60,
    ),
    _p(
      id: 'p004', name: 'MacBook Air 13" M4 16/256GB, Midnight', cat: 'electronics', sub: 'Noutbuklar', brand: 'Apple',
      price: 15290000, oldPrice: 16990000, rating: 4.9, reviews: 512, sold: 1650, img: 'macbook',
      desc: 'M4 chip, 13.6" Liquid Retina displey, 18 soatgacha batareya. Yupqa, yengil va shovqinsiz.',
      specs: {'Displey': '13.6" Liquid Retina', 'Protsessor': 'Apple M4', 'RAM': '16 GB', 'SSD': '256 GB', "Og'irlik": '1.24 kg'},
      seller: 'iStore Uzbekistan', tags: ['popular', 'new'], daysAgo: 10, stock: 9,
    ),
    _p(
      id: 'p005', name: 'ASUS Vivobook 15 i5-1335U 16/512GB', cat: 'electronics', sub: 'Noutbuklar', brand: 'ASUS',
      price: 7490000, oldPrice: 8290000, rating: 4.6, reviews: 388, sold: 2100, img: 'asus_laptop',
      desc: "O'qish va ish uchun ideal: 15.6\" Full HD displey, 13-avlod Intel Core i5, 16GB RAM va 512GB SSD.",
      specs: {'Displey': '15.6" FHD IPS', 'Protsessor': 'Intel Core i5-1335U', 'RAM': '16 GB', 'SSD': '512 GB', 'OS': 'Windows 11'},
      seller: 'Texnomart', tags: ['sale'], daysAgo: 70, stock: 30,
    ),
    _p(
      id: 'p006', name: 'AirPods Pro 2 (USB-C)', cat: 'electronics', sub: 'Quloqchinlar', brand: 'Apple',
      price: 2890000, oldPrice: 3290000, rating: 4.8, reviews: 1730, sold: 8900, img: 'airpods',
      desc: 'Faol shovqin bostirish, Adaptiv audio, H2 chip. 30 soatgacha umumiy quvvat.',
      specs: {'Turi': 'TWS', 'Shovqin bostirish': 'ANC', 'Batareya': '6+24 soat', 'Ulanish': 'Bluetooth 5.3', 'Suvdan himoya': 'IP54'},
      seller: 'iStore Uzbekistan', tags: ['popular', 'bestseller'], daysAgo: 90, stock: 45,
    ),
    _p(
      id: 'p007', name: 'Sony WH-1000XM5 simsiz quloqchin, qora', cat: 'electronics', sub: 'Quloqchinlar', brand: 'Sony',
      price: 4190000, oldPrice: 4990000, rating: 4.9, reviews: 655, sold: 2300, img: 'sony_headphones',
      desc: 'Sanoatdagi eng yaxshi shovqin bostirish, 30 soat batareya, Hi-Res Audio va juda qulay dizayn.',
      specs: {'Turi': 'Ustki', 'Shovqin bostirish': 'ANC', 'Batareya': '30 soat', 'Ulanish': 'Bluetooth 5.2, 3.5mm', "Og'irlik": '250 g'},
      seller: 'Sony Center', tags: ['popular'], daysAgo: 120, stock: 12,
    ),
    _p(
      id: 'p008', name: 'Samsung 55" Crystal UHD 4K Smart TV (2025)', cat: 'electronics', sub: 'Televizorlar', brand: 'Samsung',
      price: 6790000, oldPrice: 7990000, rating: 4.7, reviews: 421, sold: 1900, img: 'samsung_tv',
      desc: '4K Crystal protsessor, HDR, Tizen OS, Netflix, YouTube va boshqa ilovalar. Yupqa ramka dizayni.',
      specs: {'Diagonal': '55"', 'Ruxsat': '3840x2160', 'OS': 'Tizen', 'HDMI': '3 ta', 'Wi-Fi': 'Bor'},
      seller: 'Samsung Brand Store', tags: ['sale', 'bestseller'], daysAgo: 40, stock: 18,
    ),
    _p(
      id: 'p009', name: 'Xiaomi TV A Pro 43" 4K Google TV', cat: 'electronics', sub: 'Televizorlar', brand: 'Xiaomi',
      price: 3490000, oldPrice: 3990000, rating: 4.6, reviews: 809, sold: 4100, img: 'xiaomi_tv',
      desc: 'Google TV, Dolby Vision, 4K UHD, Chromecast built-in. Har qanday xona uchun mos.',
      specs: {'Diagonal': '43"', 'Ruxsat': '4K UHD', 'OS': 'Google TV', 'HDMI': '3 ta', 'Ovoz': '2x10W Dolby Audio'},
      seller: 'Mi Store Tashkent', tags: ['sale'], daysAgo: 25, stock: 35,
    ),
    _p(
      id: 'p010', name: 'Apple Watch Series 10 GPS 42mm', cat: 'electronics', sub: 'Aksessuarlar', brand: 'Apple',
      price: 5490000, rating: 4.8, reviews: 290, sold: 1200, img: 'apple_watch',
      desc: "Eng yupqa Apple Watch, kattaroq displey, uyqu apnoe bildirishnomalari va tezkor quvvatlash.",
      specs: {'Displey': '42mm Retina LTPO3', 'Suvdan himoya': '50m', 'Batareya': '18 soat', 'Chip': 'S10'},
      seller: 'iStore Uzbekistan', tags: ['new'], daysAgo: 5, stock: 22,
    ),
    _p(
      id: 'p011', name: 'Anker PowerCore 20000mAh 22.5W powerbank', cat: 'electronics', sub: 'Aksessuarlar', brand: 'Anker',
      price: 389000, oldPrice: 459000, rating: 4.7, reviews: 1120, sold: 9800, img: 'powerbank',
      desc: 'Ikki qurilmani bir vaqtda quvvatlash, 22.5W tez quvvatlash, ixcham dizayn.',
      specs: {"Sig'im": '20000 mAh', 'Quvvat': '22.5W', 'Portlar': 'USB-A x2, USB-C', "Og'irlik": '343 g'},
      seller: 'GadgetHub', tags: ['bestseller', 'sale'], daysAgo: 150, stock: 120,
    ),
    _p(
      id: 'p012', name: 'Logitech MX Master 3S simsiz sichqoncha', cat: 'electronics', sub: 'Aksessuarlar', brand: 'Logitech',
      price: 1190000, rating: 4.9, reviews: 233, sold: 870, img: 'logitech_mouse',
      desc: "Ergonomik dizayn, 8000 DPI sensor, jim tugmalar va MagSpeed g'ildirak. Bir zaryadda 70 kun.",
      specs: {'Sensor': '8000 DPI', 'Ulanish': 'Bluetooth, Logi Bolt', 'Batareya': '70 kun', 'Tugmalar': '7 ta'},
      seller: 'Texnomart', tags: ['popular'], daysAgo: 200, stock: 40,
    ),

    // ================= MAISHIY TEXNIKA =================
    _p(
      id: 'p013', name: 'Dyson V15 Detect simsiz changyutgich', cat: 'appliances', sub: 'Uy tozalash', brand: 'Dyson',
      price: 8990000, oldPrice: 9990000, rating: 4.8, reviews: 178, sold: 640, img: 'dyson_vacuum',
      desc: "Lazer bilan changni ko'rsatadi, 60 daqiqagacha ishlaydi, HEPA filtr. Gilam va qattiq pol uchun.",
      specs: {'Turi': 'Vertikal, simsiz', 'Ish vaqti': '60 daqiqa', 'Filtr': 'HEPA', "Sig'im": '0.77 l', 'Kafolat': '2 yil'},
      seller: 'Dyson Official', tags: ['popular'], daysAgo: 35, stock: 8,
    ),
    _p(
      id: 'p014', name: 'Philips HR3652 blender 1400W, 2L', cat: 'appliances', sub: 'Oshxona texnikasi', brand: 'Philips',
      price: 1290000, oldPrice: 1590000, rating: 4.7, reviews: 502, sold: 3200, img: 'blender',
      desc: 'ProBlend 6 3D texnologiyasi, muz maydalash rejimi, 2 litr shisha idish. Smuzi va sharbatlar uchun.',
      specs: {'Quvvat': '1400W', "Sig'im": '2 l', 'Tezliklar': '5 + turbo', 'Material': 'Shisha idish'},
      seller: 'Texnomart', tags: ['sale', 'bestseller'], daysAgo: 80, stock: 50,
    ),
    _p(
      id: 'p015', name: 'Artel 35L mikroto\'lqinli pech, kumush', cat: 'appliances', sub: 'Oshxona texnikasi', brand: 'Artel',
      price: 1190000, oldPrice: 1390000, rating: 4.5, reviews: 640, sold: 4500, img: 'microwave',
      desc: "35 litr hajm, gril funksiyasi, 10 ta avtomatik dastur. O'zbekistonda ishlab chiqarilgan.",
      specs: {'Hajm': '35 l', 'Quvvat': '1000W', 'Gril': 'Bor', 'Boshqaruv': 'Sensorli'},
      seller: 'Artel Official', tags: ['sale'], daysAgo: 100, stock: 70,
    ),
    _p(
      id: 'p016', name: 'Samsung 8kg kir yuvish mashinasi, AI Ecobubble', cat: 'appliances', sub: 'Uy tozalash', brand: 'Samsung',
      price: 6490000, oldPrice: 7290000, rating: 4.7, reviews: 315, sold: 1350, img: 'washing_machine',
      desc: "Ecobubble texnologiyasi sovuq suvda ham samarali yuvadi. Inverter motor, 20 yil kafolat. Bug' bilan tozalash.",
      specs: {'Yuklash': '8 kg', 'Aylanish': '1400 ayl/min', 'Energiya': 'A+++', 'Motor': 'Digital Inverter'},
      seller: 'Samsung Brand Store', tags: ['popular'], daysAgo: 60, stock: 15,
    ),
    _p(
      id: 'p017', name: 'Tefal Easy Fry Grill XXL havo fritezasi 6.5L', cat: 'appliances', sub: 'Oshxona texnikasi', brand: 'Tefal',
      price: 1890000, oldPrice: 2290000, rating: 4.8, reviews: 267, sold: 1800, img: 'airfryer',
      desc: "Yog'siz pishirish, 6.5 litr hajm — butun oila uchun. 8 ta avtomatik dastur va gril plastina.",
      specs: {'Hajm': '6.5 l', 'Quvvat': '1830W', 'Dasturlar': '8 ta', 'Harorat': '80–200°C'},
      seller: 'Texnomart', tags: ['new', 'sale'], daysAgo: 8, stock: 28,
    ),

    // ================= KIYIM =================
    _p(
      id: 'p018', name: "Erkaklar uchun oversize paxta futbolka, oq", cat: 'clothing', sub: 'Erkaklar kiyimi', brand: 'Basic Line',
      price: 89000, oldPrice: 129000, rating: 4.6, reviews: 1890, sold: 15600, img: 'tshirt',
      desc: '100% paxta, 220 g/m² zich mato. Oversize kesim, yuvilgandan keyin shakl saqlaydi.',
      specs: {'Material': '100% paxta', "O'lchamlar": 'S–XXL', 'Rang': 'Oq', 'Kesim': 'Oversize', 'Ishlab chiqaruvchi': "O'zbekiston"},
      seller: 'Basic Line UZ', tags: ['bestseller', 'sale', 'popular'], daysAgo: 30, stock: 300,
    ),
    _p(
      id: 'p019', name: "Erkaklar uchun slim fit jinsi shim, to'q ko'k", cat: 'clothing', sub: 'Erkaklar kiyimi', brand: 'Denim&Co',
      price: 249000, oldPrice: 329000, rating: 4.5, reviews: 720, sold: 4300, img: 'jeans',
      desc: "Cho'ziluvchan denim, slim fit kesim, 5 ta cho'ntak. Kundalik va rasmiy uslubga mos.",
      specs: {'Material': '98% paxta, 2% elastan', "O'lchamlar": '29–36', 'Rang': "To'q ko'k", 'Kesim': 'Slim'},
      seller: 'Denim&Co', tags: ['sale'], daysAgo: 50, stock: 140,
    ),
    _p(
      id: 'p020', name: "Ayollar uchun yozgi gulli ko'ylak, midi", cat: 'clothing', sub: 'Ayollar kiyimi', brand: 'Flora',
      price: 199000, oldPrice: 279000, rating: 4.7, reviews: 540, sold: 2900, img: 'dress',
      desc: "Yengil viskoza mato, midi uzunlik, gulli naqsh. Yoz kunlari uchun qulay va chiroyli.",
      specs: {'Material': '100% viskoza', "O'lchamlar": 'XS–XL', 'Uzunlik': 'Midi', 'Fasl': 'Yoz'},
      seller: 'Flora Boutique', tags: ['popular', 'sale'], daysAgo: 15, stock: 85,
    ),
    _p(
      id: 'p021', name: "Erkaklar uchun issiq hoodie, kulrang", cat: 'clothing', sub: 'Erkaklar kiyimi', brand: 'Urban Wear',
      price: 179000, oldPrice: 239000, rating: 4.6, reviews: 980, sold: 6700, img: 'hoodie',
      desc: "Ichki tomoni momiqli, kanguru cho'ntak, kapyushon. Kuz-qish mavsumi uchun ideal.",
      specs: {'Material': '80% paxta, 20% polyester', "O'lchamlar": 'S–3XL', 'Rang': 'Kulrang'},
      seller: 'Urban Wear', tags: ['new'], daysAgo: 4, stock: 220,
    ),
    _p(
      id: 'p022', name: "Bolalar uchun sport kostyum, 3-8 yosh", cat: 'clothing', sub: 'Bolalar kiyimi', brand: 'KidsJoy',
      price: 159000, oldPrice: 199000, rating: 4.8, reviews: 410, sold: 2200, img: 'kids_tracksuit',
      desc: "Yumshoq futer mato, elastik bel, chidamli tikuv. Faol bolalar uchun.",
      specs: {'Material': 'Futer (paxta)', "O'lchamlar": '98–128', 'Yosh': '3–8'},
      seller: 'KidsJoy', tags: ['sale'], daysAgo: 22, stock: 95,
    ),

    // ================= OYOQ KIYIM =================
    _p(
      id: 'p023', name: 'Nike Air Max 270 krossovka, qora/oq', cat: 'shoes', sub: 'Krossovkalar', brand: 'Nike',
      price: 1590000, oldPrice: 1890000, rating: 4.8, reviews: 860, sold: 3900, img: 'nike_sneakers',
      desc: "Katta Air yostiqchasi, nafas oluvchi mesh yuza. Kundalik va sport uchun.",
      specs: {"O'lchamlar": '39–45', 'Yuqori qism': 'Mesh/sintetika', 'Taglik': 'Rezina + Air', 'Rang': 'Qora/oq'},
      seller: 'SportMaster UZ', tags: ['popular', 'bestseller'], daysAgo: 40, stock: 60,
    ),
    _p(
      id: 'p024', name: 'Adidas Ultraboost Light yugurish krossovkasi', cat: 'shoes', sub: 'Krossovkalar', brand: 'Adidas',
      price: 1790000, rating: 4.7, reviews: 342, sold: 1400, img: 'adidas_running',
      desc: "Eng yengil Boost taglik, Primeknit yuza. Uzoq masofaga yugurish uchun.",
      specs: {"O'lchamlar": '38–46', 'Taglik': 'Boost Light', "Og'irlik": '299 g', 'Rang': 'Oq'},
      seller: 'SportMaster UZ', tags: ['new'], daysAgo: 6, stock: 34,
    ),
    _p(
      id: 'p025', name: "Erkaklar uchun klassik charm tufli, qora", cat: 'shoes', sub: 'Tuflilar', brand: 'Bruno',
      price: 549000, oldPrice: 699000, rating: 4.5, reviews: 210, sold: 980, img: 'leather_shoes',
      desc: "Tabiiy charm, qulay ichki taglik, rasmiy uchrashuvlar uchun.",
      specs: {"O'lchamlar": '39–45', 'Material': 'Tabiiy charm', 'Rang': 'Qora'},
      seller: 'Bruno Shoes', tags: ['sale'], daysAgo: 75, stock: 42,
    ),
    _p(
      id: 'p026', name: "Ayollar uchun qishki etik, jigarrang", cat: 'shoes', sub: 'Etiklar', brand: 'Vera',
      price: 689000, oldPrice: 890000, rating: 4.6, reviews: 175, sold: 760, img: 'women_boots',
      desc: "Tabiiy jun bilan isitilgan, sirpanmaydigan taglik, suv o'tkazmaydigan charm.",
      specs: {"O'lchamlar": '36–41', 'Material': 'Charm, jun', 'Fasl': 'Qish'},
      seller: 'Vera Shoes', tags: ['sale'], daysAgo: 12, stock: 38,
    ),

    // ================= GO'ZALLIK =================
    _p(
      id: 'p027', name: 'Dior Sauvage EDT 100ml erkaklar atiri', cat: 'beauty', sub: 'Parfyumeriya', brand: 'Dior',
      price: 1890000, oldPrice: 2190000, rating: 4.9, reviews: 675, sold: 2800, img: 'dior_sauvage',
      desc: "Bergamot, qalampir va ambroxan notalari. Yorqin va erkakcha hid, 8 soatdan ortiq turadi.",
      specs: {'Hajm': '100 ml', 'Turi': 'Eau de Toilette', 'Hid oilasi': 'Fougère', 'Original': 'Ha'},
      seller: 'Parfum Gallery', tags: ['popular', 'bestseller'], daysAgo: 90, stock: 25,
    ),
    _p(
      id: 'p028', name: 'Chanel Coco Mademoiselle EDP 50ml', cat: 'beauty', sub: 'Parfyumeriya', brand: 'Chanel',
      price: 2290000, rating: 4.9, reviews: 388, sold: 1500, img: 'chanel_perfume',
      desc: "Apelsin, jasmin va pachuli notalari. Nafis va zamonaviy ayollar hidi.",
      specs: {'Hajm': '50 ml', 'Turi': 'Eau de Parfum', 'Hid oilasi': 'Sharqona-gulli', 'Original': 'Ha'},
      seller: 'Parfum Gallery', tags: ['popular'], daysAgo: 110, stock: 16,
    ),
    _p(
      id: 'p029', name: "Maybelline Fit Me tonal krem 30ml, 220", cat: 'beauty', sub: 'Kosmetika', brand: 'Maybelline',
      price: 129000, oldPrice: 159000, rating: 4.6, reviews: 1450, sold: 9200, img: 'foundation',
      desc: "Mat effekt, teshiklarni yashiradi, SPF 18. Normal va yog'li teri uchun.",
      specs: {'Hajm': '30 ml', 'Effekt': 'Mat', 'SPF': '18', 'Teri turi': "Normal/yog'li"},
      seller: 'Beauty House', tags: ['bestseller', 'sale'], daysAgo: 55, stock: 200,
    ),
    _p(
      id: 'p030', name: "CeraVe namlovchi yuz kremi 52ml", cat: 'beauty', sub: 'Teri parvarishi', brand: 'CeraVe',
      price: 189000, rating: 4.8, reviews: 880, sold: 5400, img: 'cerave_cream',
      desc: "3 ta muhim seramid va gialuron kislotasi. Dermatologlar tavsiya etadi, hidsiz.",
      specs: {'Hajm': '52 ml', 'Teri turi': 'Barcha turlar', 'Tarkib': 'Seramidlar, gialuron'},
      seller: 'Beauty House', tags: ['popular'], daysAgo: 30, stock: 150,
    ),
    _p(
      id: 'p031', name: 'Dyson Airwrap Complete Long soch stayleri', cat: 'beauty', sub: 'Soch parvarishi', brand: 'Dyson',
      price: 7490000, oldPrice: 8290000, rating: 4.8, reviews: 140, sold: 420, img: 'dyson_airwrap',
      desc: "Coanda effekti bilan sochni issiqlik shikastlamasdan turmaklaydi. 6 ta nasadka.",
      specs: {'Quvvat': '1300W', 'Nasadkalar': '6 ta', 'Uzun soch uchun': 'Ha', 'Kafolat': '2 yil'},
      seller: 'Dyson Official', tags: ['new'], daysAgo: 9, stock: 6,
    ),

    // ================= UY UCHUN =================
    _p(
      id: 'p032', name: "Skandinav uslubidagi divan, 3 o'rinli, kulrang", cat: 'home', sub: 'Uy jihozlari', brand: 'HomeLux',
      price: 4990000, oldPrice: 5990000, rating: 4.7, reviews: 96, sold: 310, img: 'sofa',
      desc: "Mustahkam yog'och karkas, yuqori sifatli mato, olinadigan yostiqlar. Yig'ish oson.",
      specs: {"O'lcham": '210x88x85 sm', 'Material': 'Mato, yog\'och', 'Rang': 'Kulrang', 'Yetkazish': 'Bepul'},
      seller: 'HomeLux Mebel', tags: ['sale'], daysAgo: 65, stock: 7,
    ),
    _p(
      id: 'p033', name: "Tefal Ingenio 10 qismli qozon-tova to'plami", cat: 'home', sub: 'Oshxona buyumlari', brand: 'Tefal',
      price: 1690000, oldPrice: 2090000, rating: 4.8, reviews: 233, sold: 1100, img: 'cookware_set',
      desc: "Olinadigan dastak, barcha plita turlariga mos, titanium yopishmas qoplama.",
      specs: {'Qismlar': '10 ta', 'Qoplama': 'Titanium Excellence', 'Induksiya': 'Ha'},
      seller: 'Texnomart', tags: ['popular', 'sale'], daysAgo: 45, stock: 24,
    ),
    _p(
      id: 'p034', name: "Bambukdan choy to'plami, 6 kishilik", cat: 'home', sub: 'Oshxona buyumlari', brand: 'Rishtan Ceramics',
      price: 349000, rating: 4.9, reviews: 312, sold: 1900, img: 'tea_set',
      desc: "Rishton ustalari tomonidan qo'lda yasalgan keramika. Milliy naqshlar, sovg'a qutisi bilan.",
      specs: {'Qismlar': 'Choynak + 6 piyola', 'Material': 'Keramika', 'Ishlab chiqaruvchi': "Rishton, O'zbekiston"},
      seller: 'Rishtan Ceramics', tags: ['popular'], daysAgo: 28, stock: 40,
    ),
    _p(
      id: 'p035', name: "Ortopedik matras 160x200, 22 sm", cat: 'home', sub: 'Tekstil', brand: 'SleepWell',
      price: 2490000, oldPrice: 2990000, rating: 4.7, reviews: 188, sold: 720, img: 'mattress',
      desc: "Mustaqil prujinalar, memory foam qatlam, gipoallergen mato. 10 yil kafolat.",
      specs: {"O'lcham": '160x200 sm', 'Balandlik': '22 sm', 'Qattiqlik': "O'rta", 'Kafolat': '10 yil'},
      seller: 'SleepWell', tags: ['sale'], daysAgo: 85, stock: 11,
    ),
    _p(
      id: 'p036', name: "LED stol lampasi, sensorli, 3 rejim", cat: 'home', sub: 'Dekor', brand: 'Lumina',
      price: 159000, oldPrice: 199000, rating: 4.6, reviews: 560, sold: 3600, img: 'desk_lamp',
      desc: "Ko'z uchun xavfsiz LED, 3 ta yorug'lik rejimi, USB quvvatlash, egiluvchan tayanch.",
      specs: {'Quvvat': '8W', 'Rejimlar': '3 ta', 'Quvvatlash': 'USB', 'Rang': 'Oq'},
      seller: 'Lumina Light', tags: ['bestseller', 'sale'], daysAgo: 35, stock: 130,
    ),

    // ================= OZIQ-OVQAT =================
    _p(
      id: 'p037', name: "Olma «Semerenko», 1 kg", cat: 'food', sub: 'Meva va sabzavotlar', brand: 'Fermer bozori',
      price: 14900, oldPrice: 18900, rating: 4.7, reviews: 2300, sold: 48000, img: 'apples',
      desc: "Farg'ona vodiysidan yangi terilgan yashil olma. Shirin-nordon, sersuv.",
      specs: {"Og'irlik": '1 kg', 'Kelib chiqishi': "Farg'ona", 'Saqlash': '+2..+6°C'},
      seller: 'Fermer bozori', tags: ['popular', 'bestseller', 'sale'], daysAgo: 1, stock: 500,
    ),
    _p(
      id: 'p038', name: "Banan, 1 kg", cat: 'food', sub: 'Meva va sabzavotlar', brand: 'Fermer bozori',
      price: 19900, rating: 4.6, reviews: 1800, sold: 39000, img: 'bananas',
      desc: "Ekvador banani, pishgan va shirin. Har kuni yangi partiya.",
      specs: {"Og'irlik": '1 kg', 'Kelib chiqishi': 'Ekvador'},
      seller: 'Fermer bozori', tags: ['bestseller'], daysAgo: 1, stock: 400,
    ),
    _p(
      id: 'p039', name: "Pomidor «Yusupov», 1 kg", cat: 'food', sub: 'Meva va sabzavotlar', brand: 'Fermer bozori',
      price: 12900, oldPrice: 15900, rating: 4.8, reviews: 1500, sold: 27000, img: 'tomatoes',
      desc: "Mashhur Toshkent pomidori — go'shtdor, shirin va xushbo'y. Salat uchun ideal.",
      specs: {"Og'irlik": '1 kg', 'Kelib chiqishi': 'Toshkent viloyati'},
      seller: 'Fermer bozori', tags: ['popular', 'sale'], daysAgo: 1, stock: 350,
    ),
    _p(
      id: 'p040', name: "Coca-Cola 1.5L, 6 dona", cat: 'food', sub: 'Ichimliklar', brand: 'Coca-Cola',
      price: 69000, oldPrice: 78000, rating: 4.8, reviews: 3200, sold: 61000, img: 'cola',
      desc: "Klassik Coca-Cola, 1.5 litr, 6 donalik tejamkor to'plam.",
      specs: {'Hajm': '1.5 l x 6', 'Turi': 'Gazlangan', 'Ishlab chiqaruvchi': "O'zbekiston"},
      seller: 'BozorGo Market', tags: ['bestseller', 'sale'], daysAgo: 3, stock: 900,
    ),
    _p(
      id: 'p041', name: "Nestlé Pure Life suv 0.5L, 12 dona", cat: 'food', sub: 'Ichimliklar', brand: 'Nestlé',
      price: 36000, rating: 4.7, reviews: 990, sold: 22000, img: 'water_bottles',
      desc: "Toza ichimlik suvi, 12 donalik qulay to'plam. Ofis va uy uchun.",
      specs: {'Hajm': '0.5 l x 12', 'Turi': 'Gazsiz'},
      seller: 'BozorGo Market', tags: ['popular'], daysAgo: 3, stock: 700,
    ),
    _p(
      id: 'p042', name: "Lavazza Qualità Oro donali kofe 1kg", cat: 'food', sub: 'Kundalik mahsulotlar', brand: 'Lavazza',
      price: 289000, oldPrice: 339000, rating: 4.9, reviews: 610, sold: 4100, img: 'coffee_beans',
      desc: "100% arabika, o'rta qovurilgan. Gulli va mevali notalar bilan ideal espresso.",
      specs: {"Og'irlik": '1 kg', 'Turi': 'Donali', 'Tarkib': '100% arabika', 'Qovurish': "O'rta"},
      seller: 'Coffee Lab', tags: ['popular', 'sale'], daysAgo: 20, stock: 90,
    ),
    _p(
      id: 'p043', name: "Ferrero Rocher shokolad konfetlari, 300g", cat: 'food', sub: 'Shirinliklar', brand: 'Ferrero',
      price: 149000, oldPrice: 179000, rating: 4.9, reviews: 1230, sold: 8600, img: 'ferrero',
      desc: "24 dona findiqli shokolad konfet. Sovg'a uchun ajoyib tanlov.",
      specs: {"Og'irlik": '300 g', 'Miqdor': '24 dona', 'Kelib chiqishi': 'Italiya'},
      seller: 'BozorGo Market', tags: ['bestseller', 'sale'], daysAgo: 14, stock: 210,
    ),

    // ================= UY-RO'ZG'OR =================
    _p(
      id: 'p044', name: "Ariel Color kir yuvish kukuni 6kg", cat: 'household', sub: 'Kir yuvish', brand: 'Ariel',
      price: 159000, oldPrice: 189000, rating: 4.7, reviews: 1050, sold: 12000, img: 'detergent',
      desc: "Rangli kiyimlar uchun, sovuq suvda ham dog'larni ketkazadi. 40 ta yuvishga yetadi.",
      specs: {"Og'irlik": '6 kg', 'Turi': 'Kukun', 'Yuvishlar': '40'},
      seller: 'BozorGo Market', tags: ['bestseller', 'sale'], daysAgo: 10, stock: 320,
    ),
    _p(
      id: 'p045', name: "Fairy idish yuvish vositasi 900ml, limon", cat: 'household', sub: 'Tozalash vositalari', brand: 'Fairy',
      price: 34900, rating: 4.8, reviews: 2400, sold: 35000, img: 'dish_soap',
      desc: "Bir tomchi — tog'dek idish. Yog'ni oson ketkazadi, qo'lga yumshoq.",
      specs: {'Hajm': '900 ml', 'Hid': 'Limon'},
      seller: 'BozorGo Market', tags: ['popular', 'bestseller'], daysAgo: 7, stock: 600,
    ),

    // ================= AVTO =================
    _p(
      id: 'p046', name: "70mai Dash Cam A500S videoregistrator, GPS", cat: 'auto', sub: 'Elektronika', brand: '70mai',
      price: 890000, oldPrice: 1090000, rating: 4.7, reviews: 430, sold: 2100, img: 'dashcam',
      desc: "2.7K yozuv, GPS, ADAS ogohlantirish, tungi ko'rish. Wi-Fi orqali telefonga ulanadi.",
      specs: {'Ruxsat': '2.7K', 'GPS': 'Bor', "Ko'rish burchagi": '140°', 'Ekran': '2" IPS'},
      seller: 'AutoZone UZ', tags: ['popular', 'sale'], daysAgo: 38, stock: 55,
    ),
    _p(
      id: 'p047', name: "Baseus magnitli telefon tutqichi, avtomobil uchun", cat: 'auto', sub: 'Aksessuarlar', brand: 'Baseus',
      price: 79000, oldPrice: 99000, rating: 4.6, reviews: 1600, sold: 14000, img: 'phone_holder',
      desc: "Kuchli magnit, 360° aylanish, havo panjarasiga o'rnatiladi. Barcha telefonlarga mos.",
      specs: {"O'rnatish": 'Havo panjarasi', 'Aylanish': '360°', 'Material': 'Alyuminiy'},
      seller: 'AutoZone UZ', tags: ['bestseller', 'sale'], daysAgo: 120, stock: 400,
    ),
    _p(
      id: 'p048', name: "Avtomobil o'rindiq qoplamasi, ekocharm, 9 qism", cat: 'auto', sub: 'Aksessuarlar', brand: 'AutoComfort',
      price: 549000, rating: 4.5, reviews: 210, sold: 890, img: 'seat_covers',
      desc: "Universal o'lcham, sifatli ekocharm, o'rnatish oson. Cobalt, Nexia, Gentra va boshqalarga mos.",
      specs: {'Qismlar': '9 ta', 'Material': 'Ekocharm', 'Rang': 'Qora/bej'},
      seller: 'AutoComfort', tags: [], daysAgo: 95, stock: 30,
    ),

    // ================= SPORT =================
    _p(
      id: 'p049', name: "Yoga gilamchasi 6mm, sirpanmaydigan, sumka bilan", cat: 'sport', sub: 'Fitnes', brand: 'FitPro',
      price: 129000, oldPrice: 169000, rating: 4.7, reviews: 870, sold: 6100, img: 'yoga_mat',
      desc: "TPE material, ikki tomonlama, 183x61 sm. Yoga, pilates va fitnes uchun.",
      specs: {"O'lcham": '183x61 sm', 'Qalinlik': '6 mm', 'Material': 'TPE'},
      seller: 'SportMaster UZ', tags: ['bestseller', 'sale'], daysAgo: 42, stock: 180,
    ),
    _p(
      id: 'p050', name: "Sozlanadigan gantellar to'plami 2x20kg", cat: 'sport', sub: 'Fitnes', brand: 'FitPro',
      price: 890000, oldPrice: 1090000, rating: 4.8, reviews: 265, sold: 1200, img: 'dumbbells',
      desc: "Uyda mashq qilish uchun: 2.5 kg dan 20 kg gacha sozlanadi. Metall disklar, rezina qoplama.",
      specs: {"Og'irlik": '2x20 kg', 'Material': "Cho'yan, rezina", 'Qadam': '2.5 kg'},
      seller: 'SportMaster UZ', tags: ['popular', 'sale'], daysAgo: 60, stock: 26,
    ),
    _p(
      id: 'p051', name: "Adidas Al Rihla futbol to'pi, 5 o'lcham", cat: 'sport', sub: 'Futbol', brand: 'Adidas',
      price: 349000, rating: 4.7, reviews: 390, sold: 2400, img: 'football',
      desc: "Rasmiy o'lcham va og'irlik, termal yopishtirilgan panellar, yaxshi aerodinamika.",
      specs: {"O'lcham": '5', 'Material': 'PU', 'Turi': 'Trenirovka'},
      seller: 'SportMaster UZ', tags: ['popular'], daysAgo: 33, stock: 70,
    ),

    // ================= BOLALAR =================
    _p(
      id: 'p052', name: "LEGO Classic ijodiy g'ishtlar to'plami, 484 qism", cat: 'kids', sub: "O'yinchoqlar", brand: 'LEGO',
      price: 449000, oldPrice: 529000, rating: 4.9, reviews: 520, sold: 2600, img: 'lego',
      desc: "33 xil rangdagi 484 qism, g'oyalar kitobchasi bilan. 4+ yosh uchun.",
      specs: {'Qismlar': '484', 'Yosh': '4+', 'Original': 'Ha'},
      seller: 'ToyLand', tags: ['popular', 'sale'], daysAgo: 18, stock: 48,
    ),
    _p(
      id: 'p053', name: "Pampers Premium Care tagliklar 4 (9-14kg), 104 dona", cat: 'kids', sub: 'Chaqaloq parvarishi', brand: 'Pampers',
      price: 289000, oldPrice: 329000, rating: 4.8, reviews: 1900, sold: 16000, img: 'diapers',
      desc: "Eng yumshoq Pampers, 12 soatgacha quruqlik, namlik indikatori.",
      specs: {"O'lcham": '4 (9–14 kg)', 'Miqdor': '104 dona'},
      seller: 'BozorGo Market', tags: ['bestseller', 'sale'], daysAgo: 6, stock: 260,
    ),
    _p(
      id: 'p054', name: "Bolalar uchun 3 g'ildirakli samokat, LED", cat: 'kids', sub: "O'yinchoqlar", brand: 'KidsJoy',
      price: 389000, oldPrice: 459000, rating: 4.7, reviews: 340, sold: 1800, img: 'kids_scooter',
      desc: "Yonuvchi g'ildiraklar, balandligi sozlanadigan dastak, 50 kg gacha. 3–8 yosh.",
      specs: {'Yosh': '3–8', 'Yuk': '50 kg', "G'ildiraklar": 'PU, LED'},
      seller: 'ToyLand', tags: ['new', 'sale'], daysAgo: 3, stock: 44,
    ),

    // ================= KITOBLAR / ASBOBLAR / BOG' =================
    _p(
      id: 'p055', name: "«Atomik odatlar» — Jeyms Klir (o'zbek tilida)", cat: 'books', sub: 'Biznes', brand: 'Asaxiy Books',
      price: 89000, oldPrice: 109000, rating: 4.9, reviews: 1100, sold: 9400, img: 'book_habits',
      desc: "Kichik o'zgarishlar orqali katta natijalarga erishish haqida dunyo bestselleri. Qattiq muqova, 320 bet.",
      specs: {'Muallif': 'Jeyms Klir', 'Til': "O'zbek", 'Betlar': '320', 'Muqova': 'Qattiq'},
      seller: 'Asaxiy Books', tags: ['bestseller', 'popular', 'sale'], daysAgo: 27, stock: 150,
    ),
    _p(
      id: 'p056', name: "Bosch GSR 12V-30 akkumulyatorli drel-shurupovert", cat: 'tools', sub: 'Elektr asboblar', brand: 'Bosch',
      price: 1290000, oldPrice: 1490000, rating: 4.8, reviews: 245, sold: 1300, img: 'drill',
      desc: "Ixcham va kuchli: 30 Nm moment, 2 ta akkumulyator, LED yoritish. Professional sifat.",
      specs: {'Kuchlanish': '12V', 'Moment': '30 Nm', 'Akkumulyator': '2x2.0 Ah', 'Kafolat': '2 yil'},
      seller: 'Bosch Center', tags: ['popular', 'sale'], daysAgo: 48, stock: 21,
    ),
    _p(
      id: 'p057', name: "Bog' uchun tomchilatib sug'orish to'plami, 25m", cat: 'garden', sub: "Sug'orish", brand: 'GreenLine',
      price: 189000, oldPrice: 229000, rating: 4.6, reviews: 160, sold: 950, img: 'drip_irrigation',
      desc: "Suvni 60% tejaydi. 25 metr shlang, 30 ta tomizgich, ulagichlar. O'rnatish oson.",
      specs: {'Uzunlik': '25 m', 'Tomizgichlar': '30 ta', 'Material': 'PVC'},
      seller: 'GreenLine', tags: ['sale'], daysAgo: 52, stock: 65,
    ),
  ];

  static Product? byId(String id) {
    for (final p in all) {
      if (p.id == id) return p;
    }
    return null;
  }
}
