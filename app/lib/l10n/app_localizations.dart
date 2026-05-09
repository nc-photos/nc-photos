import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_zh.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ca'),
    Locale('cs'),
    Locale('de'),
    Locale('el'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sk'),
    Locale('tr'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get appTitle;

  /// Name of the translator(s) for this language
  ///
  /// In en, this message translates to:
  /// **''**
  String get translator;

  /// Label of the tab that lists user photos
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get photosTabLabel;

  /// Groups of photos, e.g., albums, trash bin, etc
  ///
  /// In en, this message translates to:
  /// **'Collections'**
  String get collectionsTooltip;

  /// Tooltip of the zoom button
  ///
  /// In en, this message translates to:
  /// **'Zoom'**
  String get zoomTooltip;

  /// Label of the settings entry in menu
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsMenuLabel;

  /// Title of the contextual app bar that shows number of selected items
  ///
  /// In en, this message translates to:
  /// **'{count, plural, other{{count} selected}}'**
  String selectionAppBarTitle(num count);

  /// Inform user that the selected items are being deleted
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Deleting 1 item} other{Deleting {count} items}}'**
  String deleteSelectedProcessingNotification(num count);

  /// Inform user that the selected items are deleted successfully
  ///
  /// In en, this message translates to:
  /// **'All items deleted successfully'**
  String get deleteSelectedSuccessNotification;

  /// Inform user that some/all the selected items cannot be deleted
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Failed deleting 1 item} other{Failed deleting {count} items}}'**
  String deleteSelectedFailureNotification(num count);

  /// Archive selected items
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archiveTooltip;

  /// Archived all selected items successfully
  ///
  /// In en, this message translates to:
  /// **'All items archived successfully'**
  String get archiveSelectedSuccessNotification;

  /// Cannot archive some of the selected items
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Failed archiving 1 item} other{Failed archiving {count} items}}'**
  String archiveSelectedFailureNotification(num count);

  /// Unarchive selected items
  ///
  /// In en, this message translates to:
  /// **'Unarchive'**
  String get unarchiveTooltip;

  /// Unarchived all selected items successfully
  ///
  /// In en, this message translates to:
  /// **'All items unarchived successfully'**
  String get unarchiveSelectedSuccessNotification;

  /// Cannot unarchive some of the selected items
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Failed unarchiving 1 item} other{Failed unarchiving {count} items}}'**
  String unarchiveSelectedFailureNotification(num count);

  /// Delete selected items
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get deleteTooltip;

  /// Inform user that the item is deleted successfully
  ///
  /// In en, this message translates to:
  /// **'Deleted item successfully'**
  String get deleteSuccessNotification;

  /// Inform user that the item cannot be deleted
  ///
  /// In en, this message translates to:
  /// **'Failed deleting item'**
  String get deleteFailureNotification;

  /// Inform user that the selected items cannot be removed from an album
  ///
  /// In en, this message translates to:
  /// **'Failed removing items from album'**
  String get removeSelectedFromAlbumFailureNotification;

  /// Tooltip of the button that adds a new server
  ///
  /// In en, this message translates to:
  /// **'Add server'**
  String get addServerTooltip;

  /// Inform user that a server is removed successfully
  ///
  /// In en, this message translates to:
  /// **'Removed {server} successfully'**
  String removeServerSuccessNotification(Object server);

  /// Tooltip of the button that creates a new album
  ///
  /// In en, this message translates to:
  /// **'New album'**
  String get createAlbumTooltip;

  /// Number of items inside an album
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =0{Empty} one{1 item} other{{count} items}}'**
  String albumSize(num count);

  /// A collection containing all archived photos
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get albumArchiveLabel;

  /// (deprecated, may be removed in the future) Inform user that the app is connecting to a server
  ///
  /// In en, this message translates to:
  /// **'Connecting to\n{server}'**
  String connectingToServer(Object server);

  /// Shown when the app is waiting for the user to sign in via an external browser
  ///
  /// In en, this message translates to:
  /// **'Waiting for the server to authorize us'**
  String get connectingToServer2;

  /// Shown when the app is waiting for the user to sign in via an external browser
  ///
  /// In en, this message translates to:
  /// **'Please sign in via the opened browser'**
  String get connectingToServerInstruction;

  /// Hint of the text field expecting name data
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get nameInputHint;

  /// Shown when a name input is required but value not given. This is intended to be a generic message and does not assume what this 'name' represents
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameInputInvalidEmpty;

  /// Label of the skip button
  ///
  /// In en, this message translates to:
  /// **'SKIP'**
  String get skipButtonLabel;

  /// Label of the confirm button
  ///
  /// In en, this message translates to:
  /// **'CONFIRM'**
  String get confirmButtonLabel;

  /// (deprecated, may be removed in the future)
  ///
  /// In en, this message translates to:
  /// **'Sign in to Nextcloud server'**
  String get signInHeaderText;

  /// (deprecated, may be removed in the future)
  ///
  /// In en, this message translates to:
  /// **'Use an app password if you have two-factor authentication enabled in the server'**
  String get signIn2faHintText;

  /// Sign in to Nextcloud server
  ///
  /// In en, this message translates to:
  /// **'Nextcloud\nSign in'**
  String get signInHeaderText2;

  /// Hint of the text field expecting server address data
  ///
  /// In en, this message translates to:
  /// **'Server address'**
  String get serverAddressInputHint;

  /// Inform user that the server address input field cannot be empty
  ///
  /// In en, this message translates to:
  /// **'Please enter the server address'**
  String get serverAddressInputInvalidEmpty;

  /// Hint of the text field expecting username data
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get usernameInputHint;

  /// Inform user that the username input field cannot be empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your username'**
  String get usernameInputInvalidEmpty;

  /// Hint of the text field expecting password data
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordInputHint;

  /// Inform user that the password input field cannot be empty
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordInputInvalidEmpty;

  /// Inform user what to do in root picker widget
  ///
  /// In en, this message translates to:
  /// **'Pick the folders to be included'**
  String get rootPickerHeaderText;

  /// Inform user what to do in root picker widget
  ///
  /// In en, this message translates to:
  /// **'Only photos inside the folders will be shown. Press Skip to include all'**
  String get rootPickerSubHeaderText;

  /// Text of the list item to navigate up the directory tree
  ///
  /// In en, this message translates to:
  /// **'(go back)'**
  String get rootPickerNavigateUpItemText;

  /// Failed while unpicking an item in the root picker list
  ///
  /// In en, this message translates to:
  /// **'Failed unpicking item'**
  String get rootPickerUnpickFailureNotification;

  /// Error when user pressing confirm without picking any folders
  ///
  /// In en, this message translates to:
  /// **'Please pick at least one folder or press skip to include all'**
  String get rootPickerListEmptyNotification;

  /// Title of the introductory widget
  ///
  /// In en, this message translates to:
  /// **'Getting started'**
  String get setupWidgetTitle;

  /// Inform user that they can modify this setting after the setup process
  ///
  /// In en, this message translates to:
  /// **'You can change this later in Settings'**
  String get setupSettingsModifyLaterHint;

  /// Inform user about the preference folder created by this app
  ///
  /// In en, this message translates to:
  /// **'This app creates a folder on the Nextcloud server to store preference files. Please do not modify or remove it unless you plan to remove this app'**
  String get setupHiddenPrefDirNoticeDetail;

  /// Title of the Settings widget
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsWidgetTitle;

  /// Set display language
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageTitle;

  /// Follow the Android system language
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageOptionSystemDefaultLabel;

  /// Metadata (e.g., date, resolution, GPS, etc)
  ///
  /// In en, this message translates to:
  /// **'File metadata'**
  String get settingsMetadataTitle;

  /// Title of the EXIF support setting
  ///
  /// In en, this message translates to:
  /// **'Client-side EXIF support'**
  String get settingsExifSupportTitle2;

  /// Subtitle of the EXIF support setting when the value is true. The goal is to warn user about the possible side effects of enabling this setting
  ///
  /// In en, this message translates to:
  /// **'Require extra network usage'**
  String get settingsExifSupportTrueSubtitle;

  /// Fallback to client side EXIF parser
  ///
  /// In en, this message translates to:
  /// **'Fall back to client-side parser'**
  String get settingsFallbackClientExifTitle;

  /// No description provided for @settingsFallbackClientExifTrueText.
  ///
  /// In en, this message translates to:
  /// **'If Nextcloud failed to extract the file metadata, use the client-side parser instead'**
  String get settingsFallbackClientExifTrueText;

  /// No description provided for @settingsFallbackClientExifFalseText.
  ///
  /// In en, this message translates to:
  /// **'If Nextcloud failed to extract the file metadata, leave it as is'**
  String get settingsFallbackClientExifFalseText;

  /// No description provided for @settingsFallbackClientExifConfirmDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enable client-side fallback?'**
  String get settingsFallbackClientExifConfirmDialogTitle;

  /// No description provided for @settingsFallbackClientExifConfirmDialogText.
  ///
  /// In en, this message translates to:
  /// **'Normally Nextcloud server will automatically process your photos and store the EXIF metadata in the background. However, the background job may fail due to a configuration issue or server bug. If enabled, we will process those files ourselves instead.'**
  String get settingsFallbackClientExifConfirmDialogText;

  /// Memory albums contain photos taken in a specific time range in the past
  ///
  /// In en, this message translates to:
  /// **'Memories'**
  String get settingsMemoriesTitle;

  /// Memory albums contain photos taken in a specific time range in the past
  ///
  /// In en, this message translates to:
  /// **'Show photos taken in the past'**
  String get settingsMemoriesSubtitle;

  /// No description provided for @settingsAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get settingsAccountTitle;

  /// An account label is used to replace the server URL in the app bar, could be useful for privacy reason
  ///
  /// In en, this message translates to:
  /// **'Label'**
  String get settingsAccountLabelTitle;

  /// No description provided for @settingsAccountLabelDescription.
  ///
  /// In en, this message translates to:
  /// **'Set a label to be shown in place of the server URL'**
  String get settingsAccountLabelDescription;

  /// Change the included folders of an account
  ///
  /// In en, this message translates to:
  /// **'Included folders'**
  String get settingsIncludedFoldersTitle;

  /// Set the share folder such that it matches the parameter in config.php
  ///
  /// In en, this message translates to:
  /// **'Share folder'**
  String get settingsShareFolderTitle;

  /// Set the share folder such that it matches the parameter in config.php
  ///
  /// In en, this message translates to:
  /// **'Locate the share folder'**
  String get settingsShareFolderDialogTitle;

  /// Set the share folder such that it matches the parameter in config.php
  ///
  /// In en, this message translates to:
  /// **'This setting corresponds to the share_folder parameter in config.php. The two values MUST be identical.\n\nPlease locate the same folder as the one set in config.php.'**
  String get settingsShareFolderDialogDescription;

  /// Set the share folder such that it matches the parameter in config.php
  ///
  /// In en, this message translates to:
  /// **'Please locate the same folder as the one set in config.php. Press default if you did not set the parameter.'**
  String get settingsShareFolderPickerDescription;

  /// Select the server app for face recognition
  ///
  /// In en, this message translates to:
  /// **'Person provider'**
  String get settingsPersonProviderTitle;

  /// Enable/disable various server apps
  ///
  /// In en, this message translates to:
  /// **'Server app support'**
  String get settingsServerAppSectionTitle;

  /// The 'Photos' here means the tab called 'Photos', not literally a photo. The title of this setting will also reuse the label of that tab
  ///
  /// In en, this message translates to:
  /// **'Customize contents shown in the Photos tab'**
  String get settingsPhotosDescription;

  /// How many adjacent days to be included in memories for a particular year
  ///
  /// In en, this message translates to:
  /// **'Memories range'**
  String get settingsMemoriesRangeTitle;

  /// How many adjacent days to be included in memories for a particular year, could be 0
  ///
  /// In en, this message translates to:
  /// **'{range, plural, one{+-{range} day} other{+-{range} days}}'**
  String settingsMemoriesRangeValueText(num range);

  /// Control which device folders to be included in the timeline
  ///
  /// In en, this message translates to:
  /// **'Show device media'**
  String get settingsDeviceMediaTitle;

  /// Control which device folders to be included in the timeline
  ///
  /// In en, this message translates to:
  /// **'Selected folders will be displayed'**
  String get settingsDeviceMediaDescription;

  /// No description provided for @settingsViewerTitle.
  ///
  /// In en, this message translates to:
  /// **'Viewer'**
  String get settingsViewerTitle;

  /// No description provided for @settingsViewerDescription.
  ///
  /// In en, this message translates to:
  /// **'Customize the image/video viewer'**
  String get settingsViewerDescription;

  /// No description provided for @settingsScreenBrightnessTitle.
  ///
  /// In en, this message translates to:
  /// **'Screen brightness'**
  String get settingsScreenBrightnessTitle;

  /// No description provided for @settingsScreenBrightnessDescription.
  ///
  /// In en, this message translates to:
  /// **'Override system brightness level'**
  String get settingsScreenBrightnessDescription;

  /// No description provided for @settingsForceRotationTitle.
  ///
  /// In en, this message translates to:
  /// **'Ignore rotation lock'**
  String get settingsForceRotationTitle;

  /// No description provided for @settingsForceRotationDescription.
  ///
  /// In en, this message translates to:
  /// **'Rotate the screen even when auto rotation is disabled'**
  String get settingsForceRotationDescription;

  /// No description provided for @settingsMapProviderTitle.
  ///
  /// In en, this message translates to:
  /// **'Map provider'**
  String get settingsMapProviderTitle;

  /// No description provided for @settingsViewerCustomizeAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize app bar'**
  String get settingsViewerCustomizeAppBarTitle;

  /// No description provided for @settingsViewerCustomizeBottomAppBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize bottom app bar'**
  String get settingsViewerCustomizeBottomAppBarTitle;

  /// No description provided for @settingsShowDateInAlbumTitle.
  ///
  /// In en, this message translates to:
  /// **'Group photos by date'**
  String get settingsShowDateInAlbumTitle;

  /// No description provided for @settingsShowDateInAlbumDescription.
  ///
  /// In en, this message translates to:
  /// **'Apply only when the album is sorted by time'**
  String get settingsShowDateInAlbumDescription;

  /// No description provided for @settingsCollectionsCustomizeNavigationBarTitle.
  ///
  /// In en, this message translates to:
  /// **'Customize navigation bar'**
  String get settingsCollectionsCustomizeNavigationBarTitle;

  /// Include settings for image enhancements and the image editor
  ///
  /// In en, this message translates to:
  /// **'Editor'**
  String get settingsImageEditTitle;

  /// No description provided for @settingsImageEditDescription.
  ///
  /// In en, this message translates to:
  /// **'Customize image enhancements and the image editor'**
  String get settingsImageEditDescription;

  /// No description provided for @settingsEnhanceMaxResolutionTitle2.
  ///
  /// In en, this message translates to:
  /// **'Image resolution for enhancements'**
  String get settingsEnhanceMaxResolutionTitle2;

  /// No description provided for @settingsEnhanceMaxResolutionDescription.
  ///
  /// In en, this message translates to:
  /// **'Photos larger than the selected resolution will be downscaled.\n\nHigh resolution photos require significantly more memory and time to process. Please lower this setting if the app crashed while enhancing your photos.'**
  String get settingsEnhanceMaxResolutionDescription;

  /// Whether to save the edit/enhance results to server instead of the current device
  ///
  /// In en, this message translates to:
  /// **'Save results to server'**
  String get settingsImageEditSaveResultsToServerTitle;

  /// No description provided for @settingsImageEditSaveResultsToServerTrueDescription.
  ///
  /// In en, this message translates to:
  /// **'Results are saved to server, falling back to device storage if the upload fails'**
  String get settingsImageEditSaveResultsToServerTrueDescription;

  /// No description provided for @settingsImageEditSaveResultsToServerFalseDescription.
  ///
  /// In en, this message translates to:
  /// **'Results are saved to this device'**
  String get settingsImageEditSaveResultsToServerFalseDescription;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeTitle;

  /// No description provided for @settingsThemeDescription.
  ///
  /// In en, this message translates to:
  /// **'Customize the appearance of the app'**
  String get settingsThemeDescription;

  /// Respect the system dark mode settings introduced on Android 10
  ///
  /// In en, this message translates to:
  /// **'Follow system theme'**
  String get settingsFollowSystemThemeTitle;

  /// Customize the colors used in app
  ///
  /// In en, this message translates to:
  /// **'Theme color'**
  String get settingsSeedColorTitle;

  /// Customize the colors used in app
  ///
  /// In en, this message translates to:
  /// **'Used to derive all colors used in the app'**
  String get settingsSeedColorDescription;

  /// Use color provided by the OS, i.e., Material You
  ///
  /// In en, this message translates to:
  /// **'Use system color'**
  String get settingsSeedColorSystemColorDescription;

  /// Dialog to customize the colors used in app
  ///
  /// In en, this message translates to:
  /// **'Pick a color'**
  String get settingsSeedColorPickerTitle;

  /// No description provided for @settingsThemePrimaryColor.
  ///
  /// In en, this message translates to:
  /// **'Primary'**
  String get settingsThemePrimaryColor;

  /// No description provided for @settingsThemeSecondaryColor.
  ///
  /// In en, this message translates to:
  /// **'Secondary'**
  String get settingsThemeSecondaryColor;

  /// No description provided for @settingsThemePresets.
  ///
  /// In en, this message translates to:
  /// **'Presets'**
  String get settingsThemePresets;

  /// Use color provided by the OS, i.e., Material You
  ///
  /// In en, this message translates to:
  /// **'USE SYSTEM COLOR'**
  String get settingsSeedColorPickerSystemColorButtonLabel;

  /// Make the dark theme darker
  ///
  /// In en, this message translates to:
  /// **'Darker theme'**
  String get settingsUseBlackInDarkThemeTitle;

  /// When black in dark theme is set to true
  ///
  /// In en, this message translates to:
  /// **'Use black in dark theme'**
  String get settingsUseBlackInDarkThemeTrueDescription;

  /// When black in dark theme is set to false
  ///
  /// In en, this message translates to:
  /// **'Use dark grey in dark theme'**
  String get settingsUseBlackInDarkThemeFalseDescription;

  /// No description provided for @settingsMiscellaneousTitle.
  ///
  /// In en, this message translates to:
  /// **'Miscellaneous'**
  String get settingsMiscellaneousTitle;

  /// If enabled, users need to tap the back button twice to exit app
  ///
  /// In en, this message translates to:
  /// **'Double tap to exit'**
  String get settingsDoubleTapExitTitle;

  /// Sort photos listed in the Photos tab by filename (descending)
  ///
  /// In en, this message translates to:
  /// **'Sort by filename in Photos'**
  String get settingsPhotosTabSortByNameTitle;

  /// If enabled, users need to authenticate themselves when opening the app
  ///
  /// In en, this message translates to:
  /// **'App lock'**
  String get settingsAppLock;

  /// Unlock app with fingerprint, face, etc
  ///
  /// In en, this message translates to:
  /// **'Biometric'**
  String get settingsAppLockTypeBiometric;

  /// Unlock app with 4 to 6 digits PIN
  ///
  /// In en, this message translates to:
  /// **'PIN'**
  String get settingsAppLockTypePin;

  /// Unlock app with password
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get settingsAppLockTypePassword;

  /// No description provided for @settingsAppLockDescription.
  ///
  /// In en, this message translates to:
  /// **'If enabled, you will be asked to authenticate when you open the app. This feature does NOT protect you against real-world attacks.'**
  String get settingsAppLockDescription;

  /// No description provided for @settingsAppLockSetupBiometricFallbackDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick the fallback when biometric is not available'**
  String get settingsAppLockSetupBiometricFallbackDialogTitle;

  /// No description provided for @settingsAppLockSetupPinDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Set the PIN to unlock app'**
  String get settingsAppLockSetupPinDialogTitle;

  /// No description provided for @settingsAppLockConfirmPinDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the same PIN again'**
  String get settingsAppLockConfirmPinDialogTitle;

  /// No description provided for @settingsAppLockSetupPasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Set the password to unlock app'**
  String get settingsAppLockSetupPasswordDialogTitle;

  /// No description provided for @settingsAppLockConfirmPasswordDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter the same password again'**
  String get settingsAppLockConfirmPasswordDialogTitle;

  /// No description provided for @settingsViewerUseOriginalImageTitle.
  ///
  /// In en, this message translates to:
  /// **'Show original image instead of high quality preview in viewer'**
  String get settingsViewerUseOriginalImageTitle;

  /// No description provided for @settingsExperimentalTitle.
  ///
  /// In en, this message translates to:
  /// **'Experimental'**
  String get settingsExperimentalTitle;

  /// No description provided for @settingsExperimentalDescription.
  ///
  /// In en, this message translates to:
  /// **'Features that are not ready for everyday use'**
  String get settingsExperimentalDescription;

  /// Settings that must be tweaked with caution
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get settingsExpertTitle;

  /// No description provided for @settingsExpertWarningText.
  ///
  /// In en, this message translates to:
  /// **'Please make sure you fully understand what each option does before proceeding'**
  String get settingsExpertWarningText;

  /// No description provided for @settingsClearCacheDatabaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear file database'**
  String get settingsClearCacheDatabaseTitle;

  /// No description provided for @settingsClearCacheDatabaseDescription.
  ///
  /// In en, this message translates to:
  /// **'Clear cached file info and trigger a complete resync with the server'**
  String get settingsClearCacheDatabaseDescription;

  /// No description provided for @settingsClearCacheDatabaseSuccessNotification.
  ///
  /// In en, this message translates to:
  /// **'Database cleared successfully. You are suggested to restart the app'**
  String get settingsClearCacheDatabaseSuccessNotification;

  /// No description provided for @settingsManageTrustedCertificateTitle.
  ///
  /// In en, this message translates to:
  /// **'Manage trusted certificates'**
  String get settingsManageTrustedCertificateTitle;

  /// No description provided for @settingsUseNewHttpEngine.
  ///
  /// In en, this message translates to:
  /// **'Use new HTTP engine'**
  String get settingsUseNewHttpEngine;

  /// No description provided for @settingsUseNewHttpEngineDescription.
  ///
  /// In en, this message translates to:
  /// **'New HTTP engine based on Chromium, supporting new standards like HTTP/2* and HTTP/3 QUIC*.\n\nLimitations:\nSelf-signed certs can no longer be managed by us. You must import your CA certs to the system trust store for them to work.\n\n* HTTPS is required for HTTP/2 and HTTP/3'**
  String get settingsUseNewHttpEngineDescription;

  /// Title of the about section in settings widget
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSectionTitle;

  /// Title of the version data item
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get settingsVersionTitle;

  /// This item will show the server software version, e.g., Nextcloud 25
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get settingsServerVersionTitle;

  /// Title of the source code item
  ///
  /// In en, this message translates to:
  /// **'Source code'**
  String get settingsSourceCodeTitle;

  /// Report issue
  ///
  /// In en, this message translates to:
  /// **'Report issue'**
  String get settingsBugReportTitle;

  /// Capture app logs for bug report
  ///
  /// In en, this message translates to:
  /// **'Capture logs'**
  String get settingsCaptureLogsTitle;

  /// No description provided for @settingsCaptureLogsDescription.
  ///
  /// In en, this message translates to:
  /// **'Help developer to diagnose bugs'**
  String get settingsCaptureLogsDescription;

  /// Title of the translator item
  ///
  /// In en, this message translates to:
  /// **'Translator'**
  String get settingsTranslatorTitle;

  /// No description provided for @settingsRestartNeededDialog.
  ///
  /// In en, this message translates to:
  /// **'Please restart the app to apply changes'**
  String get settingsRestartNeededDialog;

  /// Inform user that the preference file cannot be modified
  ///
  /// In en, this message translates to:
  /// **'Failed setting preference'**
  String get writePreferenceFailureNotification;

  /// Label of the enable button
  ///
  /// In en, this message translates to:
  /// **'ENABLE'**
  String get enableButtonLabel;

  /// No description provided for @enableButtonLabel2.
  ///
  /// In en, this message translates to:
  /// **'Enable'**
  String get enableButtonLabel2;

  /// Extra notes for Nextcloud 28+
  ///
  /// In en, this message translates to:
  /// **'Client-side support complements your server. The app will process files and attributes not supported by Nextcloud'**
  String get exifSupportNextcloud28Notes;

  /// Title of the dialog to confirm enabling exif support
  ///
  /// In en, this message translates to:
  /// **'Enable client-side EXIF support?'**
  String get exifSupportConfirmationDialogTitle2;

  /// Detailed description on capturing logs
  ///
  /// In en, this message translates to:
  /// **'To take logs for a bug report:\n\n1. Enable this setting\n2. Reproduce the issue\n3. Disable this setting\n4. Look for nc-photos.log in the download folder\n\n*If the issue causes the app to crash, no logs could be captured. In such cases, please contact the developer for further instructions'**
  String get captureLogDetails;

  /// Captured logs are successfully saved to the download directory
  ///
  /// In en, this message translates to:
  /// **'Logs saved successfully'**
  String get captureLogSuccessNotification;

  /// Label of the done button
  ///
  /// In en, this message translates to:
  /// **'DONE'**
  String get doneButtonLabel;

  /// Label of the next button
  ///
  /// In en, this message translates to:
  /// **'NEXT'**
  String get nextButtonLabel;

  /// Label of the connect button
  ///
  /// In en, this message translates to:
  /// **'CONNECT'**
  String get connectButtonLabel;

  /// Warn user not to include all files in their server
  ///
  /// In en, this message translates to:
  /// **'All your files will be included. This may increase the memory usage and degrade performance'**
  String get rootPickerSkipConfirmationDialogContent2;

  /// Resolution of an image in megapixel
  ///
  /// In en, this message translates to:
  /// **'{count}MP'**
  String megapixelCount(Object count);

  /// Number of seconds
  ///
  /// In en, this message translates to:
  /// **'{count}s'**
  String secondCountSymbol(Object count);

  /// Number of millimeters
  ///
  /// In en, this message translates to:
  /// **'{count}mm'**
  String millimeterCountSymbol(Object count);

  /// Tooltip of the details button
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsTooltip;

  /// Tooltip of the download button
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get downloadTooltip;

  /// Inform user that the file is being downloaded
  ///
  /// In en, this message translates to:
  /// **'Downloading file'**
  String get downloadProcessingNotification;

  /// Inform user that the file is downloaded successfully
  ///
  /// In en, this message translates to:
  /// **'Downloaded file successfully'**
  String get downloadSuccessNotification;

  /// Inform user that the file cannot be downloaded
  ///
  /// In en, this message translates to:
  /// **'Failed downloading file'**
  String get downloadFailureNotification;

  /// Tooltip of the next button
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get nextTooltip;

  /// Tooltip of the previous button
  ///
  /// In en, this message translates to:
  /// **'Previous'**
  String get previousTooltip;

  /// Inform web user how to select items in range
  ///
  /// In en, this message translates to:
  /// **'Hold shift + click to select all in between'**
  String get webSelectRangeNotification;

  /// Inform mobile user how to select items in range
  ///
  /// In en, this message translates to:
  /// **'Long press another item to select all in between'**
  String get mobileSelectRangeNotification;

  /// Dialog to modify the date & time of a file
  ///
  /// In en, this message translates to:
  /// **'Modify date & time'**
  String get updateDateTimeDialogTitle;

  /// No description provided for @dateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get dateSubtitle;

  /// No description provided for @timeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get timeSubtitle;

  /// No description provided for @dateYearInputHint.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get dateYearInputHint;

  /// No description provided for @dateMonthInputHint.
  ///
  /// In en, this message translates to:
  /// **'Month'**
  String get dateMonthInputHint;

  /// No description provided for @dateDayInputHint.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get dateDayInputHint;

  /// No description provided for @timeHourInputHint.
  ///
  /// In en, this message translates to:
  /// **'Hour'**
  String get timeHourInputHint;

  /// No description provided for @timeMinuteInputHint.
  ///
  /// In en, this message translates to:
  /// **'Minute'**
  String get timeMinuteInputHint;

  /// No description provided for @timeSecondInputHint.
  ///
  /// In en, this message translates to:
  /// **'Second'**
  String get timeSecondInputHint;

  /// Invalid date/time input (e.g., non-numeric characters)
  ///
  /// In en, this message translates to:
  /// **'Invalid value'**
  String get dateTimeInputInvalid;

  /// Failed to set the date & time of a file
  ///
  /// In en, this message translates to:
  /// **'Failed modifying date & time'**
  String get updateDateTimeFailureNotification;

  /// Pick the folders for a folder based album
  ///
  /// In en, this message translates to:
  /// **'Pick the folders to be associated'**
  String get albumDirPickerHeaderText;

  /// Pick the folders for a folder based album
  ///
  /// In en, this message translates to:
  /// **'Only photos in the associated folders will be included in this album'**
  String get albumDirPickerSubHeaderText;

  /// Error when user pressing confirm without picking any folders
  ///
  /// In en, this message translates to:
  /// **'Please pick at least one folder'**
  String get albumDirPickerListEmptyNotification;

  /// Menu entry in the album page to import folders as albums
  ///
  /// In en, this message translates to:
  /// **'Import folders'**
  String get importFoldersTooltip;

  /// Import folders as albums
  ///
  /// In en, this message translates to:
  /// **'Import folders as albums'**
  String get albumImporterHeaderText;

  /// Import folders as albums
  ///
  /// In en, this message translates to:
  /// **'Suggested folders are listed below. Depending on the number of files on your server, it might take a while to finish'**
  String get albumImporterSubHeaderText;

  /// No description provided for @importButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'IMPORT'**
  String get importButtonLabel;

  /// Message shown while importing
  ///
  /// In en, this message translates to:
  /// **'Importing folders'**
  String get albumImporterProgressText;

  /// No description provided for @doneButtonTooltip.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get doneButtonTooltip;

  /// No description provided for @editTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get editTooltip;

  /// Error when user modified an account such that it's identical to another one
  ///
  /// In en, this message translates to:
  /// **'An account already exists with the same settings'**
  String get editAccountConflictFailureNotification;

  /// Generic dialog shown when the app is temporarily blocking user input to work on something
  ///
  /// In en, this message translates to:
  /// **'Please wait'**
  String get genericProcessingDialogContent;

  /// No description provided for @sortTooltip.
  ///
  /// In en, this message translates to:
  /// **'Sort'**
  String get sortTooltip;

  /// Select how the photos should be sorted
  ///
  /// In en, this message translates to:
  /// **'Sort by'**
  String get sortOptionDialogTitle;

  /// Sort by time, in ascending order
  ///
  /// In en, this message translates to:
  /// **'Oldest first'**
  String get sortOptionTimeAscendingLabel;

  /// Sort by time, in descending order
  ///
  /// In en, this message translates to:
  /// **'Newest first'**
  String get sortOptionTimeDescendingLabel;

  /// Sort by filename, in ascending order
  ///
  /// In en, this message translates to:
  /// **'Filename'**
  String get sortOptionFilenameAscendingLabel;

  /// Sort by filename, in descending order
  ///
  /// In en, this message translates to:
  /// **'Filename (descending)'**
  String get sortOptionFilenameDescendingLabel;

  /// Sort by album name, in ascending order
  ///
  /// In en, this message translates to:
  /// **'Album name'**
  String get sortOptionAlbumNameLabel;

  /// Sort by album name, in descending order
  ///
  /// In en, this message translates to:
  /// **'Album name (descending)'**
  String get sortOptionAlbumNameDescendingLabel;

  /// Sort manually
  ///
  /// In en, this message translates to:
  /// **'Manual'**
  String get sortOptionManualLabel;

  /// Instructions on how to rearrange photos
  ///
  /// In en, this message translates to:
  /// **'Long press and drag an item to rearrange it manually'**
  String get albumEditDragRearrangeNotification;

  /// Add some text that display between photos to an album
  ///
  /// In en, this message translates to:
  /// **'Add text'**
  String get albumAddTextTooltip;

  /// Share selected items to other apps
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareTooltip;

  /// Shown when user pressed the share button with only non-sharable items (e.g., text labels) selected
  ///
  /// In en, this message translates to:
  /// **'Select some photos to share'**
  String get shareSelectedEmptyNotification;

  /// Downloading photos to be shared
  ///
  /// In en, this message translates to:
  /// **'Downloading'**
  String get shareDownloadingDialogContent;

  /// No description provided for @searchTooltip.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get searchTooltip;

  /// Clear some sort of user input, typically a text field
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearTooltip;

  /// When there's nothing in a list
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get listNoResultsText;

  /// When there's nothing in a list
  ///
  /// In en, this message translates to:
  /// **'Empty'**
  String get listEmptyText;

  /// Deleted photos
  ///
  /// In en, this message translates to:
  /// **'Trash'**
  String get albumTrashLabel;

  /// Restore selected items from trashbin
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restoreTooltip;

  /// Restoring selected items from trashbin
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Restoring 1 item} other{Restoring {count} items}}'**
  String restoreSelectedProcessingNotification(num count);

  /// Restored all selected items from trashbin successfully
  ///
  /// In en, this message translates to:
  /// **'All items restored successfully'**
  String get restoreSelectedSuccessNotification;

  /// Cannot restore some of the selected items from trashbin
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Failed restoring 1 item} other{Failed restoring {count} items}}'**
  String restoreSelectedFailureNotification(num count);

  /// Restoring the opened item from trashbin
  ///
  /// In en, this message translates to:
  /// **'Restoring item'**
  String get restoreProcessingNotification;

  /// Restored the opened item from trashbin successfully
  ///
  /// In en, this message translates to:
  /// **'Restored item successfully'**
  String get restoreSuccessNotification;

  /// Cannot restore the opened item from trashbin
  ///
  /// In en, this message translates to:
  /// **'Failed restoring item'**
  String get restoreFailureNotification;

  /// Permanently delete selected items from trashbin
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deletePermanentlyTooltip;

  /// Make sure the user wants to delete the items
  ///
  /// In en, this message translates to:
  /// **'Delete permanently'**
  String get deletePermanentlyConfirmationDialogTitle;

  /// Make sure the user wants to delete the items
  ///
  /// In en, this message translates to:
  /// **'Selected items will be deleted permanently from the server.\n\nThis action is irreversible'**
  String get deletePermanentlyConfirmationDialogContent;

  /// A small label placed next to a shared album
  ///
  /// In en, this message translates to:
  /// **'Shared'**
  String get albumSharedLabel;

  /// Shown when the app is reading image metadata
  ///
  /// In en, this message translates to:
  /// **'Processing image metadata in the background'**
  String get metadataTaskProcessingNotification;

  /// No description provided for @configButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'CONFIG'**
  String get configButtonLabel;

  /// No description provided for @useAsAlbumCoverTooltip.
  ///
  /// In en, this message translates to:
  /// **'Use as album cover'**
  String get useAsAlbumCoverTooltip;

  /// No description provided for @helpTooltip.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get helpTooltip;

  /// No description provided for @helpButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'HELP'**
  String get helpButtonLabel;

  /// Remove the opened photo from an album
  ///
  /// In en, this message translates to:
  /// **'Remove from album'**
  String get removeFromAlbumTooltip;

  /// Title of the changelog page
  ///
  /// In en, this message translates to:
  /// **'Changelog'**
  String get changelogTitle;

  /// Title of the dialog to warn user about an untrusted SSL certificate
  ///
  /// In en, this message translates to:
  /// **'Server certificate cannot be trusted'**
  String get serverCertErrorDialogTitle;

  /// Warn user about an untrusted SSL certificate
  ///
  /// In en, this message translates to:
  /// **'The server may be hacked or someone is trying to steal your information'**
  String get serverCertErrorDialogContent;

  /// Label of the advanced button
  ///
  /// In en, this message translates to:
  /// **'ADVANCED'**
  String get advancedButtonLabel;

  /// Title of the dialog to let user decide whether to whitelist an untrusted SSL certificate
  ///
  /// In en, this message translates to:
  /// **'Whitelist unknown certificate?'**
  String get whitelistCertDialogTitle;

  /// Let user decide whether to whitelist an untrusted SSL certificate
  ///
  /// In en, this message translates to:
  /// **'You can whitelist the certificate to make the app accept it. WARNING: This poses a great security risk. Make sure the cert is self-signed by you or a trusted party\n\nHost: {host}\nFingerprint: {fingerprint}'**
  String whitelistCertDialogContent(Object host, Object fingerprint);

  /// Label of the whitelist certificate button
  ///
  /// In en, this message translates to:
  /// **'ACCEPT THE RISK AND WHITELIST'**
  String get whitelistCertButtonLabel;

  /// The app will show the owner of the file if it's being shared with you by others. The name of the owner is displayed above this line
  ///
  /// In en, this message translates to:
  /// **'Shared with you by this user'**
  String get fileSharedByDescription;

  /// Permanently delete all items from trashbin
  ///
  /// In en, this message translates to:
  /// **'Empty trash'**
  String get emptyTrashbinTooltip;

  /// Make sure the user wants to delete all items
  ///
  /// In en, this message translates to:
  /// **'Empty trash'**
  String get emptyTrashbinConfirmationDialogTitle;

  /// Make sure the user wants to delete all items
  ///
  /// In en, this message translates to:
  /// **'All items will be deleted permanently from the server.\n\nThis action is irreversible'**
  String get emptyTrashbinConfirmationDialogContent;

  /// Unset the cover of the opened album
  ///
  /// In en, this message translates to:
  /// **'Unset cover'**
  String get unsetAlbumCoverTooltip;

  /// Mute the video player
  ///
  /// In en, this message translates to:
  /// **'Mute'**
  String get muteTooltip;

  /// Unmute the video player
  ///
  /// In en, this message translates to:
  /// **'Unmute'**
  String get unmuteTooltip;

  /// Browse photos grouped by person
  ///
  /// In en, this message translates to:
  /// **'People'**
  String get collectionPeopleLabel;

  /// A button to start a slideshow from the current collection
  ///
  /// In en, this message translates to:
  /// **'Slideshow'**
  String get slideshowTooltip;

  /// Set up slideshow before starting
  ///
  /// In en, this message translates to:
  /// **'Set up slideshow'**
  String get slideshowSetupDialogTitle;

  /// Set the duration of each image in MM:SS format. This setting is ignored for videos
  ///
  /// In en, this message translates to:
  /// **'Image duration (MM:SS)'**
  String get slideshowSetupDialogDurationTitle;

  /// Whether to shuffle the collection
  ///
  /// In en, this message translates to:
  /// **'Shuffle'**
  String get slideshowSetupDialogShuffleTitle;

  /// Whether to restart the slideshow from the beginning after the last slide
  ///
  /// In en, this message translates to:
  /// **'Repeat'**
  String get slideshowSetupDialogRepeatTitle;

  /// Whether to play the slideshow in reverse order
  ///
  /// In en, this message translates to:
  /// **'Reverse'**
  String get slideshowSetupDialogReverseTitle;

  /// Copied the share link to clipboard
  ///
  /// In en, this message translates to:
  /// **'Link copied'**
  String get linkCopiedNotification;

  /// Let the user pick how they want to share
  ///
  /// In en, this message translates to:
  /// **'Share as'**
  String get shareMethodDialogTitle;

  /// Share the preview of a file
  ///
  /// In en, this message translates to:
  /// **'Preview'**
  String get shareMethodPreviewTitle;

  /// No description provided for @shareMethodPreviewDescription.
  ///
  /// In en, this message translates to:
  /// **'Share a reduced quality preview to other apps (only supports images)'**
  String get shareMethodPreviewDescription;

  /// Share the original file
  ///
  /// In en, this message translates to:
  /// **'Original file'**
  String get shareMethodOriginalFileTitle;

  /// No description provided for @shareMethodOriginalFileDescription.
  ///
  /// In en, this message translates to:
  /// **'Download the original file and share it to other apps'**
  String get shareMethodOriginalFileDescription;

  /// Create a share link on server and share it
  ///
  /// In en, this message translates to:
  /// **'Public link'**
  String get shareMethodPublicLinkTitle;

  /// No description provided for @shareMethodPublicLinkDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new public link on the server. Anyone with the link can access the file'**
  String get shareMethodPublicLinkDescription;

  /// Create a password protected share link on server and share it
  ///
  /// In en, this message translates to:
  /// **'Password protected link'**
  String get shareMethodPasswordLinkTitle;

  /// No description provided for @shareMethodPasswordLinkDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new password protected link on the server'**
  String get shareMethodPasswordLinkDescription;

  /// List items being shared by the current account
  ///
  /// In en, this message translates to:
  /// **'Sharing'**
  String get collectionSharingLabel;

  /// The date when this file was last shared by you
  ///
  /// In en, this message translates to:
  /// **'Last shared on {date}'**
  String fileLastSharedDescription(Object date);

  /// The date when this file was shared with you
  ///
  /// In en, this message translates to:
  /// **'{user} shared with you on {date}'**
  String fileLastSharedByOthersDescription(Object user, Object date);

  /// The date when this album was shared with you
  ///
  /// In en, this message translates to:
  /// **'{user} shared an album with you on {date}'**
  String albumLastSharedByOthersDescription(Object user, Object date);

  /// A list of users or links where this file is sharing with
  ///
  /// In en, this message translates to:
  /// **'Shared with'**
  String get sharedWithLabel;

  /// Remove a share
  ///
  /// In en, this message translates to:
  /// **'Unshare'**
  String get unshareTooltip;

  /// Removed a share
  ///
  /// In en, this message translates to:
  /// **'Removed share'**
  String get unshareSuccessNotification;

  /// Show where the file is located
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationLabel;

  /// Dialog shown when sharing multiple files as link
  ///
  /// In en, this message translates to:
  /// **'Nextcloud does not support share links for multiple files. The app will instead COPY the files to a new folder and share the folder instead.'**
  String get multipleFilesLinkShareDialogContent;

  /// Input field for folder name
  ///
  /// In en, this message translates to:
  /// **'Folder name'**
  String get folderNameInputHint;

  /// Folder name cannot be left empty
  ///
  /// In en, this message translates to:
  /// **'Please enter the name of the folder'**
  String get folderNameInputInvalidEmpty;

  /// Folder name contains characters that are not allowed
  ///
  /// In en, this message translates to:
  /// **'Contains invalid characters'**
  String get folderNameInputInvalidCharacters;

  /// Message shown when sharing files
  ///
  /// In en, this message translates to:
  /// **'Creating share'**
  String get createShareProgressText;

  /// Error message shown when some files cannot be copied
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{Failed copying 1 item} other{Failed copying {count} items}}'**
  String copyItemsFailureNotification(num count);

  /// Dialog shown after user unshared a dir originally created by the app to share multiple files
  ///
  /// In en, this message translates to:
  /// **'Delete folder?'**
  String get unshareLinkShareDirDialogTitle;

  /// Dialog shown after user unshared a dir originally created by the app to share multiple files
  ///
  /// In en, this message translates to:
  /// **'This folder was created by the app to share multiple files as a link. It is now no longer shared with any party, do you want to delete this folder?'**
  String get unshareLinkShareDirDialogContent;

  /// Albums shared with you are not automatically added to the Collections view, unless you choose to do so, which is what this button does
  ///
  /// In en, this message translates to:
  /// **'Add to Collections'**
  String get addToCollectionsViewTooltip;

  /// Dialog to share an album with another user
  ///
  /// In en, this message translates to:
  /// **'Share with user'**
  String get shareAlbumDialogTitle;

  /// Shared an album with another user successfully, but some files inside the album cannot be shared
  ///
  /// In en, this message translates to:
  /// **'Album shared with {user}, but failed to share some files'**
  String shareAlbumSuccessWithErrorNotification(Object user);

  /// Unshared an album with another user successfully, but some files inside the album cannot be unshared
  ///
  /// In en, this message translates to:
  /// **'Album unshared with {user}, but failed to unshare some files'**
  String unshareAlbumSuccessWithErrorNotification(Object user);

  /// Fix file shares in an album. Due to limitation of the server API, album and its files are shared separately, but they are both needed for shared album to work correctly. This button will attempt to synchronize them
  ///
  /// In en, this message translates to:
  /// **'Fix shares'**
  String get fixSharesTooltip;

  /// Fix an issue
  ///
  /// In en, this message translates to:
  /// **'Fix'**
  String get fixTooltip;

  /// Fix all listed issues
  ///
  /// In en, this message translates to:
  /// **'Fix all'**
  String get fixAllTooltip;

  /// The album is shared with user but a file is NOT
  ///
  /// In en, this message translates to:
  /// **'Not shared with {user}'**
  String missingShareDescription(Object user);

  /// The album is NOT shared with user but a file is
  ///
  /// In en, this message translates to:
  /// **'Shared with {user}'**
  String extraShareDescription(Object user);

  /// No description provided for @defaultButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'DEFAULT'**
  String get defaultButtonLabel;

  /// Input a user name to share this album with
  ///
  /// In en, this message translates to:
  /// **'Add user'**
  String get addUserInputHint;

  /// This dialog is shown when user first open a shared album
  ///
  /// In en, this message translates to:
  /// **'Introducing shared album'**
  String get sharedAlbumInfoDialogTitle;

  /// This dialog is shown when user first open a shared album
  ///
  /// In en, this message translates to:
  /// **'Shared album allows multiple users on the same server to access the same album. Please read carefully the limitations before continuing'**
  String get sharedAlbumInfoDialogContent;

  /// No description provided for @learnMoreButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'LEARN MORE'**
  String get learnMoreButtonLabel;

  /// Migrate database to work with the updated app
  ///
  /// In en, this message translates to:
  /// **'Updating database'**
  String get migrateDatabaseProcessingNotification;

  /// No description provided for @migrateDatabaseFailureNotification.
  ///
  /// In en, this message translates to:
  /// **'Failed migrating database'**
  String get migrateDatabaseFailureNotification;

  /// Memory albums are generated by the app and include photos in the past years
  ///
  /// In en, this message translates to:
  /// **'{count, plural, one{1 year ago} other{{count} years ago}}'**
  String memoryAlbumName(num count);

  /// The app failed to scan the user's home folder on signing in
  ///
  /// In en, this message translates to:
  /// **'Home folder not found'**
  String get homeFolderNotFoundDialogTitle;

  /// Ask the user to provide us the correct WebDAV URL
  ///
  /// In en, this message translates to:
  /// **'Please correct the WebDAV URL shown below. You can find the URL in the Nextcloud web interface.'**
  String get homeFolderNotFoundDialogContent;

  /// Home folder can't be left empty
  ///
  /// In en, this message translates to:
  /// **'Please enter the name of your home folder'**
  String get homeFolderInputInvalidEmpty;

  /// Create a new collection. A collection can be an album, a folder, or something else in the future
  ///
  /// In en, this message translates to:
  /// **'New collection'**
  String get createCollectionTooltip;

  /// Create an album as collection
  ///
  /// In en, this message translates to:
  /// **'Client-side album'**
  String get createCollectionDialogAlbumLabel2;

  /// Describe how an album collection works
  ///
  /// In en, this message translates to:
  /// **'Album with extra features, accessible only with this app'**
  String get createCollectionDialogAlbumDescription2;

  /// Create a folder as collection
  ///
  /// In en, this message translates to:
  /// **'Folder'**
  String get createCollectionDialogFolderLabel;

  /// Describe how a folder collection works
  ///
  /// In en, this message translates to:
  /// **'Show photos inside a folder'**
  String get createCollectionDialogFolderDescription;

  /// Browse photos added to favorites
  ///
  /// In en, this message translates to:
  /// **'Favorites'**
  String get collectionFavoritesLabel;

  /// Add photo to favorites
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get favoriteTooltip;

  /// Successfully added photos to favorites
  ///
  /// In en, this message translates to:
  /// **'Added to favorites'**
  String get favoriteSuccessNotification;

  /// Failed adding photos to favorites
  ///
  /// In en, this message translates to:
  /// **'Failed adding to favorites'**
  String get favoriteFailureNotification;

  /// Remove photo to favorites
  ///
  /// In en, this message translates to:
  /// **'Unfavorite'**
  String get unfavoriteTooltip;

  /// Successfully removed photos from favorites
  ///
  /// In en, this message translates to:
  /// **'Removed from favorites'**
  String get unfavoriteSuccessNotification;

  /// Failed removing photos from favorites
  ///
  /// In en, this message translates to:
  /// **'Failed removing from favorites'**
  String get unfavoriteFailureNotification;

  /// Create a collection containing files with tags
  ///
  /// In en, this message translates to:
  /// **'Tag'**
  String get createCollectionDialogTagLabel;

  /// Describe how a tag collection works
  ///
  /// In en, this message translates to:
  /// **'Show photos with specific tags'**
  String get createCollectionDialogTagDescription;

  /// Input a tag
  ///
  /// In en, this message translates to:
  /// **'Add tag'**
  String get addTagInputHint;

  /// At least 1 tag is required to create a tag collection. This error is shown when user try to create one without selecting any tags
  ///
  /// In en, this message translates to:
  /// **'Please add at least 1 tag'**
  String get tagPickerNoTagSelectedNotification;

  /// The background service is stopping itself
  ///
  /// In en, this message translates to:
  /// **'Stopping service'**
  String get backgroundServiceStopping;

  /// Shown when the app has paused reading image metadata due to low battery
  ///
  /// In en, this message translates to:
  /// **'Battery is low'**
  String get metadataTaskPauseLowBatteryNotification;

  /// Enhance a photo
  ///
  /// In en, this message translates to:
  /// **'Enhance'**
  String get enhanceTooltip;

  /// No description provided for @enhanceButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'ENHANCE'**
  String get enhanceButtonLabel;

  /// No description provided for @enhanceIntroDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Enhance your photos'**
  String get enhanceIntroDialogTitle;

  /// No description provided for @enhanceIntroDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Your photos are processed locally on your device. By default, they are downscaled to 2048x1536. You can adjust the output resolution in Settings'**
  String get enhanceIntroDialogDescription;

  /// Enhance a photo taken in low-light environment
  ///
  /// In en, this message translates to:
  /// **'Low-light enhancement'**
  String get enhanceLowLightTitle;

  /// No description provided for @enhanceLowLightDescription.
  ///
  /// In en, this message translates to:
  /// **'Brighten your photos taken in low-light environments'**
  String get enhanceLowLightDescription;

  /// This parameter sets how much brighter the output will be
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get enhanceLowLightParamBrightnessLabel;

  /// List photos on your device that were modified by the app, via image enhancements or the image editor
  ///
  /// In en, this message translates to:
  /// **'Edited (local)'**
  String get collectionEditedPhotosLabel;

  /// Make sure the user wants to delete the items from the current device
  ///
  /// In en, this message translates to:
  /// **'Selected items will be deleted permanently from this device.\n\nThis action is irreversible'**
  String get deletePermanentlyLocalConfirmationDialogContent;

  /// Blur the background of a photo
  ///
  /// In en, this message translates to:
  /// **'Portrait blur'**
  String get enhancePortraitBlurTitle;

  /// No description provided for @enhancePortraitBlurDescription.
  ///
  /// In en, this message translates to:
  /// **'Blur the background of your photos, works best with portraits'**
  String get enhancePortraitBlurDescription;

  /// This parameter sets the radius of the blur filter
  ///
  /// In en, this message translates to:
  /// **'Blurriness'**
  String get enhancePortraitBlurParamBlurLabel;

  /// Upscale an image. The algorithm implemented in the app will upscale to 4x the original resolution (eg, 100x100 to 400x400)
  ///
  /// In en, this message translates to:
  /// **'Super-resolution (4x)'**
  String get enhanceSuperResolution4xTitle;

  /// No description provided for @enhanceSuperResolution4xDescription.
  ///
  /// In en, this message translates to:
  /// **'Enlarge your photos to 4x of their original resolution (see Help for details on how max resolution applies here)'**
  String get enhanceSuperResolution4xDescription;

  /// Transfer the image style from a reference image to a photo
  ///
  /// In en, this message translates to:
  /// **'Style transfer'**
  String get enhanceStyleTransferTitle;

  /// Pick a reference image for the style transfer algorithm
  ///
  /// In en, this message translates to:
  /// **'Pick a style'**
  String get enhanceStyleTransferStyleDialogTitle;

  /// No description provided for @enhanceStyleTransferStyleDialogDescription.
  ///
  /// In en, this message translates to:
  /// **'Transfer image style from a reference image to your photos'**
  String get enhanceStyleTransferStyleDialogDescription;

  /// Show this error if users did not pick a reference image
  ///
  /// In en, this message translates to:
  /// **'Please pick a style'**
  String get enhanceStyleTransferNoStyleSelectedNotification;

  /// Desaturate the background of a photo
  ///
  /// In en, this message translates to:
  /// **'Color pop'**
  String get enhanceColorPopTitle;

  /// No description provided for @enhanceColorPopDescription.
  ///
  /// In en, this message translates to:
  /// **'Desaturate the background of your photos, works best with portraits'**
  String get enhanceColorPopDescription;

  /// This generic parameter sets the weight of the applied effect. The effect will be more obvious when the weight is high.
  ///
  /// In en, this message translates to:
  /// **'Weight'**
  String get enhanceGenericParamWeightLabel;

  /// Automatically improve your photo
  ///
  /// In en, this message translates to:
  /// **'Auto retouch'**
  String get enhanceRetouchTitle;

  /// No description provided for @enhanceRetouchDescription.
  ///
  /// In en, this message translates to:
  /// **'Automatically retouch your photos, improve overall color and vibrance'**
  String get enhanceRetouchDescription;

  /// If double tap to exit is enabled in settings, shown when users tap the back button
  ///
  /// In en, this message translates to:
  /// **'Tap again to exit'**
  String get doubleTapExitNotification;

  /// Warn before dismissing image editor (e.g., user pressing back button)
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get imageEditDiscardDialogTitle;

  /// No description provided for @imageEditDiscardDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Your changes are not saved'**
  String get imageEditDiscardDialogContent;

  /// Discard the current unsaved content
  ///
  /// In en, this message translates to:
  /// **'DISCARD'**
  String get discardButtonLabel;

  /// Save the current content
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get saveTooltip;

  /// No description provided for @imageEditDownloadDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Downloading image from server...'**
  String get imageEditDownloadDialogTitle;

  /// No description provided for @imageEditProcessDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Processing image...'**
  String get imageEditProcessDialogTitle;

  /// No description provided for @imageEditSaveDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Saving result...'**
  String get imageEditSaveDialogTitle;

  /// Adjust the brightness of an image
  ///
  /// In en, this message translates to:
  /// **'Brightness'**
  String get imageEditColorBrightness;

  /// Adjust the contrast of an image
  ///
  /// In en, this message translates to:
  /// **'Contrast'**
  String get imageEditColorContrast;

  /// Adjust the white point of an image. Learn more about this adjustment: https://www.photoreview.com.au/tips/editing/advanced-levels-adjustments
  ///
  /// In en, this message translates to:
  /// **'White point'**
  String get imageEditColorWhitePoint;

  /// Adjust the black point of an image
  ///
  /// In en, this message translates to:
  /// **'Black point'**
  String get imageEditColorBlackPoint;

  /// Adjust the color saturation of an image
  ///
  /// In en, this message translates to:
  /// **'Saturation'**
  String get imageEditColorSaturation;

  /// This roughly equals to adjusting the color temperature of an image. The end result is to shift the image colors such that it looks 'warmer' or 'cooler'
  ///
  /// In en, this message translates to:
  /// **'Warmth'**
  String get imageEditColorWarmth;

  /// Shift colors from a green to a magenta tint
  ///
  /// In en, this message translates to:
  /// **'Tint'**
  String get imageEditColorTint;

  /// Title of the image editor
  ///
  /// In en, this message translates to:
  /// **'Preview edits'**
  String get imageEditTitle;

  /// Label of the color tools. These can be used to adjust the color of an image
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get imageEditToolbarColorLabel;

  /// Label of the transformation tools. These can be used to transform an image, e.g., rotate it
  ///
  /// In en, this message translates to:
  /// **'Transform'**
  String get imageEditToolbarTransformLabel;

  /// Change the orientation of the image, 90 degree per step
  ///
  /// In en, this message translates to:
  /// **'Orientation'**
  String get imageEditTransformOrientation;

  /// Indicate a clockwise rotation. This text must be short as there's only minimal space
  ///
  /// In en, this message translates to:
  /// **'cw'**
  String get imageEditTransformOrientationClockwise;

  /// Indicate a counterclockwise rotation. This text must be short as there's only minimal space
  ///
  /// In en, this message translates to:
  /// **'ccw'**
  String get imageEditTransformOrientationCounterclockwise;

  /// Crop the image
  ///
  /// In en, this message translates to:
  /// **'Crop'**
  String get imageEditTransformCrop;

  /// No description provided for @imageEditToolbarEffectLabel.
  ///
  /// In en, this message translates to:
  /// **'Effect'**
  String get imageEditToolbarEffectLabel;

  /// No description provided for @imageEditEffectHalftone.
  ///
  /// In en, this message translates to:
  /// **'Halftone'**
  String get imageEditEffectHalftone;

  /// No description provided for @imageEditEffectPixelation.
  ///
  /// In en, this message translates to:
  /// **'Pixelation'**
  String get imageEditEffectPixelation;

  /// No description provided for @imageEditEffectPosterization.
  ///
  /// In en, this message translates to:
  /// **'Posterization'**
  String get imageEditEffectPosterization;

  /// No description provided for @imageEditEffectSketch.
  ///
  /// In en, this message translates to:
  /// **'Sketch'**
  String get imageEditEffectSketch;

  /// No description provided for @imageEditEffectToon.
  ///
  /// In en, this message translates to:
  /// **'Toon'**
  String get imageEditEffectToon;

  /// No description provided for @imageEditEffectFace.
  ///
  /// In en, this message translates to:
  /// **'Face'**
  String get imageEditEffectFace;

  /// No description provided for @imageEditEffectParamEdge.
  ///
  /// In en, this message translates to:
  /// **'Edge'**
  String get imageEditEffectParamEdge;

  /// No description provided for @imageEditEffectParamColor.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get imageEditEffectParamColor;

  /// Hatching is an artistic technique used to create shading and tonal effects by drawing closely spaced parallel lines
  ///
  /// In en, this message translates to:
  /// **'Hatching'**
  String get imageEditEffectParamHatching;

  /// Adjust face jawline
  ///
  /// In en, this message translates to:
  /// **'Jawline'**
  String get imageEditEffectParamJawline;

  /// Adjust size of the eye
  ///
  /// In en, this message translates to:
  /// **'Eye size'**
  String get imageEditEffectParamEyeSize;

  /// No description provided for @imageEditFaceDetectionRunningMessage.
  ///
  /// In en, this message translates to:
  /// **'Detecting faces...'**
  String get imageEditFaceDetectionRunningMessage;

  /// No description provided for @imageEditNoFaceDetected.
  ///
  /// In en, this message translates to:
  /// **'No faces detected'**
  String get imageEditNoFaceDetected;

  /// Shown when there are one or more detected faces but none of them is selected
  ///
  /// In en, this message translates to:
  /// **'Select one or more faces on your photos to apply the effects'**
  String get imageEditFaceNotSelected;

  /// Changing the image transformation will affect the result of face detection. This message is used to notify user to select the faces again afterwards
  ///
  /// In en, this message translates to:
  /// **'Selected faces are cleared after adjusting image transformation settings'**
  String get imageEditResetSelectedFaceMessage;

  /// Shown when app failed to open the image for editing
  ///
  /// In en, this message translates to:
  /// **'Unable to open file'**
  String get imageEditOpenErrorMessage;

  /// Shown when app failed to save the edited image
  ///
  /// In en, this message translates to:
  /// **'Error saving image'**
  String get imageEditSaveErrorMessage;

  /// No description provided for @categoriesLabel.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categoriesLabel;

  /// Shown in the search landing page under the People section when there are no people
  ///
  /// In en, this message translates to:
  /// **'Press settings to switch provider or press help to learn more'**
  String get searchLandingPeopleListEmptyText2;

  /// Search all videos
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get searchLandingCategoryVideosLabel;

  /// Modify search filters
  ///
  /// In en, this message translates to:
  /// **'FILTERS'**
  String get searchFilterButtonLabel;

  /// Dialog to modify search filters
  ///
  /// In en, this message translates to:
  /// **'Search filters'**
  String get searchFilterDialogTitle;

  /// A confirmation button, typically in a dialog, that apply the current settings
  ///
  /// In en, this message translates to:
  /// **'APPLY'**
  String get applyButtonLabel;

  /// This is the default option for all search filters. Filters with this value will be ignored
  ///
  /// In en, this message translates to:
  /// **'Any'**
  String get searchFilterOptionAnyLabel;

  /// Positive option for a boolean filter
  ///
  /// In en, this message translates to:
  /// **'True'**
  String get searchFilterOptionTrueLabel;

  /// Negative option for a boolean filter
  ///
  /// In en, this message translates to:
  /// **'False'**
  String get searchFilterOptionFalseLabel;

  /// Filter search results by file type
  ///
  /// In en, this message translates to:
  /// **'Type'**
  String get searchFilterTypeLabel;

  /// Filter search results by file type
  ///
  /// In en, this message translates to:
  /// **'Image'**
  String get searchFilterTypeOptionImageLabel;

  /// List of active search filters shown in the result page (by file type, image)
  ///
  /// In en, this message translates to:
  /// **'images'**
  String get searchFilterBubbleTypeImageText;

  /// Filter search results by file type
  ///
  /// In en, this message translates to:
  /// **'Video'**
  String get searchFilterTypeOptionVideoLabel;

  /// List of active search filters shown in the result page (by file type, video)
  ///
  /// In en, this message translates to:
  /// **'videos'**
  String get searchFilterBubbleTypeVideoText;

  /// Filter search results by whether it's in favorites
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get searchFilterFavoriteLabel;

  /// List of active search filters shown in the result page (by favorites, true)
  ///
  /// In en, this message translates to:
  /// **'favorites'**
  String get searchFilterBubbleFavoriteTrueText;

  /// List of active search filters shown in the result page (by favorites, false)
  ///
  /// In en, this message translates to:
  /// **'not favorites'**
  String get searchFilterBubbleFavoriteFalseText;

  /// A button to show all items of a certain item group (e.g., show all recognized faces)
  ///
  /// In en, this message translates to:
  /// **'SHOW ALL'**
  String get showAllButtonLabel;

  /// The estimated place where a photo was taken at. The place could be a town, a city, an administrative region, or a country.
  ///
  /// In en, this message translates to:
  /// **'Near {place}'**
  String gpsPlaceText(Object place);

  /// Warn about the inaccurate nature of our offline reverse geocoding feature (i.e., converting coordinates into addresses)
  ///
  /// In en, this message translates to:
  /// **'About place'**
  String get gpsPlaceAboutDialogTitle;

  /// Warn about the inaccurate nature of our offline reverse geocoding feature (i.e., converting coordinates into addresses)
  ///
  /// In en, this message translates to:
  /// **'The place shown here is only a rough estimation and not guaranteed to be accurate. It does not represent our views on any disputed areas.'**
  String get gpsPlaceAboutDialogContent;

  /// Browse photos grouped by place
  ///
  /// In en, this message translates to:
  /// **'Places'**
  String get collectionPlacesLabel;

  /// This dialog asks users to choose between saving the edited/enhanced result on the device or server
  ///
  /// In en, this message translates to:
  /// **'Saving the result'**
  String get imageSaveOptionDialogTitle;

  /// This dialog asks users to choose between saving the edited/enhanced result on the device or server
  ///
  /// In en, this message translates to:
  /// **'Select where to save this and future processed images. If you picked server but the app failed to upload it, it will be saved on your device.'**
  String get imageSaveOptionDialogContent;

  /// Save the image on the current device
  ///
  /// In en, this message translates to:
  /// **'DEVICE'**
  String get imageSaveOptionDialogDeviceButtonLabel;

  /// Save the image on your Nextcloud server
  ///
  /// In en, this message translates to:
  /// **'SERVER'**
  String get imageSaveOptionDialogServerButtonLabel;

  /// After adding a new account, the app need to sync with the server before showing anything. This message will be shown on screen instead with a proper progress bar and the folder being synced.
  ///
  /// In en, this message translates to:
  /// **'Syncing with your server for the first time'**
  String get initialSyncMessage;

  /// Enable or disable loop in the video player
  ///
  /// In en, this message translates to:
  /// **'Loop'**
  String get loopTooltip;

  /// Inform user that a collection cannot be created
  ///
  /// In en, this message translates to:
  /// **'Failed creating collection'**
  String get createCollectionFailureNotification;

  /// Add one or more items to a collection
  ///
  /// In en, this message translates to:
  /// **'Add to collection'**
  String get addItemToCollectionTooltip;

  /// Inform user that the item cannot be added to a collection
  ///
  /// In en, this message translates to:
  /// **'Failed adding to collection'**
  String get addItemToCollectionFailureNotification;

  /// Cannot set the opened item as the collection cover
  ///
  /// In en, this message translates to:
  /// **'Failed setting collection cover'**
  String get setCollectionCoverFailureNotification;

  /// Export an arbitrary Collection (typical one with generated contents) as a new static Collection
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get exportCollectionTooltip;

  /// No description provided for @exportCollectionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Export collection'**
  String get exportCollectionDialogTitle;

  /// Server-side albums that are available in Nextcloud 25+
  ///
  /// In en, this message translates to:
  /// **'Server-side album'**
  String get createCollectionDialogNextcloudAlbumLabel2;

  /// No description provided for @createCollectionDialogNextcloudAlbumDescription2.
  ///
  /// In en, this message translates to:
  /// **'Create an album on your server, accessible with any app'**
  String get createCollectionDialogNextcloudAlbumDescription2;

  /// No description provided for @removeCollectionsFailedNotification.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove some collections'**
  String get removeCollectionsFailedNotification;

  /// No description provided for @accountSettingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Account settings'**
  String get accountSettingsTooltip;

  /// No description provided for @contributorsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Contributors'**
  String get contributorsTooltip;

  /// e.g., set as wallpaper
  ///
  /// In en, this message translates to:
  /// **'Set as'**
  String get setAsTooltip;

  /// Confirmation dialog when deleting an account (i.e., signing out)
  ///
  /// In en, this message translates to:
  /// **'You are about to sign out from {server}'**
  String deleteAccountConfirmDialogText(Object server);

  /// Unlock app via selected means (e.g., password) in case app lock is enabled by user
  ///
  /// In en, this message translates to:
  /// **'Unlock the app'**
  String get appLockUnlockHint;

  /// Unlock app via selected means (e.g., password) in case app lock is enabled by user
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get appLockUnlockWrongPassword;

  /// No description provided for @enabledText.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabledText;

  /// No description provided for @disabledText.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabledText;

  /// A page to manage trusted certificates
  ///
  /// In en, this message translates to:
  /// **'Trusted certificates'**
  String get trustedCertManagerPageTitle;

  /// The selected cert has been trusted already
  ///
  /// In en, this message translates to:
  /// **'Already trusted'**
  String get trustedCertManagerAlreadyTrustedError;

  /// Select a server from the account list
  ///
  /// In en, this message translates to:
  /// **'Select HTTPS server'**
  String get trustedCertManagerSelectServer;

  /// There's no HTTPS server in the account list
  ///
  /// In en, this message translates to:
  /// **'No server available'**
  String get trustedCertManagerNoHttpsServerError;

  /// No description provided for @trustedCertManagerFailedToRemoveCertError.
  ///
  /// In en, this message translates to:
  /// **'Failed to remove certificate'**
  String get trustedCertManagerFailedToRemoveCertError;

  /// No description provided for @missingVideoThumbnailHelpDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Having trouble with video thumbnails?'**
  String get missingVideoThumbnailHelpDialogTitle;

  /// No description provided for @dontShowAgain.
  ///
  /// In en, this message translates to:
  /// **'Don\'t show again'**
  String get dontShowAgain;

  /// Filter photos by date range
  ///
  /// In en, this message translates to:
  /// **'Date range'**
  String get mapBrowserDateRangeLabel;

  /// No description provided for @mapBrowserDateRangeThisMonth.
  ///
  /// In en, this message translates to:
  /// **'This month'**
  String get mapBrowserDateRangeThisMonth;

  /// No description provided for @mapBrowserDateRangePrevMonth.
  ///
  /// In en, this message translates to:
  /// **'Previous month'**
  String get mapBrowserDateRangePrevMonth;

  /// No description provided for @mapBrowserDateRangeThisYear.
  ///
  /// In en, this message translates to:
  /// **'This year'**
  String get mapBrowserDateRangeThisYear;

  /// No description provided for @mapBrowserDateRangeCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get mapBrowserDateRangeCustom;

  /// No description provided for @homeTabMapBrowser.
  ///
  /// In en, this message translates to:
  /// **'Map'**
  String get homeTabMapBrowser;

  /// No description provided for @mapBrowserSetDefaultDateRangeButton.
  ///
  /// In en, this message translates to:
  /// **'Set as default'**
  String get mapBrowserSetDefaultDateRangeButton;

  /// No description provided for @todayText.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get todayText;

  /// No description provided for @livePhotoTooltip.
  ///
  /// In en, this message translates to:
  /// **'Live photo'**
  String get livePhotoTooltip;

  /// Instruction to customize buttons layout
  ///
  /// In en, this message translates to:
  /// **'Drag and drop to rearrange buttons'**
  String get dragAndDropRearrangeButtons;

  /// Instruction to customize navigation bar buttons in the Collections page
  ///
  /// In en, this message translates to:
  /// **'Drag and drop to rearrange buttons, tap the buttons above to minimize them'**
  String get customizeCollectionsNavBarDescription;

  /// Some button can't be removed. This message will be shown instead when user try to do so
  ///
  /// In en, this message translates to:
  /// **'This button cannot be customized'**
  String get customizeButtonsUnsupportedWarning;

  /// No description provided for @placePickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a place'**
  String get placePickerTitle;

  /// Add a map that display between photos to an album
  ///
  /// In en, this message translates to:
  /// **'Add map'**
  String get albumAddMapTooltip;

  /// No description provided for @fileNotFound.
  ///
  /// In en, this message translates to:
  /// **'File not found'**
  String get fileNotFound;

  /// No description provided for @signInViaNextcloudLoginFlowV2.
  ///
  /// In en, this message translates to:
  /// **'via Nextcloud Login Flow v2'**
  String get signInViaNextcloudLoginFlowV2;

  /// No description provided for @signInViaUsernamePassword.
  ///
  /// In en, this message translates to:
  /// **'via username and password'**
  String get signInViaUsernamePassword;

  /// Local files on your device
  ///
  /// In en, this message translates to:
  /// **'On device'**
  String get fileOnDevice;

  /// Filed uploaded to your Nextcloud server
  ///
  /// In en, this message translates to:
  /// **'On cloud'**
  String get fileOnCloud;

  /// Upload files to your Nextcloud server
  ///
  /// In en, this message translates to:
  /// **'Upload'**
  String get uploadTooltip;

  /// Pick a folder on your server where the files will be uploaded to
  ///
  /// In en, this message translates to:
  /// **'Upload to'**
  String get uploadFolderPickerTitle;

  /// While it's possible to select both remote and local files in timeline, some features only work with one kind of them. We'll show this warning when user selected a mixture of files and tried to perform a remote only action
  ///
  /// In en, this message translates to:
  /// **'This feature only supports remote files on your Nextcloud server. Any selected local files are ignored'**
  String get opOnlySupportRemoteFiles;

  /// While it's possible to select both remote and local files in timeline, some features only work with one kind of them. We'll show this warning when user selected a mixture of files and tried to perform a local only action
  ///
  /// In en, this message translates to:
  /// **'This feature only supports local files on your device. Any selected remote files are ignored'**
  String get opOnlySupportLocalFiles;

  /// Upload path
  ///
  /// In en, this message translates to:
  /// **'Path'**
  String get uploadDialogPath;

  /// Batch convert files
  ///
  /// In en, this message translates to:
  /// **'Batch convert'**
  String get uploadDialogBatchConvert;

  /// No description provided for @uploadBatchConvertWarningText1.
  ///
  /// In en, this message translates to:
  /// **'Your photos will be compressed before uploading to your server.'**
  String get uploadBatchConvertWarningText1;

  /// No description provided for @uploadBatchConvertWarningText2.
  ///
  /// In en, this message translates to:
  /// **'Motion photos are NOT supported and they will be uploaded as a still image.'**
  String get uploadBatchConvertWarningText2;

  /// No description provided for @uploadBatchConvertWarningText3.
  ///
  /// In en, this message translates to:
  /// **'Some metadata may be altered or dropped.'**
  String get uploadBatchConvertWarningText3;

  /// No description provided for @uploadBatchConvertWarningText4.
  ///
  /// In en, this message translates to:
  /// **'Supported source formats: JPEG, PNG, WEBP, BMP, HEIC'**
  String get uploadBatchConvertWarningText4;

  /// No description provided for @uploadBatchConvertSettings.
  ///
  /// In en, this message translates to:
  /// **'Conversion settings'**
  String get uploadBatchConvertSettings;

  /// Image format
  ///
  /// In en, this message translates to:
  /// **'Format'**
  String get uploadBatchConvertSettingsFormat;

  /// No description provided for @uploadBatchConvertSettingsQuality.
  ///
  /// In en, this message translates to:
  /// **'Quality'**
  String get uploadBatchConvertSettingsQuality;

  /// No description provided for @uploadBatchConvertSettingsDownscaling.
  ///
  /// In en, this message translates to:
  /// **'Downscaling'**
  String get uploadBatchConvertSettingsDownscaling;

  /// No description provided for @viewerLastPageText.
  ///
  /// In en, this message translates to:
  /// **'No more photos'**
  String get viewerLastPageText;

  /// Remove the file from server but keep the device copy
  ///
  /// In en, this message translates to:
  /// **'Server only'**
  String get deleteMergedFileDialogServerOnlyButton;

  /// Remove the file from device but keep the server copy
  ///
  /// In en, this message translates to:
  /// **'Device only'**
  String get deleteMergedFileDialogLocalOnlyButton;

  /// Remove the file from device and server
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get deleteMergedFileDialogBothButton;

  /// No description provided for @deleteMergedFileDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Some of the files exist both on your server and your device. Where should we delete these files from?'**
  String get deleteMergedFileDialogContent;

  /// No description provided for @deleteSingleMergedFileDialogContent.
  ///
  /// In en, this message translates to:
  /// **'File exists both on your server and your device. Where should we delete this file from?'**
  String get deleteSingleMergedFileDialogContent;

  /// When adding an item to a collection, ask the user where should we insert it to
  ///
  /// In en, this message translates to:
  /// **'Where to insert item?'**
  String get collectionAddItemTitle;

  /// No description provided for @greetingsMorning.
  ///
  /// In en, this message translates to:
  /// **'Good morning, {user}'**
  String greetingsMorning(Object user);

  /// No description provided for @greetingsAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good afternoon, {user}'**
  String greetingsAfternoon(Object user);

  /// No description provided for @greetingsNight.
  ///
  /// In en, this message translates to:
  /// **'Good evening, {user}'**
  String greetingsNight(Object user);

  /// No description provided for @recognizeInstructionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Setup required for Recognize integration'**
  String get recognizeInstructionDialogTitle;

  /// No description provided for @recognizeInstructionDialogContent.
  ///
  /// In en, this message translates to:
  /// **'Since Nextcloud 33, a server-side app is required to support Recognize.'**
  String get recognizeInstructionDialogContent;

  /// No description provided for @recognizeInstructionDialogButton.
  ///
  /// In en, this message translates to:
  /// **'Open Guide'**
  String get recognizeInstructionDialogButton;

  /// Error message when server responds with HTTP401
  ///
  /// In en, this message translates to:
  /// **'Unauthenticated access. Please sign-in again if the problem continues'**
  String get errorUnauthenticated;

  /// Error message when the app can't connect to the server
  ///
  /// In en, this message translates to:
  /// **'Unable to connect. Server may be offline or your device may be disconnected'**
  String get errorDisconnected;

  /// Error message when server responds with HTTP423
  ///
  /// In en, this message translates to:
  /// **'File is locked on server. Please try again later'**
  String get errorLocked;

  /// Error message when the base URL is invalid
  ///
  /// In en, this message translates to:
  /// **'Unable to communicate. Please make sure the address is the base URL of your Nextcloud instance'**
  String get errorInvalidBaseUrl;

  /// Error message when the username or password is wrong
  ///
  /// In en, this message translates to:
  /// **'Unable to authenticate. Please double check the username and password'**
  String get errorWrongPassword;

  /// HTTP 500
  ///
  /// In en, this message translates to:
  /// **'Server error. Please make sure the server is set up correctly'**
  String get errorServerError;

  /// Album files are versioned. Overwriting a newer version is disallowed as it will lead to unexpected data loss
  ///
  /// In en, this message translates to:
  /// **'Can\'t modify this album as it was created by a later version of this app. Please update the app and try again'**
  String get errorAlbumDowngrade;

  /// Missing permission on Android
  ///
  /// In en, this message translates to:
  /// **'Requires storage access permission'**
  String get errorNoStoragePermission;

  /// No cert to establish HTTPS connection
  ///
  /// In en, this message translates to:
  /// **'Server certificate not found. Try HTTP instead?'**
  String get errorServerNoCert;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ca',
    'cs',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'it',
    'ja',
    'nl',
    'pl',
    'pt',
    'ru',
    'sk',
    'tr',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'tr':
      return AppLocalizationsTr();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
