
import 'package:flutter_test/flutter_test.dart';
import 'package:messio/main.dart';
import 'package:messio/pages/ConversationPageList.dart';

void main() {
  testWidgets('Main UI Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(Messio());

    expect(find.byType(ConversationPageList),findsOneWidget);

  });
}
