# Buna App Cleaning & Optimization Guide

This single guide consolidates all actionable cleaning, optimization, and maintenance steps for the Buna Festival app. Use this as your reference for keeping the codebase and assets clean, efficient, and maintainable.

---

## 1. Asset Management
- Use only correct asset paths and naming conventions (e.g., `assets/buna_blue.png`).
- Remove unused or duplicate assets from the project.
- Optimize image assets for size and performance (see `ASSET_OPTIMIZATION_GUIDE.txt`).
- Ensure all assets are declared in `pubspec.yaml` and referenced correctly in code.

## 2. Code Cleanup
- Remove deprecated APIs and unused imports/fields.
- Refactor code for readability and maintainability.
- Ensure all widgets and services are properly wired and tested.
- Address all analyzer warnings and info messages.

## 3. Documentation
- Keep all documentation in the `docs` folder.
- Minimize redundant information and combine related topics.
- Update documentation as cleaning and optimization tasks are completed.

## 4. Dependency Management
- Regularly check for dependency version conflicts.
- Update dependencies to latest compatible versions for your Flutter SDK.
- Remove or replace problematic packages as needed.

## 5. Testing & Quality
- Maintain comprehensive widget and integration tests.
- Run `flutter analyze` and `flutter test` regularly.
- Address all test failures and warnings promptly.

## 6. Maintenance Checklist
- [x] Asset path issues resolved
- [x] Widget and integration tests updated
- [x] Deprecated APIs flagged for update
- [x] Documentation moved to `docs` folder
- [ ] Final review and polish

---

## Project Tracking (Merged)
- All project tracking tasks are now included in this cleaning checklist.
- For historical tracking, see previous commits or audit reports.

---

## Recommendations
- Run `flutter clean && flutter pub get` after major changes.
- Profile and optimize slow areas for performance.
- Improve accessibility features.
- Set up CI/CD with linting and automated checks.

---

This guide replaces redundant/empty docs and merges all cleaning-related content for easy reference.
