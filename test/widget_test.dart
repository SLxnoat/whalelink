import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whalelink/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: WhaleLinkApp()));

    // Verify that the Splash Screen appears initially
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // You can add more expectations here as we expand the tests
  });
}
