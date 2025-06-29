# Project Tracking for buna_app

---

## Recently Completed
- ✅ Project structure and feature folders scaffolded
- ✅ Onboarding screen scaffolded
- ✅ Navigation and state management (go_router, Riverpod) set up
- ✅ Firebase initialization and anonymous authentication (Android/iOS/Web)
- ✅ Sensitive files excluded in .gitignore
- ✅ Multi-language support (EN/BG) ARB files and localization setup
- ✅ Language selector on onboarding screen
- ✅ Firebase web config and permission handling for all platforms

---

## v0.0.2 Roadmap

### User Experience (UX)
- [ ] Add loading indicators for network/content screens (e.g., news, venues, schedule)
- [ ] Improve onboarding with festival info, visuals, and clear next steps
- [ ] Add error messages and user-friendly error screens for failed network requests
- [ ] Implement “pull to refresh” for news and schedule screens
- [ ] Ensure consistent button styles, padding, and spacing across the app
- [ ] Improve accessibility: larger tap targets, color contrast, and screen reader labels
- [ ] Add feedback for permission requests (explain why permissions are needed)
- [ ] Test and fix layout issues on different devices and orientations

### Visual & Branding
- [ ] Add custom app icon and splash/launch screens for Android and iOS
- [ ] Add festival branding (logo, colors, fonts) throughout the app

### Content & Features
- [ ] Implement real festival data for venues, events, and news (static or from a simple backend)
- [ ] Add a basic schedule/timetable screen
- [ ] Add a map view with venue markers (Google Maps or OpenStreetMap)

### Platform Polish
- [ ] Test and fix layout issues on web, Android, and iOS
- [ ] Improve accessibility (larger tap targets, color contrast, screen reader labels)

### Code Quality & Maintenance
- [ ] Add more widget and integration tests
- [ ] Refactor code for modularity and maintainability
- [ ] Update documentation and screenshots

### Optional/Nice-to-have
- [ ] Add a “favorites” feature for events/venues
- [ ] Add push notification support for news/updates

---

## Platform-Specific Setup Checklist

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

## Features and Requirements

### User Experience & Accessibility
- [ ] Add user profiles/attendee registration (Firebase, anonymous only for now)
- [x] Add multilingual support (BG/EN)
- [ ] Add accessibility features
- [x] Implement onboarding page

### Personal Schedule & Notifications
- [ ] Implement personal schedule, favorites, and event reminders
- [ ] Implement festival news and notifications (with user preferences)

### Festival Content & Discovery
- [ ] Add artist and artwork details
- [ ] Implement maps and gallery for art pieces and venues
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

## Code Quality & Project Improvement Checklist

- [x] Pin dependency versions in `pubspec.yaml` (avoid `any` for production)
- [x] Remove unused dependencies
- [x] Organize feature code in separate folders (modular structure)
- [x] Move logic out of `main.dart` into services/providers (partially, more possible)
- [x] Add error handling for async operations (Firebase, permissions, etc.)
- [x] Manage all state with Riverpod providers (partially, more possible)
- [x] Use named routes and route guards with `go_router`
- [x] Implement localization and accessibility (semantic labels, contrast, screen reader support) (localization done, accessibility in progress)
- [x] Request permissions only when needed, not all at app start (web excluded)
- [x] Add rationale dialogs before requesting sensitive permissions (to do)
- [ ] Add unit, widget, and integration tests for features and navigation
- [x] Expand `README.md` with setup, build, and contribution instructions
- [x] Add code comments and docstrings for public classes/methods (partially)
- [ ] Set up CI/CD (e.g., GitHub Actions) for tests and code analysis
- [x] Ensure privacy policy and terms are available if collecting user data (to do if needed)

---

## Useful Links
- Festival Website: [https://bunavarna.com/](https://bunavarna.com/)
- Facebook: [https://www.facebook.com/BunaVarna/](https://www.facebook.com/BunaVarna/)
- Instagram: [https://www.instagram.com/buna.varna/](https://www.instagram.com/buna.varna/)
- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Flutter Documentation](https://docs.flutter.dev/)

---
**Before pushing to GitHub:**
- Sensitive files like `google-services.json` (Android) and `GoogleService-Info.plist` (iOS) are excluded by `.gitignore` and should NOT be committed.
- Review your `.gitignore` for any other secrets or local config files.
- You are ready to initialize a git repo, commit, and push to GitHub!

---
Update this file as you progress with development and add more tasks as needed.

---
**Next Steps:**
- Update app icons and splash screens for both platforms
- Configure and test permissions (camera, location, notifications, etc.)
- Test on real Android and iOS devices
- Continue implementing features and UI/UX
