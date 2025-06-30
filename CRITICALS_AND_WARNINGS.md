# Flutter Analyze: Criticals & Warnings Checklist

_Last updated: 2025-06-30 (analyze: 81 issues)_

## ❗ Critical Errors (Must Fix)
- [x] The name 'SplashScreen' isn't a class - `lib/navigation/app_router.dart:152`
- [x] Classes can only extend other classes - `lib/widgets/navigation/buna_drawer.dart:13`
- [x] No associated named super constructor parameter - `lib/widgets/navigation/buna_drawer.dart:14`
- [x] Undefined class 'WidgetRef' - `lib/widgets/navigation/buna_drawer.dart:17`
- [x] Undefined class 'AsyncValue' - `lib/widgets/navigation/buna_drawer.dart:98`
- [x] Target of URI doesn't exist: '../branding/index.dart' - `lib/widgets/splash_screen.dart:5`
- [x] The name 'BunaLogoWithText' isn't a class - `lib/widgets/splash_screen.dart:84, 105`
- [x] Target of URI doesn't exist: 'package:buna_app/widgets/onboarding_step.dart' - `test/onboarding_step_test.dart:3`
- [x] The function 'OnboardingStep' isn't defined - `test/onboarding_step_test.dart:12, 31`
- [x] The name 'BunaAppWithPermissions' isn't a class - `test/widget_test.dart:20`
- [x] A value of type 'BunaDrawer' can't be returned from the method '_buildEndDrawer' because it has a return type of 'Widget' - `lib/navigation/main_layout.dart:139`

## ⚠️ Warnings & Infos (Recommended)
- [ ] Unused imports (multiple files)
- [ ] Deprecated: 'textScaleFactorOf' (multiple files)
- [ ] Deprecated: 'withOpacity' (multiple files)
- [ ] Unused variables and fields (multiple files)
- [ ] Prefer null-aware operators (e.g., `?.`)
- [ ] Use super parameters
- [ ] Prefer interpolation to compose strings
- [ ] Use 'TypeName _' instead of a type literal
- [ ] Unnecessary import (multiple files)
- [ ] Unnecessary null comparison
- [ ] Don't use 'BuildContext's across async gaps

---
Check off each item as you resolve it. Update this file after each `flutter analyze` run.
