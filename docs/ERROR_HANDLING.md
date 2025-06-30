# Error Handling System

This document explains the centralized error handling system implemented in the Buna Festival app, designed to provide consistent, user-friendly error handling across all features.

## Overview

The error handling system provides:
- **Centralized error categorization** with custom exception types
- **User-friendly error messages** that are context-aware
- **Consistent UI components** for error display
- **Automatic error reporting** for debugging and analytics
- **Retry mechanisms** for recoverable errors
- **Proper error logging** for development and production

## Architecture

### Core Components

1. **ErrorHandler** (`lib/services/error_handler.dart`)
   - Central service for error processing and categorization
   - Provides user-friendly messages and UI helpers
   - Handles error reporting and logging

2. **Custom Exception Types**
   - `AppException`: Base exception class
   - `NetworkException`: Network connectivity issues
   - `ApiException`: API/HTTP errors with status codes
   - `CacheException`: Data caching issues
   - `ValidationException`: Data validation errors

3. **Error UI Components**
   - `ErrorScreen`: Full-screen error display
   - `SimpleErrorScreen`: Simplified error screen
   - `ErrorCard`: Inline error display for lists/cards

## Exception Types

### AppException
Base exception class with common properties:
```dart
class AppException implements Exception {
  final String message;
  final String? code;
  final dynamic originalError;
  final StackTrace? stackTrace;
}
```

### NetworkException
Handles network-related errors:
- `SocketException`: No internet connection
- `HttpException`: Network request failures
- `TimeoutException`: Request timeouts

### ApiException
Handles API-specific errors with HTTP status codes:
- `400`: Bad Request
- `401`: Unauthorized
- `403`: Forbidden
- `404`: Not Found
- `429`: Rate Limited
- `500+`: Server Errors

### CacheException
Handles data caching issues:
- Cache corruption
- Cache expiration
- Cache access failures

### ValidationException
Handles data validation errors:
- Invalid data format
- Missing required fields
- Field-specific validation errors

## Usage Examples

### Basic Error Handling

```dart
import '../services/error_handler.dart';

try {
  final data = await apiCall();
  return data;
} catch (error, stackTrace) {
  final appError = ErrorHandler().handleError(error, stackTrace);
  throw appError;
}
```

### API Error Handling

```dart
try {
  final response = await http.get(url);
  if (response.statusCode == 200) {
    return parseData(response.body);
  } else {
    throw ErrorHandler().handleApiError(
      'Failed to fetch data',
      '/api/endpoint',
      response.statusCode,
    );
  }
} catch (e, stackTrace) {
  throw ErrorHandler().handleError(e, stackTrace);
}
```

### Using Error Extensions

```dart
import '../services/error_handler.dart';

// Automatically handle errors in Futures
final data = await apiCall().handleError(ErrorHandler());

// Automatically handle errors in Streams
final stream = dataStream.handleError(ErrorHandler());
```

## UI Components

### ErrorScreen
Full-screen error display with retry functionality:

```dart
ErrorScreen(
  error: appError,
  onRetry: () => retryOperation(),
  showBackButton: true,
)
```

### SimpleErrorScreen
Simplified error screen for basic errors:

```dart
SimpleErrorScreen(
  message: 'Something went wrong',
  onRetry: () => retryOperation(),
)
```

### ErrorCard
Inline error display for lists and cards:

```dart
ErrorCard(
  error: appError,
  onRetry: () => retryOperation(),
  height: 120,
)
```

## Error Display Features

### Automatic Error Categorization
The system automatically categorizes errors and provides appropriate:
- **Icons**: Different icons for different error types
- **Colors**: Color-coded error displays
- **Messages**: Context-aware user-friendly messages
- **Actions**: Appropriate retry/back buttons

### Error-Specific Help
Different error types show specific help information:

#### Network Errors
- Check internet connection
- Switch between WiFi and mobile data
- Restart the app

#### API Errors
- Service availability information
- Rate limiting guidance
- Server status information

#### Validation Errors
- Data format explanations
- Field-specific guidance

## Error Reporting

### Development Mode
In debug mode, errors are logged to the console:
```dart
if (kDebugMode) {
  print('Error: $error');
  print('StackTrace: $stackTrace');
}
```

### Production Mode
In production, errors can be reported to services like:
- Firebase Crashlytics
- Sentry
- Custom analytics services

```dart
void reportError(AppException error) {
  // Implement your preferred error reporting service
  if (kDebugMode) {
    print('Reporting error: ${error.message}');
  }
}
```

## Integration with Riverpod

### Provider Error Handling
Providers automatically handle errors and provide them to UI:

```dart
final newsProvider = StateNotifierProvider<NewsStateNotifier, AsyncValue<List<NewsArticle>>>((ref) {
  return NewsStateNotifier();
});

class NewsStateNotifier extends StateNotifier<AsyncValue<List<NewsArticle>>> {
  final ErrorHandler _errorHandler = ErrorHandler();
  
  Future<void> _loadNews() async {
    try {
      state = const AsyncValue.loading();
      final news = await ApiService.fetchNews();
      state = AsyncValue.data(news);
    } catch (error, stackTrace) {
      final appError = _errorHandler.handleError(error, stackTrace);
      _errorHandler.reportError(appError);
      state = AsyncValue.error(appError, stackTrace);
    }
  }
}
```

### UI Error Handling
UI components handle AsyncValue errors:

```dart
newsState.when(
  data: (news) => NewsList(news),
  loading: () => LoadingIndicator(),
  error: (error, stackTrace) {
    final appError = error as AppException;
    return ErrorScreen(
      error: appError,
      onRetry: () => ref.read(newsProvider.notifier).refresh(),
    );
  },
)
```

## Best Practices

### 1. Always Use ErrorHandler
Don't throw raw exceptions. Always wrap them:

```dart
// ❌ Bad
throw Exception('Something went wrong');

// ✅ Good
throw ErrorHandler().handleError(error, stackTrace);
```

### 2. Provide Retry Mechanisms
For recoverable errors, always provide retry options:

```dart
ErrorScreen(
  error: appError,
  onRetry: () => retryOperation(),
)
```

### 3. Use Appropriate Error Types
Choose the right exception type for your error:

```dart
// Network issues
throw NetworkException('No internet connection');

// API issues
throw ApiException('Server error', statusCode: 500);

// Validation issues
throw ValidationException('Invalid email format');
```

### 4. Log Errors Appropriately
Always log errors for debugging:

```dart
try {
  // operation
} catch (error, stackTrace) {
  final appError = ErrorHandler().handleError(error, stackTrace);
  ErrorHandler().reportError(appError);
  throw appError;
}
```

### 5. Handle Errors at the Right Level
- **Low-level**: Catch and categorize errors
- **Mid-level**: Transform errors for UI consumption
- **High-level**: Display errors to users

## Configuration

### Error Handler Configuration
You can customize the error handler behavior:

```dart
class ErrorHandler {
  // Customize timeout duration
  static const Duration _timeout = Duration(seconds: 30);
  
  // Customize cache expiry
  static const Duration _cacheExpiry = Duration(minutes: 15);
  
  // Customize retry logic
  bool isRetryable(AppException error) {
    // Custom retry logic
  }
}
```

### Error Reporting Configuration
Configure error reporting for your preferred service:

```dart
void reportError(AppException error) {
  // Firebase Crashlytics
  FirebaseCrashlytics.instance.recordError(
    error.originalError ?? error,
    error.stackTrace,
  );
  
  // Sentry
  Sentry.captureException(
    error.originalError ?? error,
    stackTrace: error.stackTrace,
  );
}
```

## Testing

### Unit Testing
Test error handling in your unit tests:

```dart
test('should handle network errors', () async {
  when(apiService.fetchData()).thenThrow(SocketException('No connection'));
  
  final result = await dataProvider.fetchData();
  
  expect(result, isA<NetworkException>());
  expect(result.message, contains('internet connection'));
});
```

### Widget Testing
Test error UI components:

```dart
testWidgets('should show error screen with retry button', (tester) async {
  await tester.pumpWidget(
    ErrorScreen(
      error: NetworkException('No connection'),
      onRetry: () {},
    ),
  );
  
  expect(find.text('Connection Error'), findsOneWidget);
  expect(find.text('Try Again'), findsOneWidget);
});
```

## Troubleshooting

### Common Issues

1. **Error not categorized properly**
   - Check if the error type is handled in `ErrorHandler.handleError()`
   - Add new error type handling if needed

2. **Error message not user-friendly**
   - Update the message in the appropriate exception constructor
   - Use `getUserFriendlyMessage()` for custom messages

3. **Retry not working**
   - Check if `isRetryable()` returns true for your error type
   - Ensure the retry callback is properly implemented

4. **Error not being reported**
   - Check if error reporting is enabled
   - Verify the reporting service configuration

### Debug Mode
Enable debug logging to see error details:

```dart
if (kDebugMode) {
  print('Error: $error');
  print('StackTrace: $stackTrace');
  print('Error Type: ${error.runtimeType}');
}
```

## Future Enhancements

1. **Error Analytics**: Track error patterns and frequency
2. **Automatic Retry**: Implement exponential backoff for retries
3. **Error Recovery**: Automatic recovery for certain error types
4. **Offline Error Handling**: Better handling of offline scenarios
5. **Error Localization**: Localized error messages for different languages

## Support

For issues with the error handling system:
1. Check the error logs in debug mode
2. Verify error categorization is correct
3. Test error scenarios manually
4. Review the error handling documentation
5. Contact the development team for assistance 