import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lab5_ung_dung_doc_bao/main.dart';

void main() {
  testWidgets('App khởi chạy không lỗi', (WidgetTester tester) async {
    final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);
    await tester.pumpWidget(NewsApp(themeModeNotifier: themeNotifier));
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
