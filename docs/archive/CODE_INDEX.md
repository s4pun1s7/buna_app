# Buna Festival App - Code Index

## 📋 Project Overview
**Buna Festival App** is a cross-platform Flutter application for the Buna art festival, supporting Android, iOS, and Web platforms. The app features multi-language support, Firebase integration, venue management, interactive maps, and real-time news updates.

**Version**: 0.0.1+1  
**Flutter SDK**: >=3.8.0  
**Dart SDK**: >=3.0.0  

---

## 🏗️ Architecture Overview

### Core Architecture
- **State Management**: Riverpod for reactive state management
- **Navigation**: Go Router for type-safe navigation
- **Backend**: Firebase (Auth, Analytics, Firestore)
- **API Integration**: WordPress REST API for content
- **Localization**: Flutter's built-in localization (EN/BG)
- **Theme**: Light/Dark mode with Material Design 3

### Project Structure
```
lib/
├── main.dart                 # App entry point
├── app.dart                  # Main app widget
├── features/                 # Feature modules
├── models/                   # Data models
├── providers/                # Riverpod state management
├── services/                 # Business logic & API
├── navigation/               # Routing & navigation
├── widgets/                  # Reusable UI components
├── theme/                    # App theming
├── utils/                    # Utility functions
└── l10n/                     # Localization files
```

---

## 🚀 Entry Points

### `lib/main.dart`
**Purpose**: Application entry point and initialization
- Firebase initialization (Web/Mobile)
- Permission requests (Camera, Location, Notifications)
- Anonymous authentication setup
- Service initialization
- Analytics tracking

**Key Functions**:
- `main()`: App initialization and Firebase setup
- `requestFestivalPermissions()`: Permission handling
- `BunaAppWithPermissions`: Wrapper widget for permissions

### `lib/app.dart`
**Purpose**: Main app configuration and theme setup
- MaterialApp.router configuration
- Theme management (Light/Dark mode)
- Localization setup
- Router configuration
- Analytics integration

---

## 📱 Features Module

### Core Features
| Feature | Location | Description |
|---------|----------|-------------|
| **Onboarding** | `lib/features/onboarding/` | User introduction and language selection |
| **Home** | `lib/features/home/` | Main dashboard and navigation hub |
| **Venues** | `lib/features/venues/` | Festival venue management and details |
| **Maps** | `lib/features/maps/` | Interactive Google Maps integration |
| **News** | `lib/features/news/` | Real-time festival updates and announcements |
| **Info** | `lib/features/info/` | Festival information and about section |
| **Schedule** | `lib/features/schedule/` | Event scheduling and personal calendar |
| **QR** | `lib/features/qr/` | QR code scanning functionality |
| **AR** | `lib/features/ar/` | Augmented reality features |
| **Social** | `lib/features/social/` | Social sharing and interaction |
| **Feedback** | `lib/features/feedback/` | User feedback system |
| **Artists** | `lib/features/artists/` | Artist profiles and details |
| **Map Gallery** | `lib/features/map_gallery/` | Gallery of map views |
| **Offline** | `lib/features/offline/` | Offline functionality |

---

## 🗂️ Data Models

### `lib/models/festival_data.dart`
**Purpose**: Core data models for festival content
- **NewsItem**: News articles and updates
- **Venue**: Venue information and details
- **Event**: Event scheduling and details
- **Artist**: Artist profiles and information
- **FestivalInfo**: General festival information

### `lib/models/schedule.dart`
**Purpose**: Schedule and event management
- **Schedule**: Personal schedule management
- **Event**: Individual event details

### `lib/models/favorites_manager.dart`
**Purpose**: User favorites and preferences
- **FavoritesManager**: Manages user favorites across the app

### `lib/models/event_notes_reminders_manager.dart`
**Purpose**: Event reminder system
- **EventNotesRemindersManager**: Handles user reminders

---

## 🔄 State Management (Riverpod Providers)

### Core Providers
| Provider | Location | Purpose |
|----------|----------|---------|
| **localeProvider** | `lib/providers/locale_provider.dart` | Global language management (EN/BG) |
| **themeProvider** | `lib/providers/theme_provider.dart` | Theme mode management (Light/Dark/System) |
| **festivalDataProvider** | `lib/providers/festival_data_provider.dart` | News, events, and venue data |
| **favoritesProvider** | `lib/providers/favorites_provider.dart` | User favorites management |
| **scheduleProvider** | `lib/providers/schedule_provider.dart` | Personal schedule management |
| **connectivityProvider** | `lib/services/connectivity_service.dart` | Network connectivity status |

### Provider Setup
- **riverpod_setup.dart**: Riverpod configuration and setup
- **provider_container.dart**: Provider container configuration

---

## 🔧 Services Layer

### API & Data Services
| Service | Location | Purpose |
|---------|----------|---------|
| **ApiService** | `lib/services/api_service.dart` | WordPress REST API integration |
| **CacheService** | `lib/services/cache_service.dart` | Persistent data caching |
| **ScheduleService** | `lib/services/schedule_service.dart` | Schedule management logic |

### Infrastructure Services
| Service | Location | Purpose |
|---------|----------|---------|
| **ConnectivityService** | `lib/services/connectivity_service.dart` | Network connectivity monitoring |
| **AnalyticsService** | `lib/services/analytics_service.dart` | User behavior tracking |
| **PerformanceService** | `lib/services/performance_service.dart` | Performance monitoring |
| **ErrorHandler** | `lib/services/error_handler.dart` | Centralized error management |

---

## 🧭 Navigation System

### Router Configuration
- **app_router.dart**: Main router configuration with Go Router
- **route_constants.dart**: Route path constants and definitions
- **route_guards.dart**: Navigation guards and authentication
- **route_observer.dart**: Route change tracking and analytics

### Layout Components
- **main_layout.dart**: Main app layout with navigation drawer and FAB
- **buna_nav_bar.dart**: Bottom navigation bar component

---

## 🎨 UI Components

### Core Widgets
| Widget | Location | Purpose |
|--------|----------|---------|
| **BunaAppBar** | `lib/widgets/buna_app_bar.dart` | Custom app bar component |
| **BunaDrawer** | `lib/widgets/buna_drawer.dart` | Navigation drawer |
| **BunaFab** | `lib/widgets/buna_fab.dart` | Floating action button |
| **BunaNavBar** | `lib/widgets/buna_nav_bar.dart` | Bottom navigation bar |

### Utility Widgets
| Widget | Location | Purpose |
|--------|----------|---------|
| **LoadingIndicator** | `lib/widgets/loading_indicator.dart` | Loading state display |
| **ErrorScreen** | `