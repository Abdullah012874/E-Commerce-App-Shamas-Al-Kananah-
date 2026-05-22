import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shams_al_kananah/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: ShamsAlKananahApp()));

    // Verify that the home screen is displayed
    expect(find.text('Shams Al Kananah'), findsOneWidget);
  });
}
