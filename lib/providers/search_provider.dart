import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sources/local_storage.dart';

class SearchHistoryNotifier extends Notifier<List<String>> {
  late LocalStorage _storage;

  @override
  List<String> build() {
    _storage = ref.watch(localStorageProvider);
    return _storage.readSearchHistory();
  }

  void add(String q) {
    final t = q.trim();
    if (t.isEmpty) return;
    final list = [t, ...state.where((e) => e.toLowerCase() != t.toLowerCase())].take(10).toList();
    state = list;
    _storage.writeSearchHistory(list);
  }

  void remove(String q) {
    state = state.where((e) => e != q).toList();
    _storage.writeSearchHistory(state);
  }

  void clear() {
    state = const [];
    _storage.writeSearchHistory(const []);
  }
}

final searchHistoryProvider =
    NotifierProvider<SearchHistoryNotifier, List<String>>(SearchHistoryNotifier.new);
