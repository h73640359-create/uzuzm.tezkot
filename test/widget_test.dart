import 'package:bozorgo/app.dart';
import 'package:bozorgo/data/sources/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Ilova ishga tushadi va bosh sahifa ochiladi', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final prefs = await SharedPreferences.getInstance();
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [localStorageProvider.overrideWithValue(LocalStorage(prefs))],
        child: const BozorGoApp(),
      ),
    );
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.text('Bosh sahifa'), findsOneWidget);
    expect(find.text('Kategoriyalar'), findsWidgets);
    expect(find.text('Savat'), findsOneWidget);
    expect(find.text('Buyurtmalar'), findsOneWidget);
    expect(find.text('Profil'), findsOneWidget);
  });
}
