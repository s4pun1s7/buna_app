# Figma Integration Guide for buna_app

This guide explains how to integrate Figma designs into your Flutter project and keep assets and UI code in sync with design updates.

## 1. Access Figma Designs
- Ensure you have access to the Figma file for your app’s UI.
- Collaborate with designers to clarify export requirements.

## 2. Install Figma Plugins
- Recommended plugins:
  - **Figma Export**: For exporting images and SVGs.
  - **Figma to Flutter**: For generating Flutter widget code.
  - **Figma Tokens**: For exporting design tokens (colors, typography).

## 3. Export Assets
- Export images, icons, and SVGs at 1x, 2x, and 3x resolutions.
- Place exported assets in the `assets/` directory.
- Update `pubspec.yaml` to include new assets:
  ```yaml
  flutter:
    assets:
      - assets/your_asset.png
      - assets/your_icon.svg
  ```

## 4. Export Design Tokens
- Export colors, fonts, and spacing values from Figma.
- Add them to your Flutter theme files in `lib/theme/`.
- Example:
  ```dart
  // lib/theme/colors.dart
  const primaryColor = Color(0xFF123456);
  ```

## 5. Generate UI Code
- Use Figma plugins to generate Flutter widget code.
- Place generated code in `lib/widgets/` or relevant folders.
- Refactor and clean up generated code for maintainability and consistency.

## 6. Document the Workflow
- Keep this guide updated with your team’s Figma integration process.
- Add tips, plugin recommendations, and troubleshooting steps as needed.

## 7. Update Workflow
- Define how to update assets and code when Figma designs change:
  - Manual export and replacement
  - Plugin-based sync
- Communicate changes with your team to avoid conflicts.

---

**References:**
- [Figma API Documentation](https://www.figma.com/developers/api)
- [Figma to Flutter Plugin](https://www.figma.com/community/plugin/1034969338659738588/Figma-to-Flutter)

Feel free to expand this guide as your workflow evolves.
