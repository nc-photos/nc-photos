// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get appTitle => 'Fotos';

  @override
  String get translator => 'Arnau Mora';

  @override
  String get photosTabLabel => 'Fotos';

  @override
  String get collectionsTooltip => 'Col·leccions';

  @override
  String get zoomTooltip => 'Zoom';

  @override
  String get settingsMenuLabel => 'Configuració';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seleccionats',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eliminant $count elements',
      one: 'Eliminant 1 element',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification => 'Elements eliminats correctament';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'No s\'han pogut eliminar $count elements',
      one: 'No s\'ha pogut eliminar 1 element',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Arxivar';

  @override
  String get archiveSelectedSuccessNotification => 'Elements arxivats correctament';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'No s\'han pogut arxivar $count elements',
      one: 'No s\'ha pogut arxivar 1 element',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Desarxivar';

  @override
  String get unarchiveSelectedSuccessNotification => 'Elements desarxivats correctament';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'No s\'han pogut arxivar $count elements',
      one: 'No s\'ha pogut arxivar 1 element',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Eliminar';

  @override
  String get deleteSuccessNotification => 'Element eliminat correctament';

  @override
  String get deleteFailureNotification => 'No s\'ha pogut eliminar';

  @override
  String get removeSelectedFromAlbumFailureNotification => 'No s\'han pogut eliminar de l\'àlbum';

  @override
  String get addServerTooltip => 'Afegir servidor';

  @override
  String removeServerSuccessNotification(Object server) {
    return '$server eliminat correctament';
  }

  @override
  String get createAlbumTooltip => 'Nou àlbum';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elements',
      one: '1 element',
      zero: 'Buit',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Arxiu';

  @override
  String connectingToServer(Object server) {
    return 'Connectant amb\n$server';
  }

  @override
  String get connectingToServer2 => 'Esperant a que el servidor ens autoritze';

  @override
  String get connectingToServerInstruction => 'Per favor, inicia sessió amb el navegador obert';

  @override
  String get nameInputHint => 'Nom';

  @override
  String get nameInputInvalidEmpty => 'El nom és necessari';

  @override
  String get skipButtonLabel => 'SALTAR';

  @override
  String get confirmButtonLabel => 'CONFIRMAR';

  @override
  String get signInHeaderText => 'Inicia sessió al servidor de Nextcloud';

  @override
  String get signIn2faHintText => 'Fes servir una contrasenya d\'aplicació si tens habilitada l\'autentificació de dos passes al servidor';

  @override
  String get signInHeaderText2 => 'Nextcloud\nIniciar sessió';

  @override
  String get serverAddressInputHint => 'Direcció del servidor';

  @override
  String get serverAddressInputInvalidEmpty => 'Per favor, introdueix la direcció del servidor';

  @override
  String get usernameInputHint => 'Nom d\'Usuari';

  @override
  String get usernameInputInvalidEmpty => 'Per favor, introdueix el teu nom d\'usuari';

  @override
  String get passwordInputHint => 'Contrasenya';

  @override
  String get passwordInputInvalidEmpty => 'Per favor, introdueix la teva contrasenya';

  @override
  String get rootPickerHeaderText => 'Selecciona les carpetes a incloure';

  @override
  String get rootPickerSubHeaderText => 'Només es mostraran les fotos a aquests directoris. Toca SALTAR per a incloure totes les carpetes';

  @override
  String get rootPickerNavigateUpItemText => '(ves enrere)';

  @override
  String get rootPickerUnpickFailureNotification => 'No s\'ha pogut deseleccionar l\'element';

  @override
  String get rootPickerListEmptyNotification => 'Per favor, selecciona almenys una carpeta o prem saltar per a incloure-les totes';

  @override
  String get setupWidgetTitle => 'Per a començar';

  @override
  String get setupSettingsModifyLaterHint => 'Pots canviar-ho més tard a la configuració';

  @override
  String get setupHiddenPrefDirNoticeDetail => 'Aquesta aplicació crea una carpeta al servidor de Nextcloud per a desar fitxers de preferències. Per favor, no la modifiques o elimines si no tens pensat eliminar aquesta app';

  @override
  String get settingsWidgetTitle => 'Configuració';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => 'Per defecte';

  @override
  String get settingsMetadataTitle => 'File metadata';

  @override
  String get settingsExifSupportTitle2 => 'Client-side EXIF support';

  @override
  String get settingsExifSupportTrueSubtitle => 'Requereix un ús extra de la xarxa';

  @override
  String get settingsFallbackClientExifTitle => 'Fall back to client-side parser';

  @override
  String get settingsFallbackClientExifTrueText => 'If Nextcloud failed to extract the file metadata, use the client-side parser instead';

  @override
  String get settingsFallbackClientExifFalseText => 'If Nextcloud failed to extract the file metadata, leave it as is';

  @override
  String get settingsFallbackClientExifConfirmDialogTitle => 'Enable client-side fallback?';

  @override
  String get settingsFallbackClientExifConfirmDialogText => 'Normally Nextcloud server will automatically process your photos and store the EXIF metadata in the background. However, the background job may fail due to a configuration issue or server bug. If enabled, we will process those files ourselves instead.';

  @override
  String get settingsMemoriesTitle => 'Memories';

  @override
  String get settingsMemoriesSubtitle => 'Mostra fotos fetes al passat';

  @override
  String get settingsAccountTitle => 'Compte';

  @override
  String get settingsAccountLabelTitle => 'Etiqueta';

  @override
  String get settingsAccountLabelDescription => 'Estableix una etiqueta per a mostrar en comptes de l\'URL del servidor';

  @override
  String get settingsIncludedFoldersTitle => 'Carpetes incloses';

  @override
  String get settingsShareFolderTitle => 'Compartir carpeta';

  @override
  String get settingsShareFolderDialogTitle => 'Troba la carpeta compartida';

  @override
  String get settingsShareFolderDialogDescription => 'Aquest ajust correspon al paràmetre share_folder a config.php. Els dos valors han de ser idèntics.\n\nPer favor, troba la mateixa carpeta a la establerta en config.php.';

  @override
  String get settingsShareFolderPickerDescription => 'Please locate the same folder as the one set in config.php. Press default if you did not set the parameter.';

  @override
  String get settingsPersonProviderTitle => 'Person provider';

  @override
  String get settingsServerAppSectionTitle => 'Server app support';

  @override
  String get settingsPhotosDescription => 'Customize contents shown in the Photos tab';

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
  String get settingsDeviceMediaDescription => 'Selected folders will be displayed';

  @override
  String get settingsViewerTitle => 'Viewer';

  @override
  String get settingsViewerDescription => 'Customize the image/video viewer';

  @override
  String get settingsScreenBrightnessTitle => 'Screen brightness';

  @override
  String get settingsScreenBrightnessDescription => 'Override system brightness level';

  @override
  String get settingsForceRotationTitle => 'Ignore rotation lock';

  @override
  String get settingsForceRotationDescription => 'Rotate the screen even when auto rotation is disabled';

  @override
  String get settingsMapProviderTitle => 'Map provider';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'Customize app bar';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle => 'Customize bottom app bar';

  @override
  String get settingsShowDateInAlbumTitle => 'Group photos by date';

  @override
  String get settingsShowDateInAlbumDescription => 'Apply only when the album is sorted by time';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle => 'Customize navigation bar';

  @override
  String get settingsImageEditTitle => 'Editor';

  @override
  String get settingsImageEditDescription => 'Customize image enhancements and the image editor';

  @override
  String get settingsEnhanceMaxResolutionTitle2 => 'Image resolution for enhancements';

  @override
  String get settingsEnhanceMaxResolutionDescription => 'Photos larger than the selected resolution will be downscaled.\n\nHigh resolution photos require significantly more memory and time to process. Please lower this setting if the app crashed while enhancing your photos.';

  @override
  String get settingsImageEditSaveResultsToServerTitle => 'Save results to server';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription => 'Results are saved to server, falling back to device storage if the upload fails';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription => 'Els resultats es desen al dispositiu';

  @override
  String get settingsThemeTitle => 'Tema';

  @override
  String get settingsThemeDescription => 'Personalitza l\'apariència de l\'app';

  @override
  String get settingsFollowSystemThemeTitle => 'Segueix el tema del dispositiu';

  @override
  String get settingsSeedColorTitle => 'Color del tema';

  @override
  String get settingsSeedColorDescription => 'Utilitzat per a derivar tots els colors de l\'app';

  @override
  String get settingsSeedColorSystemColorDescription => 'Use system color';

  @override
  String get settingsSeedColorPickerTitle => 'Selecciona un color';

  @override
  String get settingsThemePrimaryColor => 'Primary';

  @override
  String get settingsThemeSecondaryColor => 'Secondary';

  @override
  String get settingsThemePresets => 'Presets';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel => 'USE SYSTEM COLOR';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Tema més obscur';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription => 'Fes servir el negre al tema obscur';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription => 'Fes servir el gris al tema obscur';

  @override
  String get settingsMiscellaneousTitle => 'Varis';

  @override
  String get settingsDoubleTapExitTitle => 'Prem dos vegades per a sortir';

  @override
  String get settingsPhotosTabSortByNameTitle => 'Ordena pel nom del fitxer a Fotos';

  @override
  String get settingsAppLock => 'App lock';

  @override
  String get settingsAppLockTypeBiometric => 'Biometric';

  @override
  String get settingsAppLockTypePin => 'PIN';

  @override
  String get settingsAppLockTypePassword => 'Password';

  @override
  String get settingsAppLockDescription => 'If enabled, you will be asked to authenticate when you open the app. This feature does NOT protect you against real-world attacks.';

  @override
  String get settingsAppLockSetupBiometricFallbackDialogTitle => 'Pick the fallback when biometric is not available';

  @override
  String get settingsAppLockSetupPinDialogTitle => 'Set the PIN to unlock app';

  @override
  String get settingsAppLockConfirmPinDialogTitle => 'Enter the same PIN again';

  @override
  String get settingsAppLockSetupPasswordDialogTitle => 'Set the password to unlock app';

  @override
  String get settingsAppLockConfirmPasswordDialogTitle => 'Enter the same password again';

  @override
  String get settingsViewerUseOriginalImageTitle => 'Show original image instead of high quality preview in viewer';

  @override
  String get settingsExperimentalTitle => 'Experimental';

  @override
  String get settingsExperimentalDescription => 'Funcions que no estan llestes per a un ús diari';

  @override
  String get settingsExpertTitle => 'Avançat';

  @override
  String get settingsExpertWarningText => 'Per favor estigues segur que entens totes les opcions abans de fer-les servir';

  @override
  String get settingsClearCacheDatabaseTitle => 'Buida la base de dades de fitxers';

  @override
  String get settingsClearCacheDatabaseDescription => 'Buida totes les dades desades sobre els arxius, i resincronitza amb el servidor';

  @override
  String get settingsClearCacheDatabaseSuccessNotification => 'La base de dades s\'ha buidat correctament. Es recomana reiniciar l\'app';

  @override
  String get settingsManageTrustedCertificateTitle => 'Manage trusted certificates';

  @override
  String get settingsUseNewHttpEngine => 'Use new HTTP engine';

  @override
  String get settingsUseNewHttpEngineDescription => 'New HTTP engine based on Chromium, supporting new standards like HTTP/2* and HTTP/3 QUIC*.\n\nLimitations:\nSelf-signed certs can no longer be managed by us. You must import your CA certs to the system trust store for them to work.\n\n* HTTPS is required for HTTP/2 and HTTP/3';

  @override
  String get settingsAboutSectionTitle => 'About';

  @override
  String get settingsVersionTitle => 'Version';

  @override
  String get settingsServerVersionTitle => 'Server';

  @override
  String get settingsSourceCodeTitle => 'Source code';

  @override
  String get settingsBugReportTitle => 'Report issue';

  @override
  String get settingsCaptureLogsTitle => 'Capture logs';

  @override
  String get settingsCaptureLogsDescription => 'Help developer to diagnose bugs';

  @override
  String get settingsTranslatorTitle => 'Translator';

  @override
  String get settingsRestartNeededDialog => 'Please restart the app to apply changes';

  @override
  String get writePreferenceFailureNotification => 'Failed setting preference';

  @override
  String get enableButtonLabel => 'ENABLE';

  @override
  String get enableButtonLabel2 => 'Enable';

  @override
  String get exifSupportNextcloud28Notes => 'Client-side support complements your server. The app will process files and attributes not supported by Nextcloud';

  @override
  String get exifSupportConfirmationDialogTitle2 => 'Enable client-side EXIF support?';

  @override
  String get captureLogDetails => 'To take logs for a bug report:\n\n1. Enable this setting\n2. Reproduce the issue\n3. Disable this setting\n4. Look for nc-photos.log in the download folder\n\n*If the issue causes the app to crash, no logs could be captured. In such cases, please contact the developer for further instructions';

  @override
  String get captureLogSuccessNotification => 'Logs saved successfully';

  @override
  String get doneButtonLabel => 'DONE';

  @override
  String get nextButtonLabel => 'NEXT';

  @override
  String get connectButtonLabel => 'CONNECT';

  @override
  String get rootPickerSkipConfirmationDialogContent2 => 'All your files will be included. This may increase the memory usage and degrade performance';

  @override
  String megapixelCount(Object count) {
    return '${count}MP';
  }

  @override
  String secondCountSymbol(Object count) {
    return '${count}s';
  }

  @override
  String millimeterCountSymbol(Object count) {
    return '${count}mm';
  }

  @override
  String get detailsTooltip => 'Detalls';

  @override
  String get downloadTooltip => 'Descarrega';

  @override
  String get downloadProcessingNotification => 'Descarregant l\'arxiu';

  @override
  String get downloadSuccessNotification => 'S\'ha descarregat correctament';

  @override
  String get downloadFailureNotification => 'No s\'ha pogut descarregar';

  @override
  String get nextTooltip => 'Següent';

  @override
  String get previousTooltip => 'Anterior';

  @override
  String get webSelectRangeNotification => 'Mantè shift + clic per a seleccionar tots els d\'enmig';

  @override
  String get mobileSelectRangeNotification => 'Manté premut un altre element per a seleccionar tots els d\'enmig';

  @override
  String get updateDateTimeDialogTitle => 'Modifica la data i hora';

  @override
  String get dateSubtitle => 'Data';

  @override
  String get timeSubtitle => 'Hora';

  @override
  String get dateYearInputHint => 'Any';

  @override
  String get dateMonthInputHint => 'Mes';

  @override
  String get dateDayInputHint => 'Dia';

  @override
  String get timeHourInputHint => 'Hora';

  @override
  String get timeMinuteInputHint => 'Minut';

  @override
  String get timeSecondInputHint => 'Segon';

  @override
  String get dateTimeInputInvalid => 'Valor invàlid';

  @override
  String get updateDateTimeFailureNotification => 'Failed modifying date & time';

  @override
  String get albumDirPickerHeaderText => 'Pick the folders to be associated';

  @override
  String get albumDirPickerSubHeaderText => 'Only photos in the associated folders will be included in this album';

  @override
  String get albumDirPickerListEmptyNotification => 'Please pick at least one folder';

  @override
  String get importFoldersTooltip => 'Import folders';

  @override
  String get albumImporterHeaderText => 'Import folders as albums';

  @override
  String get albumImporterSubHeaderText => 'Suggested folders are listed below. Depending on the number of files on your server, it might take a while to finish';

  @override
  String get importButtonLabel => 'IMPORT';

  @override
  String get albumImporterProgressText => 'Importing folders';

  @override
  String get doneButtonTooltip => 'Done';

  @override
  String get editTooltip => 'Edit';

  @override
  String get editAccountConflictFailureNotification => 'An account already exists with the same settings';

  @override
  String get genericProcessingDialogContent => 'Please wait';

  @override
  String get sortTooltip => 'Sort';

  @override
  String get sortOptionDialogTitle => 'Sort by';

  @override
  String get sortOptionTimeAscendingLabel => 'Oldest first';

  @override
  String get sortOptionTimeDescendingLabel => 'Newest first';

  @override
  String get sortOptionFilenameAscendingLabel => 'Filename';

  @override
  String get sortOptionFilenameDescendingLabel => 'Filename (descending)';

  @override
  String get sortOptionAlbumNameLabel => 'Album name';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'Nom de l\'àlbum (descendent)';

  @override
  String get sortOptionManualLabel => 'Manual';

  @override
  String get albumEditDragRearrangeNotification => 'Prem i arrastra per a reordenar manualment';

  @override
  String get albumAddTextTooltip => 'Afegeix text';

  @override
  String get shareTooltip => 'Compartir';

  @override
  String get shareSelectedEmptyNotification => 'Selecciona algunes fotos per a compartir';

  @override
  String get shareDownloadingDialogContent => 'Descarregant';

  @override
  String get searchTooltip => 'Cerca';

  @override
  String get clearTooltip => 'Buidar';

  @override
  String get listNoResultsText => 'Sense resultats';

  @override
  String get listEmptyText => 'Buit';

  @override
  String get albumTrashLabel => 'Paperera';

  @override
  String get restoreTooltip => 'Restaurar';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restaurant $count elements',
      one: 'Restaurant 1 element',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification => 'Tots els elements s\'han restaurat correctament';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'No s\'han pogut restaurar $count elements',
      one: 'No s\'ha pogut restaurar 1 element',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Restaurant element';

  @override
  String get restoreSuccessNotification => 'S\'ha restaurat l\'element amb èxit';

  @override
  String get restoreFailureNotification => 'No s\'ha pogut restaurar l\'element';

  @override
  String get deletePermanentlyTooltip => 'Eliminar permanentment';

  @override
  String get deletePermanentlyConfirmationDialogTitle => 'Delete permanently';

  @override
  String get deletePermanentlyConfirmationDialogContent => 'Selected items will be deleted permanently from the server.\n\nThis action is irreversible';

  @override
  String get albumSharedLabel => 'Shared';

  @override
  String get metadataTaskProcessingNotification => 'Processing image metadata in the background';

  @override
  String get configButtonLabel => 'CONFIG';

  @override
  String get useAsAlbumCoverTooltip => 'Use as album cover';

  @override
  String get helpTooltip => 'Help';

  @override
  String get helpButtonLabel => 'HELP';

  @override
  String get removeFromAlbumTooltip => 'Remove from album';

  @override
  String get changelogTitle => 'Changelog';

  @override
  String get serverCertErrorDialogTitle => 'Server certificate cannot be trusted';

  @override
  String get serverCertErrorDialogContent => 'The server may be hacked or someone is trying to steal your information';

  @override
  String get advancedButtonLabel => 'ADVANCED';

  @override
  String get whitelistCertDialogTitle => 'Whitelist unknown certificate?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'You can whitelist the certificate to make the app accept it. WARNING: This poses a great security risk. Make sure the cert is self-signed by you or a trusted party\n\nHost: $host\nFingerprint: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel => 'ACCEPT THE RISK AND WHITELIST';

  @override
  String get fileSharedByDescription => 'Shared with you by this user';

  @override
  String get emptyTrashbinTooltip => 'Empty trash';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Empty trash';

  @override
  String get emptyTrashbinConfirmationDialogContent => 'Tots els elements s\'eliminaran permanentment del servidor.\n\nAquesta acció no és reversible';

  @override
  String get unsetAlbumCoverTooltip => 'Elimina la coberta';

  @override
  String get muteTooltip => 'Silencia';

  @override
  String get unmuteTooltip => 'Desilencia';

  @override
  String get collectionPeopleLabel => 'Gent';

  @override
  String get slideshowTooltip => 'Carrussel';

  @override
  String get slideshowSetupDialogTitle => 'Configura el carrussel';

  @override
  String get slideshowSetupDialogDurationTitle => 'Duració de la imatge (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Mescla';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Repeteix';

  @override
  String get slideshowSetupDialogReverseTitle => 'Inverteix';

  @override
  String get linkCopiedNotification => 'Enllaç copiat';

  @override
  String get shareMethodDialogTitle => 'Comparteix com a';

  @override
  String get shareMethodPreviewTitle => 'Previsualitza';

  @override
  String get shareMethodPreviewDescription => 'Comparteix com a una previsualització amb altres apps (només es suporten imatges)';

  @override
  String get shareMethodOriginalFileTitle => 'Arxiu original';

  @override
  String get shareMethodOriginalFileDescription => 'Descarrega l\'arxiu original i comparteix-lo amb altres apps';

  @override
  String get shareMethodPublicLinkTitle => 'Enllaç públic';

  @override
  String get shareMethodPublicLinkDescription => 'Create a new public link on the server. Anyone with the link can access the file';

  @override
  String get shareMethodPasswordLinkTitle => 'Password protected link';

  @override
  String get shareMethodPasswordLinkDescription => 'Create a new password protected link on the server';

  @override
  String get collectionSharingLabel => 'Sharing';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Last shared on $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user shared with you on $date';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user shared an album with you on $date';
  }

  @override
  String get sharedWithLabel => 'Shared with';

  @override
  String get unshareTooltip => 'Unshare';

  @override
  String get unshareSuccessNotification => 'Removed share';

  @override
  String get locationLabel => 'Location';

  @override
  String get multipleFilesLinkShareDialogContent => 'Nextcloud does not support share links for multiple files. The app will instead COPY the files to a new folder and share the folder instead.';

  @override
  String get folderNameInputHint => 'Folder name';

  @override
  String get folderNameInputInvalidEmpty => 'Please enter the name of the folder';

  @override
  String get folderNameInputInvalidCharacters => 'Contains invalid characters';

  @override
  String get createShareProgressText => 'Creating share';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Failed copying $count items',
      one: 'Failed copying 1 item',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Delete folder?';

  @override
  String get unshareLinkShareDirDialogContent => 'This folder was created by the app to share multiple files as a link. It is now no longer shared with any party, do you want to delete this folder?';

  @override
  String get addToCollectionsViewTooltip => 'Add to Collections';

  @override
  String get shareAlbumDialogTitle => 'Share with user';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Album shared with $user, but failed to share some files';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'Album unshared with $user, but failed to unshare some files';
  }

  @override
  String get fixSharesTooltip => 'Fix shares';

  @override
  String get fixTooltip => 'Fix';

  @override
  String get fixAllTooltip => 'Fix all';

  @override
  String missingShareDescription(Object user) {
    return 'Not shared with $user';
  }

  @override
  String extraShareDescription(Object user) {
    return 'Shared with $user';
  }

  @override
  String get defaultButtonLabel => 'DEFAULT';

  @override
  String get addUserInputHint => 'Add user';

  @override
  String get sharedAlbumInfoDialogTitle => 'Introducing shared album';

  @override
  String get sharedAlbumInfoDialogContent => 'Shared album allows multiple users on the same server to access the same album. Please read carefully the limitations before continuing';

  @override
  String get learnMoreButtonLabel => 'LEARN MORE';

  @override
  String get migrateDatabaseProcessingNotification => 'Updating database';

  @override
  String get migrateDatabaseFailureNotification => 'Failed migrating database';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years ago',
      one: '1 year ago',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'Home folder not found';

  @override
  String get homeFolderNotFoundDialogContent => 'Please correct the WebDAV URL shown below. You can find the URL in the Nextcloud web interface.';

  @override
  String get homeFolderInputInvalidEmpty => 'Please enter the name of your home folder';

  @override
  String get createCollectionTooltip => 'New collection';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Client-side album';

  @override
  String get createCollectionDialogAlbumDescription2 => 'Album with extra features, accessible only with this app';

  @override
  String get createCollectionDialogFolderLabel => 'Folder';

  @override
  String get createCollectionDialogFolderDescription => 'Show photos inside a folder';

  @override
  String get collectionFavoritesLabel => 'Favorites';

  @override
  String get favoriteTooltip => 'Favorite';

  @override
  String get favoriteSuccessNotification => 'Added to favorites';

  @override
  String get favoriteFailureNotification => 'Failed adding to favorites';

  @override
  String get unfavoriteTooltip => 'Unfavorite';

  @override
  String get unfavoriteSuccessNotification => 'Removed from favorites';

  @override
  String get unfavoriteFailureNotification => 'Failed removing from favorites';

  @override
  String get createCollectionDialogTagLabel => 'Tag';

  @override
  String get createCollectionDialogTagDescription => 'Show photos with specific tags';

  @override
  String get addTagInputHint => 'Add tag';

  @override
  String get tagPickerNoTagSelectedNotification => 'Please add at least 1 tag';

  @override
  String get backgroundServiceStopping => 'Stopping service';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'Battery is low';

  @override
  String get enhanceTooltip => 'Enhance';

  @override
  String get enhanceButtonLabel => 'ENHANCE';

  @override
  String get enhanceIntroDialogTitle => 'Enhance your photos';

  @override
  String get enhanceIntroDialogDescription => 'Your photos are processed locally on your device. By default, they are downscaled to 2048x1536. You can adjust the output resolution in Settings';

  @override
  String get enhanceLowLightTitle => 'Low-light enhancement';

  @override
  String get enhanceLowLightDescription => 'Brighten your photos taken in low-light environments';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Brightness';

  @override
  String get collectionEditedPhotosLabel => 'Edited (local)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent => 'Selected items will be deleted permanently from this device.\n\nThis action is irreversible';

  @override
  String get enhancePortraitBlurTitle => 'Portrait blur';

  @override
  String get enhancePortraitBlurDescription => 'Blur the background of your photos, works best with portraits';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Blurriness';

  @override
  String get enhanceSuperResolution4xTitle => 'Super-resolution (4x)';

  @override
  String get enhanceSuperResolution4xDescription => 'Enlarge your photos to 4x of their original resolution (see Help for details on how max resolution applies here)';

  @override
  String get enhanceStyleTransferTitle => 'Style transfer';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Pick a style';

  @override
  String get enhanceStyleTransferStyleDialogDescription => 'Transfer image style from a reference image to your photos';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification => 'Please pick a style';

  @override
  String get enhanceColorPopTitle => 'Color pop';

  @override
  String get enhanceColorPopDescription => 'Desaturate the background of your photos, works best with portraits';

  @override
  String get enhanceGenericParamWeightLabel => 'Weight';

  @override
  String get enhanceRetouchTitle => 'Auto retouch';

  @override
  String get enhanceRetouchDescription => 'Automatically retouch your photos, improve overall color and vibrance';

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
  String get imageEditFaceNotSelected => 'Select one or more faces on your photos to apply the effects';

  @override
  String get imageEditResetSelectedFaceMessage => 'Selected faces are cleared after adjusting image transformation settings';

  @override
  String get imageEditOpenErrorMessage => 'Unable to open file';

  @override
  String get imageEditSaveErrorMessage => 'Error saving image';

  @override
  String get categoriesLabel => 'Categories';

  @override
  String get searchLandingPeopleListEmptyText2 => 'Press settings to switch provider or press help to learn more';

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
  String get gpsPlaceAboutDialogContent => 'The place shown here is only a rough estimation and not guaranteed to be accurate. It does not represent our views on any disputed areas.';

  @override
  String get collectionPlacesLabel => 'Places';

  @override
  String get imageSaveOptionDialogTitle => 'Saving the result';

  @override
  String get imageSaveOptionDialogContent => 'Select where to save this and future processed images. If you picked server but the app failed to upload it, it will be saved on your device.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'DEVICE';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'SERVER';

  @override
  String get initialSyncMessage => 'Syncing with your server for the first time';

  @override
  String get loopTooltip => 'Loop';

  @override
  String get createCollectionFailureNotification => 'Failed creating collection';

  @override
  String get addItemToCollectionTooltip => 'Add to collection';

  @override
  String get addItemToCollectionFailureNotification => 'Failed adding to collection';

  @override
  String get setCollectionCoverFailureNotification => 'Failed setting collection cover';

  @override
  String get exportCollectionTooltip => 'Export';

  @override
  String get exportCollectionDialogTitle => 'Export collection';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 => 'Server-side album';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 => 'Create an album on your server, accessible with any app';

  @override
  String get removeCollectionsFailedNotification => 'Failed to remove some collections';

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
  String get trustedCertManagerFailedToRemoveCertError => 'Failed to remove certificate';

  @override
  String get missingVideoThumbnailHelpDialogTitle => 'Having trouble with video thumbnails?';

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
  String get dragAndDropRearrangeButtons => 'Drag and drop to rearrange buttons';

  @override
  String get customizeCollectionsNavBarDescription => 'Drag and drop to rearrange buttons, tap the buttons above to minimize them';

  @override
  String get customizeButtonsUnsupportedWarning => 'This button cannot be customized';

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
  String get opOnlySupportRemoteFiles => 'This feature only supports remote files on your Nextcloud server. Any selected local files are ignored';

  @override
  String get opOnlySupportLocalFiles => 'This feature only supports local files on your device. Any selected remote files are ignored';

  @override
  String get uploadDialogPath => 'Path';

  @override
  String get uploadDialogBatchConvert => 'Batch convert';

  @override
  String get uploadBatchConvertWarningText1 => 'Your photos will be compressed before uploading to your server.';

  @override
  String get uploadBatchConvertWarningText2 => 'Motion photos are NOT supported and they will be uploaded as a still image.';

  @override
  String get uploadBatchConvertWarningText3 => 'Some metadata may be altered or dropped.';

  @override
  String get uploadBatchConvertWarningText4 => 'Supported source formats: JPEG, PNG, WEBP, BMP, HEIC';

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
  String get deleteMergedFileDialogContent => 'Some of the files exist both on your server and your device. Where should we delete these files from?';

  @override
  String get deleteSingleMergedFileDialogContent => 'File exists both on your server and your device. Where should we delete this file from?';

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
  String get errorUnauthenticated => 'Unauthenticated access. Please sign-in again if the problem continues';

  @override
  String get errorDisconnected => 'Unable to connect. Server may be offline or your device may be disconnected';

  @override
  String get errorLocked => 'File is locked on server. Please try again later';

  @override
  String get errorInvalidBaseUrl => 'Unable to communicate. Please make sure the address is the base URL of your Nextcloud instance';

  @override
  String get errorWrongPassword => 'Unable to authenticate. Please double check the username and password';

  @override
  String get errorServerError => 'Server error. Please make sure the server is set up correctly';

  @override
  String get errorAlbumDowngrade => 'Can\'t modify this album as it was created by a later version of this app. Please update the app and try again';

  @override
  String get errorNoStoragePermission => 'Requires storage access permission';

  @override
  String get errorServerNoCert => 'Server certificate not found. Try HTTP instead?';
}
