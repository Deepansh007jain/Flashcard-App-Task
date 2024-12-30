import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flashcard/main.dart';  // Updated import to match your project name

void main() {
  group('Flashcard App Widget Tests', () {
    testWidgets('App starts with empty state message', (WidgetTester tester) async {
      // Build our app and trigger a frame
      await tester.pumpWidget(const FlashcardApp());

      // Verify that we have the empty state message
      expect(find.text('No flashcards yet. Add some!'), findsOneWidget);
      
      // Verify that we have an add button
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('Can add a flashcard', (WidgetTester tester) async {
      await tester.pumpWidget(const FlashcardApp());

      // Tap the add button
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();

      // Verify that the add dialog is shown
      expect(find.text('Add Flashcard'), findsOneWidget);

      // Enter question and answer
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Question'),
        'Test Question'
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Answer'),
        'Test Answer'
      );

      // Tap the add button in dialog
      await tester.tap(find.widgetWithText(TextButton, 'Add'));
      await tester.pumpAndSettle();

      // Verify that the flashcard appears
      expect(find.text('Test Question'), findsOneWidget);
      expect(find.text('Test Answer'), findsNothing); // Answer should be hidden initially
    });

    testWidgets('Can toggle answer visibility', (WidgetTester tester) async {
      await tester.pumpWidget(const FlashcardApp());

      // Add a flashcard first
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Question'),
        'Test Question'
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Answer'),
        'Test Answer'
      );
      await tester.tap(find.widgetWithText(TextButton, 'Add'));
      await tester.pumpAndSettle();

      // Verify answer is initially hidden
      expect(find.text('Test Answer'), findsNothing);

      // Tap the card to show answer
      await tester.tap(find.text('Test Question'));
      await tester.pumpAndSettle();

      // Verify answer is now visible
      expect(find.text('Test Answer'), findsOneWidget);
    });

    testWidgets('Can delete a flashcard', (WidgetTester tester) async {
      await tester.pumpWidget(const FlashcardApp());

      // Add a flashcard first
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Question'),
        'Test Question'
      );
      await tester.enterText(
        find.widgetWithText(TextFormField, 'Answer'),
        'Test Answer'
      );
      await tester.tap(find.widgetWithText(TextButton, 'Add'));
      await tester.pumpAndSettle();

      // Tap delete button
      await tester.tap(find.byIcon(Icons.delete));
      await tester.pumpAndSettle();

      // Verify confirmation dialog appears
      expect(find.text('Delete Flashcard'), findsOneWidget);
      expect(find.text('Are you sure you want to delete this flashcard?'), findsOneWidget);

      // Confirm deletion
      var ttest;
      await ttest.tap(find.widgetWithText(TextButton, 'Delete'));
      await tester.pumpAndSettle();

      // Verify card is removed and empty state message is shown
      expect(find.text('Test Question'), findsNothing);
      expect(find.text('No flashcards yet. Add some!'), findsOneWidget);
    });
  });
}