// This is a basic widget test for the app
// You can run this test by running `flutter test` in the terminal

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:all_in_one_video_saver/main.dart';

void main() {
  testWidgets('App launches correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // Verify that the app title is present
    expect(find.text('All-in-One Video Saver'), findsOneWidget);
  });
}