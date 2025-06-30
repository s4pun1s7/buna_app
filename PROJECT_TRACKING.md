# Project Tracking for buna_app

---

## 🎉 Recently Completed (Latest Sprint)
- ✅ **Code Cleanup & Refactoring**: Organized imports, removed unused dependencies, improved code structure
- ✅ **Global Language Toggle**: Implemented centralized locale management with Riverpod providers
- ✅ **Enhanced News Section**: Added real-time festival updates including app development announcement
- ✅ **Improved State Management**: Centralized locale provider for app-wide language changes
- ✅ **UI/UX Improvements**: Consistent theming and responsive design across all platforms
- ✅ **Import Organization**: Converted all relative imports to absolute imports for better maintainability
- ✅ **Language Toggle Positioning**: Optimized placement to avoid bottom navigation bar overlap
- ✅ **News Content**: Added structured news items with proper styling and categorization

---

## ✅ Previously Completed
- ✅ Project structure and feature folders scaffolded
- ✅ Onboarding screen scaffolded
- ✅ Navigation and state management (go_router, Riverpod) set up
- ✅ Firebase initialization and anonymous authentication (Android/iOS/Web)
- ✅ Sensitive files excluded in .gitignore
- ✅ Multi-language support (EN/BG) ARB files and localization setup
- ✅ Language selector on onboarding screen
- ✅ Firebase web config and permission handling for all platforms
- ✅ Loading indicators for News, Venues, and Maps screens
- ✅ Google Maps integration for Android, iOS, and Web
- ✅ Reusable AppBar, Drawer, FAB, and NavBar widgets
- ✅ Merge conflicts resolved, dev branch reset
- ✅ Error screens/messages for News, Venues, and Maps
- ✅ Bottom navigation bar for main navigation
- ✅ Google Maps web API key setup and troubleshooting
- ✅ Info screen updated with About Us and partners
- ✅ Onboarding step extracted as reusable widget
- ✅ Widget tests for onboarding, error, and loading widgets
- ✅ Rationale dialogs before requesting sensitive permissions
- ✅ Riverpod state management integrated for favorites, schedule, and locale
- ✅ Schedule/favorites logic refactored into services/providers
- ✅ Widget extraction for schedule card and other UI
- ✅ Full localization audit, ARB update, and codegen
- ✅ Code cleanup: removed unused files/folders (e.g., lib/common, empty features)
- ✅ .gitignore reviewed and updated for generated, build, and sensitive files

---

## 🚀 v0.0.3 Roadmap

### User Experience (UX) - In Progress
- [x] Add loading indicators for network/content screens (e.g., news, venues, schedule)
- [x] Add error messages and user-friendly error screens for failed network requests
- [x] Add rationale dialogs before requesting sensitive permissions
- [x] Add bottom navigation bar for main navigation
- [x] Implement global language toggle with proper positioning
- [x] Add structured news content with proper styling
- [ ] Improve onboarding with festival info, visuals, and clear next steps
- [ ] Implement "pull to refresh" for news and schedule screens
- [ ] Ensure consistent button styles, padding, and spacing across the app
- [ ] Improve accessibility: larger tap targets, color contrast, and screen reader labels
- [ ] Test and fix layout issues on different devices and orientations
- [ ] Add accessibility features (semantic labels, focus order, etc.)

### Visual & Branding
- [ ] Add custom app icon and splash/launch screens for Android and iOS
- [ ] Add festival branding (logo, colors, fonts) throughout the app
- [ ] Implement dark mode support
- [ ] Add animations and micro-interactions

### Content & Features
- [x] Implement real festival data for venues, events, and news (static or from a simple backend)
- [ ] Add a basic schedule/timetable screen
- [x] Add a map view with venue markers (Google Maps or OpenStreetMap)
- [x] Add a "favorites" feature for events/venues
- [ ] Add event details and artist information
- [ ] Implement search functionality for venues and events
- [ ] Add offline mode for basic content

### Platform Polish
- [ ] Test and fix layout issues on web, Android, and iOS
- [ ] Improve accessibility (larger tap targets, color contrast, screen reader labels)
- [ ] Optimize performance for older devices
- [ ] Add platform-specific features (widgets, shortcuts)

### Code Quality & Maintenance
- [x] Add more widget and integration tests
- [x] Refactor code for modularity and maintainability (services, providers, widgets)
- [x] Update documentation and screenshots
- [x] Remove unused/empty feature folders and files
- [x] Organize imports and improve code structure
- [ ] Set up CI/CD pipeline for automated testing
- [ ] Add code coverage reporting
- [ ] Implement automated code formatting and linting

### Optional/Nice-to-have
- [ ] Add push notification support for news/updates
- [ ] Implement social sharing features
- [ ] Add QR code scanning for venue/event information
- [ ] Implement AR features for venue exploration

---

## 🔧 Technical Improvements Completed

### State Management
- [x] Centralized locale management with `LocaleNotifier`
- [x] Global language toggle accessible from main interface
- [x] Proper Riverpod integration for all state management
- [x] Removed local state management in favor of providers

### Code Organization
- [x] Converted all relative imports to absolute imports
- [x] Organized imports by package type (Flutter, third-party, local)
- [x] Removed unused imports and dependencies
- [x] Improved code structure and maintainability

### UI/UX Enhancements
- [x] Optimized language toggle positioning
- [x] Added structured news content with proper styling
- [x] Improved responsive design across platforms
- [x] Enhanced visual hierarchy and typography

---

## 📱 Platform-Specific Setup Checklist

### Android
- [x] Place `google-services.json` in `android/app/`
- [ ] Update app icon and splash screen in `android/app/src/main/res/`
- [ ] Configure permissions in `android/app/src/main/AndroidManifest.xml` (camera, location, notifications, etc.)
- [ ] Set up package name and version in `android/app/build.gradle`
- [ ] Test on Android emulator and real device

### iOS
- [x] Place `GoogleService-Info.plist` in `ios/Runner/`
- [ ] Update app icon and launch screen in `ios/Runner/Assets.xcassets/`
- [ ] Configure permissions in `ios/Runner/Info.plist` (camera, location, notifications, etc.)
- [ ] Set up bundle identifier and version in Xcode project settings
- [ ] Test on iOS simulator and real device (requires Mac)

---

## 🎯 Features and Requirements

### User Experience & Accessibility
- [ ] Add user profiles/attendee registration (Firebase, anonymous only for now)
- [x] Add multilingual support (BG/EN) with global toggle
- [ ] Add accessibility features
- [x] Implement onboarding page

### Personal Schedule & Notifications
- [x] Implement personal schedule, favorites, and event reminders (with Riverpod)
- [x] Implement festival news and notifications (with user preferences)

### Festival Content & Discovery
- [ ] Add artist and artwork details
- [x] Implement maps and gallery for art pieces and venues
- [ ] Add augmented reality (AR) features
- [ ] Add QR code support

### Engagement & Interaction Tools
- [ ] Add social sharing
- [ ] Add in-app feedback or surveys
- [ ] Add ticketing or RSVP integration
- [ ] Add live updates or streaming

### Technical & Support
- [ ] Add offline mode
- [ ] Add sponsor/partner highlights

### General
- [x] Define app features and requirements
- [x] Design app UI/UX (scaffolded, further design needed)
- [x] Set up navigation and state management
- [ ] Testing and deployment

---

## 🧪 Code Quality & Project Improvement Checklist

- [x] Pin dependency versions in `pubspec.yaml` (avoid `any` for production)
- [x] Remove unused dependencies
- [x] Organize feature code in separate folders (modular structure)
- [x] Move logic out of `main.dart` into services/providers (fully modular)
- [x] Add error handling for async operations (Firebase, permissions, etc.)
- [x] Manage all state with Riverpod providers
- [x] Use named routes and route guards with `go_router`
- [x] Implement localization and accessibility (semantic labels, contrast, screen reader support) (localization done, accessibility in progress)
- [x] Request permissions only when needed, not all at app start (web excluded)
- [x] Add rationale dialogs before requesting sensitive permissions
- [x] Add unit, widget, and integration tests for features and navigation
- [x] Expand `README.md` with setup, build, and contribution instructions
- [x] Add code comments and docstrings for public classes/methods (partially)
- [ ] Set up CI/CD (e.g., Actions) for tests and code analysis
- [x] Ensure privacy policy and terms are available if collecting user data (to do if needed)

---

## 📊 Current Status

### Completed Features
- **Core App Structure**: ✅ Complete
- **Navigation**: ✅ Complete
- **State Management**: ✅ Complete
- **Localization**: ✅ Complete
- **Firebase Integration**: ✅ Complete
- **Basic UI Components**: ✅ Complete
- **Venue Management**: ✅ Complete
- **Maps Integration**: ✅ Complete
- **News System**: ✅ Complete
- **Language Toggle**: ✅ Complete

### In Progress
- **UI/UX Polish**: 🔄 Ongoing
- **Testing**: 🔄 Ongoing
- **Documentation**: 🔄 Ongoing

### Next Priority
- **App Icons & Branding**: 📋 Planned
- **Accessibility Features**: 📋 Planned
- **Performance Optimization**: 📋 Planned

---

## 🔗 Useful Links
- Festival Website: [https://bunavarna.com/](https://bunavarna.com/)
- Facebook: [https://www.facebook.com/BunaVarna/](https://www.facebook.com/BunaVarna/)
- Instagram: [https://www.instagram.com/buna.varna/](https://www.instagram.com/buna.varna/)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Documentation](https://docs.flutter.dev/)

---
**Before pushing to remote:**
- Sensitive files like `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are excluded by `.gitignore` and should NOT be committed.
- Review your `.gitignore` for any other secrets or local config files.
- You are ready to initialize a git repo, commit, and push to your remote!

---
Update this file as you progress with development and add more tasks as needed.

---
**Next Steps:**
- Update app icons and splash screens for both platforms
- Configure and test permissions (camera, location, notifications, etc.)
- Test on real Android and iOS devices
- Continue implementing features and UI/UX
- Set up CI/CD pipeline for automated testing and deployment
