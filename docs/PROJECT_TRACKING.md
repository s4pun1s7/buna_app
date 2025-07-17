---
# buna_app Project Tracking (2025)

## Recent Progress
- Major code cleanup: 0 critical errors, improved type safety, modular structure
- Performance: caching, offline support, analytics, connectivity monitoring
- Error handling: centralized, user-friendly messages
- Theme system: light/dark mode, persistent preferences
- Website integration: WordPress REST API for news/events
- Accessibility: scalable fonts, semantic labels, color contrast
- Documentation: updated guides, screenshots, and code comments

## Key Features (v0.0.3)
- Multilingual support (EN/BG), global language toggle
- Onboarding, schedule, favorites, event reminders
- Real festival data for venues, events, news
- Map view with venue markers
- Search and offline mode for basic content
- Feedback, QR, and cache clearing screens
- Modern UI: Material 3, dark mode, responsive design

## In Progress / Next Steps
- Polish onboarding visuals and add festival branding
- Add custom app icon and splash screens
- Refine button styles, spacing, and micro-interactions
- Add event details, artist info, and AR features
- Optimize for older devices and platforms
- Set up CI/CD pipeline, code coverage, automated testing
- Add push notifications, social sharing, QR/AR features
- Finalize accessibility improvements (focus order, semantic labels)

## Platform Setup
- Android: google-services.json, permissions, icons, splash
- iOS: GoogleService-Info.plist, permissions, icons, launch screen

## Code Quality
- 0 critical errors, 37 total issues (down from 90)
- Improved null safety, error handling, performance
- Modular code, organized imports, removed unused files

## Useful Links
- [Festival Website](https://bunavarna.com/)
- [Facebook](https://www.facebook.com/BunaVarna/)
- [Instagram](https://www.instagram.com/buna.varna/)
- [Website Integration Guide](docs/WEBSITE_INTEGRATION.md)
- [Accessibility Guide](docs/ACCESSIBILITY.md)

---
**Before pushing to GitHub:**
- Sensitive files (google-services.json, GoogleService-Info.plist) are excluded by .gitignore
- Review .gitignore for secrets and local config files

---
Update this file as you progress. Add/remove tasks as needed.
