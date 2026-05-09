// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get appTitle => 'Fotky';

  @override
  String get translator => 'Števob';

  @override
  String get photosTabLabel => 'Fotky';

  @override
  String get collectionsTooltip => 'Zbierky';

  @override
  String get zoomTooltip => 'Priblížiť';

  @override
  String get settingsMenuLabel => 'Nastavenia';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count vybraných',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mazanie $count položiek',
      one: 'Mazanie 1 položky',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification =>
      'Všetky položky boli úspešne odstránené';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nepodarilo sa vymazať $count položiek',
      one: 'Nepodarilo sa vymazať 1 položku',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Archivovať';

  @override
  String get archiveSelectedSuccessNotification =>
      'Všetky položky boli úspešne archivované';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nepodarilo sa archivovať $count položiek',
      one: 'Nepodarilo sa archivovať 1 položku',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Dearchivovať';

  @override
  String get unarchiveSelectedSuccessNotification =>
      'Všetky položky boli úspešne dearchivované';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nepodarilo sa dearchivovať $count položiek',
      one: 'Nepodarilo sa dearchivovať 1 položku',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Odstrániť';

  @override
  String get deleteSuccessNotification => 'Položka úspešne odstránená';

  @override
  String get deleteFailureNotification => 'Nepodarilo sa vymazať položku';

  @override
  String get removeSelectedFromAlbumFailureNotification =>
      'Nepodarilo sa odstrániť položky z albumu';

  @override
  String get addServerTooltip => 'Pridať server';

  @override
  String removeServerSuccessNotification(Object server) {
    return 'Server $server úspešne odstránený';
  }

  @override
  String get createAlbumTooltip => 'Nový album';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count položiek',
      one: '1 položka',
      zero: 'Prázdne',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Archív';

  @override
  String connectingToServer(Object server) {
    return 'Pripájam sa k\n$server';
  }

  @override
  String get connectingToServer2 => 'Čakám na autorizáciu zo strany servera';

  @override
  String get connectingToServerInstruction =>
      'Prihláste sa cez otvorený prehliadač';

  @override
  String get nameInputHint => 'Názov';

  @override
  String get nameInputInvalidEmpty => 'Názov je povinný';

  @override
  String get skipButtonLabel => 'PRESKOČIŤ';

  @override
  String get confirmButtonLabel => 'POTVRDIŤ';

  @override
  String get signInHeaderText => 'Prihláste sa na Nextcloud server';

  @override
  String get signIn2faHintText =>
      'Použite heslo aplikácie, ak máte na serveri povolené dvojfaktorové overenie';

  @override
  String get signInHeaderText2 => 'Nextcloud\nPrihlásiť sa';

  @override
  String get serverAddressInputHint => 'Adresa servera';

  @override
  String get serverAddressInputInvalidEmpty => 'Zadajte adresu servera';

  @override
  String get usernameInputHint => 'Používateľské meno';

  @override
  String get usernameInputInvalidEmpty => 'Zadajte svoje používateľské meno';

  @override
  String get passwordInputHint => 'Heslo';

  @override
  String get passwordInputInvalidEmpty => 'Zadajte svoje heslo';

  @override
  String get rootPickerHeaderText => 'Vyberte priečinky, ktoré sa majú zahrnúť';

  @override
  String get rootPickerSubHeaderText =>
      'Zobrazia sa len fotografie vo vnútri vybraných priečinkov. Stlačte Preskočiť pre zahrnutie všetkých';

  @override
  String get rootPickerNavigateUpItemText => '(ísť späť)';

  @override
  String get rootPickerUnpickFailureNotification =>
      'Nepodarilo sa zrušiť výber položky';

  @override
  String get rootPickerListEmptyNotification =>
      'Vyberte aspoň jeden priečinok alebo stlačte preskočiť pre zahrnutie všetkých';

  @override
  String get setupWidgetTitle => 'Začíname';

  @override
  String get setupSettingsModifyLaterHint =>
      'Môžete to neskôr zmeniť v Nastaveniach';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      'Táto aplikácia vytvára priečinok na Nextcloud serveri pre uloženie súborov s preferenciami. Prosím neupravujte ani neodstraňujte ho, pokiaľ neplánujete odstrániť túto aplikáciu';

  @override
  String get settingsWidgetTitle => 'Nastavenia';

  @override
  String get settingsLanguageTitle => 'Jazyk';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => 'Predvolená systémová';

  @override
  String get settingsMetadataTitle => 'Metadata súborov';

  @override
  String get settingsExifSupportTitle2 => 'Klientská podpora EXIF';

  @override
  String get settingsExifSupportTrueSubtitle =>
      'Vyžaduje dodatočný sieťový prenos';

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
  String get settingsMemoriesTitle => 'Spomienky';

  @override
  String get settingsMemoriesSubtitle =>
      'Zobraziť fotografie nasnímané v minulosti';

  @override
  String get settingsAccountTitle => 'Účet';

  @override
  String get settingsAccountLabelTitle => 'Označenie';

  @override
  String get settingsAccountLabelDescription =>
      'Nastavte označenie, ktoré sa zobrazí namiesto URL servera';

  @override
  String get settingsIncludedFoldersTitle => 'Zahrnuté priečinky';

  @override
  String get settingsShareFolderTitle => 'Zdieľaný priečinok';

  @override
  String get settingsShareFolderDialogTitle => 'Nájsť priečinok na zdieľanie';

  @override
  String get settingsShareFolderDialogDescription =>
      'Toto nastavenie zodpovedá parametru share_folder v config.php. Obe hodnoty MUSIA byť identické.\n\nNájdite ten istý priečinok, aký je nastavený v config.php.';

  @override
  String get settingsShareFolderPickerDescription =>
      'Nájdite ten istý priečinok, aký je nastavený v config.php. Stlačte predvolené, ak ste parameter nenastavili.';

  @override
  String get settingsPersonProviderTitle => 'Poskytovateľ osôb';

  @override
  String get settingsServerAppSectionTitle => 'Podpora serverovej aplikácie';

  @override
  String get settingsPhotosDescription =>
      'Prispôsobiť obsah zobrazený na karte Fotky';

  @override
  String get settingsMemoriesRangeTitle => 'Rozsah spomienok';

  @override
  String settingsMemoriesRangeValueText(num range) {
    String _temp0 = intl.Intl.pluralLogic(
      range,
      locale: localeName,
      other: '+-$range dní',
      one: '+-$range deň',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeviceMediaTitle => 'Show device media';

  @override
  String get settingsDeviceMediaDescription =>
      'Selected folders will be displayed';

  @override
  String get settingsViewerTitle => 'Prehliadač';

  @override
  String get settingsViewerDescription =>
      'Prispôsobiť prehliadač obrázkov/videí';

  @override
  String get settingsScreenBrightnessTitle => 'Jas obrazovky';

  @override
  String get settingsScreenBrightnessDescription =>
      'Prepísať systémovú úroveň jasu';

  @override
  String get settingsForceRotationTitle => 'Ignorovať uzamknutie rotácie';

  @override
  String get settingsForceRotationDescription =>
      'Otočte obrazovku aj keď je automatické otáčanie zakázané';

  @override
  String get settingsMapProviderTitle => 'Poskytovateľ máp';

  @override
  String get settingsViewerCustomizeAppBarTitle =>
      'Prispôsobiť hornú lištu aplikácie';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle =>
      'Prispôsobiť spodnú lištu aplikácie';

  @override
  String get settingsShowDateInAlbumTitle => 'Zoskupiť fotografie podľa dátumu';

  @override
  String get settingsShowDateInAlbumDescription =>
      'Použiť len keď je album triedený podľa času';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'Prispôsobiť navigačný panel';

  @override
  String get settingsImageEditTitle => 'Editor';

  @override
  String get settingsImageEditDescription =>
      'Prispôsobiť vylepšenia obrázkov a editor obrázkov';

  @override
  String get settingsEnhanceMaxResolutionTitle2 =>
      'Rozlíšenie obrázkov pre vylepšenia';

  @override
  String get settingsEnhanceMaxResolutionDescription =>
      'Fotografie väčšie než zvolené rozlíšenie budú zmenšené.\n\nVeľmi vysoké rozlíšenie vyžaduje podstatne viac pamäte a času na spracovanie. Ak aplikácia padá pri vylepšovaní fotiek, znížte túto hodnotu.';

  @override
  String get settingsImageEditSaveResultsToServerTitle =>
      'Ukladať výsledky na server';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      'Výsledky sa ukladajú na server, ak sa nepodarí nahrať, uložia sa do zariadenia';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      'Výsledky sa ukladajú do tohto zariadenia';

  @override
  String get settingsThemeTitle => 'Téma';

  @override
  String get settingsThemeDescription => 'Prispôsobiť vzhľad aplikácie';

  @override
  String get settingsFollowSystemThemeTitle => 'Riaď sa systémovou témou';

  @override
  String get settingsSeedColorTitle => 'Farba témy';

  @override
  String get settingsSeedColorDescription =>
      'Používa sa na odvodenie všetkých farieb v aplikácii';

  @override
  String get settingsSeedColorSystemColorDescription =>
      'Použiť systémovú farbu';

  @override
  String get settingsSeedColorPickerTitle => 'Vyberte farbu';

  @override
  String get settingsThemePrimaryColor => 'Primárna';

  @override
  String get settingsThemeSecondaryColor => 'Sekundárna';

  @override
  String get settingsThemePresets => 'Predvoľby';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel =>
      'POUŽIŤ SYSTÉMOVÚ FARBU';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Tmavšia téma';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription =>
      'Použiť čiernu v tmavej téme';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription =>
      'Použiť tmavosivú v tmavej téme';

  @override
  String get settingsMiscellaneousTitle => 'Rôzne';

  @override
  String get settingsDoubleTapExitTitle => 'Dvojité ťuknutie pre ukončenie';

  @override
  String get settingsPhotosTabSortByNameTitle =>
      'Triediť podľa názvu súboru v Fotkách';

  @override
  String get settingsAppLock => 'Zámok aplikácie';

  @override
  String get settingsAppLockTypeBiometric => 'Biometria';

  @override
  String get settingsAppLockTypePin => 'PIN';

  @override
  String get settingsAppLockTypePassword => 'Heslo';

  @override
  String get settingsAppLockDescription =>
      'Ak je povolené, pri otvorení aplikácie budete požiadaní o autentifikáciu. Táto funkcia VÁS NECHRÁNI pred reálnymi fyzickými útokmi.';

  @override
  String get settingsAppLockSetupBiometricFallbackDialogTitle =>
      'Vyberte alternatívu, keď nie je k dispozícii biometria';

  @override
  String get settingsAppLockSetupPinDialogTitle =>
      'Nastavte PIN na odomknutie aplikácie';

  @override
  String get settingsAppLockConfirmPinDialogTitle =>
      'Zadajte rovnaký PIN znova';

  @override
  String get settingsAppLockSetupPasswordDialogTitle =>
      'Nastavte heslo na odomknutie aplikácie';

  @override
  String get settingsAppLockConfirmPasswordDialogTitle =>
      'Zadajte rovnaké heslo znova';

  @override
  String get settingsViewerUseOriginalImageTitle =>
      'Show original image instead of high quality preview in viewer';

  @override
  String get settingsExperimentalTitle => 'Experimentálne';

  @override
  String get settingsExperimentalDescription =>
      'Funkcie, ktoré nie sú pripravené na každodenné použitie';

  @override
  String get settingsExpertTitle => 'Pokročilé';

  @override
  String get settingsExpertWarningText =>
      'Uistite sa, že plne rozumiete účelu každej možnosti pred pokračovaním';

  @override
  String get settingsClearCacheDatabaseTitle => 'Vymazať databázu súborov';

  @override
  String get settingsClearCacheDatabaseDescription =>
      'Vymažte info o súboroch z cache a spustite úplnú resynchronizáciu so serverom';

  @override
  String get settingsClearCacheDatabaseSuccessNotification =>
      'Databáza úspešne vymazaná. Odporúča sa reštartovať aplikáciu';

  @override
  String get settingsManageTrustedCertificateTitle =>
      'Spravovať dôveryhodné certifikáty';

  @override
  String get settingsUseNewHttpEngine => 'Použiť nový HTTP engine';

  @override
  String get settingsUseNewHttpEngineDescription =>
      'Nový HTTP engine založený na Chromium, podporuje nové štandardy ako HTTP/2* a HTTP/3 QUIC*.\n\nObmedzenia:\nVlastnoručne podpísané certifikáty nemožno nami spravovať. Musíte importovať vaše CA certifikáty do systémového úložiska dôveryhodných certifikátov.\n\n* HTTPS je požadované pre HTTP/2 a HTTP/3';

  @override
  String get settingsAboutSectionTitle => 'O aplikácii';

  @override
  String get settingsVersionTitle => 'Verzia';

  @override
  String get settingsServerVersionTitle => 'Server';

  @override
  String get settingsSourceCodeTitle => 'Zdrojový kód';

  @override
  String get settingsBugReportTitle => 'Nahlásiť problém';

  @override
  String get settingsCaptureLogsTitle => 'Zachytiť protokoly';

  @override
  String get settingsCaptureLogsDescription =>
      'Pomôžte vývojárovi diagnostikovať chyby';

  @override
  String get settingsTranslatorTitle => 'Prekladateľ';

  @override
  String get settingsRestartNeededDialog =>
      'Reštartujte aplikáciu pre použitie zmien';

  @override
  String get writePreferenceFailureNotification =>
      'Nepodarilo sa nastaviť preferenciu';

  @override
  String get enableButtonLabel => 'POVOLIŤ';

  @override
  String get enableButtonLabel2 => 'Enable';

  @override
  String get exifSupportNextcloud28Notes =>
      'Klientska podpora dopĺňa váš server. Aplikácia spracuje súbory a atribúty nepodporované Nextcloudom';

  @override
  String get exifSupportConfirmationDialogTitle2 =>
      'Povoliť klientsku podporu EXIF?';

  @override
  String get captureLogDetails =>
      'Ak chcete vytvoriť protokoly pre nahlásenie chyby:\n\n1. Povoľte toto nastavenie\n2. Reprodukujte problém\n3. Zakážte toto nastavenie\n4. Nájdite súbor nc-photos.log v priečinku na stiahnutie\n\n*Ak problém spôsobí pád aplikácie, protokoly nebude možné zachytiť. V takom prípade prosím kontaktujte vývojára pre ďalšie inštrukcie';

  @override
  String get captureLogSuccessNotification => 'Protokoly úspešne upravené';

  @override
  String get doneButtonLabel => 'HOTOVO';

  @override
  String get nextButtonLabel => 'ĎALEJ';

  @override
  String get connectButtonLabel => 'PRIPOJIŤ';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      'Všetky vaše súbory budú zahrnuté. Môže to zvýšiť spotrebu pamäte a zhoršiť výkon';

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
  String get detailsTooltip => 'Podrobnosti';

  @override
  String get downloadTooltip => 'Stiahnuť';

  @override
  String get downloadProcessingNotification => 'Sťahovanie súboru';

  @override
  String get downloadSuccessNotification => 'Súbor úspešne stiahnutý';

  @override
  String get downloadFailureNotification => 'Nepodarilo sa stiahnuť súbor';

  @override
  String get nextTooltip => 'Ďalej';

  @override
  String get previousTooltip => 'Predchádzajúce';

  @override
  String get webSelectRangeNotification =>
      'Podržte shift + kliknite pre výber všetkých medzi nimi';

  @override
  String get mobileSelectRangeNotification =>
      'Dlhým stlačením inej položky vyberiete všetko medzi nimi';

  @override
  String get updateDateTimeDialogTitle => 'Upraviť dátum & čas';

  @override
  String get dateSubtitle => 'Dátum';

  @override
  String get timeSubtitle => 'Čas';

  @override
  String get dateYearInputHint => 'Rok';

  @override
  String get dateMonthInputHint => 'Mesiac';

  @override
  String get dateDayInputHint => 'Deň';

  @override
  String get timeHourInputHint => 'Hodina';

  @override
  String get timeMinuteInputHint => 'Minúta';

  @override
  String get timeSecondInputHint => 'Sekunda';

  @override
  String get dateTimeInputInvalid => 'Neplatná hodnota';

  @override
  String get updateDateTimeFailureNotification =>
      'Nepodarilo sa upraviť dátum & čas';

  @override
  String get albumDirPickerHeaderText =>
      'Vyberte zložky, ktoré majú byť pridružené';

  @override
  String get albumDirPickerSubHeaderText =>
      'Len fotografie v pridružených zložkách budú zahrnuté do tohto albumu';

  @override
  String get albumDirPickerListEmptyNotification =>
      'Vyberte aspoň jednu zložku';

  @override
  String get importFoldersTooltip => 'Importovať priečinky';

  @override
  String get albumImporterHeaderText => 'Importovať zložky ako albumy';

  @override
  String get albumImporterSubHeaderText =>
      'Navrhované zložky sú uvedené nižšie. V závislosti od počte súborov na vašom serveri môže import chvíľu trvať';

  @override
  String get importButtonLabel => 'IMPORTOVAŤ';

  @override
  String get albumImporterProgressText => 'Importovanie zložiek';

  @override
  String get doneButtonTooltip => 'Hotovo';

  @override
  String get editTooltip => 'Upraviť';

  @override
  String get editAccountConflictFailureNotification =>
      'Účet s rovnakým nastavením už existuje';

  @override
  String get genericProcessingDialogContent => 'Prosím počkajte';

  @override
  String get sortTooltip => 'Triediť';

  @override
  String get sortOptionDialogTitle => 'Triediť podľa';

  @override
  String get sortOptionTimeAscendingLabel => 'Najstaršie ako prvé';

  @override
  String get sortOptionTimeDescendingLabel => 'Najnovšie ako prvé';

  @override
  String get sortOptionFilenameAscendingLabel => 'Názov súboru';

  @override
  String get sortOptionFilenameDescendingLabel => 'Názov súboru (zostupne)';

  @override
  String get sortOptionAlbumNameLabel => 'Názov albumu';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'Názov albumu (zostupne)';

  @override
  String get sortOptionManualLabel => 'Manuálne';

  @override
  String get albumEditDragRearrangeNotification =>
      'Dlhým stlačením a potiahnutím položky ju presuňte ručne';

  @override
  String get albumAddTextTooltip => 'Pridať text';

  @override
  String get shareTooltip => 'Zdieľať';

  @override
  String get shareSelectedEmptyNotification =>
      'Vyberte niektoré fotografie na zdieľanie';

  @override
  String get shareDownloadingDialogContent => 'Sťahujem';

  @override
  String get searchTooltip => 'Hľadať';

  @override
  String get clearTooltip => 'Vymazať';

  @override
  String get listNoResultsText => 'Žiadne výsledky';

  @override
  String get listEmptyText => 'Prázdne';

  @override
  String get albumTrashLabel => 'Kôš';

  @override
  String get restoreTooltip => 'Obnoviť';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Obnovujem $count položiek',
      one: 'Obnovujem 1 položku',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification =>
      'Všetky položky boli úspešne obnovené';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nepodarilo sa obnoviť $count položiek',
      one: 'Nepodarilo sa obnoviť 1 položku',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Obnovovanie položky';

  @override
  String get restoreSuccessNotification => 'Položka úspešne obnovená';

  @override
  String get restoreFailureNotification => 'Nepodarilo sa obnoviť položku';

  @override
  String get deletePermanentlyTooltip => 'Odstrániť natrvalo';

  @override
  String get deletePermanentlyConfirmationDialogTitle => 'Odstrániť natrvalo';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      'Vybrané položky budú natrvalo odstránené zo servera.\n\nTáto akcia je nevratná';

  @override
  String get albumSharedLabel => 'Zdieľané';

  @override
  String get metadataTaskProcessingNotification =>
      'Spracovávanie metadát obrázkov na pozadí';

  @override
  String get configButtonLabel => 'KONFIGURÁCIA';

  @override
  String get useAsAlbumCoverTooltip => 'Použiť ako obal albumu';

  @override
  String get helpTooltip => 'Pomoc';

  @override
  String get helpButtonLabel => 'POMOC';

  @override
  String get removeFromAlbumTooltip => 'Odstrániť z albumu';

  @override
  String get changelogTitle => 'Zoznam zmien';

  @override
  String get serverCertErrorDialogTitle =>
      'Certifikátu servera nemožno dôverovať';

  @override
  String get serverCertErrorDialogContent =>
      'Server môže byť napadnutý alebo sa niekto pokúša ukradnúť vaše informácie';

  @override
  String get advancedButtonLabel => 'POKROČILÉ';

  @override
  String get whitelistCertDialogTitle =>
      'Pridať neznámy certifikát do dôveryhodných?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'Certifikát môžete pridať do zoznamu dôveryhodných, aby ho aplikácia prijala. VAROVANIE: To predstavuje veľké bezpečnostné riziko. Uistite sa, že certifikát je samopodpísaný vami alebo dôveryhodnou stranou.\n\nHost: $host\nOdtlačok: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel => 'PRIJAT RIZIKO A PRIDAŤ DO ZOZNAMU';

  @override
  String get fileSharedByDescription => 'Zdieľané s vami týmto používateľom';

  @override
  String get emptyTrashbinTooltip => 'Vyprázdniť kôš';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Vyprázdniť kôš';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      'Všetky položky budú natrvalo odstránené zo servera.\n\nTáto akcia je nevratná';

  @override
  String get unsetAlbumCoverTooltip => 'Zrušiť obal';

  @override
  String get muteTooltip => 'Stlmiť';

  @override
  String get unmuteTooltip => 'Zapnúť zvuk';

  @override
  String get collectionPeopleLabel => 'Ľudia';

  @override
  String get slideshowTooltip => 'Prezentácia';

  @override
  String get slideshowSetupDialogTitle => 'Nastaviť prezentáciu';

  @override
  String get slideshowSetupDialogDurationTitle =>
      'Dĺžka zobrazenia obrázka (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Zamiešať';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Opakovať';

  @override
  String get slideshowSetupDialogReverseTitle => 'Obrátiť poradie';

  @override
  String get linkCopiedNotification => 'Odkaz skopírovaný';

  @override
  String get shareMethodDialogTitle => 'Zdieľať ako';

  @override
  String get shareMethodPreviewTitle => 'Náhľad';

  @override
  String get shareMethodPreviewDescription =>
      'Zdieľať zníženú kvalitu náhľadu do iných aplikácií (len obrázky)';

  @override
  String get shareMethodOriginalFileTitle => 'Pôvodný súbor';

  @override
  String get shareMethodOriginalFileDescription =>
      'Stiahnuť pôvodný súbor a zdieľať ho s inými aplikáciami';

  @override
  String get shareMethodPublicLinkTitle => 'Verejný odkaz';

  @override
  String get shareMethodPublicLinkDescription =>
      'Vytvoriť na serveri nový verejný odkaz. Ktokoľvek s odkazom môže súbor získať';

  @override
  String get shareMethodPasswordLinkTitle => 'Odkaz chránený heslom';

  @override
  String get shareMethodPasswordLinkDescription =>
      'Vytvoriť na serveri nový odkaz chránený heslom';

  @override
  String get collectionSharingLabel => 'Zdieľanie';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Naposledy zdieľané $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user s vami zdieľal dňa $date';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user s vami zdieľal album $date';
  }

  @override
  String get sharedWithLabel => 'Zdieľané s';

  @override
  String get unshareTooltip => 'Zrušiť zdieľanie';

  @override
  String get unshareSuccessNotification =>
      'Odstránenie zdieľania prebehlo úspešne';

  @override
  String get locationLabel => 'Poloha';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloud nepodporuje zdieľanie odkazu pre viaceré súbory. Aplikácia namiesto toho SKOPÍRUJE súbory do nového priečinka a ten zdieľa.';

  @override
  String get folderNameInputHint => 'Názov priečinka';

  @override
  String get folderNameInputInvalidEmpty => 'Zadajte názov priečinka';

  @override
  String get folderNameInputInvalidCharacters => 'Obsahuje neplatné znaky';

  @override
  String get createShareProgressText => 'Vytváram zdieľanie';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nepodarilo sa skopírovať $count položiek',
      one: 'Nepodarilo sa skopírovať 1 položku',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Vymazať priečinok?';

  @override
  String get unshareLinkShareDirDialogContent =>
      'Tento priečinok bol vytvorený aplikáciou na zdieľanie viacerých súborov ako odkaz. Teraz už nie je s nikým zdieľaný, chcete tento priečinok vymazať?';

  @override
  String get addToCollectionsViewTooltip => 'Pridať do zbierky';

  @override
  String get shareAlbumDialogTitle => 'Zdieľať s používateľom';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Album zdieľaný s $user, ale nepodarilo sa zdieľať niektoré súbory';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'Album prestal byť zdieľaný s $user, ale nepodarilo sa odzdielať niektoré súbory';
  }

  @override
  String get fixSharesTooltip => 'Opraviť zdieľania';

  @override
  String get fixTooltip => 'Opraviť';

  @override
  String get fixAllTooltip => 'Opraviť všetko';

  @override
  String missingShareDescription(Object user) {
    return 'Nezdieľané s $user';
  }

  @override
  String extraShareDescription(Object user) {
    return 'Zdieľané s $user';
  }

  @override
  String get defaultButtonLabel => 'VÝCHODZIE';

  @override
  String get addUserInputHint => 'Pridať užívateľa';

  @override
  String get sharedAlbumInfoDialogTitle => 'Predstavujeme zdieľaný album';

  @override
  String get sharedAlbumInfoDialogContent =>
      'Zdieľaný album umožňuje viacerým používateľom na rovnakom serveri pristupovať k rovnakému albumu. Pred pokračovaním si pozorne prečítajte obmedzenia.';

  @override
  String get learnMoreButtonLabel => 'DOZVEDIEŤ SA VIAC';

  @override
  String get migrateDatabaseProcessingNotification => 'Aktualizácia databázy';

  @override
  String get migrateDatabaseFailureNotification =>
      'Nepodarilo sa migrovať databázu';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'pred $count rokmi',
      one: 'pred 1 rokom',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle =>
      'Domovský priečinok nebol nájdený';

  @override
  String get homeFolderNotFoundDialogContent =>
      'Prosím opravte URL WebDAV uvedenú nižšie. URL môžete nájsť vo webovom rozhraní Nextcloud.';

  @override
  String get homeFolderInputInvalidEmpty =>
      'Zadajte názov vášho domovského priečinka';

  @override
  String get createCollectionTooltip => 'Nová zbierka';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Klientsky album';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      'Album s dodatočnými funkciami, prístupný len v tejto aplikácii';

  @override
  String get createCollectionDialogFolderLabel => 'Priečinok';

  @override
  String get createCollectionDialogFolderDescription =>
      'Zobraziť fotografie vo vnútri priečinka';

  @override
  String get collectionFavoritesLabel => 'Obľúbené';

  @override
  String get favoriteTooltip => 'Obľúbiť';

  @override
  String get favoriteSuccessNotification => 'Pridané do obľúbených';

  @override
  String get favoriteFailureNotification =>
      'Nepodarilo sa pridať do obľúbených';

  @override
  String get unfavoriteTooltip => 'Odobrať z obľúbených';

  @override
  String get unfavoriteSuccessNotification => 'Odstránené z obľúbených';

  @override
  String get unfavoriteFailureNotification =>
      'Nepodarilo sa odstrániť z obľúbených';

  @override
  String get createCollectionDialogTagLabel => 'Štítok';

  @override
  String get createCollectionDialogTagDescription =>
      'Zobraziť fotografie so špecifickými štítkami';

  @override
  String get addTagInputHint => 'Pridať štítok';

  @override
  String get tagPickerNoTagSelectedNotification =>
      'Prosím pridajte aspoň 1 štítok';

  @override
  String get backgroundServiceStopping => 'Zastavovanie služby';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'Nízka batéria';

  @override
  String get enhanceTooltip => 'Vylepšiť';

  @override
  String get enhanceButtonLabel => 'VYLEPŠIŤ';

  @override
  String get enhanceIntroDialogTitle => 'Vylepšite svoje fotografie';

  @override
  String get enhanceIntroDialogDescription =>
      'Vaše fotografie sa spracovávajú lokálne na vašom zariadení. Predvolene sa zmenšia na 2048x1536. Výstupné rozlíšenie môžete upraviť v Nastaveniach';

  @override
  String get enhanceLowLightTitle => 'Vylepšenie pri slabom svetle';

  @override
  String get enhanceLowLightDescription =>
      'Zosvetlite fotografie urobené v slabom osvetlení';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Jas';

  @override
  String get collectionEditedPhotosLabel => 'Upravené (lokálne)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      'Vybrané položky budú natrvalo odstránené z tohto zariadenia.\n\nTáto akcia je nevratná';

  @override
  String get enhancePortraitBlurTitle => 'Portrétový efekt rozmazania';

  @override
  String get enhancePortraitBlurDescription =>
      'Rozmažte pozadie vašich fotografií, najlepšie funguje pri portrétoch';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Rozmazanie';

  @override
  String get enhanceSuperResolution4xTitle => 'Super-rozlíšenie (4x)';

  @override
  String get enhanceSuperResolution4xDescription =>
      'Zväčšite vaše fotografie na 4x pôvodného rozlíšenia (pozrite nápovedu pre detaily)';

  @override
  String get enhanceStyleTransferTitle => 'Prenos štýlu';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Vyberte štýl';

  @override
  String get enhanceStyleTransferStyleDialogDescription =>
      'Preneste vzhľad z referenčného obrázka do vašich fotografií';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification =>
      'Prosím vyberte štýl';

  @override
  String get enhanceColorPopTitle => 'Farebný efekt';

  @override
  String get enhanceColorPopDescription =>
      'Odstráňte farebnosť pozadia vašich fotografií, najlepšie funguje pri portrétoch';

  @override
  String get enhanceGenericParamWeightLabel => 'Váha';

  @override
  String get enhanceRetouchTitle => 'Automatické retušovanie';

  @override
  String get enhanceRetouchDescription =>
      'Automaticky upravte vaše fotografie, zlepšite celkové farby a živost';

  @override
  String get doubleTapExitNotification => 'Ťuknite znova pre ukončenie';

  @override
  String get imageEditDiscardDialogTitle => 'Zahodiť zmeny?';

  @override
  String get imageEditDiscardDialogContent => 'Vaše zmeny neboli uložené';

  @override
  String get discardButtonLabel => 'ZAHODIŤ';

  @override
  String get saveTooltip => 'Uložiť';

  @override
  String get imageEditDownloadDialogTitle => 'Downloading image from server...';

  @override
  String get imageEditProcessDialogTitle => 'Processing image...';

  @override
  String get imageEditSaveDialogTitle => 'Saving result...';

  @override
  String get imageEditColorBrightness => 'Jas';

  @override
  String get imageEditColorContrast => 'Kontrast';

  @override
  String get imageEditColorWhitePoint => 'Biely bod';

  @override
  String get imageEditColorBlackPoint => 'Čierny bod';

  @override
  String get imageEditColorSaturation => 'Saturácia';

  @override
  String get imageEditColorWarmth => 'Teplota';

  @override
  String get imageEditColorTint => 'Odtieň';

  @override
  String get imageEditTitle => 'Náhľad úprav';

  @override
  String get imageEditToolbarColorLabel => 'Farba';

  @override
  String get imageEditToolbarTransformLabel => 'Transformovať';

  @override
  String get imageEditTransformOrientation => 'Orientácia';

  @override
  String get imageEditTransformOrientationClockwise => 'po smere hodín';

  @override
  String get imageEditTransformOrientationCounterclockwise =>
      'proti smeru hodín';

  @override
  String get imageEditTransformCrop => 'Orezať';

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
  String get categoriesLabel => 'Kategórie';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      'Stlačte nastavenia pre zmenu poskytovateľa alebo pomoc pre viac informácií';

  @override
  String get searchLandingCategoryVideosLabel => 'Videá';

  @override
  String get searchFilterButtonLabel => 'FILTRE';

  @override
  String get searchFilterDialogTitle => 'Filtre vyhľadávania';

  @override
  String get applyButtonLabel => 'POUŽIŤ';

  @override
  String get searchFilterOptionAnyLabel => 'Hocičo';

  @override
  String get searchFilterOptionTrueLabel => 'Pravda';

  @override
  String get searchFilterOptionFalseLabel => 'Nepravda';

  @override
  String get searchFilterTypeLabel => 'Typ';

  @override
  String get searchFilterTypeOptionImageLabel => 'Obrázok';

  @override
  String get searchFilterBubbleTypeImageText => 'obrázky';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Video';

  @override
  String get searchFilterBubbleTypeVideoText => 'videá';

  @override
  String get searchFilterFavoriteLabel => 'Obľúbené';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'obľúbené';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'nie obľúbené';

  @override
  String get showAllButtonLabel => 'ZOBRAZIŤ VŠETKO';

  @override
  String gpsPlaceText(Object place) {
    return 'Blízko $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'O mieste';

  @override
  String get gpsPlaceAboutDialogContent =>
      'Tu zobrazené miesto je len približný odhad a nie je zaručená jeho presnosť. Nevyjadruje naše názory na žiadne sporné územia.';

  @override
  String get collectionPlacesLabel => 'Miesta';

  @override
  String get imageSaveOptionDialogTitle => 'Ukladanie výsledku';

  @override
  String get imageSaveOptionDialogContent =>
      'Vyberte, kam uložiť tento a budúce spracované obrázky. Ak zvolíte server, ale aplikácia ho nedokáže nahrať, bude uložený do vášho zariadenia.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'ZARIADENIE';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'SERVER';

  @override
  String get initialSyncMessage =>
      'Synchronizácia so serverom prebieha prvýkrát';

  @override
  String get loopTooltip => 'Opakovať';

  @override
  String get createCollectionFailureNotification =>
      'Nepodarilo sa vytvoriť zbierku';

  @override
  String get addItemToCollectionTooltip => 'Pridať do zbierky';

  @override
  String get addItemToCollectionFailureNotification =>
      'Nepodarilo sa pridať do zbierky';

  @override
  String get setCollectionCoverFailureNotification =>
      'Nepodarilo sa nastaviť obal zbierky';

  @override
  String get exportCollectionTooltip => 'Exportovať';

  @override
  String get exportCollectionDialogTitle => 'Exportovať zbierku';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 => 'Serverový album';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 =>
      'Vytvorte album na vašom serveri, prístupné z akejkoľvek aplikácie';

  @override
  String get removeCollectionsFailedNotification =>
      'Nepodarilo sa odstrániť niektoré zbierky';

  @override
  String get accountSettingsTooltip => 'Nastavenie účtu';

  @override
  String get contributorsTooltip => 'Prispievatelia';

  @override
  String get setAsTooltip => 'Nastaviť ako';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return 'Chystáte sa odhlásiť zo servera $server';
  }

  @override
  String get appLockUnlockHint => 'Odomknúť aplikáciu';

  @override
  String get appLockUnlockWrongPassword => 'Nesprávne heslo';

  @override
  String get enabledText => 'Povolené';

  @override
  String get disabledText => 'Zakázané';

  @override
  String get trustedCertManagerPageTitle => 'Dôveryhodné certifikáty';

  @override
  String get trustedCertManagerAlreadyTrustedError => 'Už je dôveryhodný';

  @override
  String get trustedCertManagerSelectServer => 'Vyberte HTTPS server';

  @override
  String get trustedCertManagerNoHttpsServerError =>
      'Žiadny dostupný HTTPS server';

  @override
  String get trustedCertManagerFailedToRemoveCertError =>
      'Nepodarilo sa odstrániť certifikát';

  @override
  String get missingVideoThumbnailHelpDialogTitle =>
      'Máte problémy s miniatúrami videí?';

  @override
  String get dontShowAgain => 'Už viac nezobrazovať';

  @override
  String get mapBrowserDateRangeLabel => 'Časové rozpätie';

  @override
  String get mapBrowserDateRangeThisMonth => 'Tento mesiac';

  @override
  String get mapBrowserDateRangePrevMonth => 'Predchádzajúci mesiac';

  @override
  String get mapBrowserDateRangeThisYear => 'Tento rok';

  @override
  String get mapBrowserDateRangeCustom => 'Vlastné';

  @override
  String get homeTabMapBrowser => 'Mapa';

  @override
  String get mapBrowserSetDefaultDateRangeButton => 'Nastaviť ako predvolené';

  @override
  String get todayText => 'Dnes';

  @override
  String get livePhotoTooltip => 'Live fotka';

  @override
  String get dragAndDropRearrangeButtons =>
      'Presúvaním a ťahaním zoraďte tlačidlá';

  @override
  String get customizeCollectionsNavBarDescription =>
      'Presúvajte tlačidlá potiahnutím a ťahom, ťuknutím na tlačidlá hore ich minimalizujete';

  @override
  String get customizeButtonsUnsupportedWarning =>
      'Toto tlačidlo nie je možné prispôsobiť';

  @override
  String get placePickerTitle => 'Vyberte miesto';

  @override
  String get albumAddMapTooltip => 'Pridať text';

  @override
  String get fileNotFound => 'Súbor nenájdený';

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
      'Neautentifikovaný prístup. Prihláste sa znova, ak problém pretrváva';

  @override
  String get errorDisconnected =>
      'Nie je možné sa pripojiť. Server môže byť offline alebo vaše zariadenie odpojené';

  @override
  String get errorLocked => 'Súbor je uzamknutý na serveri. Skúste to neskôr';

  @override
  String get errorInvalidBaseUrl =>
      'Nie je možné komunikovať. Uistite sa, že adresa je základná URL vašej inštancie Nextcloud';

  @override
  String get errorWrongPassword =>
      'Nie je možné sa autentifikovať. Skontrolujte používateľské meno a heslo';

  @override
  String get errorServerError =>
      'Chyba servera. Uistite sa, že server je správne nastavený';

  @override
  String get errorAlbumDowngrade =>
      'Tento album nie je možné upraviť, pretože bol vytvorený novšou verziou tejto aplikácie. Aktualizujte aplikáciu a skúste znova';

  @override
  String get errorNoStoragePermission =>
      'Požadované povolenie na prístup k úložisku';

  @override
  String get errorServerNoCert =>
      'Server certificate not found. Try HTTP instead?';
}
