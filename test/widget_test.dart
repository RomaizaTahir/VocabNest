
import 'package:flutter_test/flutter_test.dart';
import 'package:vocab_nest/main.dart';

void main() {
  testWidgets('Vocab Nest app launches', (WidgetTester tester) async {
    await tester.pumpWidget(const VocabNestApp());

    expect(find.text('Vocab Nest'), findsOneWidget);
  });
}
