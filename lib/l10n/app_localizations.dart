import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_bg.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('bg'),
    Locale('en')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Buna Festival'**
  String get appTitle;

  /// No description provided for @onboardingTitle1.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Buna Festival'**
  String get onboardingTitle1;

  /// No description provided for @onboardingTitle2.
  ///
  /// In en, this message translates to:
  /// **'Discover Art & Events'**
  String get onboardingTitle2;

  /// No description provided for @onboardingTitle3.
  ///
  /// In en, this message translates to:
  /// **'Personalize Your Experience'**
  String get onboardingTitle3;

  /// No description provided for @onboardingDesc1.
  ///
  /// In en, this message translates to:
  /// **'Explore the festival, artists, and venues.'**
  String get onboardingDesc1;

  /// No description provided for @onboardingDesc2.
  ///
  /// In en, this message translates to:
  /// **'Find art pieces, events, and more on the map.'**
  String get onboardingDesc2;

  /// No description provided for @onboardingDesc3.
  ///
  /// In en, this message translates to:
  /// **'Bookmark favorites, set reminders, and get news.'**
  String get onboardingDesc3;

  /// No description provided for @onboardingSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get onboardingSkip;

  /// No description provided for @onboardingNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get onboardingNext;

  /// No description provided for @onboardingDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get onboardingDone;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageBulgarian.
  ///
  /// In en, this message translates to:
  /// **'Bulgarian'**
  String get languageBulgarian;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @venues.
  ///
  /// In en, this message translates to:
  /// **'Venues'**
  String get venues;

  /// No description provided for @map.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get map;

  /// No description provided for @news.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get news;

  /// No description provided for @info.
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;

  /// No description provided for @favorites.
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get favorites;

  /// No description provided for @events.
  ///
  /// In en, this message translates to:
  /// **'Events'**
  String get events;

  /// No description provided for @schedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get schedule;

  /// No description provided for @yourSchedule.
  ///
  /// In en, this message translates to:
  /// **'Your Schedule'**
  String get yourSchedule;

  /// No description provided for @yourFavorites.
  ///
  /// In en, this message translates to:
  /// **'Your Favorites'**
  String get yourFavorites;

  /// No description provided for @seeFullSchedule.
  ///
  /// In en, this message translates to:
  /// **'See full schedule'**
  String get seeFullSchedule;

  /// No description provided for @showLess.
  ///
  /// In en, this message translates to:
  /// **'Show less'**
  String get showLess;

  /// No description provided for @noFavoriteEvents.
  ///
  /// In en, this message translates to:
  /// **'No favorite events yet.'**
  String get noFavoriteEvents;

  /// No description provided for @noFavoriteVenues.
  ///
  /// In en, this message translates to:
  /// **'No favorite venues yet.'**
  String get noFavoriteVenues;

  /// No description provided for @addToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add to favorites'**
  String get addToFavorites;

  /// No description provided for @removeFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove from favorites'**
  String get removeFromFavorites;

  /// No description provided for @addEventToFavorites.
  ///
  /// In en, this message translates to:
  /// **'Add event to favorites'**
  String get addEventToFavorites;

  /// No description provided for @removeEventFromFavorites.
  ///
  /// In en, this message translates to:
  /// **'Remove event from favorites'**
  String get removeEventFromFavorites;

  /// No description provided for @addReminder.
  ///
  /// In en, this message translates to:
  /// **'Add reminder'**
  String get addReminder;

  /// No description provided for @removeReminder.
  ///
  /// In en, this message translates to:
  /// **'Remove reminder'**
  String get removeReminder;

  /// No description provided for @addEditNote.
  ///
  /// In en, this message translates to:
  /// **'Add/Edit note'**
  String get addEditNote;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @viewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on Map'**
  String get viewOnMap;

  /// No description provided for @eventsLabel.
  ///
  /// In en, this message translates to:
  /// **'Events:'**
  String get eventsLabel;

  /// No description provided for @venuesLabel.
  ///
  /// In en, this message translates to:
  /// **'Venues:'**
  String get venuesLabel;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @latest.
  ///
  /// In en, this message translates to:
  /// **'Latest'**
  String get latest;

  /// No description provided for @today.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// No description provided for @mobileApp.
  ///
  /// In en, this message translates to:
  /// **'Mobile App'**
  String get mobileApp;

  /// No description provided for @festivalUpdates.
  ///
  /// In en, this message translates to:
  /// **'Festival Updates'**
  String get festivalUpdates;

  /// No description provided for @moreUpdatesComing.
  ///
  /// In en, this message translates to:
  /// **'More festival news and updates will be posted here as they become available. Follow us on social media for the latest announcements.'**
  String get moreUpdatesComing;

  /// No description provided for @appDevelopmentStarted.
  ///
  /// In en, this message translates to:
  /// **'Development of the Buna app has begun!'**
  String get appDevelopmentStarted;

  /// No description provided for @appDevelopmentDescription.
  ///
  /// In en, this message translates to:
  /// **'We are excited to announce that development of the official Buna Festival mobile app has started! This app will provide festival-goers with real-time updates, venue information, event schedules, and much more. Stay tuned for more updates as we build the ultimate festival companion app.'**
  String get appDevelopmentDescription;

  /// No description provided for @permissionCameraTitle.
  ///
  /// In en, this message translates to:
  /// **'Camera Permission'**
  String get permissionCameraTitle;

  /// No description provided for @permissionCameraMessage.
  ///
  /// In en, this message translates to:
  /// **'We need camera access for AR and QR features at the festival.'**
  String get permissionCameraMessage;

  /// No description provided for @permissionLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Location Permission'**
  String get permissionLocationTitle;

  /// No description provided for @permissionLocationMessage.
  ///
  /// In en, this message translates to:
  /// **'We use your location to show you nearby venues and events.'**
  String get permissionLocationMessage;

  /// No description provided for @permissionNotificationTitle.
  ///
  /// In en, this message translates to:
  /// **'Notification Permission'**
  String get permissionNotificationTitle;

  /// No description provided for @permissionNotificationMessage.
  ///
  /// In en, this message translates to:
  /// **'Enable notifications to receive festival news and updates.'**
  String get permissionNotificationMessage;

  /// No description provided for @allow.
  ///
  /// In en, this message translates to:
  /// **'Allow'**
  String get allow;

  /// No description provided for @deny.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get deny;

  /// No description provided for @devToolsMenu.
  ///
  /// In en, this message translates to:
  /// **'DevTools Menu'**
  String get devToolsMenu;

  /// No description provided for @hotReload.
  ///
  /// In en, this message translates to:
  /// **'Hot Reload'**
  String get hotReload;

  /// No description provided for @showDebugInfo.
  ///
  /// In en, this message translates to:
  /// **'Show Debug Info'**
  String get showDebugInfo;

  /// No description provided for @iosSizeToggleOn.
  ///
  /// In en, this message translates to:
  /// **'iOS Size: ON'**
  String get iosSizeToggleOn;

  /// No description provided for @iosSizeToggleOff.
  ///
  /// In en, this message translates to:
  /// **'iOS Size: OFF'**
  String get iosSizeToggleOff;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['bg', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'bg': return AppLocalizationsBg();
    case 'en': return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
