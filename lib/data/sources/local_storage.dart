import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Lokal saqlash (SharedPreferences ustidagi yupqa qatlam).
/// Backend ulanganda bu qatlam kesh sifatida ishlashi mumkin.
class LocalStorage {
  LocalStorage(this._prefs);
  final SharedPreferences _prefs;

  static const _kCart = 'cart_v1';
  static const _kFavorites = 'favorites_v1';
  static const _kOrders = 'orders_v1';
  static const _kProfile = 'profile_v1';
  static const _kAddresses = 'addresses_v1';
  static const _kSearchHistory = 'search_history_v1';
  static const _kThemeMode = 'theme_mode_v1';
  static const _kNotifications = 'notifications_v1';
  static const _kLanguage = 'language_v1';
  static const _kOnboarded = 'onboarded_v1';

  // ---- Umumiy JSON yordamchilar ----
  Future<void> _setJson(String key, Object value) =>
      _prefs.setString(key, jsonEncode(value));

  T? _getJson<T>(String key) {
    final raw = _prefs.getString(key);
    if (raw == null) return null;
    try {
      return jsonDecode(raw) as T;
    } catch (_) {
      return null;
    }
  }

  // ---- Savat ----
  List<Map<String, dynamic>> readCart() =>
      (_getJson<List>(_kCart) ?? const []).cast<Map<String, dynamic>>();
  Future<void> writeCart(List<Map<String, dynamic>> items) => _setJson(_kCart, items);

  // ---- Sevimlilar ----
  List<String> readFavorites() => _prefs.getStringList(_kFavorites) ?? const [];
  Future<void> writeFavorites(List<String> ids) => _prefs.setStringList(_kFavorites, ids);

  // ---- Buyurtmalar ----
  List<Map<String, dynamic>> readOrders() =>
      (_getJson<List>(_kOrders) ?? const []).cast<Map<String, dynamic>>();
  Future<void> writeOrders(List<Map<String, dynamic>> orders) => _setJson(_kOrders, orders);

  // ---- Profil ----
  Map<String, dynamic>? readProfile() => _getJson<Map<String, dynamic>>(_kProfile);
  Future<void> writeProfile(Map<String, dynamic> p) => _setJson(_kProfile, p);
  Future<void> clearProfile() async => _prefs.remove(_kProfile);

  // ---- Manzillar ----
  List<Map<String, dynamic>>? readAddresses() =>
      _getJson<List>(_kAddresses)?.cast<Map<String, dynamic>>();
  Future<void> writeAddresses(List<Map<String, dynamic>> a) => _setJson(_kAddresses, a);

  // ---- Qidiruv tarixi ----
  List<String> readSearchHistory() => _prefs.getStringList(_kSearchHistory) ?? const [];
  Future<void> writeSearchHistory(List<String> h) => _prefs.setStringList(_kSearchHistory, h);

  // ---- Sozlamalar ----
  int? readThemeMode() => _prefs.getInt(_kThemeMode);
  Future<void> writeThemeMode(int v) => _prefs.setInt(_kThemeMode, v);
  bool readNotifications() => _prefs.getBool(_kNotifications) ?? true;
  Future<void> writeNotifications(bool v) => _prefs.setBool(_kNotifications, v);
  String readLanguage() => _prefs.getString(_kLanguage) ?? 'uz';
  Future<void> writeLanguage(String v) => _prefs.setString(_kLanguage, v);
  bool readOnboarded() => _prefs.getBool(_kOnboarded) ?? false;
  Future<void> writeOnboarded(bool v) => _prefs.setBool(_kOnboarded, v);

  Future<void> clearAll() => _prefs.clear();
}

/// main.dart da haqiqiy instans bilan override qilinadi.
final localStorageProvider = Provider<LocalStorage>((ref) {
  throw UnimplementedError('localStorageProvider main.dart da override qilinishi kerak');
});
