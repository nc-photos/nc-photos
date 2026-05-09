// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get appTitle => 'Photos';

  @override
  String get translator => 'pHamala';

  @override
  String get photosTabLabel => 'Kuvat';

  @override
  String get collectionsTooltip => 'Kokoelmat';

  @override
  String get zoomTooltip => 'Tarkenna';

  @override
  String get settingsMenuLabel => 'Asetukset';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count valittu',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Poistetaan $count kohdetta',
      one: 'Poistetaan 1 kohde',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification =>
      'Kaikki valitut kohteet poistettu onnistuneesti';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kohteen poistaminen epäonnistui',
      one: ' 1 kohteen poistaminen epäonnistui',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Arkistoi';

  @override
  String get archiveSelectedSuccessNotification =>
      'Kaikki valitut kohteet arkistoitu';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kohteen arkistointi epäonnistui',
      one: '1 kohteen arkistointi epäonnistui',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Peru arkistointi';

  @override
  String get unarchiveSelectedSuccessNotification =>
      'Kaikkien kohteiden arkistointi peruttu';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kohteen arkistoinnin peruminen epäonnistui',
      one: '1 kohteen arkistoinnin peruminen epäonnistui',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Poista';

  @override
  String get deleteSuccessNotification => 'Kohde poistettu';

  @override
  String get deleteFailureNotification => 'Kohteen poistaminen epäonnistui';

  @override
  String get removeSelectedFromAlbumFailureNotification =>
      'Kohteiden poistaminen albumista epäonnistui';

  @override
  String get addServerTooltip => 'Lisää palvelin';

  @override
  String removeServerSuccessNotification(Object server) {
    return 'Palvelin:$server poistettu';
  }

  @override
  String get createAlbumTooltip => 'Uusi albumi';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kohdetta',
      one: '1 kohde',
      zero: 'Empty',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Arkistoi';

  @override
  String connectingToServer(Object server) {
    return 'Yhdistetään \n$server';
  }

  @override
  String get connectingToServer2 => 'Odotetaan palvelimen tunnistautumista';

  @override
  String get connectingToServerInstruction =>
      'Kirjaudu auenneen selaimen kautta';

  @override
  String get nameInputHint => 'Nimi';

  @override
  String get nameInputInvalidEmpty => 'Nimi vaaditaan';

  @override
  String get skipButtonLabel => 'OHITA';

  @override
  String get confirmButtonLabel => 'VAHVISTA';

  @override
  String get signInHeaderText => 'Kirjaudu Nextcloud-palvelimeen';

  @override
  String get signIn2faHintText =>
      'Käytä sovellussalasanaa, jos käytössäsi on kaksivaiheinen tunnistautuminen';

  @override
  String get signInHeaderText2 => 'Nextcloud\nKirjaudu sisään';

  @override
  String get serverAddressInputHint => 'Palvelimen osoite';

  @override
  String get serverAddressInputInvalidEmpty => 'Syötä palvelimen osoite';

  @override
  String get usernameInputHint => 'Käyttäjätunnus';

  @override
  String get usernameInputInvalidEmpty => 'Syötä käyttäjätunnus';

  @override
  String get passwordInputHint => 'Salasana';

  @override
  String get passwordInputInvalidEmpty => 'Syötä salasana';

  @override
  String get rootPickerHeaderText => 'Valitse sisällytetyt kansiot';

  @override
  String get rootPickerSubHeaderText =>
      'Ainoastaan kansion sisäisest kuvat näytetään. Paina Ohita sisällyttääksesi kaikki kuvat';

  @override
  String get rootPickerNavigateUpItemText => '(takaisin)';

  @override
  String get rootPickerUnpickFailureNotification =>
      'Kohteen valinta epäonnistui';

  @override
  String get rootPickerListEmptyNotification =>
      'Valitse vähintään yksi kansio tai paina ohita sisällyttääksesi kaikki';

  @override
  String get setupWidgetTitle => 'Aloitetaan';

  @override
  String get setupSettingsModifyLaterHint =>
      'Voit muuttaa tämän myöhemmin asetuksista';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      'Tämä sovellus luo Nextcloud-palvelimeen kansion asetustiedostoja. Älä muokkaa tai poista kansiota ellet ole aikeissa poistaa sovellusta';

  @override
  String get settingsWidgetTitle => 'Asetukset';

  @override
  String get settingsLanguageTitle => 'Kieli';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => 'Järjestelmän oletus';

  @override
  String get settingsMetadataTitle => 'Tiedoston metatiedot';

  @override
  String get settingsExifSupportTitle2 => 'Client-side EXIF support';

  @override
  String get settingsExifSupportTrueSubtitle =>
      'Vaatii ylimääräistä verkon käyttöä';

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
  String get settingsMemoriesTitle => 'Muistot';

  @override
  String get settingsMemoriesSubtitle => 'Näytä aiemmin otettuja kuvia';

  @override
  String get settingsAccountTitle => 'Tili';

  @override
  String get settingsAccountLabelTitle => 'Otsikko';

  @override
  String get settingsAccountLabelDescription =>
      'Aseta tunniste, joka näytetään palvelimen URL:n sijasta';

  @override
  String get settingsIncludedFoldersTitle => 'Sisällytetyt kansiot';

  @override
  String get settingsShareFolderTitle => 'Jaa kansio';

  @override
  String get settingsShareFolderDialogTitle => 'Paikanna jaettu kansio';

  @override
  String get settingsShareFolderDialogDescription =>
      'Tämä asetus vaikuttaa share_folder parametreihini config.php -tiedostossa. Asetusten arvojen TÄYTYY olla identtisiä. \n\nPaikanna sama kansio, joka on määritetty config-php -tiedostossa.';

  @override
  String get settingsShareFolderPickerDescription =>
      'Paikanna sama kansio, joka on määritetty config.php -tiedostossa. Paina oletusta, jos et ole määrittänyt parametrejä käsin.';

  @override
  String get settingsPersonProviderTitle => 'Henkilön tarjoaja';

  @override
  String get settingsServerAppSectionTitle => 'Palvelimen sovellustuki';

  @override
  String get settingsPhotosDescription =>
      'Muokkaa Kuvat-välilehdellä näytettävää sisältöä';

  @override
  String get settingsMemoriesRangeTitle => 'Muistojen väli';

  @override
  String settingsMemoriesRangeValueText(num range) {
    String _temp0 = intl.Intl.pluralLogic(
      range,
      locale: localeName,
      other: '+-$range päivää',
      one: '+-$range päivä',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeviceMediaTitle => 'Show device media';

  @override
  String get settingsDeviceMediaDescription =>
      'Selected folders will be displayed';

  @override
  String get settingsViewerTitle => 'Katselin';

  @override
  String get settingsViewerDescription => 'Muokkaa kuva/video -katselinta';

  @override
  String get settingsScreenBrightnessTitle => 'Näytön kirkkaus';

  @override
  String get settingsScreenBrightnessDescription =>
      'Ohita järjestelmän määrittämä kirkkaus';

  @override
  String get settingsForceRotationTitle => 'Ohita näytön kiertäjän lukitus';

  @override
  String get settingsForceRotationDescription =>
      'Kierrä näyttöä, vaikka järjestelmän automaattinen näytönkierto on poiskytketty';

  @override
  String get settingsMapProviderTitle => 'Karttapalvelun-tarjoaja';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'Customize app bar';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle =>
      'Customize bottom app bar';

  @override
  String get settingsShowDateInAlbumTitle => 'Ryhmitä kuvat päivämäärän mukaan';

  @override
  String get settingsShowDateInAlbumDescription =>
      'Käytä vain kun albumi on lajiteltu ajan mukaan';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'Customize navigation bar';

  @override
  String get settingsImageEditTitle => 'Editori';

  @override
  String get settingsImageEditDescription =>
      'Muokkaa kuvien parannusta ja kuvaeditoria';

  @override
  String get settingsEnhanceMaxResolutionTitle2 =>
      'Kuvaresoluutio muokkausta varten';

  @override
  String get settingsEnhanceMaxResolutionDescription =>
      'Määritettyä resoluutiota suuremmat kuvat skaalataan määritettyyn resoluutioon.\n\nKorkean resoluution kuvien käsittely vie huomattavasti enemmän muistia ja aikaa. Mikäli sovellus kaatuu käsittelyn aikana, vähennä tämän asetuksen arvoa.';

  @override
  String get settingsImageEditSaveResultsToServerTitle =>
      'Tallenna muokkaus palvelimelle';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      'Muokkaukset tallennetaan palvelimelle. Virheen sattuessa muokkaukset tallennetaan paikallisesti laitteelle.';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      'Muokkaukset tallennetaan paikallisesti tälle laitteelle.';

  @override
  String get settingsThemeTitle => 'Teema';

  @override
  String get settingsThemeDescription => 'Muokkaa sovelluksen ulkoasua';

  @override
  String get settingsFollowSystemThemeTitle => 'Käytä järjestelmän teemaa';

  @override
  String get settingsSeedColorTitle => 'Teeman väri';

  @override
  String get settingsSeedColorDescription =>
      'Käytetään määrittämään sovelluksen kaikkia värejä';

  @override
  String get settingsSeedColorSystemColorDescription =>
      'Käytä järjestelmän oletusarvoa';

  @override
  String get settingsSeedColorPickerTitle => 'Valitse väri';

  @override
  String get settingsThemePrimaryColor => 'Primary';

  @override
  String get settingsThemeSecondaryColor => 'Secondary';

  @override
  String get settingsThemePresets => 'Presets';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel =>
      'KÄYTÄ JÄRJESTELMÄN OLETUSARVOA';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Tumma teema';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription =>
      'Käytä mustaa tummassa teemassa';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription =>
      'Käytä tumman harmaata tummassa teemassa';

  @override
  String get settingsMiscellaneousTitle => 'Sekalaiset';

  @override
  String get settingsDoubleTapExitTitle => 'Napauta kahdesti poistuaksesi';

  @override
  String get settingsPhotosTabSortByNameTitle =>
      'Järjestä tiedostonimen mukaan';

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
  String get settingsExperimentalTitle => 'Kokeellinen';

  @override
  String get settingsExperimentalDescription =>
      'Kokeellisia ominaisuuksia, jotka eivät ole vielä täysin vakaita';

  @override
  String get settingsExpertTitle => 'Edistyneet';

  @override
  String get settingsExpertWarningText =>
      'Varmista, että olet ymmärtänyt jokaisen vaihtoehdon ennen kuin teet mitään';

  @override
  String get settingsClearCacheDatabaseTitle => 'Puhdista tietokanta';

  @override
  String get settingsClearCacheDatabaseDescription =>
      'Puhdista välitiedostot ja aloita uudelleen synkronointi palvelimen kanssa';

  @override
  String get settingsClearCacheDatabaseSuccessNotification =>
      'Tietokannan puhdistus onnistui. Käynnistä sovellus uudelleen';

  @override
  String get settingsManageTrustedCertificateTitle =>
      'Manage trusted certificates';

  @override
  String get settingsUseNewHttpEngine => 'Use new HTTP engine';

  @override
  String get settingsUseNewHttpEngineDescription =>
      'New HTTP engine based on Chromium, supporting new standards like HTTP/2* and HTTP/3 QUIC*.\n\nLimitations:\nSelf-signed certs can no longer be managed by us. You must import your CA certs to the system trust store for them to work.\n\n* HTTPS is required for HTTP/2 and HTTP/3';

  @override
  String get settingsAboutSectionTitle => 'Tietoa';

  @override
  String get settingsVersionTitle => 'Versio';

  @override
  String get settingsServerVersionTitle => 'Palvelin';

  @override
  String get settingsSourceCodeTitle => 'Lähdekoodi';

  @override
  String get settingsBugReportTitle => 'Ilmoita ongelmasta';

  @override
  String get settingsCaptureLogsTitle => 'Kaappaa lokitiedot';

  @override
  String get settingsCaptureLogsDescription =>
      'Auta kehittäjää korjaamaan bugeja';

  @override
  String get settingsTranslatorTitle => 'Kääntäjä';

  @override
  String get settingsRestartNeededDialog =>
      'Please restart the app to apply changes';

  @override
  String get writePreferenceFailureNotification =>
      'Asetusten tallennus epäonnistui';

  @override
  String get enableButtonLabel => 'OTA KÄYTTÖÖN';

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
      'Lokitietojen tallenusta varten:\n\n1. Ota tämä asetus käyttöön\n2. Toista ongelma\n3. Poista tämä asetus käytöstä\n4. Etsi nc-photos.log -tiedosto latauskansiosta\n\n*Mikäli ongelma kaataa sovelluksen, lokitiedostoja ei pystytä tallentamaan. Tässä tapauksessa ota yhteyttä kehittäjään lisätietoja varten.';

  @override
  String get captureLogSuccessNotification =>
      'Lokitiedot tallennettu onnistuneesti';

  @override
  String get doneButtonLabel => 'VALMIS';

  @override
  String get nextButtonLabel => 'SEURAAVA';

  @override
  String get connectButtonLabel => 'YHDISTÄ';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      'Kaikki tiedostosi sisällytetään. Tämä voi lisä muistinkäyttöä ja hidastaa suorituskykyä.';

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
  String get detailsTooltip => 'Tiedot';

  @override
  String get downloadTooltip => 'Lataus';

  @override
  String get downloadProcessingNotification => 'Ladataan tiedostoa';

  @override
  String get downloadSuccessNotification => 'Tiedoston lataus onnistui';

  @override
  String get downloadFailureNotification => 'Tiedoston lataus epäonnistui';

  @override
  String get nextTooltip => 'Seuraava';

  @override
  String get previousTooltip => 'Edellinen';

  @override
  String get webSelectRangeNotification =>
      'Paina shift + napauta viimeistä kuvaa valitaksesi kuvat niiden välistä';

  @override
  String get mobileSelectRangeNotification =>
      'Paina kohdetta pitkään valitaksesi kaikki niiden väliltä';

  @override
  String get updateDateTimeDialogTitle => 'Muokkaa aikaa ja päiväystä';

  @override
  String get dateSubtitle => 'Päivämäärä';

  @override
  String get timeSubtitle => 'Aika';

  @override
  String get dateYearInputHint => 'Vuosi';

  @override
  String get dateMonthInputHint => 'Kuukausi';

  @override
  String get dateDayInputHint => 'Päivä';

  @override
  String get timeHourInputHint => 'Tunti';

  @override
  String get timeMinuteInputHint => 'Minuutti';

  @override
  String get timeSecondInputHint => 'Sekuntti';

  @override
  String get dateTimeInputInvalid => 'Epäkelpo arvo';

  @override
  String get updateDateTimeFailureNotification =>
      'Ajan ja päiväyksen muuttaminen epäonnistui';

  @override
  String get albumDirPickerHeaderText => 'Valitse mukana olevat albumit';

  @override
  String get albumDirPickerSubHeaderText =>
      'Ainoastaan valituissa kansioissa olevat kuvat näkyvät tässä albumissa';

  @override
  String get albumDirPickerListEmptyNotification =>
      'Valitse vähintään yksi albumi';

  @override
  String get importFoldersTooltip => 'Tuo kansioita';

  @override
  String get albumImporterHeaderText => 'Tuo kansiot albumeiksi';

  @override
  String get albumImporterSubHeaderText =>
      'Suositellut albumit on listattu alapuolelle. Tiedostojen tuontinopeus riippuu tiedostojen määrästä palvelimella.';

  @override
  String get importButtonLabel => 'TUO';

  @override
  String get albumImporterProgressText => 'Importing folders';

  @override
  String get doneButtonTooltip => 'Valmis';

  @override
  String get editTooltip => 'Edit';

  @override
  String get editAccountConflictFailureNotification =>
      'Käyttäjätunnus samoilla asetuksilla on jo olemassa';

  @override
  String get genericProcessingDialogContent => 'Ole hyvä ja odota';

  @override
  String get sortTooltip => 'Lajittele';

  @override
  String get sortOptionDialogTitle => 'Sort by';

  @override
  String get sortOptionTimeAscendingLabel => 'Vanhin ensin';

  @override
  String get sortOptionTimeDescendingLabel => 'Uusin ensin';

  @override
  String get sortOptionFilenameAscendingLabel => 'Tiedostonimi';

  @override
  String get sortOptionFilenameDescendingLabel => 'Tiedostonimi (laskeutuva)';

  @override
  String get sortOptionAlbumNameLabel => 'Albumin nimi';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'Albumin nimi (laskeva)';

  @override
  String get sortOptionManualLabel => 'Käsin';

  @override
  String get albumEditDragRearrangeNotification =>
      'Paina kohdetta pitkään järjestääksesi sen uudelleen käsin';

  @override
  String get albumAddTextTooltip => 'Lisää teksti';

  @override
  String get shareTooltip => 'Jaa';

  @override
  String get shareSelectedEmptyNotification => 'Valitse kuvia jaettavaksi';

  @override
  String get shareDownloadingDialogContent => 'Ladataan';

  @override
  String get searchTooltip => 'Etsi';

  @override
  String get clearTooltip => 'Clear';

  @override
  String get listNoResultsText => 'Ei tuloksia';

  @override
  String get listEmptyText => 'Tyhjä';

  @override
  String get albumTrashLabel => 'Roskakori';

  @override
  String get restoreTooltip => 'Palauta';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Palautetaan $count kohdetta',
      one: 'Palautetaan 1 kohde',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification =>
      'Kaikki kohteet palautettu onnistuneesti';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kohteen palautus epäonnistui',
      one: '1 kohteen palautus epäonnistui',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Palautetaan kohdetta';

  @override
  String get restoreSuccessNotification => 'Kohde palautettu onnistuneesti';

  @override
  String get restoreFailureNotification => 'Kohteen palautus epäonnistui';

  @override
  String get deletePermanentlyTooltip => 'Poista lopullisesti';

  @override
  String get deletePermanentlyConfirmationDialogTitle => 'Poista lopullisesti';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      ' Valitut kohteet poistetaan palvelimelta lopullisesti.\n\nTätä toimintoa ei voi perua';

  @override
  String get albumSharedLabel => 'Jaetut';

  @override
  String get metadataTaskProcessingNotification =>
      'Prosessoidaan kuvien metadataa taustalla';

  @override
  String get configButtonLabel => 'ASETUS';

  @override
  String get useAsAlbumCoverTooltip => 'Use as album cover';

  @override
  String get helpTooltip => 'Tuki';

  @override
  String get helpButtonLabel => 'TUKI';

  @override
  String get removeFromAlbumTooltip => 'Poista albumista';

  @override
  String get changelogTitle => 'Muutosloki';

  @override
  String get serverCertErrorDialogTitle =>
      'Palvelisertifikaattiin ei voida luottaa';

  @override
  String get serverCertErrorDialogContent =>
      'Palvelimeen on mahdollisesti murtauduttu tai joku yrittää mahdollisesti varastaa tietojasi';

  @override
  String get advancedButtonLabel => 'EDISTYNEET';

  @override
  String get whitelistCertDialogTitle => 'Salli tuntematon sertifikaatti?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'Voit sallia sertifikaatin ja saada sovelluksen hyväksymään sen. VAROITUS: Tämä on tietoturvariski! Varmista, että sertifikaatin on luonut sinä itse tai luotettava taho\n\nHost: $host\nSormenjälki: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel => 'HYVÄKSY RISKIT JA SALLI';

  @override
  String get fileSharedByDescription => 'Jaettu sinulle tältä käyttäjältä';

  @override
  String get emptyTrashbinTooltip => 'Tyhjä roskakori';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Tyhjä roskakori';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      'Kaikki kohteet poistetaan lopullisesti palvelimelta\n\nTätä ei voi peruuttaa';

  @override
  String get unsetAlbumCoverTooltip => 'Poista albumin kansi';

  @override
  String get muteTooltip => 'Mykistä';

  @override
  String get unmuteTooltip => 'Poista mykistys';

  @override
  String get collectionPeopleLabel => 'Ihmiset';

  @override
  String get slideshowTooltip => 'Kuvasarja';

  @override
  String get slideshowSetupDialogTitle => 'Aseta kuvasarja';

  @override
  String get slideshowSetupDialogDurationTitle => 'Kuvan kesto (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Sekoita';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Toista';

  @override
  String get slideshowSetupDialogReverseTitle => 'Käänteinen';

  @override
  String get linkCopiedNotification => 'Linkki kopioitu';

  @override
  String get shareMethodDialogTitle => 'Jaa';

  @override
  String get shareMethodPreviewTitle => 'Esikatselu';

  @override
  String get shareMethodPreviewDescription =>
      'Jaa heikkolaatuisempi esikatselu muihin sovelluksiin (vain kuvat tuettu)';

  @override
  String get shareMethodOriginalFileTitle => 'Alkuperäinen tiedosto';

  @override
  String get shareMethodOriginalFileDescription =>
      'Lataa alkuperäinen tiedosto ja jaa se muiden sovellusten kanssa';

  @override
  String get shareMethodPublicLinkTitle => 'Julkinen linkki';

  @override
  String get shareMethodPublicLinkDescription =>
      'Luo julkinen linkki palvelimelle. Kaikki linkinhaltijat voivat käyttää tiedostoa';

  @override
  String get shareMethodPasswordLinkTitle => 'Password protected link';

  @override
  String get shareMethodPasswordLinkDescription =>
      'Luo uusi salasanasuojattu linkki palvelimelle';

  @override
  String get collectionSharingLabel => 'Jaettu';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Jaettu viimeksi $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user jakoi kanssasi $date';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user jakoi albumin kanssasi $date';
  }

  @override
  String get sharedWithLabel => 'Jaettu';

  @override
  String get unshareTooltip => 'Poista jako';

  @override
  String get unshareSuccessNotification => 'Poistetut jaot';

  @override
  String get locationLabel => 'Sijainti';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloud ei tue linkin jakoa usealle tiedostolle. Sovellus KOPIO sen sijaan tiedostot kansioon ja jakaa luodun kansion.';

  @override
  String get folderNameInputHint => 'Kansion nimi';

  @override
  String get folderNameInputInvalidEmpty => 'Syötä kansion nimi';

  @override
  String get folderNameInputInvalidCharacters =>
      'Sisältää sopimattomia merkkejä';

  @override
  String get createShareProgressText => 'Luodaan jakoa';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count kohteen kopiointi epäonnistui',
      one: ' 1 kohteen kopiointi epäonnistui',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Poista kansio?';

  @override
  String get unshareLinkShareDirDialogContent =>
      'Sovellus loi tämän kansion jakaakseen useamman tiedoston samalla linkillä. Sitä ei enää jaeta kenenkään kanssa. Haluatko poistaa tämän kansion?';

  @override
  String get addToCollectionsViewTooltip => 'Lisää kokoelmaan';

  @override
  String get shareAlbumDialogTitle => 'Jaa toisen käyttäjän kanssa';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Albumi jaettu käyttäjän $user kanssa. Joidenkin tiedostojen jako kuitenkin epäonnistui';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'Albumin jakaminen käyttäjän $user kanssa lopetettu. Joidenkin tiedostojen jakaminen kuitenkin epäonnistui';
  }

  @override
  String get fixSharesTooltip => 'Korjaa jaot';

  @override
  String get fixTooltip => 'Korjaa';

  @override
  String get fixAllTooltip => 'Korjaa kaikki';

  @override
  String missingShareDescription(Object user) {
    return 'Ei jaettu käyttäjäm $user kanssa';
  }

  @override
  String extraShareDescription(Object user) {
    return 'Jaettu käyttäjän $user kanssa';
  }

  @override
  String get defaultButtonLabel => 'OLETUS';

  @override
  String get addUserInputHint => 'Lisää käyttäjä';

  @override
  String get sharedAlbumInfoDialogTitle =>
      'Uutena ominaisuutena jaetut albumit';

  @override
  String get sharedAlbumInfoDialogContent =>
      'Jaetut albumit sallii useiden käyttäjien yhtäaikaisen pääsyn albumiin. Lue huolellisesti jaettujen albumien rajoitukset ennen käyttöä';

  @override
  String get learnMoreButtonLabel => 'LUE LISÄÄ';

  @override
  String get migrateDatabaseProcessingNotification => 'Päivitetään tietokantaa';

  @override
  String get migrateDatabaseFailureNotification =>
      'Tietokantojen yhdistäminen epäonnistui';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vuotta sitten',
      one: '1 vuosi sitten',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'Kotikansiota ei löytynyt';

  @override
  String get homeFolderNotFoundDialogContent =>
      'Korjaa WebDAV URL-osoite. Löydät URL-osoitteen Nextloud-verkkokäyttöliittymästä.';

  @override
  String get homeFolderInputInvalidEmpty => 'Nimeä kotikansiosi';

  @override
  String get createCollectionTooltip => 'Uusi kokoelma';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Client-side album';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      'Album with extra features, accessible only with this app';

  @override
  String get createCollectionDialogFolderLabel => 'Kansio';

  @override
  String get createCollectionDialogFolderDescription =>
      'Näytä kaikki kansion kuvat';

  @override
  String get collectionFavoritesLabel => 'Suosikit';

  @override
  String get favoriteTooltip => 'Suosikki';

  @override
  String get favoriteSuccessNotification => 'Lisää suosikkeihin';

  @override
  String get favoriteFailureNotification =>
      'Kuvien lisäys suosikkeihin epäonnistui';

  @override
  String get unfavoriteTooltip => 'Poista suosikeista';

  @override
  String get unfavoriteSuccessNotification => 'Poistettu suosikeista';

  @override
  String get unfavoriteFailureNotification => 'Suosikeista poisto epäonnistui';

  @override
  String get createCollectionDialogTagLabel => 'Tunniste';

  @override
  String get createCollectionDialogTagDescription =>
      'Näytä kuvat tietyillä tunnisteilla';

  @override
  String get addTagInputHint => 'Lisää tunniste';

  @override
  String get tagPickerNoTagSelectedNotification =>
      'Lisää ainakin yksi tunniste';

  @override
  String get backgroundServiceStopping => 'Pysäytetään palvelua';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'Akku on vähissä';

  @override
  String get enhanceTooltip => 'Paranna';

  @override
  String get enhanceButtonLabel => 'PARANNA';

  @override
  String get enhanceIntroDialogTitle => 'Paranna kuviasi';

  @override
  String get enhanceIntroDialogDescription =>
      'Kuviasi käsitellään paikallisesti laitteellasi. Oletuksena kuvat skaalataan resoluutioon 2048x1536. Voit muuttaa tämän resoluution asetuksista.';

  @override
  String get enhanceLowLightTitle => 'Hämärässä otettujen kuvien parannus';

  @override
  String get enhanceLowLightDescription =>
      'Kirkasta hämärässä ympäristössä otettuja kuvia';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Kirkkaus';

  @override
  String get collectionEditedPhotosLabel => 'Muokatut (paikallinen)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      'Valitut kuvat poistetaan lopullisesti laitteeltasi.\n\nTätä toimintoa ei voi perua.';

  @override
  String get enhancePortraitBlurTitle => 'Muotokuvan sumennus';

  @override
  String get enhancePortraitBlurDescription =>
      'Sumenna kuviesi taustaa, toimii parhaiten muotokuvien kanssa';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Blurriness';

  @override
  String get enhanceSuperResolution4xTitle => 'Super-resoluutio (4x)';

  @override
  String get enhanceSuperResolution4xDescription =>
      'Skaalaa kuviesi resoluutiota jopa 4x normaalista resoluutiosta. (Lue kohta Apua saadaksesi lisätietoa, kuinka toiminto toimii.)';

  @override
  String get enhanceStyleTransferTitle => 'Tyylin siirto';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Valitse tyyli';

  @override
  String get enhanceStyleTransferStyleDialogDescription =>
      'Siirrä kuvan tyyli vertailukuvasta omiin kuviisi.';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification => 'Valitse tyyli';

  @override
  String get enhanceColorPopTitle => 'Värihyppy';

  @override
  String get enhanceColorPopDescription =>
      'Vähennä kuvien taustan saturaatiota, toimii parhaiten muotokuvien kanssa.';

  @override
  String get enhanceGenericParamWeightLabel => 'Paino';

  @override
  String get enhanceRetouchTitle => 'Automaattinen parannus';

  @override
  String get enhanceRetouchDescription =>
      'Paranna kuvia automaattisesti. Parantaa kuvien värisävyjä.';

  @override
  String get doubleTapExitNotification => 'Napauta uudelleen poistuaksesi';

  @override
  String get imageEditDiscardDialogTitle => 'Hylkää muutokset?';

  @override
  String get imageEditDiscardDialogContent => 'Muutoksia ei tallennettu';

  @override
  String get discardButtonLabel => 'HYLKÄÄ';

  @override
  String get saveTooltip => 'Save';

  @override
  String get imageEditDownloadDialogTitle => 'Downloading image from server...';

  @override
  String get imageEditProcessDialogTitle => 'Processing image...';

  @override
  String get imageEditSaveDialogTitle => 'Saving result...';

  @override
  String get imageEditColorBrightness => 'Kirkkaus';

  @override
  String get imageEditColorContrast => 'Kontrasti';

  @override
  String get imageEditColorWhitePoint => 'Valkoinen piste';

  @override
  String get imageEditColorBlackPoint => 'Musta piste';

  @override
  String get imageEditColorSaturation => 'Saturaatio';

  @override
  String get imageEditColorWarmth => 'Lämpö';

  @override
  String get imageEditColorTint => 'Värisävy';

  @override
  String get imageEditTitle => 'Esikatsele muutoksia';

  @override
  String get imageEditToolbarColorLabel => 'Väri';

  @override
  String get imageEditToolbarTransformLabel => 'Muuta';

  @override
  String get imageEditTransformOrientation => 'Kierto';

  @override
  String get imageEditTransformOrientationClockwise => 'myötäpäivään';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'vastapäivään';

  @override
  String get imageEditTransformCrop => 'Rajaa';

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
  String get categoriesLabel => 'Luokat';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      'Valitse \"asetukset\" vaihtaaksesi tarjoajaa tai paina \"apua\" saadaksesi lisää tietoa';

  @override
  String get searchLandingCategoryVideosLabel => 'Videot';

  @override
  String get searchFilterButtonLabel => 'SUODATTIMET';

  @override
  String get searchFilterDialogTitle => 'Hakusuodattimet';

  @override
  String get applyButtonLabel => 'KÄYTÄ';

  @override
  String get searchFilterOptionAnyLabel => 'Kaikki';

  @override
  String get searchFilterOptionTrueLabel => 'Tosi';

  @override
  String get searchFilterOptionFalseLabel => 'Epätosi';

  @override
  String get searchFilterTypeLabel => 'Tyyppi';

  @override
  String get searchFilterTypeOptionImageLabel => 'Kuva';

  @override
  String get searchFilterBubbleTypeImageText => 'kuvat';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Video';

  @override
  String get searchFilterBubbleTypeVideoText => 'videot';

  @override
  String get searchFilterFavoriteLabel => 'Suosikki';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'suosikit';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'ei suosikeissa';

  @override
  String get showAllButtonLabel => 'NÄYTÄ KAIKKI';

  @override
  String gpsPlaceText(Object place) {
    return 'Seuraava $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'Paikasta';

  @override
  String get gpsPlaceAboutDialogContent =>
      'Näytetty paikka on vain karkea arvio. Se ei välttämättä ole tarkka. Paikka ei kuvaa sovelluksen kehittäjien näkökantaa alueesta.';

  @override
  String get collectionPlacesLabel => 'Paikat';

  @override
  String get imageSaveOptionDialogTitle => 'Tallennetaan tulosta';

  @override
  String get imageSaveOptionDialogContent =>
      'Valitse mihin prosessoidut kuvat tallennetaan. Mikäli kuvansiirto palvelimelle epäonnistuu, tallennetaan kuva laitteelle.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'LAITE';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'PALVELIN';

  @override
  String get initialSyncMessage =>
      'Synkronoidaan palvelimen kanssa ensimmäistä kertaa';

  @override
  String get loopTooltip => 'Uudelleentoista';

  @override
  String get createCollectionFailureNotification =>
      'Kokoelman luonti epäonnistui';

  @override
  String get addItemToCollectionTooltip => 'Lisää kokoelmaan';

  @override
  String get addItemToCollectionFailureNotification =>
      'Kokoelmaan lisääminen epäonnistui';

  @override
  String get setCollectionCoverFailureNotification =>
      'Kokoelman kansikuvan asetus epäonnistui';

  @override
  String get exportCollectionTooltip => 'Vie';

  @override
  String get exportCollectionDialogTitle => 'Vie kokoelma';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 => 'Server-side album';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 =>
      'Create an album on your server, accessible with any app';

  @override
  String get removeCollectionsFailedNotification =>
      'Joidenkin kokoelmien poisto epäonnistui';

  @override
  String get accountSettingsTooltip => 'Tiliasetukset';

  @override
  String get contributorsTooltip => 'Avustajat';

  @override
  String get setAsTooltip => 'Aseta';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return 'Olet aikeissa uloskirjautua palvelimelta  $server';
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
  String get recognizeInstructionDialogTitle =>
      'Setup required for Recognize integration';

  @override
  String get recognizeInstructionDialogContent =>
      'Since Nextcloud 33, a server-side app is required to support Recognize.';

  @override
  String get recognizeInstructionDialogButton => 'Open Guide';

  @override
  String get errorUnauthenticated =>
      'Ei sallittu pääsyä. Kirjaudu sovellukseen uudelleen mikäli virhe toistuu';

  @override
  String get errorDisconnected =>
      'Yhdistäminen epäonnistui. Palvelin saattaa olla offline-tilassa tai mobiililaitettasi ei ole kytketty verkkoon';

  @override
  String get errorLocked =>
      'Tiedosto lukittu palvelimella. Yritä myöhemmin uudelleen';

  @override
  String get errorInvalidBaseUrl =>
      'Yhteyttä ei voitu muodostaa. Varmista, että Nextcloud-palvelimesi URL-osoite on oikein';

  @override
  String get errorWrongPassword =>
      'Kirjautuminen epäonnistui. Varmista, että käyttäjätunnuksesi ja salasanasi on oikein';

  @override
  String get errorServerError =>
      'Palvelin-virhe. Varmista, että palvelin on konfiguroitu oikein';

  @override
  String get errorAlbumDowngrade =>
      'Albumia ei voitu muokata, koska albumi on luotu sovelluksen uudemmalla versiolla. Päivitä sovellus viimeisimpään versioon ja yritä uudelleen';

  @override
  String get errorNoStoragePermission => 'Tallennustilan käyttölupa vaaditaan';

  @override
  String get errorServerNoCert =>
      'Server certificate not found. Try HTTP instead?';
}
