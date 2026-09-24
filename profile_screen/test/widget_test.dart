import "package:flutter_test/flutter_test.dart";
import "package:profile_screen/main.dart";

void main() {
  testWidgets("ProfileApp smoke test", (WidgetTester tester) async {
    await tester.pumpWidget(const ProfileApp());
    expect(find.text("My profile"), findsOneWidget);
  });
}
