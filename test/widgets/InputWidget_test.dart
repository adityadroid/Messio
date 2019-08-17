import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:messio/widgets/InputWidget.dart';

void main(){
   MaterialApp app = MaterialApp(
    home: Scaffold(
        body:  InputWidget()
    ),
  );
  testWidgets('InputWidget UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(app);

    expect(find.byType(IconButton),findsNWidgets(2));
    expect(find.byType(EditableText),findsOneWidget);

  });
}