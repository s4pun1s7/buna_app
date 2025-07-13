# Testing Guide

Comprehensive testing strategy for the Buna Festival app covering unit tests, widget tests, and integration tests.

## 🧪 Testing Strategy

### Test Types
1. **Unit Tests** - Test individual functions, methods, and classes
2. **Widget Tests** - Test UI components and user interactions
3. **Integration Tests** - Test complete user flows and app behavior
4. **Performance Tests** - Test app performance and memory usage

### Test Structure
```
test/
├── unit/                  # Unit tests
│   ├── services/         # Service layer tests
│   ├── providers/        # Provider logic tests
│   ├── models/           # Data model tests
│   └── utils/            # Utility function tests
├── widget/               # Widget tests
│   ├── features/         # Feature-specific widget tests
│   ├── widgets/          # Reusable widget tests
│   └── screens/          # Screen widget tests
├── integration/          # Integration tests
│   ├── flows/            # Complete user flows
│   └── platform/         # Platform-specific tests
└── fixtures/             # Test data and mocks
```

## 🏃 Running Tests

### Basic Test Commands
```sh
# Run all tests
flutter test

# Run specific test file
flutter test test/unit/services/api_service_test.dart

# Run tests with coverage
flutter test --coverage

# Run tests in verbose mode
flutter test --verbose

# Run tests and watch for changes
flutter test --watch
```

### Platform-Specific Testing
```sh
# Test on specific platform
flutter test --platform chrome
flutter test --platform vm

# Integration tests on device
flutter test integration_test/app_test.dart -d android
flutter test integration_test/app_test.dart -d ios
```

### Coverage Analysis
```sh
# Generate coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html

# View coverage report
open coverage/html/index.html
```

## 📝 Writing Tests

### Unit Tests

#### Testing Services
```dart
// test/unit/services/api_service_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:buna_app/services/api_service.dart';

void main() {
  group('ApiService', () {
    late ApiService apiService;
    late MockHttpClient mockHttpClient;

    setUp(() {
      mockHttpClient = MockHttpClient();
      apiService = ApiService(httpClient: mockHttpClient);
    });

    test('should fetch news successfully', () async {
      // Arrange
      when(mockHttpClient.get(any))
          .thenAnswer((_) async => MockResponse(statusCode: 200, body: '{"news": []}'));

      // Act
      final result = await apiService.fetchNews();

      // Assert
      expect(result, isA<List<NewsItem>>());
      verify(mockHttpClient.get(any)).called(1);
    });

    test('should handle network errors', () async {
      // Arrange
      when(mockHttpClient.get(any))
          .thenThrow(NetworkException('Connection failed'));

      // Act & Assert
      expect(() => apiService.fetchNews(), throwsA(isA<NetworkException>()));
    });
  });
}
```

#### Testing Providers
```dart
// test/unit/providers/theme_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buna_app/providers/theme_provider.dart';

void main() {
  group('ThemeProvider', () {
    test('should start with system theme mode', () {
      final container = ProviderContainer();
      final themeMode = container.read(themeProvider);
      
      expect(themeMode, ThemeMode.system);
    });

    test('should update theme mode', () {
      final container = ProviderContainer();
      
      container.read(themeProvider.notifier).setThemeMode(ThemeMode.dark);
      final themeMode = container.read(themeProvider);
      
      expect(themeMode, ThemeMode.dark);
    });
  });
}
```

### Widget Tests

#### Testing Screens
```dart
// test/widget/features/venues/venues_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buna_app/features/venues/venues_screen.dart';

void main() {
  group('VenuesScreen', () {
    testWidgets('should display venues list', (WidgetTester tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            venuesProvider.overrideWith((ref) => MockVenuesNotifier()),
          ],
          child: MaterialApp(home: VenuesScreen()),
        ),
      );

      // Act
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Festival Venues'), findsOneWidget);
    });

    testWidgets('should handle loading state', (WidgetTester tester) async {
      // Test loading state
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            venuesProvider.overrideWith((ref) => AsyncValue.loading()),
          ],
          child: MaterialApp(home: VenuesScreen()),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });
}
```

#### Testing Widgets
```dart
// test/widget/widgets/venue_card_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:buna_app/widgets/venue_card.dart';
import 'package:buna_app/models/venue.dart';

void main() {
  group('VenueCard', () {
    final mockVenue = Venue(
      id: '1',
      name: 'Test Venue',
      description: 'Test Description',
      location: 'Test Location',
    );

    testWidgets('should display venue information', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VenueCard(venue: mockVenue),
          ),
        ),
      );

      expect(find.text('Test Venue'), findsOneWidget);
      expect(find.text('Test Description'), findsOneWidget);
      expect(find.text('Test Location'), findsOneWidget);
    });

    testWidgets('should handle tap events', (WidgetTester tester) async {
      bool tapped = false;
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VenueCard(
              venue: mockVenue,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      await tester.tap(find.byType(VenueCard));
      await tester.pumpAndSettle();

      expect(tapped, isTrue);
    });
  });
}
```

### Integration Tests

#### App Flow Testing
```dart
// integration_test/app_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:buna_app/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('App Integration Tests', () {
    testWidgets('complete onboarding flow', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();

      // Test onboarding
      expect(find.text('Welcome to Buna Festival'), findsOneWidget);
      
      // Select language
      await tester.tap(find.text('English'));
      await tester.pumpAndSettle();
      
      // Complete onboarding
      await tester.tap(find.text('Get Started'));
      await tester.pumpAndSettle();
      
      // Verify navigation to home
      expect(find.byIcon(Icons.home), findsOneWidget);
    });

    testWidgets('navigation between main screens', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      
      // Skip onboarding (if needed)
      // Navigate to venues
      await tester.tap(find.byIcon(Icons.location_on));
      await tester.pumpAndSettle();
      
      expect(find.text('Venues'), findsOneWidget);
      
      // Navigate to news
      await tester.tap(find.byIcon(Icons.article));
      await tester.pumpAndSettle();
      
      expect(find.text('News'), findsOneWidget);
    });
  });
}
```

## 🎯 Testing Best Practices

### Unit Tests
- Test one thing at a time
- Use descriptive test names
- Follow AAA pattern (Arrange, Act, Assert)
- Mock external dependencies
- Test both success and failure scenarios

### Widget Tests
- Test user interactions
- Verify UI state changes
- Test accessibility features
- Use meaningful widget selectors
- Test different screen sizes

### Integration Tests
- Test complete user workflows
- Test cross-platform compatibility
- Verify real data integration
- Test performance under load
- Test offline scenarios

## 🔧 Test Configuration

### Test Dependencies
```yaml
# pubspec.yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  integration_test:
    sdk: flutter
  mockito: ^5.4.2
  build_runner: ^2.4.7
  faker: ^2.1.0
```

### Mock Generation
```dart
// test/mocks.dart
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:buna_app/services/api_service.dart';

@GenerateMocks([http.Client, ApiService])
void main() {}
```

Generate mocks:
```sh
flutter packages pub run build_runner build
```

### Test Configuration
```dart
// test/test_config.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void setUpTestEnvironment() {
  setUpAll(() {
    // Mock shared preferences
    SharedPreferences.setMockInitialValues({});
  });
}
```

## 📊 Coverage Targets

### Current Coverage Goals
- **Overall**: 80%+ code coverage
- **Services**: 90%+ coverage
- **Providers**: 85%+ coverage
- **Widgets**: 75%+ coverage
- **Models**: 95%+ coverage

### Coverage Reports
```sh
# Generate coverage
flutter test --coverage

# View coverage by file
lcov --summary coverage/lcov.info

# Generate HTML report
genhtml coverage/lcov.info -o coverage/html
```

## 🚀 Continuous Integration

### GitHub Actions Example
```yaml
# .github/workflows/test.yml
name: Test

on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.8.0'
      
      - run: flutter pub get
      - run: flutter test --coverage
      - run: flutter analyze
      
      - name: Upload coverage
        uses: codecov/codecov-action@v3
        with:
          file: coverage/lcov.info
```

## 🔍 Debugging Tests

### Test Debugging
```sh
# Run specific test with debugging
flutter test test/unit/services/api_service_test.dart --verbose

# Run tests with print statements
flutter test --verbose --debug
```

### Widget Test Debugging
```dart
// In widget tests, use for debugging
testWidgets('debug widget test', (WidgetTester tester) async {
  await tester.pumpWidget(MyWidget());
  
  // Print widget tree for debugging
  debugDumpApp();
  
  // Print render tree
  debugDumpRenderTree();
});
```

## ✅ Testing Checklist

### Before Committing
- [ ] All tests pass: `flutter test`
- [ ] Code coverage meets targets
- [ ] No test warnings or errors
- [ ] Integration tests pass on target platforms
- [ ] Performance tests within acceptable limits

### New Feature Testing
- [ ] Unit tests for business logic
- [ ] Widget tests for UI components
- [ ] Integration tests for user flows
- [ ] Error handling tests
- [ ] Accessibility tests
- [ ] Performance impact tests

### Regression Testing
- [ ] Existing tests still pass
- [ ] No new test failures introduced
- [ ] Coverage doesn't decrease significantly
- [ ] Cross-platform compatibility maintained

---

For more information, see:
- [Getting Started](GETTING_STARTED.md)
- [Contributing Guidelines](CONTRIBUTING.md)
- [Architecture Guide](ARCHITECTURE.md)
