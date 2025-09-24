// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:trip_mate/features/auths/controllers/auth_controller.dart';
import 'package:trip_mate/features/auths/controllers/ui_controller.dart';
import 'package:trip_mate/features/auths/login.dart';

void main() {
  testWidgets('Login button shows loading indicator when processing', (WidgetTester tester) async {
    // Create controllers
    final authController = AuthController();
    final uiController = UIController();

    // Build the login page with providers and ScreenUtilInit
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthController>.value(value: authController),
              ChangeNotifierProvider<UIController>.value(value: uiController),
            ],
            child: const MaterialApp(
              home: LoginPage(),
            ),
          );
        },
      ),
    );

    // Initially, the login button should not show loading
    expect(find.byType(CircularProgressIndicator), findsNothing);

    // Set loading state to true
    authController.setLoading(true);
    await tester.pump();

    // Now the login button should show loading indicator
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    // Set loading state back to false
    authController.setLoading(false);
    await tester.pump();

    // Loading indicator should be gone
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('Error message is displayed when login fails', (WidgetTester tester) async {
    // Create controllers
    final authController = AuthController();
    final uiController = UIController();

    // Build the login page with providers and ScreenUtilInit
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthController>.value(value: authController),
              ChangeNotifierProvider<UIController>.value(value: uiController),
            ],
            child: const MaterialApp(
              home: LoginPage(),
            ),
          );
        },
      ),
    );

    // Initially, no error message should be displayed
    expect(find.text('Please fill in all fields'), findsNothing);

    // Set an error message
    authController.setErrorMessage('Please fill in all fields');
    await tester.pump();

    // Error message should now be displayed
    expect(find.text('Please fill in all fields'), findsOneWidget);

    // Clear error message
    authController.setErrorMessage(null);
    await tester.pump();

    // Error message should be gone
    expect(find.text('Please fill in all fields'), findsNothing);
  });

  testWidgets('Required fields are marked with asterisk', (WidgetTester tester) async {
    // Create controllers
    final authController = AuthController();
    final uiController = UIController();

    // Build the login page with providers and ScreenUtilInit
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider<AuthController>.value(value: authController),
              ChangeNotifierProvider<UIController>.value(value: uiController),
            ],
            child: const MaterialApp(
              home: LoginPage(),
            ),
          );
        },
      ),
    );

    // Check that required fields are marked with asterisk
    expect(find.text('Email *'), findsOneWidget);
    expect(find.text('Password *'), findsOneWidget);
    expect(find.text('Fields marked with * are required'), findsOneWidget);
  });
}
