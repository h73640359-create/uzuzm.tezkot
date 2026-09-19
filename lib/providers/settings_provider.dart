import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/sources/local_storage.dart';

class SettingsState {
  const SettingsState({
    required this.themeMode,
    required this.notifications,
    required this.language,
  });

  final ThemeMode themeMode;
  final bool notifications;
  final String language;

  SettingsState copyWith({ThemeMode? themeMode, bool? notifications, String? language}) =>
      SettingsState(
        themeMode: themeMode ?? this.themeMode,
        notifications: notifications ?? this.notifications,
        language: language ?? this.language,
      );
}

class SettingsNotifier extends Notifier<SettingsState> {
  late LocalStorage _storage;

  @override
  SettingsState build() {
    _storage = ref.watch(localStorageProvider);
    final tm = _storage.readThemeMode();
    return SettingsState(
      themeMode: tm == null ? ThemeMode.light : ThemeMode.values[tm.clamp(0, 2)],
      notifications: _storage.readNotifications(),
      language: _storage.readLanguage(),
    );
  }

  void setThemeMode(ThemeMode mode) {
    state = state.copyWith(themeMode: mode);
    _storage.writeThemeMode(mode.index);
  }

  void toggleDark(bool dark) => setThemeMode(dark ? ThemeMode.dark : ThemeMode.light);

  void setNotifications(bool v) {
    state = state.copyWith(notifications: v);
    _storage.writeNotifications(v);
  }

  void setLanguage(String code) {
    state = state.copyWith(language: code);
    _storage.writeLanguage(code);
  }
}

final settingsProvider = NotifierProvider<SettingsNotifier, SettingsState>(SettingsNotifier.new);
