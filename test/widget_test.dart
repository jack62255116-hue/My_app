import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myapp/shared/theme/app_theme.dart';
import 'package:myapp/shared/widgets/app_shell.dart';

void main() {
  testWidgets('App launches and shows bottom nav', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: AppTheme.light,
          home: const AppShell(),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('홈'), findsOneWidget);
    expect(find.text('기록'), findsOneWidget);
  });
}
