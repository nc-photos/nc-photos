// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Fotos';

  @override
  String get translator =>
      'Andreas\nMrNobody\nNiclas Heinz\nOdious\nPhilProg\nshagn';

  @override
  String get photosTabLabel => 'Fotos';

  @override
  String get collectionsTooltip => 'Alben';

  @override
  String get zoomTooltip => 'Zoom';

  @override
  String get settingsMenuLabel => 'Einstellungen';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count markiert',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Lösche $count Elemente',
      one: 'Lösche 1 Element',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification =>
      'Alle Elemente wurden erfolgreich gelöscht';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fehler beim Löschen von $count Elementen',
      one: 'Fehler beim Löschen von 1 Element',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Archivieren';

  @override
  String get archiveSelectedSuccessNotification =>
      'Alle Elemente wurden erfolgreich archiviert';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fehler beim archivieren von $count Elementen',
      one: 'Fehler beim Archivieren von 1 Element',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Dearchivieren';

  @override
  String get unarchiveSelectedSuccessNotification =>
      'Alle Elemente erfolgreich dearchiviert';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fehler beim Dearchivieren von $count Elementen',
      one: '1 Element konnte nicht dearchiviert werden',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Löschen';

  @override
  String get deleteSuccessNotification => 'Element erfolgreich gelöscht';

  @override
  String get deleteFailureNotification => 'Löschen des Elements fehlgeschlagen';

  @override
  String get removeSelectedFromAlbumFailureNotification =>
      'Entfernen von Elementen aus dem Album fehlgeschlagen';

  @override
  String get addServerTooltip => 'Server hinzufügen';

  @override
  String removeServerSuccessNotification(Object server) {
    return '$server erfolgreich entfernt';
  }

  @override
  String get createAlbumTooltip => 'Neues Album';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Elemente',
      one: '1 Element',
      zero: 'Leer',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Archiv';

  @override
  String connectingToServer(Object server) {
    return 'Verbinde zu\n$server';
  }

  @override
  String get connectingToServer2 =>
      'Warten darauf, dass der Server uns autorisiert';

  @override
  String get connectingToServerInstruction =>
      'Bitte via dem geöffneten Browser anmelden';

  @override
  String get nameInputHint => 'Name';

  @override
  String get nameInputInvalidEmpty => 'Name ist erforderlich';

  @override
  String get skipButtonLabel => 'ÜBERSPRINGEN';

  @override
  String get confirmButtonLabel => 'BESTÄTIGEN';

  @override
  String get signInHeaderText => 'Melden Sie sich beim Nextcloud-Server an';

  @override
  String get signIn2faHintText =>
      'Verwenden Sie ein App-Passwort, wenn Sie die Zwei-Faktor-Authentifizierung auf dem Server aktiviert haben';

  @override
  String get signInHeaderText2 => 'Nextcloud\nLogin';

  @override
  String get serverAddressInputHint => 'Serveradresse';

  @override
  String get serverAddressInputInvalidEmpty =>
      'Bitte geben Sie die Serveradresse ein';

  @override
  String get usernameInputHint => 'Benutzername';

  @override
  String get usernameInputInvalidEmpty =>
      'Bitte geben Sie Ihren Benutzernamen ein';

  @override
  String get passwordInputHint => 'Passwort';

  @override
  String get passwordInputInvalidEmpty => 'Bitte geben Sie Ihr Passwort ein';

  @override
  String get rootPickerHeaderText =>
      'Wählen Sie die Ordner aus, die aufgenommen werden sollen';

  @override
  String get rootPickerSubHeaderText =>
      'Es werden nur Fotos in den Ordnern angezeigt. Drücken Sie Überspringen, um alle einzuschließen';

  @override
  String get rootPickerNavigateUpItemText => '(geh zurück)';

  @override
  String get rootPickerUnpickFailureNotification =>
      'Aufheben des Elements fehlgeschlagen';

  @override
  String get rootPickerListEmptyNotification =>
      'Bitte wählen Sie mindestens einen Ordner aus oder drücken Sie Überspringen, um alle aufzunehmen';

  @override
  String get setupWidgetTitle => 'Einstieg';

  @override
  String get setupSettingsModifyLaterHint =>
      'Sie können dies später in den Einstellungen ändern';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      'Diese App erstellt einen Ordner auf dem Nextcloud-Server, um Einstellungsdateien zu speichern. Bitte ändern oder entfernen Sie sie nicht, es sei denn, Sie beabsichtigen, diese App zu entfernen';

  @override
  String get settingsWidgetTitle => 'Einstellungen';

  @override
  String get settingsLanguageTitle => 'Sprache';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => 'Systemstandard';

  @override
  String get settingsMetadataTitle => 'Dateimetadaten';

  @override
  String get settingsExifSupportTitle2 => 'Client-side EXIF support';

  @override
  String get settingsExifSupportTrueSubtitle =>
      'Erfordert zusätzliche Netzwerknutzung';

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
  String get settingsMemoriesTitle => 'Erinnerungen';

  @override
  String get settingsMemoriesSubtitle => 'Zeige Fotos aus der Vergangenheit';

  @override
  String get settingsAccountTitle => 'Konto';

  @override
  String get settingsAccountLabelTitle => 'Bezeichnung';

  @override
  String get settingsAccountLabelDescription =>
      'Legen Sie eine Bezeichnung fest, die ansteller der Server-URL angezeigt wird';

  @override
  String get settingsIncludedFoldersTitle => 'Enthaltene Ordner';

  @override
  String get settingsShareFolderTitle => 'Ordner teilen';

  @override
  String get settingsShareFolderDialogTitle => 'Suchen Sie den Freigabeordner';

  @override
  String get settingsShareFolderDialogDescription =>
      'Diese Einstellung entspricht dem Parameter **share_folder** in der **config.php**. Die beiden Werte MÜSSEN identisch sein.\n\nBitte suchen Sie denselben Ordner, der auch in der **config.php** festgelegt ist.';

  @override
  String get settingsShareFolderPickerDescription =>
      'Bitte suchen Sie denselben Ordner, der in der **config.php** festgelegt ist. Drücken Sie \"Standard\", falls Sie den Parameter nicht festgelegt haben.';

  @override
  String get settingsPersonProviderTitle => 'Personenanbieter';

  @override
  String get settingsServerAppSectionTitle => 'Unterstützung Server App';

  @override
  String get settingsPhotosDescription => 'Passen Sie Inhalte im Fotos Tab an';

  @override
  String get settingsMemoriesRangeTitle => 'Erinnerungszeitraum';

  @override
  String settingsMemoriesRangeValueText(num range) {
    String _temp0 = intl.Intl.pluralLogic(
      range,
      locale: localeName,
      other: '+-$range Tage',
      one: '+-$range Tag',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeviceMediaTitle => 'Show device media';

  @override
  String get settingsDeviceMediaDescription =>
      'Selected folders will be displayed';

  @override
  String get settingsViewerTitle => 'Viewer';

  @override
  String get settingsViewerDescription => 'Den Bild-/Video-Viewer anpassen';

  @override
  String get settingsScreenBrightnessTitle => 'Bildschirmhelligkeit';

  @override
  String get settingsScreenBrightnessDescription =>
      'Bildschirmhelligkeit des Systems überschreiben';

  @override
  String get settingsForceRotationTitle => 'Rotationssperre ignorieren';

  @override
  String get settingsForceRotationDescription =>
      'Den Bildschirm rotieren, auch wenn die automatische Drehung deaktiviert ist';

  @override
  String get settingsMapProviderTitle => 'Kartendienst';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'Customize app bar';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle =>
      'Customize bottom app bar';

  @override
  String get settingsShowDateInAlbumTitle => 'Fotos nach Datum gruppieren';

  @override
  String get settingsShowDateInAlbumDescription =>
      'Nur anwenden, wenn das Album zeitlich sortiert ist';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'Navigationsleiste anpassen';

  @override
  String get settingsImageEditTitle => 'Editor';

  @override
  String get settingsImageEditDescription =>
      'Personalisiere Bildverbesserungen und den Bildeditor';

  @override
  String get settingsEnhanceMaxResolutionTitle2 =>
      'Bildauflösung für Verbesserungen';

  @override
  String get settingsEnhanceMaxResolutionDescription =>
      'Fotos, die größer als die gewählte Auflösung sind, werden herunterskaliert.\n\nFotos mit hoher Auflösung benötigen deutlich mehr Speicher und Zeit für die Verarbeitung. Bitte verringern Sie diese Einstellung, falls die App beim Verbessern Ihrer Fotos abgestürzt ist.';

  @override
  String get settingsImageEditSaveResultsToServerTitle =>
      'Ergebnisse auf dem Server speichern';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      'Ergebnisse werden auf dem Server gespeichert, ersatzweise im Gerätespeicher wenn das fehlschlägt';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      'Ergebnisse werden auf diesem Gerät gespeichert';

  @override
  String get settingsThemeTitle => 'Design';

  @override
  String get settingsThemeDescription =>
      'Passen Sie das Erscheinungsbild der App an';

  @override
  String get settingsFollowSystemThemeTitle => 'Systemdesign folgen';

  @override
  String get settingsSeedColorTitle => 'Designfarbe';

  @override
  String get settingsSeedColorDescription =>
      'Wird benutzt um alle Farben in der App abzuleiten';

  @override
  String get settingsSeedColorSystemColorDescription => 'Systemfarbe verwenden';

  @override
  String get settingsSeedColorPickerTitle => 'Wähle eine Farbe';

  @override
  String get settingsThemePrimaryColor => 'Primär';

  @override
  String get settingsThemeSecondaryColor => 'Sekundär';

  @override
  String get settingsThemePresets => 'Voreinstellungen';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel =>
      'Verwende Systemfarben';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Dunkleres Design';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription =>
      'Schwarz im dunklen Design verwenden';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription =>
      'Dunkelgrau im dunklen Design verwenden';

  @override
  String get settingsMiscellaneousTitle => 'Sonstige';

  @override
  String get settingsDoubleTapExitTitle => 'Doppeltippen zum Verlassen';

  @override
  String get settingsPhotosTabSortByNameTitle =>
      'Nach Dateinamen sortieren in Fotos';

  @override
  String get settingsAppLock => 'App Sperre';

  @override
  String get settingsAppLockTypeBiometric => 'Biometrie';

  @override
  String get settingsAppLockTypePin => 'PIN';

  @override
  String get settingsAppLockTypePassword => 'Password';

  @override
  String get settingsAppLockDescription =>
      'Wenn diese Funktion aktiviert ist, werden Sie beim Öffnen der App aufgefordert, sich zu authentifizieren. Diese Funktion schützt Sie NICHT vor Angriffen aus der realen Welt.';

  @override
  String get settingsAppLockSetupBiometricFallbackDialogTitle =>
      'Wählen Sie die alternative Methode, wenn biometrische Daten nicht verfügbar sind.';

  @override
  String get settingsAppLockSetupPinDialogTitle =>
      'PIN zum Entsperren der App einrichten';

  @override
  String get settingsAppLockConfirmPinDialogTitle =>
      'Geben Sie den selben PIN nochmals ein';

  @override
  String get settingsAppLockSetupPasswordDialogTitle =>
      'Setzen Sie das Password für die Entsperrung';

  @override
  String get settingsAppLockConfirmPasswordDialogTitle =>
      'Geben Sie das selbe Password nochmals ein';

  @override
  String get settingsViewerUseOriginalImageTitle =>
      'Show original image instead of high quality preview in viewer';

  @override
  String get settingsExperimentalTitle => 'Experimental';

  @override
  String get settingsExperimentalDescription =>
      'Funktionen, die nicht für den alltäglichen Einsatz bereit sind';

  @override
  String get settingsExpertTitle => 'Erweitert';

  @override
  String get settingsExpertWarningText =>
      'Bitte stellen Sie sicher, dass Sie vollständig verstehen was jede Option tut bevor Sie fortfahren';

  @override
  String get settingsClearCacheDatabaseTitle => 'Dateidatenbank leeren';

  @override
  String get settingsClearCacheDatabaseDescription =>
      'Gecachte Dateiinfo leeren und einen kompletten Resync mit dem Server auslösen';

  @override
  String get settingsClearCacheDatabaseSuccessNotification =>
      'Dateidatenbank erfolgreich geleert. Es wird empfohlen die App neuzustarten';

  @override
  String get settingsManageTrustedCertificateTitle =>
      'Verwalte vertrauenswürdige Zertifikate';

  @override
  String get settingsUseNewHttpEngine => 'Verwende das neue HTTP Engine';

  @override
  String get settingsUseNewHttpEngineDescription =>
      'Neuer HTTP-Engine basierend auf Chromium, der neue Standards wie HTTP/2* und HTTP/3 QUIC* unterstützt.\n\nEinschränkungen: \nSelbstsignierte Zertifikate können von uns nicht mehr verwaltet werden. Sie müssen Ihre CA-Zertifikate in den Systemvertrauensspeicher importieren, damit sie funktionieren.\n\n* HTTPS ist erforderlich für HTTP/2 und HTTP/3.';

  @override
  String get settingsAboutSectionTitle => 'Über';

  @override
  String get settingsVersionTitle => 'Version';

  @override
  String get settingsServerVersionTitle => 'Server';

  @override
  String get settingsSourceCodeTitle => 'Quellcode';

  @override
  String get settingsBugReportTitle => 'Melde Probleme';

  @override
  String get settingsCaptureLogsTitle => 'Protokolle erfassen';

  @override
  String get settingsCaptureLogsDescription =>
      'Helfen Sie dem Entwickler, Fehler zu diagnostizieren';

  @override
  String get settingsTranslatorTitle => 'Übersetzer';

  @override
  String get settingsRestartNeededDialog =>
      'Bitte App neu starten um die Änderungen anzuwenden';

  @override
  String get writePreferenceFailureNotification =>
      'Einstellung der Einstellung fehlgeschlagen';

  @override
  String get enableButtonLabel => 'AKTIVIEREN';

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
      'So erstellen Sie Protokolle für einen Fehlerbericht:\n\n1. Aktivieren Sie diese Einstellung\n2. Reproduzieren Sie das Problem\n3. Deaktivieren Sie diese Einstellung\n4. Suchen Sie im Download-Ordner nach nc-photos.log\n\n*Wenn das Problem zum Absturz der App führt, konnten keine Protokolle erfasst werden. In diesem Fall wenden Sie sich bitte an den Entwickler, um weitere Anweisungen zu erhalten';

  @override
  String get captureLogSuccessNotification =>
      'Protokolle erfolgreich gespeichert';

  @override
  String get doneButtonLabel => 'FERTIG';

  @override
  String get nextButtonLabel => 'NÄCHSTE';

  @override
  String get connectButtonLabel => 'VERBINDEN';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      'Alle Ihre Dateien werden einbezogen. Dies kann die Speichernutzung erhöhen und die Leistung beeinträchtigen';

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
  String get detailsTooltip => 'Eigenschaften';

  @override
  String get downloadTooltip => 'Herunterladen';

  @override
  String get downloadProcessingNotification => 'Datei wird heruntergeladen';

  @override
  String get downloadSuccessNotification => 'Datei erfolgreich heruntergeladen';

  @override
  String get downloadFailureNotification =>
      'Herunterladen der Datei fehlgeschlagen';

  @override
  String get nextTooltip => 'Nächste';

  @override
  String get previousTooltip => 'Vorherige';

  @override
  String get webSelectRangeNotification =>
      'Halten Sie die Umschalttaste gedrückt und klicken Sie, um alle dazwischen auszuwählen';

  @override
  String get mobileSelectRangeNotification =>
      'Drücken Sie lange auf ein anderes Element, um alle dazwischen auszuwählen';

  @override
  String get updateDateTimeDialogTitle => 'Datum und Uhrzeit ändern';

  @override
  String get dateSubtitle => 'Datum';

  @override
  String get timeSubtitle => 'Zeit';

  @override
  String get dateYearInputHint => 'Jahr';

  @override
  String get dateMonthInputHint => 'Monat';

  @override
  String get dateDayInputHint => 'Tag';

  @override
  String get timeHourInputHint => 'Stunde';

  @override
  String get timeMinuteInputHint => 'Minute';

  @override
  String get timeSecondInputHint => 'Sekunde';

  @override
  String get dateTimeInputInvalid => 'Ungültiger Wert';

  @override
  String get updateDateTimeFailureNotification =>
      'Ändern von Datum & Uhrzeit fehlgeschlagen';

  @override
  String get albumDirPickerHeaderText =>
      'Wählen Sie die zu verknüpfenden Ordner aus';

  @override
  String get albumDirPickerSubHeaderText =>
      'Nur Fotos in den zugehörigen Ordnern werden in dieses Album aufgenommen';

  @override
  String get albumDirPickerListEmptyNotification =>
      'Bitte wählen Sie mindestens einen Ordner aus';

  @override
  String get importFoldersTooltip => 'Ordner importieren';

  @override
  String get albumImporterHeaderText => 'Ordner als Alben importieren';

  @override
  String get albumImporterSubHeaderText =>
      'Empfohlene Ordner sind unten aufgeführt. Abhängig von der Anzahl der Dateien auf Ihrem Server kann es eine Weile dauern, bis der Vorgang abgeschlossen ist';

  @override
  String get importButtonLabel => 'IMPORTIEREN';

  @override
  String get albumImporterProgressText => 'Importiere Ordner';

  @override
  String get doneButtonTooltip => 'Fertig';

  @override
  String get editTooltip => 'Bearbeiten';

  @override
  String get editAccountConflictFailureNotification =>
      'Es existiert bereits ein Konto mit denselben Einstellungen';

  @override
  String get genericProcessingDialogContent => 'Bitte warten';

  @override
  String get sortTooltip => 'Sortieren';

  @override
  String get sortOptionDialogTitle => 'Sortieren nach';

  @override
  String get sortOptionTimeAscendingLabel => 'Älteste zuerst';

  @override
  String get sortOptionTimeDescendingLabel => 'Neueste zuerst';

  @override
  String get sortOptionFilenameAscendingLabel => 'Dateiname';

  @override
  String get sortOptionFilenameDescendingLabel => 'Dateiname (absteigend)';

  @override
  String get sortOptionAlbumNameLabel => 'Albumname';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'Albumname (absteigend)';

  @override
  String get sortOptionManualLabel => 'Manuell';

  @override
  String get albumEditDragRearrangeNotification =>
      'Halten Sie ein Element gedrückt und ziehen Sie es, um es manuell neu anzuordnen';

  @override
  String get albumAddTextTooltip => 'Text hinzufügen';

  @override
  String get shareTooltip => 'Teilen';

  @override
  String get shareSelectedEmptyNotification =>
      'Wählen Sie einige Fotos zum Teilen aus';

  @override
  String get shareDownloadingDialogContent => 'Herunterladen';

  @override
  String get searchTooltip => 'Suche';

  @override
  String get clearTooltip => 'Leeren';

  @override
  String get listNoResultsText => 'Keine Ergebnisse';

  @override
  String get listEmptyText => 'Leer';

  @override
  String get albumTrashLabel => 'Papierkorb';

  @override
  String get restoreTooltip => 'Wiederherstellen';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Stelle $count Elemente wieder her',
      one: 'Stelle 1 Element wieder her',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification =>
      'Alle Elemente erfolgreich wiederhergestellt';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fehler beim Wiederherstellen von $count Elementen',
      one: 'Fehler beim Wiederherstellen von 1 Element',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Element wiederherstellen';

  @override
  String get restoreSuccessNotification =>
      'Element erfolgreich wiederhergestellt';

  @override
  String get restoreFailureNotification =>
      'Wiederherstellen des Elements fehlgeschlagen';

  @override
  String get deletePermanentlyTooltip => 'Dauerhaft löschen';

  @override
  String get deletePermanentlyConfirmationDialogTitle => 'Dauerhaft löschen';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      'Ausgewählte Elemente werden dauerhaft vom Server gelöscht.\n\nDiese Aktion ist nicht rückgängig zu machen';

  @override
  String get albumSharedLabel => 'Geteilt';

  @override
  String get metadataTaskProcessingNotification =>
      'Bildmetadaten im Hintergrund verarbeiten';

  @override
  String get configButtonLabel => 'KONFIGURATION';

  @override
  String get useAsAlbumCoverTooltip => 'Als Albumcover verwenden';

  @override
  String get helpTooltip => 'Hilfe';

  @override
  String get helpButtonLabel => 'HILFE';

  @override
  String get removeFromAlbumTooltip => 'Aus Album entfernen';

  @override
  String get changelogTitle => 'Was ist neu?';

  @override
  String get serverCertErrorDialogTitle =>
      'Serverzertifikat kann nicht vertraut werden';

  @override
  String get serverCertErrorDialogContent =>
      'Der Server ist möglicherweise gehackt oder jemand versucht, Ihre Informationen zu stehlen';

  @override
  String get advancedButtonLabel => 'ERWEITERT';

  @override
  String get whitelistCertDialogTitle =>
      'Unbekanntes Zertifikat auf die Whitelist setzen?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'Sie können das Zertifikat auf die Whitelist setzen, damit die App es akzeptiert. WARNUNG: Dies stellt ein großes Sicherheitsrisiko dar. Stellen Sie sicher, dass das Zertifikat von Ihnen oder einer vertrauenswürdigen Partei selbst signiert ist\n\nGastgeber: $host\nFingerabdruck: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel =>
      'AKZEPTIEREN SIE DAS RISIKO UND DIE WHITELIST';

  @override
  String get fileSharedByDescription =>
      'Von diesem Benutzer für Sie freigegeben';

  @override
  String get emptyTrashbinTooltip => 'Leere Papierkorb';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Leere Papierkorb';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      'Alle Elemente werden dauerhaft vom Server gelöscht.\n\nDiese Aktion ist nicht rückgängig zu machen';

  @override
  String get unsetAlbumCoverTooltip => 'Cover aufheben';

  @override
  String get muteTooltip => 'Stumm';

  @override
  String get unmuteTooltip => 'Stummschaltung aufheben';

  @override
  String get collectionPeopleLabel => 'Personen';

  @override
  String get slideshowTooltip => 'Diashow';

  @override
  String get slideshowSetupDialogTitle => 'Diashow einstellen';

  @override
  String get slideshowSetupDialogDurationTitle => 'Bildlaufzeit (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Zufällig';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Wiederholen';

  @override
  String get slideshowSetupDialogReverseTitle => 'Rückwärts';

  @override
  String get linkCopiedNotification => 'Link kopiert';

  @override
  String get shareMethodDialogTitle => 'Teilen als';

  @override
  String get shareMethodPreviewTitle => 'Vorschau';

  @override
  String get shareMethodPreviewDescription =>
      'Eine Vorschau mit reduzierter Qualität mit anderen Apps teilen (unterstützt nur Fotos)';

  @override
  String get shareMethodOriginalFileTitle => 'Originaldatei';

  @override
  String get shareMethodOriginalFileDescription =>
      'Die Originaldatei herunterladen und mit anderen Apps teilen';

  @override
  String get shareMethodPublicLinkTitle => 'Öffentlicher Link';

  @override
  String get shareMethodPublicLinkDescription =>
      'Einen neuen öffentlichen Link auf dem Server erstellen. Jeder mit dem Link hat auf die Datei Zugriff';

  @override
  String get shareMethodPasswordLinkTitle => 'Passwort geschützter Link';

  @override
  String get shareMethodPasswordLinkDescription =>
      'Einen neuen Passwort geschützten Link auf dem Server erstellen';

  @override
  String get collectionSharingLabel => 'Geteilt';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Zuletzt geteilt am $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user hat dies mit dir am $date geteilt';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user teilte ein Album am $date mit Ihnen';
  }

  @override
  String get sharedWithLabel => 'Geteilt mit';

  @override
  String get unshareTooltip => 'Freigabe aufheben';

  @override
  String get unshareSuccessNotification => 'Freigabe entfernen';

  @override
  String get locationLabel => 'Ort';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloud unterstützt keine Freigabelinks für mehrere Dateien. Die App wird stattdessen die Dateien in einen neuen Ordner kopieren und den Ordner freigeben.';

  @override
  String get folderNameInputHint => 'Ordnername';

  @override
  String get folderNameInputInvalidEmpty => 'Bitte Ordnernamen eingeben';

  @override
  String get folderNameInputInvalidCharacters => 'Enthält ungültige Zeichen';

  @override
  String get createShareProgressText => 'Freigabe erstellen';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count Objekte konnten nicht kopiert werden',
      one: '1 Objekt konnte nicht kopiert werden',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Ordner löschen?';

  @override
  String get unshareLinkShareDirDialogContent =>
      'Dieser Ordner wurde von der App erstellt, um mehrere Dateien als Link zu teilen. Er wird nun nicht mehr mit anderen geteilt. Möchten Sie diesen Ordner löschen?';

  @override
  String get addToCollectionsViewTooltip => 'Zu Alben hinzufügen';

  @override
  String get shareAlbumDialogTitle => 'Mit Nutzer teilen';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Album mit $user geteilt, aber einige Dateien konnten nicht geteilt werden.';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'Album mit $user nicht mehr geteilt, aber das Aufheben der Freigabe einiger Dateien ist fehlgeschlagen.';
  }

  @override
  String get fixSharesTooltip => 'Freigaben reparieren';

  @override
  String get fixTooltip => 'Fixieren';

  @override
  String get fixAllTooltip => 'Alle Fixieren';

  @override
  String missingShareDescription(Object user) {
    return 'Nicht geteilt mit $user';
  }

  @override
  String extraShareDescription(Object user) {
    return 'Geteilt mit $user';
  }

  @override
  String get defaultButtonLabel => 'STANDARD';

  @override
  String get addUserInputHint => 'Benutzer hinzufügen';

  @override
  String get sharedAlbumInfoDialogTitle => 'Einführung in geteilte Alben';

  @override
  String get sharedAlbumInfoDialogContent =>
      'Geteilte Alben erlauben mehreren Nutzern auf dem gleichen Server auf das gleiche Album zuzugreifen. Bitte lesen Sie die Einschränkungen sorgfältig durch, bevor Sie fortfahren';

  @override
  String get learnMoreButtonLabel => 'ERFAHRE MEHR';

  @override
  String get migrateDatabaseProcessingNotification => 'Aktualisiere Datenbank';

  @override
  String get migrateDatabaseFailureNotification =>
      'Datenbankmigration fehlgeschlagen';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vor $count Jahren',
      one: 'vor 1 Jahr',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'Home-Verzeichnis nicht gefunden';

  @override
  String get homeFolderNotFoundDialogContent =>
      'Bitte korrigieren Sie die unten angezeigte WebDAV-URL. Sie finden die URL in der Nextcloud-Weboberfläche.';

  @override
  String get homeFolderInputInvalidEmpty =>
      'Bitte geben Sie den Namen Ihres Home-Verzeichnis ein';

  @override
  String get createCollectionTooltip => 'Neues Album';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Client-side album';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      'Album with extra features, accessible only with this app';

  @override
  String get createCollectionDialogFolderLabel => 'Ordner';

  @override
  String get createCollectionDialogFolderDescription =>
      'Zeige Fotos innerhalb eines Ordners';

  @override
  String get collectionFavoritesLabel => 'Favoriten';

  @override
  String get favoriteTooltip => 'Favorit';

  @override
  String get favoriteSuccessNotification => 'Zu Favoriten hinzugefügt';

  @override
  String get favoriteFailureNotification =>
      'Hinzufügen zu Favoriten fehlgeschlagen';

  @override
  String get unfavoriteTooltip => 'Aus Favoriten entfernen';

  @override
  String get unfavoriteSuccessNotification => 'Aus Favoriten entfernt';

  @override
  String get unfavoriteFailureNotification =>
      'Entfernen aus den Favoriten fehlgeschlagen';

  @override
  String get createCollectionDialogTagLabel => 'Schlagwort';

  @override
  String get createCollectionDialogTagDescription =>
      'Zeige Fotos mit spezifischen Schlagworten';

  @override
  String get addTagInputHint => 'Schlagwort hinzufügen';

  @override
  String get tagPickerNoTagSelectedNotification =>
      'Bitte mindestens 1 Schlagwort hinzufügen';

  @override
  String get backgroundServiceStopping => 'Dienst stoppen';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'Akku ist schwach';

  @override
  String get enhanceTooltip => 'Verbessern';

  @override
  String get enhanceButtonLabel => 'VERBESSERN';

  @override
  String get enhanceIntroDialogTitle => 'Verbessern Sie ihre Fotos';

  @override
  String get enhanceIntroDialogDescription =>
      'Ihre Fotos werden lokal auf Ihrem Gerät verarbeitet. Standardmäßig werden sie auf 2048x1536 herunterskaliert. Sie können die Ausgabeauflösung in den Einstellungen anpassen';

  @override
  String get enhanceLowLightTitle =>
      'Verbesserung bei schlechten Lichtverhältnissen';

  @override
  String get enhanceLowLightDescription =>
      'Hellen Sie ihre Fotos auf, die bei schwachen Lichtverhältnissen aufgenommen wurden';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Helligkeit';

  @override
  String get collectionEditedPhotosLabel => 'Geändert (lokal)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      'Die ausgewählten Dateien werden dauerhaft von diesem Gerät gelöscht.\n\nDie Aktion ist unwiderruflich';

  @override
  String get enhancePortraitBlurTitle => 'Portraitunschärfe';

  @override
  String get enhancePortraitBlurDescription =>
      'Machen Sie den Hintergrund Ihrer Fotos unscharf, am besten geeignet für Porträts';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Unschärfe';

  @override
  String get enhanceSuperResolution4xTitle => 'Superauflösung (4x)';

  @override
  String get enhanceSuperResolution4xDescription =>
      'Vergrößern Sie Ihre Fotos auf das 4-fache der ursprünglichen Auflösung (siehe Hilfe für Details wie die maximale Auflösung hier verwendet wird)';

  @override
  String get enhanceStyleTransferTitle => 'Stilübertragung';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Wähle einen Stil';

  @override
  String get enhanceStyleTransferStyleDialogDescription =>
      'Übertrage einen Stil von einem Referenzbild auf deine Fotos';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification =>
      'Bitte wähle einen Stil';

  @override
  String get enhanceColorPopTitle => 'Farben hervorheben';

  @override
  String get enhanceColorPopDescription =>
      'Entsättigen Sie den Hintergrund Ihrer Fotos, am besten geeignet für Porträts';

  @override
  String get enhanceGenericParamWeightLabel => 'Gewicht';

  @override
  String get enhanceRetouchTitle => 'Autoretusche';

  @override
  String get enhanceRetouchDescription =>
      'Retuschieren Sie Ihre Fotos automatisch, verbessern Sie Farbe und Lebendigkeit';

  @override
  String get doubleTapExitNotification => 'Erneut Tippen zum Verlassen';

  @override
  String get imageEditDiscardDialogTitle => 'Änderungen verwerfen?';

  @override
  String get imageEditDiscardDialogContent =>
      'Die Änderungen werden nicht gespeichert';

  @override
  String get discardButtonLabel => 'VERWERFEN';

  @override
  String get saveTooltip => 'Speichern';

  @override
  String get imageEditDownloadDialogTitle => 'Downloading image from server...';

  @override
  String get imageEditProcessDialogTitle => 'Processing image...';

  @override
  String get imageEditSaveDialogTitle => 'Saving result...';

  @override
  String get imageEditColorBrightness => 'Helligkeit';

  @override
  String get imageEditColorContrast => 'Kontrast';

  @override
  String get imageEditColorWhitePoint => 'Weißpunkt';

  @override
  String get imageEditColorBlackPoint => 'Schwarzpunkt';

  @override
  String get imageEditColorSaturation => 'Sättigung';

  @override
  String get imageEditColorWarmth => 'Wärme';

  @override
  String get imageEditColorTint => 'Färbung';

  @override
  String get imageEditTitle => 'Vorschau Änderungen';

  @override
  String get imageEditToolbarColorLabel => 'Farbe';

  @override
  String get imageEditToolbarTransformLabel => 'Umformen';

  @override
  String get imageEditTransformOrientation => 'Orientierung';

  @override
  String get imageEditTransformOrientationClockwise => 're';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'li';

  @override
  String get imageEditTransformCrop => 'Zuschneiden';

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
  String get categoriesLabel => 'Kategorien';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      'Drücken Sie auf \"Einstellungen\", um den Anbieter zu wechseln, oder auf \"Hilfe\", um mehr zu erfahren.';

  @override
  String get searchLandingCategoryVideosLabel => 'Videos';

  @override
  String get searchFilterButtonLabel => 'FILTER';

  @override
  String get searchFilterDialogTitle => 'Suchfilter';

  @override
  String get applyButtonLabel => 'ANWENDEN';

  @override
  String get searchFilterOptionAnyLabel => 'Alle';

  @override
  String get searchFilterOptionTrueLabel => 'Ja';

  @override
  String get searchFilterOptionFalseLabel => 'Nein';

  @override
  String get searchFilterTypeLabel => 'Typ';

  @override
  String get searchFilterTypeOptionImageLabel => 'Bild';

  @override
  String get searchFilterBubbleTypeImageText => 'Bilder';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Video';

  @override
  String get searchFilterBubbleTypeVideoText => 'Videos';

  @override
  String get searchFilterFavoriteLabel => 'Favorit';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'Favoriten';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'keine Favoriten';

  @override
  String get showAllButtonLabel => 'ALLE ANZEIGEN';

  @override
  String gpsPlaceText(Object place) {
    return 'In der Nähe von $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'Über Ort';

  @override
  String get gpsPlaceAboutDialogContent =>
      'Der angezeigte Ort ist nur eine grobe Schätzung und nicht zwangsweise akkurat. Es spiegelt nicht unsere Ansichten über irgendein umstrittenes Gebiet wider.';

  @override
  String get collectionPlacesLabel => 'Orte';

  @override
  String get imageSaveOptionDialogTitle => 'Speichert das Ergebnis';

  @override
  String get imageSaveOptionDialogContent =>
      'Wählen Sie aus, wo dieses und zukünftige verarbeitete Bilder gespeichert werden sollen. Wenn Sie den Server ausgewählt haben, die App das Bild aber nicht hochladen konnte, wird es auf Ihrem Gerät gespeichert.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'GERÄT';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'SERVER';

  @override
  String get initialSyncMessage =>
      'Erstmalige Synchronisierung mit Ihrem Server';

  @override
  String get loopTooltip => 'Schleife';

  @override
  String get createCollectionFailureNotification =>
      'Album konnte nicht erstellt werden';

  @override
  String get addItemToCollectionTooltip => 'Zu Album hinzufügen';

  @override
  String get addItemToCollectionFailureNotification =>
      'Hinzufügen zum Album fehlgeschlagen';

  @override
  String get setCollectionCoverFailureNotification =>
      'Albumcover konnte nicht gesetzt werden';

  @override
  String get exportCollectionTooltip => 'Export';

  @override
  String get exportCollectionDialogTitle => 'Album exportieren';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 => 'Server-side album';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 =>
      'Create an album on your server, accessible with any app';

  @override
  String get removeCollectionsFailedNotification =>
      'Entfernen einiger Alben fehlgeschlagen';

  @override
  String get accountSettingsTooltip => 'Kontoeinstellungen';

  @override
  String get contributorsTooltip => 'Mitwirkende';

  @override
  String get setAsTooltip => 'Festlegen als';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return 'Sie sind dabei, sich abzumelden von $server';
  }

  @override
  String get appLockUnlockHint => 'Entsperren der App';

  @override
  String get appLockUnlockWrongPassword => 'Ungültiges Password';

  @override
  String get enabledText => 'Aktiviert';

  @override
  String get disabledText => 'Deaktiviert';

  @override
  String get trustedCertManagerPageTitle => 'vertrauenswürdige Zertifikate';

  @override
  String get trustedCertManagerAlreadyTrustedError =>
      'Bereits vertrauenswürdig';

  @override
  String get trustedCertManagerSelectServer => 'HTTPS-Server auswählen';

  @override
  String get trustedCertManagerNoHttpsServerError => 'Server nicht verfügbar';

  @override
  String get trustedCertManagerFailedToRemoveCertError =>
      'Fehler beim Löschen des Zertifikates';

  @override
  String get missingVideoThumbnailHelpDialogTitle =>
      'Probleme mit der Video-Miniaturansichten?';

  @override
  String get dontShowAgain => 'Nicht mehr erneut anzeigen';

  @override
  String get mapBrowserDateRangeLabel => 'Zeitspanne';

  @override
  String get mapBrowserDateRangeThisMonth => 'Dieser Monat';

  @override
  String get mapBrowserDateRangePrevMonth => 'letzten Monat';

  @override
  String get mapBrowserDateRangeThisYear => 'Dieses Jahr';

  @override
  String get mapBrowserDateRangeCustom => 'benutzerdefiniert';

  @override
  String get homeTabMapBrowser => 'Karte';

  @override
  String get mapBrowserSetDefaultDateRangeButton => 'Als Standardwert setzen';

  @override
  String get todayText => 'Heute';

  @override
  String get livePhotoTooltip => 'Live photo';

  @override
  String get dragAndDropRearrangeButtons => 'Ziehen um Buttons neu anzuordnen';

  @override
  String get customizeCollectionsNavBarDescription =>
      'Drag and drop to rearrange buttons, tap the buttons above to minimize them';

  @override
  String get customizeButtonsUnsupportedWarning =>
      'This button cannot be customized';

  @override
  String get placePickerTitle => 'Ort auswählen';

  @override
  String get albumAddMapTooltip => 'Karte einfügen';

  @override
  String get fileNotFound => 'Datei nicht gefunden';

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
      'Nicht authentifizierter Zugriff. Bitte melden Sie sich erneut an, wenn das Problem weiterhin besteht';

  @override
  String get errorDisconnected =>
      'Verbindung konnte nicht hergestellt werden. Der Server ist möglicherweise offline oder Ihr Gerät ist möglicherweise nicht verbunden';

  @override
  String get errorLocked =>
      'Datei ist auf Server gesperrt. Bitte versuchen Sie es später noch einmal';

  @override
  String get errorInvalidBaseUrl =>
      'Kann nicht kommunizieren. Bitte stellen Sie sicher, dass die Adresse die Basis-URL Ihrer Nextcloud-Instanz ist';

  @override
  String get errorWrongPassword =>
      'Nicht in der Lage zu authentifizieren. Bitte überprüfen Sie den Benutzernamen und das Passwort noch einmal';

  @override
  String get errorServerError =>
      'Serverfehler. Bitte stellen Sie sicher, dass der Server richtig eingerichtet ist';

  @override
  String get errorAlbumDowngrade =>
      'Dieses Album kann nicht geändert werden, da es mit einer neueren Version dieser App erstellt wurde. Bitte aktualisieren Sie die App und versuchen Sie es erneut';

  @override
  String get errorNoStoragePermission =>
      'Speicherzugriffsberechtigung erforderlich';

  @override
  String get errorServerNoCert =>
      'Server certificate not found. Try HTTP instead?';
}
