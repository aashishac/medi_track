import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:meditrack/core/network/connectivity_provider.dart';
import 'package:meditrack/core/widgets/custom_button.dart';
import 'package:meditrack/core/widgets/custom_text_field.dart';
import 'package:meditrack/features/auth/presentation/providers/auth_provider.dart';
import 'package:mockito/annotations.dart';
import 'package:provider/provider.dart';
//Generate mocks for providers
@GenerateMocks([AuthProvider, ConnectivityProvider])
import 'complete_widget_test.mocks.dart';

void main() {
  // helper function to wrap widgets with necessary providers
  Widget createWidgetUnderUnitTest({
    required Widget child,
    AuthProvider? authProvider,
    ConnectivityProvider? connectivityProvider,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => authProvider ?? MockAuthProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              connectivityProvider ?? MockConnectivityProvider(),
        ),
      ],
      child: MaterialApp(home: Scaffold(body: child)),
    );
  }

  /// Custom button widget testing
  group("Custom Button widget tests", () {
    testWidgets("displays button label correctly", (tester) async {
      // Arrange
      const buttonLabel = "Test Button";

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: CustomButton(onTap: () {}, buttonLabel: buttonLabel),
          ),
        ),
      ); // builds widget tree

      // Assert
      expect(find.text(buttonLabel), findsOneWidget);
    });

    testWidgets("calls onTap when pressed", (widgetTester) async {
      // Arrange
      var tapped = false;

      await widgetTester.pumpWidget(
        createWidgetUnderUnitTest(
          child: CustomButton(
            onTap: () => tapped = true,
            buttonLabel: 'button',
          ),
        ),
      );

      // Act
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      // Assert
      expect(tapped, isTrue);
    });

    testWidgets("shows loading indicator when is loading is true", (
      widgetTester,
    ) async {
      // Arrange
      await widgetTester.pumpWidget(
        createWidgetUnderUnitTest(
          child: CustomButton(
            onTap: () {},
            buttonLabel: 'Test',
            isLoading: true,
          ),
        ),
      );

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Test'), findsNothing);
    });

    testWidgets("does not call onTap when loadiing", (widgetTester) async {
      // Arrange
      var tapped = false;
      await widgetTester.pumpWidget(
        createWidgetUnderUnitTest(
          child: CustomButton(
            onTap: () {
              tapped = true;
            },
            buttonLabel: 'Test',
            isLoading: true,
          ),
        ),
      );

      // Act
      await widgetTester.tap(find.byType(ElevatedButton));
      await widgetTester.pump();

      // Assert
      expect(tapped, isFalse);
    });

    testWidgets("applies outlined style when isOutlined is true", (
      widgetTester,
    ) async {
      await widgetTester.pumpWidget(
        createWidgetUnderUnitTest(
          child: CustomButton(
            onTap: () {},
            buttonLabel: 'Test',
            isOutlined: true,
          ),
        ),
      );

      // Act
      final button = widgetTester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      final buttonStyle = button.style;

      // Assert - Button should have outlined style with border
      expect(buttonStyle, isNotNull);
    });
  });

  /// custom text field widget testing
  group("CustomTextField widget tests", () {
    testWidgets("display hint text correctly", (widgetTester) async {
      // Arrange
      const hintText = 'Enter your email';
      await widgetTester.pumpWidget(
        createWidgetUnderUnitTest(child: CustomTextField(hintText: hintText)),
      );

      // Assert
      expect(find.text(hintText), findsOneWidget);
    });

    testWidgets("displays prefix icon", (widgetTester) async {
      await widgetTester.pumpWidget(
        createWidgetUnderUnitTest(
          child: CustomTextField(prefixIcon: Icon(Icons.email)),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    // home work: displays suffix icon
    testWidgets("displays suffix icon", (widgetTester) async {
      await widgetTester.pumpWidget(
        createWidgetUnderUnitTest(
          child: CustomTextField(suffixIcon: Icon(Icons.email)),
        ),
      );

      // Assert
      expect(find.byIcon(Icons.email), findsOneWidget);
    });

    testWidgets("calls onChanges when text changes", (widgetTester) async {
      String? changedValue;
      await widgetTester.pumpWidget(
        createWidgetUnderUnitTest(
          child: CustomTextField(
            onChanged: (value) {
              changedValue = value;
            },
          ),
        ),
      );

      //Act
      await widgetTester.enterText(find.byType(TextFormField), 'test');

      // Assert
      expect(changedValue, 'test');
    });
  });
}
