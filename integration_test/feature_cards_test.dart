import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:buna_app/main.dart' as app;
import 'package:buna_app/widgets/featured/featured_artist_card.dart';
import 'package:buna_app/widgets/featured/featured_venue_card.dart';
import 'package:buna_app/widgets/featured/news_dashboard_card.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Featured Cards', () {
    testWidgets('Tap on Featured Artist Card', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final artistCard = find.byType(FeaturedArtistCard).evaluate().isNotEmpty;
      expect(artistCard, isTrue, reason: 'FeaturedArtistCard not found');
      // Add tap and navigation check if possible
    });

    testWidgets('Tap on Featured Venue Card', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final venueCard = find.byType(FeaturedVenueCard).evaluate().isNotEmpty;
      expect(venueCard, isTrue, reason: 'FeaturedVenueCard not found');
      // Add tap and navigation check if possible
    });

    testWidgets('Tap on News Dashboard Card', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      final newsCard = find.byType(NewsDashboardCard).evaluate().isNotEmpty;
      expect(newsCard, isTrue, reason: 'NewsDashboardCard not found');
      // Add tap and navigation check if possible
    });
  });
}