# 🏗️ **Buna Festival App Architecture**

*Last Updated: December 2024*  
*Version: 0.0.1+1*

A comprehensive overview of the Buna Festival app's architecture, design patterns, and technical implementation.

## 📊 **Current Status**
- ✅ **Production Ready**: Clean code with 94% linting improvement
- ✅ **Centralized Logging**: Professional logging framework implemented
- ✅ **Organized Imports**: Barrel files for clean dependency management
- ✅ **Modular Architecture**: Feature-based development approach

## 🏗️ Overall Architecture

The Buna Festival app follows a **layered architecture** with **clean separation of concerns** and **reactive state management**. The architecture is designed for scalability, maintainability, and cross-platform compatibility.

```
┌─────────────────────────────────────────────────────────────┐
│                    Presentation Layer                       │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │   Screens   │ │   Widgets   │ │   Themes    │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    State Management Layer                   │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │  Providers  │ │  Notifiers  │ │   State     │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Business Logic Layer                     │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │   Services  │ │   Models    │ │   Utils     │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Data Layer                               │
│  ┌─────────────┐ ┌─────────────┐ ┌─────────────┐          │
│  │    APIs     │ │   Cache     │ │  Firebase   │          │
│  └─────────────┘ └─────────────┘ └─────────────┘          │
└─────────────────────────────────────────────────────────────┘
```

## 📁 Project Structure

```
lib/
├── main.dart                 # App entry point
├── app.dart                  # App configuration and setup
├── features/                 # Feature-based modules
│   ├── onboarding/          # Onboarding flow
│   ├── venues/              # Venue management
│   ├── maps/                # Interactive maps
│   ├── news/                # News and updates
│   └── info/                # Festival information
├── models/                   # Data models and entities
├── providers/                # Riverpod state management
├── services/                 # Business logic and external integrations
├── widgets/                  # Reusable UI components
├── theme/                    # App theming and styling
├── l10n/                     # Localization files
└── generated/                # Generated localization code
```

## 🎯 Design Patterns

### 1. **Feature-First Architecture**
Each feature is self-contained with its own screen, widgets, and logic:

```dart
features/
├── venues/
│   ├── venues_screen.dart    # Main venue screen
│   ├── schedule_screen.dart  # Venue schedule
│   └── venues_data.dart      # Venue-specific data
```

### 2. **Provider Pattern (Riverpod)**
State management using Riverpod providers:

```dart
// Provider definition
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

// Provider usage
class MyWidget extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    return Text('Current locale: $locale');
  }
}
```

### 3. **Service Layer Pattern**
Business logic separated into service classes:

```dart
class ApiService {
  Future<List<NewsArticle>> getNews() async {
    // API implementation
  }
}

class CacheService {
  Future<void> cacheData(String key, dynamic data) async {
    // Caching implementation
  }
}
```

### 4. **Repository Pattern**
Data access abstraction through repositories:

```dart
class FestivalDataRepository {
  final ApiService _apiService;
  final CacheService _cacheService;
  
  Future<List<NewsArticle>> getNews() async {
    // Try cache first, then API
  }
}
```

## 🔄 State Management Architecture

### Provider Hierarchy
```
AppProvider (Root)
├── LocaleProvider (Language management)
├── ThemeProvider (Theme mode)
├── ConnectivityProvider (Network status)
├── FavoritesProvider (User favorites)
├── ScheduleProvider (Personal schedule)
└── FestivalDataProvider (News, events, venues)
```

### State Flow
```
User Action → Provider → Service → API/Cache → Provider → UI Update
```

### Example State Flow
```dart
// 1. User taps refresh button
// 2. Provider triggers data fetch
final newsProvider = FutureProvider<List<NewsArticle>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  return await apiService.getNews();
});

// 3. Service makes API call
class ApiService {
  Future<List<NewsArticle>> getNews() async {
    final response = await http.get(Uri.parse('$baseUrl/news'));
    return NewsArticle.fromJsonList(response.body);
  }
}

// 4. UI automatically updates when data changes
class NewsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final newsAsync = ref.watch(newsProvider);
    
    return newsAsync.when(
      data: (news) => NewsList(news: news),
      loading: () => LoadingIndicator(),
      error: (error, stack) => ErrorScreen(error: error),
    );
  }
}
```

## 🛠️ Service Layer Architecture

### Core Services
```dart
services/
├── api_service.dart          # WordPress REST API integration
├── cache_service.dart        # Persistent data caching
├── error_handler.dart        # Centralized error management
├── analytics_service.dart    # User behavior tracking
├── connectivity_service.dart # Network status monitoring
├── performance_service.dart  # App performance metrics
└── schedule_service.dart     # Schedule management
```

### Service Dependencies
```
ApiService
├── ErrorHandler
├── CacheService
└── ConnectivityService

AnalyticsService
├── ErrorHandler
└── PerformanceService

ConnectivityService
└── ErrorHandler
```

### Service Communication
```dart
// Service dependency injection
final apiServiceProvider = Provider<ApiService>((ref) {
  final errorHandler = ref.read(errorHandlerProvider);
  final cacheService = ref.read(cacheServiceProvider);
  final connectivityService = ref.read(connectivityServiceProvider);
  
  return ApiService(
    errorHandler: errorHandler,
    cacheService: cacheService,
    connectivityService: connectivityService,
  );
});
```

## 📊 Data Flow Architecture

### Data Flow Diagram
```
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│    UI       │───▶│  Provider   │───▶│   Service   │
└─────────────┘    └─────────────┘    └─────────────┘
       ▲                   │                   │
       │                   ▼                   ▼
┌─────────────┐    ┌─────────────┐    ┌─────────────┐
│   Widget    │◀───│   State     │◀───│   API/Cache │
└─────────────┘    └─────────────┘    └─────────────┘
```

### Data Models
```dart
models/
├── festival_data.dart        # Core festival data models
├── schedule.dart             # Schedule and event models
├── favorites_manager.dart    # Favorites management
└── event_notes_reminders_manager.dart # Reminders
```

### Model Relationships
```dart
// Core data models
class NewsArticle {
  final String id;
  final String title;
  final String content;
  final DateTime publishedAt;
  final String? featuredImage;
}

class FestivalEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String venueId;
  final Venue venue;
}

class Venue {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final String description;
}
```

## 🎨 UI Architecture

### Widget Hierarchy
```
MaterialApp
├── ProviderScope (Riverpod)
├── Theme (Light/Dark mode)
├── Localizations (EN/BG)
├── Router (Go Router)
│   ├── OnboardingScreen
│   └── MainApp
│       ├── BunaAppBar
│       ├── BunaDrawer
│       ├── BunaNavBar
│       └── Screen Content
│           ├── VenuesScreen
│           ├── MapsScreen
│           ├── NewsScreen
│           └── InfoScreen
└── Global Widgets
    ├── OfflineBanner
    ├── LoadingIndicator
    └── ErrorScreen
```

### Reusable Components
```dart
widgets/
├── buna_app_bar.dart         # Consistent app bar
├── buna_drawer.dart          # Navigation drawer
├── buna_nav_bar.dart         # Bottom navigation
├── buna_fab.dart             # Floating action button
├── loading_indicator.dart    # Loading states
├── error_screen.dart         # Error handling
├── offline_banner.dart       # Network status
├── search_widget.dart        # Search functionality
├── schedule_card.dart        # Event display
└── venue_info_bottom_sheet.dart # Venue details
```

### Theme Architecture
```dart
theme/
└── app_theme.dart            # Theme configuration
    ├── LightTheme
    ├── DarkTheme
    ├── ColorScheme
    ├── TextTheme
    └── Component Themes
```

## 🌐 API Integration Architecture

### WordPress REST API Integration
```dart
class ApiService {
  static const String baseUrl = 'https://buna-festival.com/wp-json/wp/v2';
  
  // News endpoints
  Future<List<NewsArticle>> getNews({int page = 1}) async
  Future<NewsArticle> getNewsById(String id) async
  
  // Events endpoints
  Future<List<FestivalEvent>> getEvents() async
  Future<FestivalEvent> getEventById(String id) async
  
  // Venues endpoints
  Future<List<Venue>> getVenues() async
  Future<Venue> getVenueById(String id) async
}
```

### API Response Handling
```dart
// Standardized response handling
class ApiResponse<T> {
  final T? data;
  final String? error;
  final bool success;
  
  ApiResponse.success(this.data) : error = null, success = true;
  ApiResponse.error(this.error) : data = null, success = false;
}

// Error handling
class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic originalError;
}
```

## 🔐 Security Architecture

### Authentication
- **Firebase Authentication** for user management
- **Anonymous authentication** for basic functionality
- **Secure token management** for API access

### Data Security
- **HTTPS** for all API communications
- **Input validation** and sanitization
- **Secure storage** for sensitive data
- **Permission-based access** control

### Privacy
- **Minimal data collection** policy
- **User consent** for analytics
- **Data encryption** in transit and storage
- **GDPR compliance** considerations

## 📱 Platform Architecture

### Cross-Platform Strategy
```
Shared Code (90%)
├── Business Logic
├── State Management
├── UI Components
└── Data Models

Platform-Specific (10%)
├── Android
│   ├── Permissions
│   ├── Native Features
│   └── Material Design
├── iOS
│   ├── Permissions
│   ├── Native Features
│   └── iOS Design
└── Web
    ├── Progressive Web App
    ├── Browser APIs
    └── Responsive Design
```

### Platform-Specific Implementations
```dart
// Platform-specific services
class PlatformService {
  static Future<bool> requestCameraPermission() async {
    if (Platform.isAndroid) {
      return await _requestAndroidCameraPermission();
    } else if (Platform.isIOS) {
      return await _requestIOSCameraPermission();
    }
    return true; // Web doesn't need permission
  }
}
```

## 🧪 Testing Architecture

### Testing Strategy
```
Testing Pyramid
├── Unit Tests (70%)
│   ├── Services
│   ├── Models
│   └── Utils
├── Widget Tests (20%)
│   ├── UI Components
│   ├── Screen Tests
│   └── Integration Tests
└── Integration Tests (10%)
    ├── User Flows
    ├── API Integration
    └── End-to-End Tests
```

### Test Structure
```dart
test/
├── unit/                     # Unit tests
│   ├── services/
│   ├── models/
│   └── utils/
├── widget/                   # Widget tests
│   ├── screens/
│   └── components/
└── integration/              # Integration tests
    ├── user_flows/
    └── api_tests/
```

## 🚀 Performance Architecture

### Performance Optimizations
- **Lazy Loading** for content and images
- **Caching Strategy** for API responses
- **Memory Management** with proper disposal
- **Image Optimization** and compression
- **Code Splitting** for web deployment

### Monitoring
```dart
class PerformanceService {
  void trackScreenLoad(String screenName) async
  void trackApiCall(String endpoint, Duration duration) async
  void trackUserAction(String action) async
  void trackError(String error, StackTrace stackTrace) async
}
```

## 🔄 Error Handling Architecture

### Error Hierarchy
```
AppException (Base)
├── NetworkException
│   ├── ConnectivityException
│   ├── TimeoutException
│   └── ApiException
├── ValidationException
├── CacheException
└── UnknownException
```

### Error Handling Flow
```
Error Occurs → Error Handler → Error Type → User-Friendly Message → UI Update
```

### Error Recovery
- **Automatic retry** for network errors
- **Fallback to cache** when API fails
- **Graceful degradation** for non-critical features
- **User feedback** for actionable errors

## 📊 Analytics Architecture

### Analytics Events
```dart
class AnalyticsService {
  void trackScreenView(String screenName) async
  void trackUserAction(String action, Map<String, dynamic> parameters) async
  void trackError(String error, StackTrace stackTrace) async
  void trackPerformance(String metric, Duration duration) async
}
```

### Event Categories
- **User Engagement** (screen views, actions)
- **Performance** (load times, errors)
- **Feature Usage** (which features are used most)
- **Error Tracking** (what goes wrong)

## 🎯 Architecture Benefits

### Maintainability
- **Separation of concerns** makes code easy to understand
- **Feature-based organization** keeps related code together
- **Consistent patterns** reduce learning curve
- **Comprehensive documentation** aids development

### Scalability
- **Modular architecture** allows easy feature addition
- **Provider pattern** scales with app complexity
- **Service layer** can be extended with new APIs
- **Platform abstraction** supports new platforms

### Testability
- **Dependency injection** enables easy mocking
- **Separated concerns** allow focused testing
- **Provider pattern** makes state testing straightforward
- **Service abstraction** enables API testing

### Performance
- **Efficient state management** with Riverpod
- **Caching strategy** reduces API calls
- **Lazy loading** improves initial load times
- **Memory management** prevents leaks

## 🔮 Future Architecture Considerations

### Planned Improvements
- **Microservices** for backend integration
- **Real-time updates** with WebSocket support
- **Offline-first** architecture with sync
- **Advanced caching** with background sync
- **Push notifications** architecture

### Scalability Plans
- **Feature flags** for gradual rollouts
- **A/B testing** infrastructure
- **Performance monitoring** dashboard
- **Error tracking** and alerting
- **Automated deployment** pipeline

---

## 📚 Related Documentation

- [Getting Started](GETTING_STARTED.md) - Setup and installation
- [Features](FEATURES.md) - Complete feature overview
- [Error Handling](ERROR_HANDLING.md) - Error management details
- [Website Integration](WEBSITE_INTEGRATION.md) - API integration guide
- [Code Cleanup](CODE_CLEANUP.md) - Architecture improvements

---

*This architecture documentation provides a comprehensive overview of the Buna Festival app's technical design and implementation patterns.* 