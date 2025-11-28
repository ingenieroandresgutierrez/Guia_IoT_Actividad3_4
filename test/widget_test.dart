import 'package:actividad3_guia_iot/constants.dart';
import 'package:actividad3_guia_iot/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
  setUpAll(() async {
    // Mock SharedPreferences before initializing Supabase
    SharedPreferences.setMockInitialValues({});

    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  });

  testWidgets('Smoke test: App starts without crashing',
      (WidgetTester tester) async {
    // Build our app.
    await tester.pumpWidget(const MyApp());

    // Wait for all animations and async tasks to complete.
    await tester.pumpAndSettle();

    // Verify that the title is displayed.
    expect(find.text('Monitor Potenciómetro – ESP32'), findsOneWidget);

    // After pumpAndSettle, the initial LED state should be loaded (or fail to load).
    // In a test environment, network calls fail, so the catch block in
    // _loadInitialLedState will execute, setting loading to false.
    // The default _ledOn state is false, so we expect to see 'LED apagado'.
    expect(find.text('LED apagado'), findsOneWidget);

    // The "Cargando estado..." text should no longer be present.
    expect(find.text('Cargando estado...'), findsNothing);
  });
}
