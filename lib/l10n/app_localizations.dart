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

  /// No description provided for @homeLocation.
  ///
  /// In en, this message translates to:
  /// **'Varna | Bulgaria'**
  String get homeLocation;

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'BUNA | Vol. 3'**
  String get homeTitle;

  /// No description provided for @homeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'FORUM FOR CONTEMPORARY ART'**
  String get homeSubtitle;

  /// No description provided for @homeFeatured.
  ///
  /// In en, this message translates to:
  /// **'Featured'**
  String get homeFeatured;

  /// No description provided for @homeQuickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get homeQuickActions;

  /// No description provided for @homeMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get homeMap;

  /// No description provided for @homeSchedule.
  ///
  /// In en, this message translates to:
  /// **'Schedule'**
  String get homeSchedule;

  /// No description provided for @homeArtists.
  ///
  /// In en, this message translates to:
  /// **'Artists'**
  String get homeArtists;

  /// No description provided for @homeVenues.
  ///
  /// In en, this message translates to:
  /// **'Venues'**
  String get homeVenues;

  /// No description provided for @homeFeaturedArtist.
  ///
  /// In en, this message translates to:
  /// **'Featured Artist'**
  String get homeFeaturedArtist;

  /// No description provided for @homeFeaturedArtistBio.
  ///
  /// In en, this message translates to:
  /// **'Discover amazing artists at Buna Festival.'**
  String get homeFeaturedArtistBio;

  /// No description provided for @homeFeaturedArtistSpecialty.
  ///
  /// In en, this message translates to:
  /// **'Contemporary Art'**
  String get homeFeaturedArtistSpecialty;

  /// No description provided for @homeFeaturedVenue.
  ///
  /// In en, this message translates to:
  /// **'Main Gallery'**
  String get homeFeaturedVenue;

  /// No description provided for @homeFeaturedVenueAddress.
  ///
  /// In en, this message translates to:
  /// **'Central Varna'**
  String get homeFeaturedVenueAddress;

  /// No description provided for @homeFeaturedVenueEvent.
  ///
  /// In en, this message translates to:
  /// **'Art Exhibition'**
  String get homeFeaturedVenueEvent;

  /// No description provided for @homeNextEvent.
  ///
  /// In en, this message translates to:
  /// **'Opening Ceremony'**
  String get homeNextEvent;

  /// No description provided for @homeNextEventVenue.
  ///
  /// In en, this message translates to:
  /// **'Main Square'**
  String get homeNextEventVenue;

  /// No description provided for @homeNextEventVenueAddress.
  ///
  /// In en, this message translates to:
  /// **'Varna Center'**
  String get homeNextEventVenueAddress;

  /// No description provided for @homeNewsTitle.
  ///
  /// In en, this message translates to:
  /// **'Festival Updates'**
  String get homeNewsTitle;

  /// No description provided for @homeNewsContent.
  ///
  /// In en, this message translates to:
  /// **'Latest news and updates from Buna Festival.'**
  String get homeNewsContent;

  /// No description provided for @homeNewsExcerpt.
  ///
  /// In en, this message translates to:
  /// **'Stay updated with the latest festival news.'**
  String get homeNewsExcerpt;

  /// No description provided for @homeNewsAuthor.
  ///
  /// In en, this message translates to:
  /// **'Festival Team'**
  String get homeNewsAuthor;

  /// No description provided for @homeNewsCategory.
  ///
  /// In en, this message translates to:
  /// **'News'**
  String get homeNewsCategory;

  /// No description provided for @artistCountryInternational.
  ///
  /// In en, this message translates to:
  /// **'International'**
  String get artistCountryInternational;

  /// No description provided for @bunaVol3.
  ///
  /// In en, this message translates to:
  /// **'BUNA | Vol.3'**
  String get bunaVol3;

  /// No description provided for @forumForContemporaryArt.
  ///
  /// In en, this message translates to:
  /// **'FORUM FOR CONTEMPORARY ART'**
  String get forumForContemporaryArt;

  /// No description provided for @festivalDates.
  ///
  /// In en, this message translates to:
  /// **'3-8 Sept.2025'**
  String get festivalDates;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @bulgarian.
  ///
  /// In en, this message translates to:
  /// **'Български'**
  String get bulgarian;

  /// No description provided for @signInGoogle.
  ///
  /// In en, this message translates to:
  /// **'Google'**
  String get signInGoogle;

  /// No description provided for @signInGuest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get signInGuest;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @shareYourFeedback.
  ///
  /// In en, this message translates to:
  /// **'Share Your Feedback'**
  String get shareYourFeedback;

  /// No description provided for @feedbackHelpText.
  ///
  /// In en, this message translates to:
  /// **'Help us improve the Buna Festival experience by sharing your thoughts, suggestions, or reporting any issues.'**
  String get feedbackHelpText;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @emailOptional.
  ///
  /// In en, this message translates to:
  /// **'Email (Optional)'**
  String get emailOptional;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get invalidEmail;

  /// No description provided for @messageRequired.
  ///
  /// In en, this message translates to:
  /// **'Message *'**
  String get messageRequired;

  /// No description provided for @enterMessage.
  ///
  /// In en, this message translates to:
  /// **'Please enter your message'**
  String get enterMessage;

  /// No description provided for @messageTooShort.
  ///
  /// In en, this message translates to:
  /// **'Message must be at least 10 characters long'**
  String get messageTooShort;

  /// No description provided for @needImmediateHelp.
  ///
  /// In en, this message translates to:
  /// **'Need Immediate Help?'**
  String get needImmediateHelp;

  /// No description provided for @urgentSupportText.
  ///
  /// In en, this message translates to:
  /// **'For urgent issues during the festival, please contact our support team:'**
  String get urgentSupportText;

  /// No description provided for @callSupport.
  ///
  /// In en, this message translates to:
  /// **'Call Support'**
  String get callSupport;

  /// No description provided for @emailSupport.
  ///
  /// In en, this message translates to:
  /// **'Email Support'**
  String get emailSupport;

  /// No description provided for @visitInPerson.
  ///
  /// In en, this message translates to:
  /// **'Visit in person'**
  String get visitInPerson;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @thankYouFeedback.
  ///
  /// In en, this message translates to:
  /// **'Thank you for your feedback!'**
  String get thankYouFeedback;

  /// No description provided for @feedbackAppreciation.
  ///
  /// In en, this message translates to:
  /// **'We appreciate your input and will use it to improve the festival experience.'**
  String get feedbackAppreciation;

  /// No description provided for @aboutFeedback.
  ///
  /// In en, this message translates to:
  /// **'About Feedback'**
  String get aboutFeedback;

  /// No description provided for @featureComingSoon.
  ///
  /// In en, this message translates to:
  /// **'This feature is coming soon...'**
  String get featureComingSoon;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @errorSubmittingFeedback.
  ///
  /// In en, this message translates to:
  /// **'Error submitting feedback: {error}'**
  String errorSubmittingFeedback(Object error);

  /// No description provided for @bunaForum.
  ///
  /// In en, this message translates to:
  /// **'Buna Forum'**
  String get bunaForum;

  /// No description provided for @qrScanner.
  ///
  /// In en, this message translates to:
  /// **'QR Scanner'**
  String get qrScanner;

  /// No description provided for @aboutQRScanner.
  ///
  /// In en, this message translates to:
  /// **'About QR Scanner'**
  String get aboutQRScanner;

  /// No description provided for @scanFestivalQRCodes.
  ///
  /// In en, this message translates to:
  /// **'Scan Festival QR Codes'**
  String get scanFestivalQRCodes;

  /// No description provided for @scanQRCodesDescription.
  ///
  /// In en, this message translates to:
  /// **'Scan QR codes around the festival to unlock exclusive content, get event information, and earn rewards.'**
  String get scanQRCodesDescription;

  /// No description provided for @eventInformation.
  ///
  /// In en, this message translates to:
  /// **'Event Information'**
  String get eventInformation;

  /// No description provided for @eventInfoContent.
  ///
  /// In en, this message translates to:
  /// **'Opening Ceremony\n\nTime: 7:00 PM\nVenue: Main Square\n\nJoin us for the spectacular opening of Buna Festival 2024!'**
  String get eventInfoContent;

  /// No description provided for @venueInformation.
  ///
  /// In en, this message translates to:
  /// **'Venue Information'**
  String get venueInformation;

  /// No description provided for @venueInfoContent.
  ///
  /// In en, this message translates to:
  /// **'Main Square\n\nAddress: Central Square, Varna\n\nPrimary venue for major festival events.'**
  String get venueInfoContent;

  /// No description provided for @artistInformation.
  ///
  /// In en, this message translates to:
  /// **'Artist Information'**
  String get artistInformation;

  /// No description provided for @artistInfoContent.
  ///
  /// In en, this message translates to:
  /// **'Elena Rodriguez\n\nLight artist from Spain.\n\nKnown for large-scale installations.'**
  String get artistInfoContent;

  /// No description provided for @workshopInformation.
  ///
  /// In en, this message translates to:
  /// **'Workshop Information'**
  String get workshopInformation;

  /// No description provided for @workshopInfoContent.
  ///
  /// In en, this message translates to:
  /// **'Digital Art Workshop\n\nLearn about digital art techniques and tools.\n\nOpen to all ages.'**
  String get workshopInfoContent;

  /// No description provided for @rewardUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Reward Unlocked!'**
  String get rewardUnlocked;

  /// No description provided for @rewardInfoContent.
  ///
  /// In en, this message translates to:
  /// **'Free Coffee\n\nShow this code at any festival café to claim your free coffee!'**
  String get rewardInfoContent;

  /// No description provided for @claim.
  ///
  /// In en, this message translates to:
  /// **'Claim'**
  String get claim;

  /// No description provided for @qrCodeInformation.
  ///
  /// In en, this message translates to:
  /// **'QR Code Information'**
  String get qrCodeInformation;

  /// No description provided for @qrCodeInfoContent.
  ///
  /// In en, this message translates to:
  /// **'Code: {code}\n\nThis QR code contains festival information.'**
  String qrCodeInfoContent(Object code);

  /// No description provided for @sharingQRCode.
  ///
  /// In en, this message translates to:
  /// **'Sharing QR code: {code}'**
  String sharingQRCode(Object code);

  /// No description provided for @generateQRCode.
  ///
  /// In en, this message translates to:
  /// **'Generate QR Code'**
  String get generateQRCode;

  /// No description provided for @qrCodeGenerationComingSoon.
  ///
  /// In en, this message translates to:
  /// **'QR code generation feature coming soon...'**
  String get qrCodeGenerationComingSoon;

  /// No description provided for @scanFromGallery.
  ///
  /// In en, this message translates to:
  /// **'Scan from Gallery'**
  String get scanFromGallery;

  /// No description provided for @galleryScanningComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Gallery scanning feature coming soon...'**
  String get galleryScanningComingSoon;

  /// No description provided for @mapGallery.
  ///
  /// In en, this message translates to:
  /// **'Map Gallery'**
  String get mapGallery;

  /// No description provided for @openFullMap.
  ///
  /// In en, this message translates to:
  /// **'Open full map'**
  String get openFullMap;

  /// No description provided for @filterOptions.
  ///
  /// In en, this message translates to:
  /// **'Filter options'**
  String get filterOptions;

  /// No description provided for @tabGrid.
  ///
  /// In en, this message translates to:
  /// **'Grid'**
  String get tabGrid;

  /// No description provided for @tabList.
  ///
  /// In en, this message translates to:
  /// **'List'**
  String get tabList;

  /// No description provided for @tabMap.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get tabMap;

  /// No description provided for @fullMap.
  ///
  /// In en, this message translates to:
  /// **'Full Map'**
  String get fullMap;

  /// No description provided for @fullMapComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Full interactive map coming soon!'**
  String get fullMapComingSoon;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location: {location}'**
  String locationLabel(Object location);

  /// No description provided for @categoryLabel.
  ///
  /// In en, this message translates to:
  /// **'Category: {category}'**
  String categoryLabel(Object category);

  /// No description provided for @tagsLabel.
  ///
  /// In en, this message translates to:
  /// **'Tags: {tags}'**
  String tagsLabel(Object tags);

  /// No description provided for @loginRequired.
  ///
  /// In en, this message translates to:
  /// **'Login Required'**
  String get loginRequired;

  /// No description provided for @loginToAccess.
  ///
  /// In en, this message translates to:
  /// **'Please log in to access this feature.'**
  String get loginToAccess;
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
