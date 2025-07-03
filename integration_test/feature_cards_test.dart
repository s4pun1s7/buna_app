import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:buna_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Featured Cards', () {
    testWidgets('Tap on Featured Artist Card', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final artistCard = find.byType(Widget).evaluate().where((e) => e.widget.toString().contains('FeaturedArtistCard')).isNotEmpty;
      expect(artistCard, isTrue, reason: 'FeaturedArtistCard not found');
      // Add tap and navigation check if possible
    });

    testWidgets('Tap on Featured Venue Card', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final venueCard = find.byType(Widget).evaluate().where((e) => e.widget.toString().contains('FeaturedVenueCard')).isNotEmpty;
      expect(venueCard, isTrue, reason: 'FeaturedVenueCard not found');
      // Add tap and navigation check if possible
    });

    testWidgets('Tap on News Dashboard Card', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final newsCard = find.byType(Widget).evaluate().where((e) => e.widget.toString().contains('NewsDashboardCard')).isNotEmpty;
      expect(newsCard, isTrue, reason: 'NewsDashboardCard not found');
      // Add tap and navigation check if possible
    });
  });
} 