# 🎨 **Widget Standardization Guidelines**

*Last Updated: December 2024*  
*Version: 1.0*

Comprehensive guidelines for standardizing widget inheritance patterns across the Buna Festival app.

---

## 📊 **Current Widget Distribution**

### **Widget Count by Type**
- **StatelessWidget**: 25 widgets
- **ConsumerWidget**: 10 widgets  
- **ConsumerStatefulWidget**: 15 widgets
- **StatefulWidget**: 3 widgets

**Total: 53 widgets**

---

## 🎯 **Widget Type Selection Rules**

### **1. ConsumerWidget** ⭐ **PREFERRED**
**Use when:**
- Widget needs to access Riverpod providers
- Widget displays data from providers
- Widget responds to state changes
- No local state management needed

**Examples:**
```dart
class HomeScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final festivalData = ref.watch(festivalDataProvider);
    return festivalData.when(
      data: (data) => HomeContent(data: data),
      loading: () => LoadingIndicator(),
      error: (error, stack) => ErrorScreen(error: error),
    );
  }
}
```

### **2. ConsumerStatefulWidget** ⭐ **WHEN NEEDED**
**Use when:**
- Widget needs both provider access AND local state
- Widget has complex local state management
- Widget needs lifecycle methods (initState, dispose)
- Widget manages local animations or timers

**Examples:**
```dart
class NewsScreen extends ConsumerStatefulWidget {
  @override
  ConsumerState<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends ConsumerState<NewsScreen> {
  late ScrollController _scrollController;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final newsData = ref.watch(newsProvider);
    // ... rest of build method
  }
}
```

### **3. StatelessWidget** ⭐ **FOR PURE UI**
**Use when:**
- Widget is pure UI with no state
- Widget receives all data via parameters
- Widget doesn't need provider access
- Widget is a simple display component

**Examples:**
```dart
class LoadingIndicator extends StatelessWidget {
  final String? message;
  
  const LoadingIndicator({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          if (message != null) Text(message!),
        ],
      ),
    );
  }
}
```

### **4. StatefulWidget** ❌ **AVOID**
**Use only when:**
- Widget needs local state but NO provider access
- Widget manages platform-specific functionality
- Widget handles complex animations without providers
- **Rare cases only**

**Examples:**
```dart
class RestartWidget extends StatefulWidget {
  final Widget child;
  
  const RestartWidget({super.key, required this.child});

  @override
  State<RestartWidget> createState() => RestartWidgetState();
}
```

---

## 🔄 **Migration Strategy**

### **Phase 1: Convert StatelessWidget to ConsumerWidget**
**Target widgets that:**
- Display data that could come from providers
- Have hardcoded data that should be dynamic
- Could benefit from reactive updates

**Examples to convert:**
- `InfoScreen` → `ConsumerWidget` (for dynamic content)
- `OfflineScreen` → `ConsumerWidget` (for connectivity status)
- `VenueInfoBottomSheet` → `ConsumerWidget` (for venue data)

### **Phase 2: Convert ConsumerStatefulWidget to ConsumerWidget**
**Target widgets that:**
- Don't actually need local state
- Only use providers for data
- Have minimal local state that can be moved to providers

**Examples to evaluate:**
- `NewsScreen` → Check if local state is necessary
- `VenuesScreen` → Check if local state is necessary
- `MapsScreen` → Check if local state is necessary

### **Phase 3: Optimize StatefulWidget Usage**
**Target widgets that:**
- Could benefit from provider access
- Have state that could be managed globally

---

## 📋 **Widget Conversion Checklist**

### **Before Converting**
- [ ] **Analyze widget purpose** - What does it do?
- [ ] **Check data sources** - Where does data come from?
- [ ] **Identify state needs** - Does it need local state?
- [ ] **Review provider usage** - Does it access providers?
- [ ] **Consider performance** - Will conversion improve performance?

### **During Conversion**
- [ ] **Update imports** - Add flutter_riverpod import
- [ ] **Change inheritance** - Update extends clause
- [ ] **Add WidgetRef parameter** - Add to build method
- [ ] **Update provider access** - Use ref.watch/ref.read
- [ ] **Test functionality** - Ensure everything works

### **After Conversion**
- [ ] **Run tests** - Verify no regressions
- [ ] **Check performance** - Ensure no performance issues
- [ ] **Update documentation** - Document the change
- [ ] **Code review** - Get team approval

---

## 🎨 **Widget Naming Conventions**

### **Screen Widgets**
```dart
class HomeScreen extends ConsumerWidget
class VenuesScreen extends ConsumerWidget
class NewsScreen extends ConsumerWidget
```

### **Component Widgets**
```dart
class LoadingIndicator extends StatelessWidget
class ErrorScreen extends StatelessWidget
class LanguageToggle extends ConsumerWidget
```

### **Card Widgets**
```dart
class FeaturedEventCard extends ConsumerWidget
class NewsDashboardCard extends StatelessWidget
class VenueCard extends ConsumerWidget
```

### **Navigation Widgets**
```dart
class BunaAppBar extends ConsumerWidget
class BunaDrawer extends ConsumerWidget
class BunaNavBar extends StatelessWidget
```

---

## 🔧 **Provider Usage Patterns**

### **Reading Data**
```dart
// For reactive updates
final data = ref.watch(dataProvider);

// For one-time reads
final data = ref.read(dataProvider);
```

### **Handling Async Data**
```dart
final asyncData = ref.watch(asyncDataProvider);

return asyncData.when(
  data: (data) => DataWidget(data: data),
  loading: () => LoadingIndicator(),
  error: (error, stack) => ErrorWidget(error: error),
);
```

### **Listening to Changes**
```dart
ref.listen<AsyncValue<Data>>(
  dataProvider,
  (previous, next) {
    next.whenData((data) {
      // Handle data changes
    });
  },
);
```

---

## 📊 **Performance Considerations**

### **Provider Optimization**
- **Use `ref.watch`** for reactive updates
- **Use `ref.read`** for one-time access
- **Use `ref.listen`** for side effects
- **Avoid unnecessary rebuilds** with selective watching

### **Widget Optimization**
- **Use `const` constructors** when possible
- **Implement `==` operator** for custom widgets
- **Use `RepaintBoundary`** for complex animations
- **Avoid expensive operations** in build methods

---

## 🧪 **Testing Guidelines**

### **ConsumerWidget Testing**
```dart
testWidgets('HomeScreen displays festival data', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        festivalDataProvider.overrideWithValue(
          AsyncValue.data(mockFestivalData),
        ),
      ],
      child: MaterialApp(home: HomeScreen()),
    ),
  );

  expect(find.text('Festival Name'), findsOneWidget);
});
```

### **StatelessWidget Testing**
```dart
testWidgets('LoadingIndicator shows message', (tester) async {
  await tester.pumpWidget(
    MaterialApp(
      home: LoadingIndicator(message: 'Loading...'),
    ),
  );

  expect(find.text('Loading...'), findsOneWidget);
});
```

---

## 📈 **Success Metrics**

### **Target Distribution**
- **ConsumerWidget**: 60% (32 widgets)
- **ConsumerStatefulWidget**: 25% (13 widgets)
- **StatelessWidget**: 15% (8 widgets)
- **StatefulWidget**: 0% (0 widgets)

### **Quality Metrics**
- **Consistency**: 100% adherence to guidelines
- **Performance**: No performance regressions
- **Maintainability**: Easier to understand and modify
- **Testability**: Better test coverage

---

## 🚀 **Implementation Plan**

### **Week 1: Analysis & Planning**
- [ ] Audit all 53 widgets
- [ ] Categorize by conversion priority
- [ ] Create conversion schedule
- [ ] Set up testing framework

### **Week 2: High-Priority Conversions**
- [ ] Convert 10 StatelessWidget → ConsumerWidget
- [ ] Convert 5 ConsumerStatefulWidget → ConsumerWidget
- [ ] Test all conversions
- [ ] Update documentation

### **Week 3: Medium-Priority Conversions**
- [ ] Convert 10 more StatelessWidget → ConsumerWidget
- [ ] Convert 5 more ConsumerStatefulWidget → ConsumerWidget
- [ ] Performance testing
- [ ] Code review

### **Week 4: Finalization**
- [ ] Convert remaining widgets
- [ ] Update all documentation
- [ ] Create code review checklist
- [ ] Establish maintenance guidelines

---

## 📚 **Resources**

### **Documentation**
- [Riverpod Documentation](https://riverpod.dev/)
- [Flutter Widget Testing](https://docs.flutter.dev/cookbook/testing/widget/introduction)
- [Performance Best Practices](https://docs.flutter.dev/perf/best-practices)

### **Examples**
- See `lib/features/home/home_screen.dart` for ConsumerWidget example
- See `lib/widgets/common/loading_indicator.dart` for StatelessWidget example
- See `lib/features/news/news_screen.dart` for ConsumerStatefulWidget example

---

*These guidelines ensure consistent, maintainable, and performant widget patterns across the Buna Festival app.* 