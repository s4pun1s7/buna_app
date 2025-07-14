# Contributing to Buna Festival App

Thank you for considering contributing to the Buna Festival app! This guide will help you get started with the development process.

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.8.0)
- Dart SDK (>=3.0.0)
- Git for version control
- Android Studio / VS Code with Flutter extensions
- Firebase account for backend services

### Setting Up Development Environment
1. **Fork and Clone**
   ```sh
   git clone https://github.com/YOUR_USERNAME/buna_app.git
   cd buna_app
   ```

2. **Install Dependencies**
   ```sh
   flutter pub get
   ```

3. **Configure Development Tools**
   ```sh
   # Enable development features
   flutter run --dart-define=DEV_TOOLS=true
   ```

4. **Set up Firebase** (see [Firebase Setup Guide](FIREBASE_SETUP.md))

## 🏗️ Development Workflow

### Branch Strategy
- `main` - Production-ready code
- `develop` - Development branch with latest features
- `feature/feature-name` - Feature development branches
- `fix/issue-description` - Bug fix branches

### Creating a Feature
1. **Create a branch**
   ```sh
   git checkout -b feature/your-feature-name
   ```

2. **Implement your feature**
   - Follow the existing code structure
   - Add tests for new functionality
   - Update documentation as needed

3. **Test your changes**
   ```sh
   # Run tests
   flutter test
   
   # Check code analysis
   flutter analyze
   
   # Format code
   flutter format .
   ```

4. **Commit your changes**
   ```sh
   git add .
   git commit -m "feat: add your feature description"
   ```

## 📝 Code Style Guidelines

### Dart/Flutter Standards
- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use meaningful variable and function names
- Add documentation comments for public APIs
- Follow the existing folder structure

### Code Organization
```
lib/
├── features/          # Feature modules (one per major app feature)
├── services/          # Business logic and external integrations
├── providers/         # Riverpod state management
├── models/            # Data models and DTOs
├── widgets/           # Reusable UI components
├── navigation/        # Routing and navigation
├── theme/             # App theming and styling
├── config/            # App configuration and feature flags
└── utils/             # Utility functions and helpers
```

### Feature Module Structure
```
features/feature_name/
├── feature_name_screen.dart    # Main screen widget
├── widgets/                    # Feature-specific widgets
├── models/                     # Feature-specific models
└── providers/                  # Feature-specific providers
```

## 🧪 Testing

### Test Types
- **Unit Tests**: Test individual functions and classes
- **Widget Tests**: Test UI components and interactions
- **Integration Tests**: Test complete user flows

### Running Tests
```sh
# All tests
flutter test

# Specific test file
flutter test test/features/venues/venues_test.dart

# With coverage
flutter test --coverage
```

### Writing Tests
- Place tests in `test/` directory mirroring `lib/` structure
- Use descriptive test names
- Test both success and error scenarios
- Mock external dependencies

## 🎯 Feature Development

### Adding New Features
1. **Plan the feature**
   - Check existing issues or create a new one
   - Discuss the approach with maintainers
   - Consider impact on existing features

2. **Create feature module**
   ```sh
   mkdir lib/features/your_feature
   # Add screen, models, and providers as needed
   ```

3. **Add feature flag** (in `lib/config/feature_flags.dart`)
   ```dart
   static const bool enableYourFeature = true;
   ```

4. **Update navigation** (in `lib/navigation/app_router.dart`)
   ```dart
   if (FeatureFlags.enableYourFeature)
     GoRoute(
       path: '/your-feature',
       builder: (context, state) => const YourFeatureScreen(),
     ),
   ```

5. **Add tests and documentation**

### State Management
- Use **Riverpod** for all state management
- Create providers in `lib/providers/`
- Follow the existing provider patterns
- Document provider responsibilities

### Error Handling
- Use the existing error handling system
- Throw `AppException` for custom errors
- Provide user-friendly error messages
- Handle offline scenarios gracefully

## 📖 Documentation

### Required Documentation
- Update feature documentation in `docs/FEATURES.md`
- Add API documentation for new services
- Update README.md if adding major features
- Include code comments for complex logic

### Documentation Style
- Use clear, concise language
- Include code examples where helpful
- Add screenshots for UI changes
- Keep documentation up-to-date with code changes

## 🐛 Bug Reports

### Before Reporting
- Check existing issues
- Test on multiple platforms (Android, iOS, Web)
- Gather debug information

### Bug Report Template
```markdown
**Bug Description**
Clear description of the bug

**Steps to Reproduce**
1. Step one
2. Step two
3. Step three

**Expected Behavior**
What should happen

**Actual Behavior**
What actually happens

**Environment**
- Flutter version:
- Platform (Android/iOS/Web):
- Device/Browser:
- App version:

**Additional Context**
Any other relevant information
```

## 🔍 Code Review Process

### Submitting Pull Requests
1. **Create descriptive title**
   - Use conventional commits format
   - Examples: `feat: add QR scanner`, `fix: resolve navigation issue`

2. **Write comprehensive description**
   - Explain the changes and why they were needed
   - Reference related issues
   - Include screenshots for UI changes

3. **Ensure CI passes**
   - All tests pass
   - Code analysis passes
   - No linting errors

### Review Criteria
- Code follows style guidelines
- Tests are included and pass
- Documentation is updated
- No breaking changes without discussion
- Feature flags are used for experimental features

## 🚦 Continuous Integration

### Automated Checks
- **Code Analysis**: `flutter analyze`
- **Tests**: `flutter test`
- **Build Verification**: Builds for all platforms
- **Dependency Check**: Verify no security vulnerabilities

### Manual Checks
- UI/UX review
- Performance testing
- Accessibility testing
- Cross-platform compatibility

## 💡 Development Tips

### Performance
- Use `const` constructors where possible
- Implement lazy loading for heavy features
- Monitor app performance with dev tools
- Use caching for expensive operations

### Debugging
- Use the in-app dev panel (`--dart-define=DEV_TOOLS=true`)
- Leverage Flutter DevTools for debugging
- Use `debugPrint` for debug logging
- Test offline scenarios

### Feature Flags
- Use feature flags for experimental features
- Test with flags both enabled and disabled
- Document flag dependencies
- Clean up unused flags regularly

## 📞 Getting Help

### Community Support
- **GitHub Issues**: Technical questions and bug reports
- **Discussions**: General questions and feature discussions
- **Documentation**: Check the comprehensive docs first

### Code Review
- Submit draft PRs early for feedback
- Ask specific questions in PR comments
- Be open to feedback and suggestions
- Help review others' PRs

## 🎉 Recognition

Contributors are recognized in:
- GitHub contributors list
- Release notes for significant contributions
- Project documentation acknowledgments

Thank you for contributing to the Buna Festival app! 🎨✨
