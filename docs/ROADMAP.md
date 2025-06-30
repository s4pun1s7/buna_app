# Buna Festival App Roadmap

This roadmap outlines the major milestones and tasks required to bring the Buna Festival app to a production-ready state. It is organized by feature area and development phase, from core functionality to launch and beyond.

---

## 1. Core Features
- [x] **Routing & Navigation**
  - Centralized route constants
  - Route guards for onboarding/auth
  - Main layout shell with app bar, bottom nav, and right drawer
  - Route observer for analytics
- [x] **Onboarding Flow**
  - Splash screen with async onboarding check
  - Multi-step onboarding with completion logic
  - Locale selection and persistence
- [x] **Home Screen**
  - Modern UI with search, quick actions, schedule, favorites, featured venues
  - Themed with app colors
- [x] **Language Support**
  - Riverpod-based language toggle
  - Custom theme integration
- [x] **Venues & Schedule**
  - Venues list, details, and schedule integration
  - Favorites management
- [x] **News & Info**
  - News feed from WordPress
  - Festival info/about page
- [x] **Maps**
  - Interactive map with venues, custom markers, user location, and details modal
- [x] **Navigation Drawer**
  - Expandable right-side drawer with all features, settings, and dev tools
- Feedback screen: implemented
- QR screen: implemented
- Schedule screen: implemented

---

## 2. UI/UX Polish
- [ ] Consistent theming and color usage
- [ ] Responsive layouts for all devices
- [ ] Smooth transitions and animations
- [ ] Accessibility (contrast, font scaling, screen reader labels)
- [ ] Empty/error/loading states for all screens
- [ ] App icon, splash screen, and launch images for all platforms
- [ ] Finalize all icons and illustrations

---

## 3. Performance & Stability
- [x] Debouncer utility for search, scroll, and API
- [ ] Optimize API calls and caching
- [ ] Lazy loading for large lists (venues, news)
- [ ] Memory and battery usage profiling
- [ ] Crash/error reporting integration
- [ ] Offline support and graceful degradation
- Dedicated offline screen: in progress
- Cache clearing UI and image optimization: implemented

---

## 4. Testing & QA
- [ ] Unit tests for providers, services, and models
- [ ] Widget tests for all screens and major widgets
- [ ] Integration tests for onboarding, navigation, and critical flows
- [ ] Manual QA on iOS, Android, and web
- [ ] Accessibility and localization testing
- [ ] Beta testing with real users

---

## 5. Documentation
- [x] README and Getting Started
- [x] Debouncer Guide
- [ ] API integration and data model docs
- [ ] Contributor and code style guide
- [ ] Changelog and release notes

---

## 6. Pre-Launch
- [ ] Finalize app store assets (screenshots, description, privacy policy)
- [ ] App store and Play Store setup
- [ ] Versioning and release candidate build
- [ ] Legal review (privacy, terms)
- [ ] Final regression and smoke testing
- [ ] Marketing and launch plan

---

## 7. Launch & Post-Launch
- [ ] Submit to App Store and Play Store
- [ ] Monitor analytics, crash reports, and user feedback
- [ ] Hotfixes for critical issues
- [ ] Plan for first feature update (based on user feedback)
- [ ] Community engagement and support

---

## 8. Stretch Goals (Post-Launch)
- [ ] User authentication and profiles
- [ ] Push notifications
- [ ] In-app ticketing or QR code scanning
- [ ] Artist/venue social features
- [ ] Advanced search and filtering
- [ ] Customizable schedule and reminders
- [ ] Festival year/history archive

---

**Legend:**
- [x] = Complete
- [ ] = In Progress / To Do

_This roadmap will be updated as the project progresses. For details on implementation, see the codebase and docs folder._ 