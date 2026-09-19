/// Ilova bo'yicha umumiy konfiguratsiya.
///
/// Ilova nomini o'zgartirish uchun [appName] ni va
/// `android/app/src/main/res/values/strings.xml` dagi `app_name` ni yangilang.
///
/// Maxfiy kalitlar kodga yozilmaydi — ular `--dart-define` orqali uzatiladi:
/// `flutter build apk --dart-define=API_BASE_URL=https://api.example.uz`
class AppConfig {
  AppConfig._();

  static const String appName = 'BozorGo';
  static const String appTagline = "Tez. Qulay. O'zbekcha.";
  static const String version = '1.0.0';
  static const String supportPhone = '+998 71 200 00 00';
  static const String supportEmail = 'support@bozorgo.uz';

  /// Backend manzili. Bo'sh bo'lsa ilova demo (lokal) ma'lumotlar bilan ishlaydi.
  static const String apiBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// To'lov provayderi kaliti. Bo'sh bo'lsa DEMO PAYMENT rejimi ishlaydi.
  static const String paymentApiKey = String.fromEnvironment('PAYMENT_API_KEY');

  static bool get isDemoMode => apiBaseUrl.isEmpty;
  static bool get isDemoPayment => paymentApiKey.isEmpty;

  /// Yetkazib berish narxi (so'm). Shu summadan yuqori xaridlarda bepul.
  static const int deliveryFee = 15000;
  static const int freeDeliveryThreshold = 300000;
}
