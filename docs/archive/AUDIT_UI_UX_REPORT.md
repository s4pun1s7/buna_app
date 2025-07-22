Moved to docs/AUDIT_UI_UX_REPORT.md
# Buna App UI/UX Audit Report

## 1. Feature Screens

### Home
- **File:** `lib/features/home/home_screen.dart`
- **Notes:** Main entry screen. Check for onboarding, navigation, and feature highlights. Ensure consistent theming and responsive layout.

### Venues
- **Files:** `venues_screen.dart`, `schedule_screen.dart`, `venues_data.dart`
- **Notes:** Venue listing, schedule, and data. Check for map integration, event details, and accessibility.

### News
- **File:** `news_screen.dart`
- **Notes:** News feed. Ensure loading/error states, readable typography, and image handling.

### Maps
- **File:** `maps_screen.dart`
- **Notes:** Map display and navigation. Check for responsiveness, controls, and accessibility.

### Info
- **File:** `info_screen.dart`
- **Notes:** Festival info. Ensure clear layout and easy navigation.

### AR
- **File:** `ar_screen.dart`
- **Notes:** Augmented reality features. Test for device compatibility and user guidance.

### QR
- **File:** `qr_screen.dart`
- **Notes:** QR code scanning. Ensure camera permissions, feedback, and error handling.

### Social
- **File:** `social_screen.dart`
- **Notes:** Social feed. Check for content moderation, feedback, and accessibility.

### Feedback
- **File:** `feedback_screen.dart`
- **Notes:** User feedback form. Ensure validation, feedback, and accessibility.

### Artists
- **File:** `artists_screen.dart`
- **Notes:** Artist profiles. Check for image loading, responsive cards, and navigation.

### Schedule
- **File:** `schedule_screen.dart`
- **Notes:** Event schedule. Ensure filtering, time zone handling, and accessibility.

### Offline
- **File:** `offline_screen.dart`
- **Notes:** Offline state. Ensure clear messaging and retry options.

### Onboarding
- **File:** `onboarding_screen.dart`
- **Notes:** Onboarding flow. Check for progress indicators, skip options, and accessibility.

### Settings
- **File:** `feature_flags_screen.dart`
- **Notes:** Feature toggles. Ensure clear grouping, toggles, and feedback.

### Map Gallery
- **File:** `map_gallery_screen.dart`
- **Notes:** Map images/gallery. Ensure image loading, zoom, and navigation.

---

## 2. Reusable Widgets

### Featured Widgets
- **Files:** `news_dashboard_card.dart`, `featured_artist_card.dart`, `featured_venue_card.dart`, `next_event_card.dart`, `buna_logo.dart`
- **Notes:** Used for dashboard and highlights. Check for consistent card design, image handling, and responsiveness.

### Venue Event Widgets
- **Files:** `venue_info_bottom_sheet.dart`, `schedule_card.dart`, `featured_event_card.dart`
- **Notes:** Event and venue details. Ensure modal accessibility, card consistency, and feedback.

### Common Widgets
- **Files:** `error_screen.dart`, `offline_banner.dart`, `search_widget.dart`, `loading_indicator.dart`, `language_toggle.dart`, `rationale_dialog.dart`
- **Notes:** Error/loading states, search, language toggle. Ensure all are accessible, themed, and provide user feedback.

### Onboarding Widgets
- **Files:** `onboarding_step.dart`
- **Notes:** Onboarding progress. Check for clear steps and accessibility.

### Navigation Widgets
- **Files:** `buna_drawer.dart`, `buna_nav_bar.dart`, `buna_fab.dart`, `buna_app_bar.dart`, `scaffold_widgets.dart`
- **Notes:** Navigation and layout. Ensure discoverability, accessibility, and consistent theming.

### Branding Widgets
- **Files:** `buna_logo.dart`, `logo_test.dart`
- **Notes:** Branding/logo. Ensure correct usage and scaling.

---

## 3. Audit Criteria & Findings

### Consistency & Theming
- Theming is managed in `lib/theme/app_theme.dart`. Check all screens for consistent use of colors, fonts, and spacing.
- Some widgets may use hardcoded styles—recommend refactoring to use theme.

### Navigation & Flow
- Navigation is handled via `GoRouter` and custom navigation widgets. Ensure all routes are reachable and logical.
- Drawer and nav bar should be accessible from all main screens.

### Accessibility
- Check for semantic labels on icons/images, sufficient color contrast, and scalable text.
- Some custom widgets may lack accessibility features—review and add as needed.

### Responsiveness
- Most screens use `Expanded`, `Flexible`, or `MediaQuery` for layout. Test on various device sizes.
- Cards and modals should adapt to screen size.

### Error & Loading States
- Common widgets exist for error/loading, but ensure all screens use them consistently.
- Provide user-friendly messages and retry options.

### User Feedback
- Buttons, forms, and actions should provide visual and/or haptic feedback.
- Loading indicators and error dialogs should be clear and non-blocking.

### Redundancy/Obsolescence
- No major duplicate widgets found, but review for any legacy or unused components.

---

## 4. Recommendations
- **Refactor hardcoded styles** to use theme where possible.
- **Add/verify accessibility features** (labels, contrast, scalable text) on all custom widgets.
- **Test responsiveness** on multiple device sizes and orientations.
- **Ensure all screens use common error/loading widgets** for consistency.
- **Review navigation flow** for discoverability and logical structure.
- **Document custom widgets** for easier maintenance.
- **Remove any unused or obsolete widgets** after review.

---

*This audit provides a detailed inventory and actionable recommendations for improving the UX/UI of the Buna App. For a deeper review, consider user testing and accessibility audits with real devices and users.* 