// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get appTitle => 'Φωτογραφίες';

  @override
  String get translator => 'Chris Karasoulis';

  @override
  String get photosTabLabel => 'Φωτογραφίες';

  @override
  String get collectionsTooltip => 'Συλλογές';

  @override
  String get zoomTooltip => 'Εστίαση';

  @override
  String get settingsMenuLabel => 'Ρυθμίσεις';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count επιλεγμένα',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Διαγραφή $count αντικειμένων',
      one: 'Διαγραφή 1 αντικειμένου',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification =>
      'Επιτυχής διαγραφή όλων των αντικειμένων';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Αποτυχία διαγραφής $count αντικειμένων',
      one: 'Αποτυχία διαγραφής 1 αντικειμένου',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Αρχειοθέτηση επιλεγμένων';

  @override
  String get archiveSelectedSuccessNotification =>
      'Επιτυχής αρχειοθέτηση όλων των αντικειμένων';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Αποτυχία αρχειοθέτησης $count αντικειμένων',
      one: 'Αποτυχία αρχειοθέτησης 1 αντικειμένου',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Αποαρχειοθέτηση επιλεγμένων';

  @override
  String get unarchiveSelectedSuccessNotification =>
      'Επιτυχής αποαρχειοθέτηση όλων των αντικειμένων';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Αποτυχία αποαρχειοθέτησης $count αντικειμένων',
      one: 'Αποτυχία αποαρχειοθέτησης 1 αντικειμένου',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Διαγραφή';

  @override
  String get deleteSuccessNotification => 'Επιτυχής διαγραφή αντικειμένου';

  @override
  String get deleteFailureNotification => 'Αποτυχία διαγραφής αντικειμένου';

  @override
  String get removeSelectedFromAlbumFailureNotification =>
      'Αποτυχία αφαίρεσης αντικειμένων από τη συλλογή';

  @override
  String get addServerTooltip => 'Προσθήκη διακομιστή';

  @override
  String removeServerSuccessNotification(Object server) {
    return 'Επιτυχής αφαίρεση $server';
  }

  @override
  String get createAlbumTooltip => 'Δημιουργία νέας συλλογής';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count αντικείμενα',
      one: '1 αντικείμενο',
      zero: 'Empty',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Αρχείο';

  @override
  String connectingToServer(Object server) {
    return 'Σύνδεση σε\n$server';
  }

  @override
  String get connectingToServer2 => 'Waiting for the server to authorize us';

  @override
  String get connectingToServerInstruction =>
      'Please sign in via the opened browser';

  @override
  String get nameInputHint => 'Όνομα';

  @override
  String get nameInputInvalidEmpty => 'Name is required';

  @override
  String get skipButtonLabel => 'ΠΑΡΑΒΛΕΨΗ';

  @override
  String get confirmButtonLabel => 'ΕΠΙΒΕΒΑΙΩΣΗ';

  @override
  String get signInHeaderText => 'Είσοδος σε διακομιστή Nextcloud';

  @override
  String get signIn2faHintText =>
      'Χρησιμοποιήστε ένα συνθηματικό εφαρμογής αν χρησιμοποιείτε πιστοποίηση δύο παραγόντων στο διακομιστή';

  @override
  String get signInHeaderText2 => 'Nextcloud\nSign in';

  @override
  String get serverAddressInputHint => 'Διεύθυνση διακομιστή';

  @override
  String get serverAddressInputInvalidEmpty =>
      'Προσθέστε τη διεύθυνση του διακομιστή';

  @override
  String get usernameInputHint => 'Όνομα χρήστη';

  @override
  String get usernameInputInvalidEmpty => 'Προσθέστε το όνομα χρήστη σας';

  @override
  String get passwordInputHint => 'Κωδικός πρόσβασης';

  @override
  String get passwordInputInvalidEmpty => 'Προσθέστε τον κωδικό πρόσβασής σας';

  @override
  String get rootPickerHeaderText =>
      'Επιλέξτε τους φακέλους που θα συμπεριληφθούν';

  @override
  String get rootPickerSubHeaderText =>
      'Μόνο οι φωτογραφίες εντός των φακέλων θα εμφανίζονται. Πατήστε Παράβλεψη για να συμπεριληφθούν όλες';

  @override
  String get rootPickerNavigateUpItemText => '(go back)';

  @override
  String get rootPickerUnpickFailureNotification =>
      'Αποτυχία αποεπιλογής αντικειμένου';

  @override
  String get rootPickerListEmptyNotification =>
      'Επιλέξτε τουλάχιστον έναν φάκελο ή πατήστε παράβλεψη για να τους συμπεριλάβετε όλους';

  @override
  String get setupWidgetTitle => 'Ξεκινάμε';

  @override
  String get setupSettingsModifyLaterHint =>
      'Μπορείτε να το αλλάξετε αργότερα στις Ρυθμίσεις';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      'Η εφαρμογή θα δημιουργήσει ένα φάκελο στο διακομιστή Nextcloud για την αποθήκευση αρχείων προτιμήσεων. Μην τον τροποποιήσετε και μην τον καταργήσετε εκτός εάν σκοπεύετε να καταργήσετε αυτήν την εφαρμογή';

  @override
  String get settingsWidgetTitle => 'Ρυθμίσεις';

  @override
  String get settingsLanguageTitle => 'Γλώσσα';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => 'System default';

  @override
  String get settingsMetadataTitle => 'File metadata';

  @override
  String get settingsExifSupportTitle2 => 'Client-side EXIF support';

  @override
  String get settingsExifSupportTrueSubtitle =>
      'Απαιτείται επιπλέον χρήση δικτύου';

  @override
  String get settingsFallbackClientExifTitle =>
      'Fall back to client-side parser';

  @override
  String get settingsFallbackClientExifTrueText =>
      'If Nextcloud failed to extract the file metadata, use the client-side parser instead';

  @override
  String get settingsFallbackClientExifFalseText =>
      'If Nextcloud failed to extract the file metadata, leave it as is';

  @override
  String get settingsFallbackClientExifConfirmDialogTitle =>
      'Enable client-side fallback?';

  @override
  String get settingsFallbackClientExifConfirmDialogText =>
      'Normally Nextcloud server will automatically process your photos and store the EXIF metadata in the background. However, the background job may fail due to a configuration issue or server bug. If enabled, we will process those files ourselves instead.';

  @override
  String get settingsMemoriesTitle => 'Αναμνήσεις';

  @override
  String get settingsMemoriesSubtitle =>
      'Προβολή φωτογραφιών που ελήφθησαν στο παρελθόν';

  @override
  String get settingsAccountTitle => 'Λογαριασμός';

  @override
  String get settingsAccountLabelTitle => 'Label';

  @override
  String get settingsAccountLabelDescription =>
      'Set a label to be shown in place of the server URL';

  @override
  String get settingsIncludedFoldersTitle => 'Περιλαμβανόμενοι φάκελοι';

  @override
  String get settingsShareFolderTitle => 'Κοινοποίηση φακέλου';

  @override
  String get settingsShareFolderDialogTitle =>
      'Εντοπισμός κοινόχρηστου φακέλου';

  @override
  String get settingsShareFolderDialogDescription =>
      'Αυτή η ρύθμιση αντιστοιχεί στην παράμετρο share_folder στο config.php. Οι δύο τιμές ΠΡΕΠΕΙ να είναι πανομοιότυπες.\n\nΕντοπίστε τον ίδιο φάκελο με αυτόν που έχει οριστεί στο config.php.';

  @override
  String get settingsShareFolderPickerDescription =>
      'Εντοπίστε τον ίδιο φάκελο με αυτόν που έχει οριστεί στο config.php. Πατήστε προεπιλογή εάν δεν έχετε ορίσει την παράμετρο.';

  @override
  String get settingsPersonProviderTitle => 'Person provider';

  @override
  String get settingsServerAppSectionTitle => 'Υποστήριξη εφαρμογών διακομιστή';

  @override
  String get settingsPhotosDescription =>
      'Customize contents shown in the Photos tab';

  @override
  String get settingsMemoriesRangeTitle => 'Memories range';

  @override
  String settingsMemoriesRangeValueText(num range) {
    String _temp0 = intl.Intl.pluralLogic(
      range,
      locale: localeName,
      other: '+-$range days',
      one: '+-$range day',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeviceMediaTitle => 'Show device media';

  @override
  String get settingsDeviceMediaDescription =>
      'Selected folders will be displayed';

  @override
  String get settingsViewerTitle => 'Προβολέας';

  @override
  String get settingsViewerDescription => 'Customize the image/video viewer';

  @override
  String get settingsScreenBrightnessTitle => 'Φωτεινότητα οθόνης';

  @override
  String get settingsScreenBrightnessDescription =>
      'Παράκαμψη του επιπέδου φωτεινότητας του συστήματος';

  @override
  String get settingsForceRotationTitle =>
      'Αγνόηση κλειδώματος περιστροφής οθόνης';

  @override
  String get settingsForceRotationDescription =>
      'Περιστροφή οθόνης ακόμα και όταν η αυτόματη περιστροφή είναι απενεργοποιημένη';

  @override
  String get settingsMapProviderTitle => 'Πάροχος χάρτη';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'Customize app bar';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle =>
      'Customize bottom app bar';

  @override
  String get settingsShowDateInAlbumTitle =>
      'Ομαδοποίηση φωτογραφιών κατά ημερομηνία';

  @override
  String get settingsShowDateInAlbumDescription =>
      'Εφαρμογή μόνο όταν το άλμπουμ είναι ταξινομημένο κατά χρόνο';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'Customize navigation bar';

  @override
  String get settingsImageEditTitle => 'Editor';

  @override
  String get settingsImageEditDescription =>
      'Customize image enhancements and the image editor';

  @override
  String get settingsEnhanceMaxResolutionTitle2 =>
      'Image resolution for enhancements';

  @override
  String get settingsEnhanceMaxResolutionDescription =>
      'Οι φωτογραφίες μεγαλύτερες από την επιλεγμένη ανάλυση θα μειωθούν.\n\nΟι φωτογραφίες υψηλής ανάλυσης απαιτούν πολύ περισσότερη μνήμη και χρόνο για επεξεργασία. Μειώστε αυτή τη ρύθμιση εάν η εφαρμογή διακοπεί κατά τη βελτίωση των φωτογραφιών.';

  @override
  String get settingsImageEditSaveResultsToServerTitle =>
      'Save results to server';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      'Results are saved to server, falling back to device storage if the upload fails';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      'Results are saved to this device';

  @override
  String get settingsThemeTitle => 'Εμφάνιση';

  @override
  String get settingsThemeDescription =>
      'Προσαρμογή της εμφάνισης της εφαρμογής';

  @override
  String get settingsFollowSystemThemeTitle => 'Χρήση εμφάνισης συστήματος';

  @override
  String get settingsSeedColorTitle => 'Theme color';

  @override
  String get settingsSeedColorDescription =>
      'Used to derive all colors used in the app';

  @override
  String get settingsSeedColorSystemColorDescription => 'Use system color';

  @override
  String get settingsSeedColorPickerTitle => 'Pick a color';

  @override
  String get settingsThemePrimaryColor => 'Primary';

  @override
  String get settingsThemeSecondaryColor => 'Secondary';

  @override
  String get settingsThemePresets => 'Presets';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel =>
      'USE SYSTEM COLOR';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Πιο σκοτεινή εμφάνιση';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription =>
      'Χρήση μαύρου στη σκοτεινή εμφάνιση';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription =>
      'Χρήση σκούρου γκρι στη σκοτεινή εμφάνιση';

  @override
  String get settingsMiscellaneousTitle => 'Διάφορα';

  @override
  String get settingsDoubleTapExitTitle => 'Double tap to exit';

  @override
  String get settingsPhotosTabSortByNameTitle =>
      'Ταξινόμηση κατά όνομα αρχείου στις Φωτογραφίες';

  @override
  String get settingsAppLock => 'App lock';

  @override
  String get settingsAppLockTypeBiometric => 'Biometric';

  @override
  String get settingsAppLockTypePin => 'PIN';

  @override
  String get settingsAppLockTypePassword => 'Password';

  @override
  String get settingsAppLockDescription =>
      'If enabled, you will be asked to authenticate when you open the app. This feature does NOT protect you against real-world attacks.';

  @override
  String get settingsAppLockSetupBiometricFallbackDialogTitle =>
      'Pick the fallback when biometric is not available';

  @override
  String get settingsAppLockSetupPinDialogTitle => 'Set the PIN to unlock app';

  @override
  String get settingsAppLockConfirmPinDialogTitle => 'Enter the same PIN again';

  @override
  String get settingsAppLockSetupPasswordDialogTitle =>
      'Set the password to unlock app';

  @override
  String get settingsAppLockConfirmPasswordDialogTitle =>
      'Enter the same password again';

  @override
  String get settingsViewerUseOriginalImageTitle =>
      'Show original image instead of high quality preview in viewer';

  @override
  String get settingsExperimentalTitle => 'Πειραματικά';

  @override
  String get settingsExperimentalDescription =>
      'Χαρακτηριστικά που δεν είναι έτοιμα για καθημερινή χρήση';

  @override
  String get settingsExpertTitle => 'Advanced';

  @override
  String get settingsExpertWarningText =>
      'Please make sure you fully understand what each option does before proceeding';

  @override
  String get settingsClearCacheDatabaseTitle => 'Clear file database';

  @override
  String get settingsClearCacheDatabaseDescription =>
      'Clear cached file info and trigger a complete resync with the server';

  @override
  String get settingsClearCacheDatabaseSuccessNotification =>
      'Database cleared successfully. You are suggested to restart the app';

  @override
  String get settingsManageTrustedCertificateTitle =>
      'Manage trusted certificates';

  @override
  String get settingsUseNewHttpEngine => 'Use new HTTP engine';

  @override
  String get settingsUseNewHttpEngineDescription =>
      'New HTTP engine based on Chromium, supporting new standards like HTTP/2* and HTTP/3 QUIC*.\n\nLimitations:\nSelf-signed certs can no longer be managed by us. You must import your CA certs to the system trust store for them to work.\n\n* HTTPS is required for HTTP/2 and HTTP/3';

  @override
  String get settingsAboutSectionTitle => 'Σχετικά';

  @override
  String get settingsVersionTitle => 'Έκδοση';

  @override
  String get settingsServerVersionTitle => 'Server';

  @override
  String get settingsSourceCodeTitle => 'Πηγαίος κώδικας';

  @override
  String get settingsBugReportTitle => 'Αναφορά προβλήματος';

  @override
  String get settingsCaptureLogsTitle => 'Αρχείο καταγραφής';

  @override
  String get settingsCaptureLogsDescription =>
      'Βοηθήστε τον προγραμματιστή να διαγνώσει σφάλματα';

  @override
  String get settingsTranslatorTitle => 'Μεταφραστής';

  @override
  String get settingsRestartNeededDialog =>
      'Please restart the app to apply changes';

  @override
  String get writePreferenceFailureNotification =>
      'Αποτυχία ρύθμισης προτίμησης';

  @override
  String get enableButtonLabel => 'ΕΝΕΡΓΟΠΟΙΗΣΗ';

  @override
  String get enableButtonLabel2 => 'Enable';

  @override
  String get exifSupportNextcloud28Notes =>
      'Client-side support complements your server. The app will process files and attributes not supported by Nextcloud';

  @override
  String get exifSupportConfirmationDialogTitle2 =>
      'Enable client-side EXIF support?';

  @override
  String get captureLogDetails =>
      'Για τη λήψη αρχείων καταγραφής για μια αναφορά σφαλμάτων:\n\n1. Ενεργοποιήστε αυτήν τη ρύθμιση\n2. Αναπαράγετε το πρόβλημα\n3. Απενεργοποιήστε αυτήν τη ρύθμιση\n4. Αναζητήστε το nc-photos.log στο φάκελο λήψης\n\n*Εάν το πρόβλημα προκαλεί τη διακοπή λειτουργίας της εφαρμογής, δεν είναι δυνατή η λήψη αρχείων καταγραφής. Σε αυτήν την περίπτωση, επικοινωνήστε με τον προγραμματιστή για περαιτέρω οδηγίες';

  @override
  String get captureLogSuccessNotification =>
      'Τα αρχεία καταγραφής αποθηκεύτηκαν με επιτυχία';

  @override
  String get doneButtonLabel => 'ΕΓΙΝΕ';

  @override
  String get nextButtonLabel => 'ΕΠΟΜΕΝΟ';

  @override
  String get connectButtonLabel => 'ΣΥΝΔΕΣΗ';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      'Όλα τα αρχεία  θα συμπεριληφθούν. Αυτό μπορεί να αυξήσει τη χρήση της μνήμης και να μειώσει την απόδοση';

  @override
  String megapixelCount(Object count) {
    return '${count}MP';
  }

  @override
  String secondCountSymbol(Object count) {
    return '$countδευτ.';
  }

  @override
  String millimeterCountSymbol(Object count) {
    return '$countχιλ.';
  }

  @override
  String get detailsTooltip => 'Λεπτομέρειες';

  @override
  String get downloadTooltip => 'Λήψη';

  @override
  String get downloadProcessingNotification => 'Λήψη αρχείου';

  @override
  String get downloadSuccessNotification => 'Επιτυχής λήψη αρχείου';

  @override
  String get downloadFailureNotification => 'Αποτυχία λήψης αρχείου';

  @override
  String get nextTooltip => 'Επόμενο';

  @override
  String get previousTooltip => 'Προηγούμενο';

  @override
  String get webSelectRangeNotification =>
      'Κρατήστε πατημένο το shift και κάντε κλικ για να επιλέξετε όλα τα ενδιάμεσα';

  @override
  String get mobileSelectRangeNotification =>
      'Πατήστε παρατεταμένα ένα άλλο αντικείμενο για να επιλέξετε όλα ενδιάμεσα';

  @override
  String get updateDateTimeDialogTitle => 'Τροποποίηση ημερομηνίας και ώρας';

  @override
  String get dateSubtitle => 'Ημερομηνία';

  @override
  String get timeSubtitle => 'Ώρα';

  @override
  String get dateYearInputHint => 'Έτος';

  @override
  String get dateMonthInputHint => 'Μήνας';

  @override
  String get dateDayInputHint => 'Ημέρα';

  @override
  String get timeHourInputHint => 'Ώρα';

  @override
  String get timeMinuteInputHint => 'Λεπτό';

  @override
  String get timeSecondInputHint => 'Δευτερόλεπτο';

  @override
  String get dateTimeInputInvalid => 'Μη έγκυρη τιμή';

  @override
  String get updateDateTimeFailureNotification =>
      'Αποτυχία τροποποίησης ημερομηνίας και ώρας';

  @override
  String get albumDirPickerHeaderText =>
      'Επιλέξτε τους φακέλους που θα συσχετιστούν';

  @override
  String get albumDirPickerSubHeaderText =>
      'Μόνο φωτογραφίες στους σχετικούς φακέλους θα συμπεριληφθούν σε αυτή τη συλλογή';

  @override
  String get albumDirPickerListEmptyNotification =>
      'Επιλέξτε τουλάχιστον έναν φάκελο';

  @override
  String get importFoldersTooltip => 'Εισαγωγή φακέλων';

  @override
  String get albumImporterHeaderText => 'Εισαγωγή φακέλων ως συλλογές';

  @override
  String get albumImporterSubHeaderText =>
      'Οι προτεινόμενοι φάκελοι παρατίθενται παρακάτω. Ανάλογα με τον αριθμό των αρχείων στον διακομιστή σας, ενδέχεται να χρειαστεί λίγος χρόνος για να ολοκληρωθεί';

  @override
  String get importButtonLabel => 'ΕΙΣΑΓΩΓΗ';

  @override
  String get albumImporterProgressText => 'Importing folders';

  @override
  String get doneButtonTooltip => 'Έγινε';

  @override
  String get editTooltip => 'Edit';

  @override
  String get editAccountConflictFailureNotification =>
      'An account already exists with the same settings';

  @override
  String get genericProcessingDialogContent => 'Παρακαλώ περιμένετε';

  @override
  String get sortTooltip => 'Ταξινόμηση';

  @override
  String get sortOptionDialogTitle => 'Sort by';

  @override
  String get sortOptionTimeAscendingLabel => 'Παλιότερα πρώτα';

  @override
  String get sortOptionTimeDescendingLabel => 'Νεότερα πρώτα';

  @override
  String get sortOptionFilenameAscendingLabel => 'Όνομα αρχείου';

  @override
  String get sortOptionFilenameDescendingLabel => 'Όνομα αρχείου (φθίνουσα)';

  @override
  String get sortOptionAlbumNameLabel => 'Όνομα άλμπουμ';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'Όνομα άλμπουμ (φθίνουσα)';

  @override
  String get sortOptionManualLabel => 'Χειροκίνητα';

  @override
  String get albumEditDragRearrangeNotification =>
      'Πατήστε παρατεταμένα και σύρετε ένα αντικείμενο για να το αναδιατάξετε χειροκίνητα';

  @override
  String get albumAddTextTooltip => 'Προσθήκη κειμένου';

  @override
  String get shareTooltip => 'Κοινοποίηση';

  @override
  String get shareSelectedEmptyNotification =>
      'Επιλέξτε μερικές φωτογραφίες για κοινοποίηση';

  @override
  String get shareDownloadingDialogContent => 'Λήψη...';

  @override
  String get searchTooltip => 'Αναζήτηση';

  @override
  String get clearTooltip => 'Εκκαθάριση';

  @override
  String get listNoResultsText => 'Κανένα αποτέλεσμα';

  @override
  String get listEmptyText => 'Κενή';

  @override
  String get albumTrashLabel => 'Κάδος';

  @override
  String get restoreTooltip => 'Επαναφορά';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Επαναφορά $count στοιχείων',
      one: 'Επαναφορά 1 στοιχείου',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification =>
      'Επιτυχής επαναφορά όλων των στοιχείων';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Αποτυχία επαναφοράς $count στοιχείων',
      one: 'Αποτυχία επαναφοράς 1 στοιχείου',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Επαναφορά στοιχείου';

  @override
  String get restoreSuccessNotification => 'Επιτυχής επαναφορά στοιχείου';

  @override
  String get restoreFailureNotification => 'Αποτυχία επαναφοράς στοιχείου';

  @override
  String get deletePermanentlyTooltip => 'Οριστική διαγραφή';

  @override
  String get deletePermanentlyConfirmationDialogTitle => 'Οριστική διαγραφή';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      'Τα επιλεγμένα στοιχεία θα διαγραφούν οριστικά από τον διακομιστή.\n\nΑυτή η ενέργεια δεν είναι αναστρέψιμη';

  @override
  String get albumSharedLabel => 'Κοινόχρηστα';

  @override
  String get metadataTaskProcessingNotification =>
      'Επεξεργασία μεταδεδομένων εικόνας στο παρασκήνιο';

  @override
  String get configButtonLabel => 'ΔΙΑΜΟΡΦΩΣΗ';

  @override
  String get useAsAlbumCoverTooltip => 'Χρήση ως εξώφυλλο άλμπουμ';

  @override
  String get helpTooltip => 'Βοήθεια';

  @override
  String get helpButtonLabel => 'ΒΟΗΘΕΙΑ';

  @override
  String get removeFromAlbumTooltip => 'Αφαίρεση από το άλμπουμ';

  @override
  String get changelogTitle => 'Αρχείο αλλαγών';

  @override
  String get serverCertErrorDialogTitle =>
      'Το πιστοποιητικό διακομιστή δεν είναι αξιόπιστο';

  @override
  String get serverCertErrorDialogContent =>
      'Ο διακομιστής ενδέχεται να έχει παραβιαστεί ή κάποιος προσπαθεί να κλέψει τα δεδομένα σας';

  @override
  String get advancedButtonLabel => 'ΠΡΟΧΩΡΗΜΕΝΟ';

  @override
  String get whitelistCertDialogTitle =>
      'Προσθήκη αγνώστου πιστοποιητικού στη λίστα επιτρεπόμενων;';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'Μπορείτε να προσθέσετε το πιστοποιητικό στη λίστα επιτρεπόμενων για να το αποδεχτεί η εφαρμογή. ΠΡΟΕΙΔΟΠΟΙΗΣΗ: Αυτό ενέχει μεγάλο κίνδυνο ασφάλειας. Βεβαιωθείτε ότι το πιστοποιητικό είναι υπογεγραμμένο από εσάς ή από κάποια αξιόπιστη πηγή\n\nHost: $host\nFingerprint: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel =>
      'ΑΠΟΔΟΧΗ ΚΙΝΔΥΝΟΥ ΚΑΙ ΠΡΟΣΘΗΚΗ ΣΤΗ ΛΙΣΤΑ ΕΠΙΤΡΕΠΟΜΕΝΩΝ';

  @override
  String get fileSharedByDescription => 'Κοινοποιήθηκε από αυτόν τον χρήστη';

  @override
  String get emptyTrashbinTooltip => 'Άδειασμα κάδου';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Άδειασμα κάδου';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      'Όλα τα στοιχεία θα διαγραφούν οριστικά από τον διακομιστή.\n\nΑυτή η ενέργεια δεν είναι αναστρέψιμη';

  @override
  String get unsetAlbumCoverTooltip => 'Αφαίρεση εξώφυλλου';

  @override
  String get muteTooltip => 'Σίγαση';

  @override
  String get unmuteTooltip => 'Κατάργηση σίγασης';

  @override
  String get collectionPeopleLabel => 'Πρόσωπα';

  @override
  String get slideshowTooltip => 'Παρουσίαση';

  @override
  String get slideshowSetupDialogTitle => 'Ρύθμιση παρουσίασης';

  @override
  String get slideshowSetupDialogDurationTitle => 'Διάρκεια εικόνας (ΛΛ:ΔΔ)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Μίξη';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Επανάληψη';

  @override
  String get slideshowSetupDialogReverseTitle => 'Reverse';

  @override
  String get linkCopiedNotification => 'Ο σύνδεσμος αντιγράφηκε';

  @override
  String get shareMethodDialogTitle => 'Κοινοποίηση ως';

  @override
  String get shareMethodPreviewTitle => 'Preview';

  @override
  String get shareMethodPreviewDescription =>
      'Share a reduced quality preview to other apps (only supports images)';

  @override
  String get shareMethodOriginalFileTitle => 'Original file';

  @override
  String get shareMethodOriginalFileDescription =>
      'Download the original file and share it to other apps';

  @override
  String get shareMethodPublicLinkTitle => 'Δημόσιος σύνδεσμος';

  @override
  String get shareMethodPublicLinkDescription =>
      'Δημιουργία ενός νέου δημόσιου σύνδεσμου στον διακομιστή. Οποιοσδήποτε διαθέτει τον σύνδεσμο μπορεί να έχει πρόσβαση στο αρχείο';

  @override
  String get shareMethodPasswordLinkTitle => 'Σύνδεσμος με κωδικό πρόσβασης';

  @override
  String get shareMethodPasswordLinkDescription =>
      'Δημιουργία ενός νέου σύνδεσμου με κωδικό πρόσβασης στον διακομιστή';

  @override
  String get collectionSharingLabel => 'Κοινοποίηση';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Τελευταία κοινοποίηση στις $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return 'Ο χρήστης $user κοινοποίησε στις $date';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return 'Ο χρήστης $user κοινοποίησε ένα άλμπουμs στις $date';
  }

  @override
  String get sharedWithLabel => 'Κοινοποίηση με';

  @override
  String get unshareTooltip => 'Κατάργηση κοινοποίησης';

  @override
  String get unshareSuccessNotification => 'Αφαιρέθηκε κοινοποίηση';

  @override
  String get locationLabel => 'Τοποθεσία';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Το Nextcloud δεν υποστηρίζει σύνδεσμο κοινής χρήσης για πολλά αρχεία. Αντίθετα, η εφαρμογή θα ΑΝΤΙΓΡΑΨΕΙ τα αρχεία σε έναν νέο φάκελο και θα τον μοιραστεί.';

  @override
  String get folderNameInputHint => 'Όνομα φακέλου';

  @override
  String get folderNameInputInvalidEmpty => 'Εισαγάγετε το όνομα του φακέλου';

  @override
  String get folderNameInputInvalidCharacters => 'Περιέχει άκυρους χαρακτήρες';

  @override
  String get createShareProgressText => 'Δημιουργία κοινοποίησης';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Αποτυχία αντιγραφής $count στοιχείων',
      one: 'Αποτυχία αντιγραφής 1 στοιχείου',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Διαγραφή φακέλου;';

  @override
  String get unshareLinkShareDirDialogContent =>
      'Αυτός ο φάκελος δημιουργήθηκε από την εφαρμογή για κοινή χρήση πολλών αρχείων ως σύνδεσμος. Δεν είναι πλέον κοινόχρηστο με κανένα μέρος, θέλετε να διαγράψετε αυτόν τον φάκελο;';

  @override
  String get addToCollectionsViewTooltip => 'Προσθήκη στη συλλογή';

  @override
  String get shareAlbumDialogTitle => 'Κοινοποίηση με χρήστη';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Το άλμπουμ κοινοποιήθηκε στο χρήστη $user, αλλά απέτυχε να μοιραστεί ορισμένα αρχεία';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'Καταργήθηκε η κοινή χρήση του άλμπουμ με τον χρήστη $user, αλλά απέτυχε η κατάργηση κοινής χρήσης ορισμένων αρχείων';
  }

  @override
  String get fixSharesTooltip => 'Επιδιόρθωση κοινοποιήσεων';

  @override
  String get fixTooltip => 'Επιδιόρθωση';

  @override
  String get fixAllTooltip => 'Επιδιόρθωση όλων';

  @override
  String missingShareDescription(Object user) {
    return 'Δεν είναι κοινόχρηστο με το χρήστη $user';
  }

  @override
  String extraShareDescription(Object user) {
    return 'Κοινόχρηστο με το χρήστη $user';
  }

  @override
  String get defaultButtonLabel => 'ΠΡΟΕΠΙΛΟΓΗ';

  @override
  String get addUserInputHint => 'Προσθήκη χρήστη';

  @override
  String get sharedAlbumInfoDialogTitle =>
      'Παρουσιάζουμε το κοινόχρηστο άλμπουμ';

  @override
  String get sharedAlbumInfoDialogContent =>
      'Το κοινόχρηστο άλμπουμ επιτρέπει σε πολλούς χρήστες στον ίδιο διακομιστή να έχουν πρόσβαση στο ίδιο άλμπουμ. Διαβάστε προσεκτικά τους περιορισμούς πριν συνεχίσετε';

  @override
  String get learnMoreButtonLabel => 'ΜΑΘΕΤΕ ΠΕΡΙΣΣΟΤΕΡΑ';

  @override
  String get migrateDatabaseProcessingNotification =>
      'Ανανέωση βάσης δεδομένων';

  @override
  String get migrateDatabaseFailureNotification =>
      'Αποτυχία μετεγκατάστασης βάσης δεδομένων';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count χρόνια πριν',
      one: '1 χρόνο πριν',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'Ο αρχικός φάκελος δεν βρέθηκε';

  @override
  String get homeFolderNotFoundDialogContent =>
      'Διορθώστε τη διεύθυνση WebDAV που εμφανίζεται παρακάτω. Μπορείτε να βρείτε τη διεύθυνση στη σελίδα του Nextcloud server.';

  @override
  String get homeFolderInputInvalidEmpty =>
      'Εισαγάγετε το όνομα του αρχικού φακέλου';

  @override
  String get createCollectionTooltip => 'Νέα συλλογή';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Client-side album';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      'Album with extra features, accessible only with this app';

  @override
  String get createCollectionDialogFolderLabel => 'Φάκελος';

  @override
  String get createCollectionDialogFolderDescription =>
      'Εμφάνιση φωτογραφιών μέσα σε ένα φάκελο';

  @override
  String get collectionFavoritesLabel => 'Αγαπημένα';

  @override
  String get favoriteTooltip => 'Αγαπημένο';

  @override
  String get favoriteSuccessNotification => 'Προστέθηκε στα αγαπημένα';

  @override
  String get favoriteFailureNotification => 'Αποτυχία προσθήκης στα αγαπημένα';

  @override
  String get unfavoriteTooltip => 'Μη αγαπημένο';

  @override
  String get unfavoriteSuccessNotification => 'Αφαιρέθηκε από τα αγαπημένα';

  @override
  String get unfavoriteFailureNotification =>
      'Αποτυχία αφαίρεσης από τα αγαπημένα';

  @override
  String get createCollectionDialogTagLabel => 'Ετικέτα';

  @override
  String get createCollectionDialogTagDescription =>
      'Εμφάνιση φωτογραφιών με συγκεκριμένες ετικέτες';

  @override
  String get addTagInputHint => 'Προσθήκη ετικέτας';

  @override
  String get tagPickerNoTagSelectedNotification =>
      'Προσθέστε τουλάχιστον 1 ετικέτα';

  @override
  String get backgroundServiceStopping => 'Διακοπή υπηρεσίας';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'Χαμηλή μπαταρία';

  @override
  String get enhanceTooltip => 'Βελτίωση';

  @override
  String get enhanceButtonLabel => 'ΒΕΛΤΙΩΣΗ';

  @override
  String get enhanceIntroDialogTitle => 'Βελτίωση φωτογραφιών';

  @override
  String get enhanceIntroDialogDescription =>
      'Οι φωτογραφίες επεξεργάζονται τοπικά στη συσκευή. Από προεπιλογή μειώνονται σε 2048x1536. Μπορείτε να προσαρμόσετε την ανάλυση εξόδου στις Ρυθμίσεις';

  @override
  String get enhanceLowLightTitle => 'Βελτίωση χαμηλού φωτισμού';

  @override
  String get enhanceLowLightDescription =>
      'Brighten your photos taken in low-light environments';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Φωτεινότητα';

  @override
  String get collectionEditedPhotosLabel => 'Edited (local)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      'Τα επιλεγμένα στοιχεία θα διαγραφούν οριστικά από αυτήν τη συσκευή.\n\nΑυτή η ενέργεια δεν είναι αναστρέψιμη';

  @override
  String get enhancePortraitBlurTitle => 'Θάμπωμα πορτρέτου';

  @override
  String get enhancePortraitBlurDescription =>
      'Blur the background of your photos, works best with portraits';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Θόλωση';

  @override
  String get enhanceSuperResolution4xTitle => 'Υπερ-ανάλυση (4x)';

  @override
  String get enhanceSuperResolution4xDescription =>
      'Enlarge your photos to 4x of their original resolution (see Help for details on how max resolution applies here)';

  @override
  String get enhanceStyleTransferTitle => 'Μεταφορά στυλ';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Pick a style';

  @override
  String get enhanceStyleTransferStyleDialogDescription =>
      'Transfer image style from a reference image to your photos';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification =>
      'Please pick a style';

  @override
  String get enhanceColorPopTitle => 'Color pop';

  @override
  String get enhanceColorPopDescription =>
      'Desaturate the background of your photos, works best with portraits';

  @override
  String get enhanceGenericParamWeightLabel => 'Weight';

  @override
  String get enhanceRetouchTitle => 'Auto retouch';

  @override
  String get enhanceRetouchDescription =>
      'Automatically retouch your photos, improve overall color and vibrance';

  @override
  String get doubleTapExitNotification => 'Tap again to exit';

  @override
  String get imageEditDiscardDialogTitle => 'Discard changes?';

  @override
  String get imageEditDiscardDialogContent => 'Your changes are not saved';

  @override
  String get discardButtonLabel => 'DISCARD';

  @override
  String get saveTooltip => 'Save';

  @override
  String get imageEditDownloadDialogTitle => 'Downloading image from server...';

  @override
  String get imageEditProcessDialogTitle => 'Processing image...';

  @override
  String get imageEditSaveDialogTitle => 'Saving result...';

  @override
  String get imageEditColorBrightness => 'Brightness';

  @override
  String get imageEditColorContrast => 'Contrast';

  @override
  String get imageEditColorWhitePoint => 'White point';

  @override
  String get imageEditColorBlackPoint => 'Black point';

  @override
  String get imageEditColorSaturation => 'Saturation';

  @override
  String get imageEditColorWarmth => 'Warmth';

  @override
  String get imageEditColorTint => 'Tint';

  @override
  String get imageEditTitle => 'Preview edits';

  @override
  String get imageEditToolbarColorLabel => 'Color';

  @override
  String get imageEditToolbarTransformLabel => 'Transform';

  @override
  String get imageEditTransformOrientation => 'Orientation';

  @override
  String get imageEditTransformOrientationClockwise => 'cw';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'ccw';

  @override
  String get imageEditTransformCrop => 'Crop';

  @override
  String get imageEditToolbarEffectLabel => 'Effect';

  @override
  String get imageEditEffectHalftone => 'Halftone';

  @override
  String get imageEditEffectPixelation => 'Pixelation';

  @override
  String get imageEditEffectPosterization => 'Posterization';

  @override
  String get imageEditEffectSketch => 'Sketch';

  @override
  String get imageEditEffectToon => 'Toon';

  @override
  String get imageEditEffectFace => 'Face';

  @override
  String get imageEditEffectParamEdge => 'Edge';

  @override
  String get imageEditEffectParamColor => 'Color';

  @override
  String get imageEditEffectParamHatching => 'Hatching';

  @override
  String get imageEditEffectParamJawline => 'Jawline';

  @override
  String get imageEditEffectParamEyeSize => 'Eye size';

  @override
  String get imageEditFaceDetectionRunningMessage => 'Detecting faces...';

  @override
  String get imageEditNoFaceDetected => 'No faces detected';

  @override
  String get imageEditFaceNotSelected =>
      'Select one or more faces on your photos to apply the effects';

  @override
  String get imageEditResetSelectedFaceMessage =>
      'Selected faces are cleared after adjusting image transformation settings';

  @override
  String get imageEditOpenErrorMessage => 'Unable to open file';

  @override
  String get imageEditSaveErrorMessage => 'Error saving image';

  @override
  String get categoriesLabel => 'Categories';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      'Press settings to switch provider or press help to learn more';

  @override
  String get searchLandingCategoryVideosLabel => 'Videos';

  @override
  String get searchFilterButtonLabel => 'FILTERS';

  @override
  String get searchFilterDialogTitle => 'Search filters';

  @override
  String get applyButtonLabel => 'APPLY';

  @override
  String get searchFilterOptionAnyLabel => 'Any';

  @override
  String get searchFilterOptionTrueLabel => 'True';

  @override
  String get searchFilterOptionFalseLabel => 'False';

  @override
  String get searchFilterTypeLabel => 'Type';

  @override
  String get searchFilterTypeOptionImageLabel => 'Image';

  @override
  String get searchFilterBubbleTypeImageText => 'images';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Video';

  @override
  String get searchFilterBubbleTypeVideoText => 'videos';

  @override
  String get searchFilterFavoriteLabel => 'Favorite';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'favorites';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'not favorites';

  @override
  String get showAllButtonLabel => 'SHOW ALL';

  @override
  String gpsPlaceText(Object place) {
    return 'Near $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'About place';

  @override
  String get gpsPlaceAboutDialogContent =>
      'The place shown here is only a rough estimation and not guaranteed to be accurate. It does not represent our views on any disputed areas.';

  @override
  String get collectionPlacesLabel => 'Places';

  @override
  String get imageSaveOptionDialogTitle => 'Saving the result';

  @override
  String get imageSaveOptionDialogContent =>
      'Select where to save this and future processed images. If you picked server but the app failed to upload it, it will be saved on your device.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'DEVICE';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'SERVER';

  @override
  String get initialSyncMessage =>
      'Syncing with your server for the first time';

  @override
  String get loopTooltip => 'Loop';

  @override
  String get createCollectionFailureNotification =>
      'Failed creating collection';

  @override
  String get addItemToCollectionTooltip => 'Add to collection';

  @override
  String get addItemToCollectionFailureNotification =>
      'Failed adding to collection';

  @override
  String get setCollectionCoverFailureNotification =>
      'Failed setting collection cover';

  @override
  String get exportCollectionTooltip => 'Export';

  @override
  String get exportCollectionDialogTitle => 'Export collection';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 => 'Server-side album';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 =>
      'Create an album on your server, accessible with any app';

  @override
  String get removeCollectionsFailedNotification =>
      'Failed to remove some collections';

  @override
  String get accountSettingsTooltip => 'Account settings';

  @override
  String get contributorsTooltip => 'Contributors';

  @override
  String get setAsTooltip => 'Set as';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return 'You are about to sign out from $server';
  }

  @override
  String get appLockUnlockHint => 'Unlock the app';

  @override
  String get appLockUnlockWrongPassword => 'Incorrect password';

  @override
  String get enabledText => 'Enabled';

  @override
  String get disabledText => 'Disabled';

  @override
  String get trustedCertManagerPageTitle => 'Trusted certificates';

  @override
  String get trustedCertManagerAlreadyTrustedError => 'Already trusted';

  @override
  String get trustedCertManagerSelectServer => 'Select HTTPS server';

  @override
  String get trustedCertManagerNoHttpsServerError => 'No server available';

  @override
  String get trustedCertManagerFailedToRemoveCertError =>
      'Failed to remove certificate';

  @override
  String get missingVideoThumbnailHelpDialogTitle =>
      'Having trouble with video thumbnails?';

  @override
  String get dontShowAgain => 'Don\'t show again';

  @override
  String get mapBrowserDateRangeLabel => 'Date range';

  @override
  String get mapBrowserDateRangeThisMonth => 'This month';

  @override
  String get mapBrowserDateRangePrevMonth => 'Previous month';

  @override
  String get mapBrowserDateRangeThisYear => 'This year';

  @override
  String get mapBrowserDateRangeCustom => 'Custom';

  @override
  String get homeTabMapBrowser => 'Map';

  @override
  String get mapBrowserSetDefaultDateRangeButton => 'Set as default';

  @override
  String get todayText => 'Today';

  @override
  String get livePhotoTooltip => 'Live photo';

  @override
  String get dragAndDropRearrangeButtons =>
      'Drag and drop to rearrange buttons';

  @override
  String get customizeCollectionsNavBarDescription =>
      'Drag and drop to rearrange buttons, tap the buttons above to minimize them';

  @override
  String get customizeButtonsUnsupportedWarning =>
      'This button cannot be customized';

  @override
  String get placePickerTitle => 'Pick a place';

  @override
  String get albumAddMapTooltip => 'Add map';

  @override
  String get fileNotFound => 'File not found';

  @override
  String get signInViaNextcloudLoginFlowV2 => 'via Nextcloud Login Flow v2';

  @override
  String get signInViaUsernamePassword => 'via username and password';

  @override
  String get fileOnDevice => 'On device';

  @override
  String get fileOnCloud => 'On cloud';

  @override
  String get uploadTooltip => 'Upload';

  @override
  String get uploadFolderPickerTitle => 'Upload to';

  @override
  String get opOnlySupportRemoteFiles =>
      'This feature only supports remote files on your Nextcloud server. Any selected local files are ignored';

  @override
  String get opOnlySupportLocalFiles =>
      'This feature only supports local files on your device. Any selected remote files are ignored';

  @override
  String get uploadDialogPath => 'Path';

  @override
  String get uploadDialogBatchConvert => 'Batch convert';

  @override
  String get uploadBatchConvertWarningText1 =>
      'Your photos will be compressed before uploading to your server.';

  @override
  String get uploadBatchConvertWarningText2 =>
      'Motion photos are NOT supported and they will be uploaded as a still image.';

  @override
  String get uploadBatchConvertWarningText3 =>
      'Some metadata may be altered or dropped.';

  @override
  String get uploadBatchConvertWarningText4 =>
      'Supported source formats: JPEG, PNG, WEBP, BMP, HEIC';

  @override
  String get uploadBatchConvertSettings => 'Conversion settings';

  @override
  String get uploadBatchConvertSettingsFormat => 'Format';

  @override
  String get uploadBatchConvertSettingsQuality => 'Quality';

  @override
  String get uploadBatchConvertSettingsDownscaling => 'Downscaling';

  @override
  String get viewerLastPageText => 'No more photos';

  @override
  String get deleteMergedFileDialogServerOnlyButton => 'Server only';

  @override
  String get deleteMergedFileDialogLocalOnlyButton => 'Device only';

  @override
  String get deleteMergedFileDialogBothButton => 'Both';

  @override
  String get deleteMergedFileDialogContent =>
      'Some of the files exist both on your server and your device. Where should we delete these files from?';

  @override
  String get deleteSingleMergedFileDialogContent =>
      'File exists both on your server and your device. Where should we delete this file from?';

  @override
  String get collectionAddItemTitle => 'Where to insert item?';

  @override
  String greetingsMorning(Object user) {
    return 'Good morning, $user';
  }

  @override
  String greetingsAfternoon(Object user) {
    return 'Good afternoon, $user';
  }

  @override
  String greetingsNight(Object user) {
    return 'Good evening, $user';
  }

  @override
  String get errorUnauthenticated =>
      'Μη εξουσιοδοτημένη πρόσβαση. Συνδεθείτε ξανά εάν το πρόβλημα συνεχίζεται';

  @override
  String get errorDisconnected =>
      'Αδυναμία σύνδεσης. Ο διακομιστής ενδέχεται να είναι εκτός σύνδεσης ή η συσκευή σας δεν είναι συνδεδεμένη';

  @override
  String get errorLocked =>
      'Το αρχείο είναι κλειδωμένο στο διακομιστή. Δοκιμάστε ξανά αργότερα';

  @override
  String get errorInvalidBaseUrl =>
      'Αδυναμία επικοινωνίας. Βεβαιωθείτε ότι η διεύθυνση είναι η βασική διεύθυνση URL του διακομιστή Nextcloud';

  @override
  String get errorWrongPassword =>
      'Αδυναμία επαλήθευσης ταυτότητας. Ελέγξτε ξανά το όνομα χρήστη και τον κωδικό πρόσβασης';

  @override
  String get errorServerError =>
      'Σφάλμα διακομιστή. Βεβαιωθείτε ότι ο διακομιστής έχει ρυθμιστεί σωστά';

  @override
  String get errorAlbumDowngrade =>
      'Δεν είναι δυνατή η τροποποίηση αυτού του άλμπουμ, καθώς δημιουργήθηκε από μεταγενέστερη έκδοση αυτής της εφαρμογής. Ενημερώστε την εφαρμογή και δοκιμάστε ξανά';

  @override
  String get errorNoStoragePermission =>
      'Απαιτείται άδεια πρόσβασης στο χώρο αποθήκευσης';

  @override
  String get errorServerNoCert =>
      'Server certificate not found. Try HTTP instead?';
}
