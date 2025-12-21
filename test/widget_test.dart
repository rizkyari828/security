import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sales/theme/theme.dart';

void main() {
  testWidgets('App theme builds', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: ThemeConfig.lightTheme,
        home: const Scaffold(body: Text('ok')),
      ),
    );

    expect(find.text('ok'), findsOneWidget);
  });
}
