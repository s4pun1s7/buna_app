# Debouncer Implementation Guide

This guide explains where and how to implement debouncers in the Buna Festival app for optimal performance and user experience.

## What are Debouncers?

Debouncers delay the execution of a function until after a specified period of inactivity. This prevents excessive function calls and improves performance.

## Available Debouncer Types

### 1. `SearchDebouncer` (300ms)
- **Use case**: Search input fields
- **Delay**: 300ms
- **Example**: User typing in search box

### 2. `UIDebouncer` (100ms)
- **Use case**: UI updates and animations
- **Delay**: 100ms
- **Example**: Filtering lists, updating UI state

### 3. `APIDebouncer` (1000ms)
- **Use case**: API calls and network requests
- **Delay**: 1000ms
- **Example**: Rate limiting API requests

### 4. `ScrollDebouncer` (150ms)
- **Use case**: Scroll events and pagination
- **Delay**: 150ms
- **Example**: Infinite scrolling, lazy loading

### 5. `Debouncer` (500ms default)
- **Use case**: General purpose debouncing
- **Delay**: Customizable (default 500ms)
- **Example**: Any custom debouncing needs

## Implementation Examples

### Search Input
```dart
final SearchDebouncer _searchDebouncer = SearchDebouncer();

void _onSearchChanged(String query) {
  _searchDebouncer.call(() => _performSearch(query));
}
```

### Scroll Events
```dart
final ScrollDebouncer _scrollDebouncer = ScrollDebouncer();

void _onScroll() {
  _scrollDebouncer.call(() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      _loadMoreNews();
    }
  });
}
```

### API Calls
```dart
class ApiService {
  static final APIDebouncer _apiDebouncer = APIDebouncer();

  static Future<T> _debouncedApiCall<T>(Future<T> Function() apiCall) async {
    Completer<T> completer = Completer<T>();
    
    _apiDebouncer.call(() async {
      try {
        final result = await apiCall();
        if (!completer.isCompleted) {
          completer.complete(result);
        }
      } catch (e) {
        if (!completer.isCompleted) {
          completer.completeError(e);
        }
      }
    });
    
    return completer.future;
  }
}
```

## Where to Implement Debouncers

### ✅ Already Implemented
1. **Search Widget** - Uses `SearchDebouncer` for search input
2. **Maps Screen** - Uses `SearchDebouncer` for venue filtering
3. **News Screen** - Uses `ScrollDebouncer` for infinite scrolling
4. **API Service** - Uses `APIDebouncer` for rate limiting

### 🔄 Recommended for Future Implementation
1. **Venues Screen** - Add search and scroll debouncing
2. **Schedule Screen** - Add UI update debouncing
3. **Favorites Screen** - Add search debouncing
4. **Settings Screen** - Add API sync debouncing

## Best Practices

1. **Always dispose** debouncers in dispose() method
2. **Cancel when needed** - cancel pending operations when clearing input
3. **Use appropriate delays** for different use cases
4. **Handle errors gracefully** in async operations
5. **Monitor performance** to ensure debouncers are effective

## Performance Benefits

- Reduced API calls
- Better user experience
- Improved battery life
- Reduced server load
- Lower memory usage

## Debugging

### Check Debouncer State
```dart
print('Debouncer active: ${_debouncer.isActive}');
```

### Monitor API Calls
```dart
// In ApiService.getCacheStats()
'is_debouncer_active': _apiDebouncer.isActive,
```

### Performance Monitoring
Use the `PerformanceService` to track debouncer effectiveness:
```dart
PerformanceService().startTimer('search_debounce');
// ... search operation
PerformanceService().endTimer('search_debounce');
```

## Common Pitfalls

1. **Forgetting to dispose**: Always dispose debouncers
2. **Wrong delay times**: Use appropriate delays for the use case
3. **Not canceling**: Cancel debouncers when clearing input
4. **Over-debouncing**: Don't debounce everything, only where needed
5. **Async handling**: Properly handle async operations in debouncers

## Testing

Test debouncers with:
- Rapid input changes
- Scroll events
- Network conditions
- Memory usage
- Performance metrics

This ensures debouncers work correctly under various conditions and provide the expected performance benefits. 