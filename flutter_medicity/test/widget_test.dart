import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_medicity/main.dart';

void main() {
  testWidgets('App should render home screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MedicityApp());

    expect(find.text('MediCity - Distribuida'), findsOneWidget);
    expect(find.text('Sistema Médico Distribuido'), findsOneWidget);
  });
}
