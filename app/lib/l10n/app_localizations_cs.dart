// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Fotky';

  @override
  String get translator => 'Fjuro\nSkyhawk';

  @override
  String get photosTabLabel => 'Fotky';

  @override
  String get collectionsTooltip => 'Sbírky';

  @override
  String get zoomTooltip => 'Přiblížení';

  @override
  String get settingsMenuLabel => 'Nastavení';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vybráno $count',
      few: 'Vybrány $count',
      one: 'Vybrána $count',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Mazání $count položek',
      one: 'Mazání 1 položky',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification =>
      'Všechny položky úspěšně přidány';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nepodařilo se odstranit $count položek',
      few: 'Nepodařilo se odstranit $count položky',
      one: 'Nepodařilo se odstranit 1 položku',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Archivovat';

  @override
  String get archiveSelectedSuccessNotification =>
      'Všechny položky úspěšně archivovány';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nepodařilo se archivovat $count položek',
      few: 'Nepodařilo se archivovat $count položky',
      one: 'Nepodařilo se archivovat 1 položku',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Zrušit archivaci';

  @override
  String get unarchiveSelectedSuccessNotification =>
      'Všechny položky úspěšně odebrány z archivu';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nepodařilo se zrušit archivaci $count položek',
      one: 'Nepodařilo se zrušit archivaci 1 položky',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Odstranit';

  @override
  String get deleteSuccessNotification => 'Položka úspěšně odstraněna';

  @override
  String get deleteFailureNotification => 'Nepodařilo se odstranit položku';

  @override
  String get removeSelectedFromAlbumFailureNotification =>
      'Nepodařilo se odebrat položky z alba';

  @override
  String get addServerTooltip => 'Přidat server';

  @override
  String removeServerSuccessNotification(Object server) {
    return 'Server $server úspěšně odebrán';
  }

  @override
  String get createAlbumTooltip => 'Nové album';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count položek',
      few: '$count položky',
      one: '1 položka',
      zero: 'Prázdné',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Archiv';

  @override
  String connectingToServer(Object server) {
    return 'Připojování k\n$server';
  }

  @override
  String get connectingToServer2 => 'Čekání na autorizaci serverem';

  @override
  String get connectingToServerInstruction =>
      'Přihlaste se prosím v otevřeném prohlížeči';

  @override
  String get nameInputHint => 'Název';

  @override
  String get nameInputInvalidEmpty => 'Je vyžadován název';

  @override
  String get skipButtonLabel => 'PŘESKOČIT';

  @override
  String get confirmButtonLabel => 'POTVRDIT';

  @override
  String get signInHeaderText => 'Přihlásit se k serveru Nextcloud';

  @override
  String get signIn2faHintText =>
      'Pokud máte na serveru povolené dvoufaktorové ověření, použijte heslo aplikace';

  @override
  String get signInHeaderText2 => 'Nextcloud\nPřihlásit se';

  @override
  String get serverAddressInputHint => 'Adresa serveru';

  @override
  String get serverAddressInputInvalidEmpty => 'Zadejte adresu serveru';

  @override
  String get usernameInputHint => 'Uživatelské jméno';

  @override
  String get usernameInputInvalidEmpty => 'Zadejte vaše uživatelské jméno';

  @override
  String get passwordInputHint => 'Heslo';

  @override
  String get passwordInputInvalidEmpty => 'Zadejte vaše heslo';

  @override
  String get rootPickerHeaderText => 'Vyberte složky, které mají být zahrnuty';

  @override
  String get rootPickerSubHeaderText =>
      'Budou zobrazeny pouze fotky uvnitř vybraných složek. Klepněte na Přeskočit pro zahrnutí všech';

  @override
  String get rootPickerNavigateUpItemText => '(vrátit se)';

  @override
  String get rootPickerUnpickFailureNotification =>
      'Nepodařilo se zrušit výběr položky';

  @override
  String get rootPickerListEmptyNotification =>
      'Vyberte prosím alespoň jednu složku nebo klepněte na Přeskočit pro zahrnutí všech';

  @override
  String get setupWidgetTitle => 'Začínáme';

  @override
  String get setupSettingsModifyLaterHint =>
      'Toto lze později změnit v nastavení';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      'Tato aplikace vytvoří složku na serveru Nextcloud pro ukládání předvoleb. Neupravujte a neodebírejte ji, pokud se nechystáte odstranit tuto aplikaci';

  @override
  String get settingsWidgetTitle => 'Nastavení';

  @override
  String get settingsLanguageTitle => 'Jazyk';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => 'Podle systému';

  @override
  String get settingsMetadataTitle => 'Metadata souboru';

  @override
  String get settingsExifSupportTitle2 => 'Podpora EXIF na straně klienta';

  @override
  String get settingsExifSupportTrueSubtitle => 'Bude používat více dat';

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
  String get settingsMemoriesTitle => 'Vzpomínky';

  @override
  String get settingsMemoriesSubtitle =>
      'Zobrazit fotografie pořízené v minulosti';

  @override
  String get settingsAccountTitle => 'Účet';

  @override
  String get settingsAccountLabelTitle => 'Štítek';

  @override
  String get settingsAccountLabelDescription =>
      'Nastavte štítek, který má být zobrazen na místě URL serveru';

  @override
  String get settingsIncludedFoldersTitle => 'Zahrnuté složky';

  @override
  String get settingsShareFolderTitle => 'Sdílet složku';

  @override
  String get settingsShareFolderDialogTitle => 'Najděte složku ke sdílení';

  @override
  String get settingsShareFolderDialogDescription =>
      'Toto nastavení odpovídá parametru share_folder v souboru config.php. Obě hodnoty MUSÍ být shodné.\n\nNajděte prosím stejnou složku, jaká je nastavena v config.php.';

  @override
  String get settingsShareFolderPickerDescription =>
      'Najděte stejnou složku, jaká je nastavena v souboru config.php. Pokud jste parametr nenastavili, stiskněte výchozí.';

  @override
  String get settingsPersonProviderTitle => 'Poskytovatel osob';

  @override
  String get settingsServerAppSectionTitle => 'Podpora aplikací na serveru';

  @override
  String get settingsPhotosDescription =>
      'Přizpůsobit obsah zobrazený na kartě Fotky';

  @override
  String get settingsMemoriesRangeTitle => 'Rozsah vzpomínek';

  @override
  String settingsMemoriesRangeValueText(num range) {
    String _temp0 = intl.Intl.pluralLogic(
      range,
      locale: localeName,
      other: '+-$range dní',
      few: '+-$range dny',
      one: '+-$range den',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeviceMediaTitle => 'Show device media';

  @override
  String get settingsDeviceMediaDescription =>
      'Selected folders will be displayed';

  @override
  String get settingsViewerTitle => 'Prohlížeč';

  @override
  String get settingsViewerDescription =>
      'Přizpůsobit prohlížeč obrázků a videí';

  @override
  String get settingsScreenBrightnessTitle => 'Jas obrazovky';

  @override
  String get settingsScreenBrightnessDescription =>
      'Přepsat systémovou úroveň jasu';

  @override
  String get settingsForceRotationTitle => 'Ignorovat uzamčení otáčení';

  @override
  String get settingsForceRotationDescription =>
      'Otáčet obrazovku i při zakázaném automatickém otáčení';

  @override
  String get settingsMapProviderTitle => 'Poskytovatel map';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'Přizpůsobit lištu aplikace';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle =>
      'Přizpůsobit spodní lištu aplikace';

  @override
  String get settingsShowDateInAlbumTitle => 'Seskupit fotky podle data';

  @override
  String get settingsShowDateInAlbumDescription =>
      'Použijte pouze při řazení alba podle času';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'Přizpůsobit navigační lištu';

  @override
  String get settingsImageEditTitle => 'Editor';

  @override
  String get settingsImageEditDescription =>
      'Přizpůsobit vylepšení a editor obrázků';

  @override
  String get settingsEnhanceMaxResolutionTitle2 =>
      'Rozlišení obrázků pro vylepšení';

  @override
  String get settingsEnhanceMaxResolutionDescription =>
      'Fotky větší než zadaná hodnota budou zmenšeny.\n\nFotky s vyšším rozlišením vyžadují výrazně vyšší množství paměti a času ke zpracování. Snižte toto nastavení, pokud aplikace spadla při vylepšování vašich fotek.';

  @override
  String get settingsImageEditSaveResultsToServerTitle =>
      'Ukládat výsledky na server';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      'Výsledky budou ukládány na server, na zařízení budou uloženy pouze při selhání';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      'Výsledky budou ukládány na toto zařízení';

  @override
  String get settingsThemeTitle => 'Motiv';

  @override
  String get settingsThemeDescription => 'Přizpůsobit vzhled aplikace';

  @override
  String get settingsFollowSystemThemeTitle => 'Podle systému';

  @override
  String get settingsSeedColorTitle => 'Barva motivu';

  @override
  String get settingsSeedColorDescription =>
      'Použito k odvození všech barev použitých v aplikaci';

  @override
  String get settingsSeedColorSystemColorDescription =>
      'Použít systémovou barvu';

  @override
  String get settingsSeedColorPickerTitle => 'Vybrat barvu';

  @override
  String get settingsThemePrimaryColor => 'Primární';

  @override
  String get settingsThemeSecondaryColor => 'Sekundární';

  @override
  String get settingsThemePresets => 'Předvolby';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel =>
      'POUŽÍT SYSTÉMOVOU BARVU';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Tmavší motiv';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription =>
      'Použít černou barvu ve tmavém motivu';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription =>
      'Použít tmavší šedou ve tmavém motivu';

  @override
  String get settingsMiscellaneousTitle => 'Různé';

  @override
  String get settingsDoubleTapExitTitle => 'Dvakrát klepnout pro zavření';

  @override
  String get settingsPhotosTabSortByNameTitle =>
      'Řazení podle názvu souboru ve Fotkách';

  @override
  String get settingsAppLock => 'Zámek aplikace';

  @override
  String get settingsAppLockTypeBiometric => 'Biometrika';

  @override
  String get settingsAppLockTypePin => 'PIN';

  @override
  String get settingsAppLockTypePassword => 'Heslo';

  @override
  String get settingsAppLockDescription =>
      'Při povolení již budete při otevření aplikace dotázáni na přihlášení. Tato funkce vás NEochrání proti reálným útokům.';

  @override
  String get settingsAppLockSetupBiometricFallbackDialogTitle =>
      'Vyberte náhradu při nedostupnosti biometriky';

  @override
  String get settingsAppLockSetupPinDialogTitle =>
      'Nastavte PIN pro odemčení aplikace';

  @override
  String get settingsAppLockConfirmPinDialogTitle => 'Znovu zadejte stejný PIN';

  @override
  String get settingsAppLockSetupPasswordDialogTitle =>
      'Nastavte heslo pro odemčení aplikace';

  @override
  String get settingsAppLockConfirmPasswordDialogTitle =>
      'Znovu zadejte stejné heslo';

  @override
  String get settingsViewerUseOriginalImageTitle =>
      'Show original image instead of high quality preview in viewer';

  @override
  String get settingsExperimentalTitle => 'Experimentální';

  @override
  String get settingsExperimentalDescription =>
      'Funkce, které nejsou připraveny ke každodennímu používání';

  @override
  String get settingsExpertTitle => 'Pokročilé';

  @override
  String get settingsExpertWarningText =>
      'Před pokračováním se ujistěte, že přesně chápete, co dělá která možnost';

  @override
  String get settingsClearCacheDatabaseTitle => 'Vymazat databázi souborů';

  @override
  String get settingsClearCacheDatabaseDescription =>
      'Vymazat informace o souborech v mezipaměti a spustit úplnou opětovnou synchronizaci se serverem';

  @override
  String get settingsClearCacheDatabaseSuccessNotification =>
      'Databáze úspěšně vymazána. Je doporučeno restartovat aplikaci';

  @override
  String get settingsManageTrustedCertificateTitle =>
      'Spravovat důvěryhodné certifikáty';

  @override
  String get settingsUseNewHttpEngine => 'Použít nový engine HTTP';

  @override
  String get settingsUseNewHttpEngineDescription =>
      'Nový engine HTTP je založený na projektu Chromium a podporuje standardy jako HTTP/2* a HTTP/3 QUIC*.\n\nOmezení:\nCertifikáty podepsané samy sebou již nemohou být spravovány námi. Aby vaše certifikáty CA fungovaly, musíte je importovat do systémového pověřeného úložiště.\n\n* Pro HTTP/2 a HTTP/3 je vyžadováno HTTPS';

  @override
  String get settingsAboutSectionTitle => 'O aplikaci';

  @override
  String get settingsVersionTitle => 'Verze';

  @override
  String get settingsServerVersionTitle => 'Server';

  @override
  String get settingsSourceCodeTitle => 'Zdrojový kód';

  @override
  String get settingsBugReportTitle => 'Nahlásit chybu';

  @override
  String get settingsCaptureLogsTitle => 'Ukládat protokoly';

  @override
  String get settingsCaptureLogsDescription =>
      'Pomoc vývojáři při diagnostice chyb';

  @override
  String get settingsTranslatorTitle => 'Překladatel';

  @override
  String get settingsRestartNeededDialog =>
      'Restartujte aplikaci pro použití změn';

  @override
  String get writePreferenceFailureNotification =>
      'Nepodařilo se upravit nastavení';

  @override
  String get enableButtonLabel => 'POVOLIT';

  @override
  String get enableButtonLabel2 => 'Enable';

  @override
  String get exifSupportNextcloud28Notes =>
      'Podpora na straně klienta doplňuje váš server. Aplikace bude zpracovávat soubory a atributy, které nejsou podporované Nextcloudem';

  @override
  String get exifSupportConfirmationDialogTitle2 =>
      'Povolit podporu EXIF na straně klienta?';

  @override
  String get captureLogDetails =>
      'Pořízení záznamů pro hlášení chyby:\n\n1. Povolte toto nastavení\n2. Reprodukujte problém\n3. Zakažte toto nastavení\n4. Vyhledejte soubor nc-photos.log ve složce stahování\n\n*Pokud problém způsobí pád aplikace, nelze pořídit žádné protokoly. V takovém případě se obraťte na vývojáře, který vám poskytne další pokyny';

  @override
  String get captureLogSuccessNotification => 'Protokoly úspěšně upraveny';

  @override
  String get doneButtonLabel => 'HOTOVO';

  @override
  String get nextButtonLabel => 'DALŠÍ';

  @override
  String get connectButtonLabel => 'PŘIPOJIT';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      'Budou zahrnuty všechny vaše soubory. Tato akce může zvýšit využití paměti a snížit výkon';

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
  String get downloadTooltip => 'Stáhnout';

  @override
  String get downloadProcessingNotification => 'Stahování souboru';

  @override
  String get downloadSuccessNotification => 'Soubor úspěšně stažen';

  @override
  String get downloadFailureNotification => 'Nepodařilo se stáhnout soubor';

  @override
  String get nextTooltip => 'Další';

  @override
  String get previousTooltip => 'Předchozí';

  @override
  String get webSelectRangeNotification =>
      'Držte Shift + klikněte pro vybrání všech položek uprostřed';

  @override
  String get mobileSelectRangeNotification =>
      'Dlouze stiskněte další položku pro vybrání všech položek mezi nimi';

  @override
  String get updateDateTimeDialogTitle => 'Upravit datum a čas';

  @override
  String get dateSubtitle => 'Datum';

  @override
  String get timeSubtitle => 'Čas';

  @override
  String get dateYearInputHint => 'Rok';

  @override
  String get dateMonthInputHint => 'Měsíc';

  @override
  String get dateDayInputHint => 'Den';

  @override
  String get timeHourInputHint => 'Hodina';

  @override
  String get timeMinuteInputHint => 'Minuta';

  @override
  String get timeSecondInputHint => 'Sekunda';

  @override
  String get dateTimeInputInvalid => 'Neplatná hodnota';

  @override
  String get updateDateTimeFailureNotification =>
      'Nepodařilo se upravit datum a čas';

  @override
  String get albumDirPickerHeaderText =>
      'Vyberte složky, které mají být přidruženy';

  @override
  String get albumDirPickerSubHeaderText =>
      'Do tohoto alba budou zařazeny pouze fotografie v přidružených složkách';

  @override
  String get albumDirPickerListEmptyNotification =>
      'Vyberte alespoň jednu složku';

  @override
  String get importFoldersTooltip => 'Importovat složky';

  @override
  String get albumImporterHeaderText => 'Import složky jako alba';

  @override
  String get albumImporterSubHeaderText =>
      'Navržené složky jsou zobrazeny níže. Podle počtu souborů na vašem serveru může tato akce chvíli trvat';

  @override
  String get importButtonLabel => 'IMPORTOVAT';

  @override
  String get albumImporterProgressText => 'Importování složek';

  @override
  String get doneButtonTooltip => 'Hotovo';

  @override
  String get editTooltip => 'Upravit';

  @override
  String get editAccountConflictFailureNotification =>
      'Již existuje účet se stejným nastavením';

  @override
  String get genericProcessingDialogContent => 'Čekejte prosím';

  @override
  String get sortTooltip => 'Řazení';

  @override
  String get sortOptionDialogTitle => 'Řadit podle';

  @override
  String get sortOptionTimeAscendingLabel => 'Nejstarší první';

  @override
  String get sortOptionTimeDescendingLabel => 'Nejnovější první';

  @override
  String get sortOptionFilenameAscendingLabel => 'Název souboru';

  @override
  String get sortOptionFilenameDescendingLabel => 'Název souboru (sestupně)';

  @override
  String get sortOptionAlbumNameLabel => 'Název alba';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'Název alba (sestupně)';

  @override
  String get sortOptionManualLabel => 'Ručně';

  @override
  String get albumEditDragRearrangeNotification =>
      'Chcete-li ručně změnit uspořádání položky, dlouze ji stiskněte a přetáhněte';

  @override
  String get albumAddTextTooltip => 'Přidat text';

  @override
  String get shareTooltip => 'Sdílet';

  @override
  String get shareSelectedEmptyNotification =>
      'Vyberte nějaké fotky ke sdílení';

  @override
  String get shareDownloadingDialogContent => 'Stahování';

  @override
  String get searchTooltip => 'Vyhledávání';

  @override
  String get clearTooltip => 'Vymazat';

  @override
  String get listNoResultsText => 'Žádné výsledky';

  @override
  String get listEmptyText => 'Prázdné';

  @override
  String get albumTrashLabel => 'Koš';

  @override
  String get restoreTooltip => 'Obnovit';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Obnovování $count položek',
      one: 'Obnovování 1 položky',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification =>
      'Všechny položky úspěšně obnoveny';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nepodařilo se obnovit $count položek',
      few: 'Nepodařilo se obnovit $count položky',
      one: 'Nepodařilo se obnovit 1 položku',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Obnovování položky';

  @override
  String get restoreSuccessNotification => 'Položka úspěšně obnovena';

  @override
  String get restoreFailureNotification => 'Nepodařilo se obnovit položku';

  @override
  String get deletePermanentlyTooltip => 'Trvale odstranit';

  @override
  String get deletePermanentlyConfirmationDialogTitle => 'Trvale odstranit';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      'Vybrané položky budou trvale odstraněny ze serveru.\n\nTato akce je nevratná';

  @override
  String get albumSharedLabel => 'Sdílené';

  @override
  String get metadataTaskProcessingNotification =>
      'Zpracovávání metadat obrázků na pozadí';

  @override
  String get configButtonLabel => 'NASTAVENÍ';

  @override
  String get useAsAlbumCoverTooltip => 'Použít jako obal alba';

  @override
  String get helpTooltip => 'Nápověda';

  @override
  String get helpButtonLabel => 'NÁPOVĚDA';

  @override
  String get removeFromAlbumTooltip => 'Odebrat z alba';

  @override
  String get changelogTitle => 'Seznam změn';

  @override
  String get serverCertErrorDialogTitle =>
      'Certifikát serveru je nedůvěryhodný';

  @override
  String get serverCertErrorDialogContent =>
      'Server může být napaden nebo se někdo snaží ukrást vaše informace';

  @override
  String get advancedButtonLabel => 'POKROČILÉ';

  @override
  String get whitelistCertDialogTitle => 'Důvěřovat neznámému certifikátu?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'Certifikát můžete zařadit na bílou listinu, aby jej aplikace akceptovala. VAROVÁNÍ: Toto představuje velké bezpečnostní riziko. Ujistěte se, že je certifikát podepsán vámi nebo důvěryhodnou stranou\n\nHostitel: $host\nFingerprint: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel => 'PŘIJMOUT RIZIKO A DŮVĚŘOVAT';

  @override
  String get fileSharedByDescription => 'Sdíleno s vámi tímto uživatelem';

  @override
  String get emptyTrashbinTooltip => 'Vyprázdnit koš';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Vyprázdnit koš';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      'Všechny položky budou ze serveru trvale odstraněny.\n\nTato akce je nevratná';

  @override
  String get unsetAlbumCoverTooltip => 'Zrušit nastavení obalu';

  @override
  String get muteTooltip => 'Ztlumit';

  @override
  String get unmuteTooltip => 'Zrušit ztlumení';

  @override
  String get collectionPeopleLabel => 'Lidé';

  @override
  String get slideshowTooltip => 'Prezentace';

  @override
  String get slideshowSetupDialogTitle => 'Nastavit prezentaci';

  @override
  String get slideshowSetupDialogDurationTitle => 'Trvání obrázku (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Náhodně';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Opakovat';

  @override
  String get slideshowSetupDialogReverseTitle => 'Obráceně';

  @override
  String get linkCopiedNotification => 'Odkaz zkopírován';

  @override
  String get shareMethodDialogTitle => 'Sdílet jako';

  @override
  String get shareMethodPreviewTitle => 'Náhled';

  @override
  String get shareMethodPreviewDescription =>
      'Sdílet náhled se sníženou kvalitou do ostatních aplikací (podporuje pouze obrázky)';

  @override
  String get shareMethodOriginalFileTitle => 'Původní soubor';

  @override
  String get shareMethodOriginalFileDescription =>
      'Stáhnout původní soubor a sdílet jej do ostatních aplikací';

  @override
  String get shareMethodPublicLinkTitle => 'Veřejný odkaz';

  @override
  String get shareMethodPublicLinkDescription =>
      'Vytvořit nový veřejný odkaz na serveru. Kdokoli s odkazem bude mít přístup k souboru';

  @override
  String get shareMethodPasswordLinkTitle => 'Odkaz chráněný heslem';

  @override
  String get shareMethodPasswordLinkDescription =>
      'Vytvořit nový odkaz chráněný heslem na serveru';

  @override
  String get collectionSharingLabel => 'Sdílení';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Naposledy sdíleno $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return 'Uživatel $user s vámi sdílel tento soubor $date';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return 'Uživatel $user s vámi sdílel toto album $date';
  }

  @override
  String get sharedWithLabel => 'Sdíleno s';

  @override
  String get unshareTooltip => 'Zrušit sdílení';

  @override
  String get unshareSuccessNotification => 'Zrušeno sdílení';

  @override
  String get locationLabel => 'Umístění';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloud nepodporuje sdílení odkazu pro více souborů. Aplikace místo toho zkopíruje soubory do nové složky a sdílí ji';

  @override
  String get folderNameInputHint => 'Název složky';

  @override
  String get folderNameInputInvalidEmpty => 'Zadejte název složky';

  @override
  String get folderNameInputInvalidCharacters => 'Obsahuje neplatné znaky';

  @override
  String get createShareProgressText => 'Vytváření sdílení';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Failed copying $count items',
      few: 'Nepodařilo se zkopírovat $count položky',
      one: 'Nepodařilo se zkopírovat 1 položku',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Odstranit složku?';

  @override
  String get unshareLinkShareDirDialogContent =>
      'Tato složka byla vytvořena aplikací pro sdílení více souborů jako odkaz. Nyní již není sdílena s žádnou stranou, chcete tuto složku odstranit?';

  @override
  String get addToCollectionsViewTooltip => 'Přidat do sbírky';

  @override
  String get shareAlbumDialogTitle => 'Sdílet s uživatelem';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Album sdíleno s uživatelem $user, nepodařilo se ale sdílet některé soubory';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'Zrušeno sdílení alba s uživatelem $user, nepodařilo se ale zrušit sdílení některých souborů';
  }

  @override
  String get fixSharesTooltip => 'Opravit sdílení';

  @override
  String get fixTooltip => 'Opravit';

  @override
  String get fixAllTooltip => 'Opravit vše';

  @override
  String missingShareDescription(Object user) {
    return 'Není sdíleno s uživatelem $user';
  }

  @override
  String extraShareDescription(Object user) {
    return 'Sdíleno s uživatelem $user';
  }

  @override
  String get defaultButtonLabel => 'VÝCHOZÍ';

  @override
  String get addUserInputHint => 'Přidat uživatele';

  @override
  String get sharedAlbumInfoDialogTitle => 'Představujeme sdílené album';

  @override
  String get sharedAlbumInfoDialogContent =>
      'Sdílené album umožňuje přístup k jednomu albu více uživatelům na stejném serveru. Před pokračováním si pozorně přečtěte omezení';

  @override
  String get learnMoreButtonLabel => 'ZJISTIT VÍCE';

  @override
  String get migrateDatabaseProcessingNotification => 'Aktualizace databáze';

  @override
  String get migrateDatabaseFailureNotification =>
      'Nepodařilo se přesunout databázi';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Před $count lety',
      one: 'Před 1 rokem',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'Domovská složka nenalezena';

  @override
  String get homeFolderNotFoundDialogContent =>
      'Opravte prosím adresu URL WebDAV níže. Správnou adresu naleznete ve webovém rozhraní Nextcloud.';

  @override
  String get homeFolderInputInvalidEmpty =>
      'Zadejte název vaší domovské složky';

  @override
  String get createCollectionTooltip => 'Nová sbírka';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Album na straně klienta';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      'Album s extra funkcemi, dostupné pouze s touto aplikací';

  @override
  String get createCollectionDialogFolderLabel => 'Složka';

  @override
  String get createCollectionDialogFolderDescription =>
      'Zobrazit fotky uvnitř složky';

  @override
  String get collectionFavoritesLabel => 'Oblíbené';

  @override
  String get favoriteTooltip => 'Oblíbené';

  @override
  String get favoriteSuccessNotification => 'Přidáno do oblíbených';

  @override
  String get favoriteFailureNotification =>
      'Nepodařilo se přidat do oblíbených';

  @override
  String get unfavoriteTooltip => 'Zrušit oblíbení';

  @override
  String get unfavoriteSuccessNotification => 'Odebráno z oblíbených';

  @override
  String get unfavoriteFailureNotification =>
      'Nepodařilo se odebrat z oblíbených';

  @override
  String get createCollectionDialogTagLabel => 'Štítek';

  @override
  String get createCollectionDialogTagDescription =>
      'Zobrazit fotky s určitými štítky';

  @override
  String get addTagInputHint => 'Přidat štítek';

  @override
  String get tagPickerNoTagSelectedNotification => 'Přidejte alespoň 1 štítek';

  @override
  String get backgroundServiceStopping => 'Zastavování služby';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'Baterie je vybitá';

  @override
  String get enhanceTooltip => 'Vylepšit';

  @override
  String get enhanceButtonLabel => 'VYLEPŠIT';

  @override
  String get enhanceIntroDialogTitle => 'Vylepšit vaše fotky';

  @override
  String get enhanceIntroDialogDescription =>
      'Fotografie jsou zpracovávány lokálně v zařízení. Ve výchozím nastavení jsou zmenšeny na 2048x1536. Výstupní rozlišení můžete upravit v nastavení';

  @override
  String get enhanceLowLightTitle => 'Vylepšení při slabém osvětlení';

  @override
  String get enhanceLowLightDescription =>
      'Rozjasní vaše fotografie pořízené v prostředí se slabým osvětlením';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Brightness';

  @override
  String get collectionEditedPhotosLabel => 'Upraveno (lokálně)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      'Vybrané položky budou z tohoto zařízení trvale odstraněny.\n\nTato akce je nevratná';

  @override
  String get enhancePortraitBlurTitle => 'Rozmazání portrétu';

  @override
  String get enhancePortraitBlurDescription =>
      'Rozmaže pozadí fotografií, nejlépe funguje u portrétů';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Rozmazání';

  @override
  String get enhanceSuperResolution4xTitle => 'Super rozlišení (4x)';

  @override
  String get enhanceSuperResolution4xDescription =>
      'Zvětší vaše fotografie na čtyřnásobek původního rozlišení (podrobnosti o tom, jak se zde uplatňuje maximální rozlišení, najdete v nápovědě).';

  @override
  String get enhanceStyleTransferTitle => 'Převod stylu';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Vyberte styl';

  @override
  String get enhanceStyleTransferStyleDialogDescription =>
      'Převede styl obrázku z referenčního obrázku na vaše fotky';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification => 'Vyberte styl';

  @override
  String get enhanceColorPopTitle => 'Černobílé pozadí';

  @override
  String get enhanceColorPopDescription =>
      'Desaturuje pozadí fotografií, nejlépe funguje u portrétů';

  @override
  String get enhanceGenericParamWeightLabel => 'Síla';

  @override
  String get enhanceRetouchTitle => 'Automatická retuš';

  @override
  String get enhanceRetouchDescription =>
      'Automaticky retušuje vaše fotografie, celkově vylepší barvu a živost';

  @override
  String get doubleTapExitNotification => 'Klepněte znovu pro ukončení';

  @override
  String get imageEditDiscardDialogTitle => 'Zahodit změny?';

  @override
  String get imageEditDiscardDialogContent => 'Vaše změny nejsou uloženy';

  @override
  String get discardButtonLabel => 'ZAHODIT';

  @override
  String get saveTooltip => 'Uložit';

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
  String get imageEditColorWhitePoint => 'Bílý bod';

  @override
  String get imageEditColorBlackPoint => 'Černý bod';

  @override
  String get imageEditColorSaturation => 'Saturace';

  @override
  String get imageEditColorWarmth => 'Teplota';

  @override
  String get imageEditColorTint => 'Odstín';

  @override
  String get imageEditTitle => 'Náhled úprav';

  @override
  String get imageEditToolbarColorLabel => 'Barva';

  @override
  String get imageEditToolbarTransformLabel => 'Úpravy';

  @override
  String get imageEditTransformOrientation => 'Otočení';

  @override
  String get imageEditTransformOrientationClockwise => 'pos';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'prs';

  @override
  String get imageEditTransformCrop => 'Oříznout';

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
  String get categoriesLabel => 'Kategorie';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      'Otevřete nastavení pro přepnutí poskytovatele nebo si otevřete nápovědu pro více informací';

  @override
  String get searchLandingCategoryVideosLabel => 'Videa';

  @override
  String get searchFilterButtonLabel => 'FILTRY';

  @override
  String get searchFilterDialogTitle => 'Hledat filtry';

  @override
  String get applyButtonLabel => 'POUŽÍT';

  @override
  String get searchFilterOptionAnyLabel => 'Jakýkoli';

  @override
  String get searchFilterOptionTrueLabel => 'Ano';

  @override
  String get searchFilterOptionFalseLabel => 'Ne';

  @override
  String get searchFilterTypeLabel => 'Typ';

  @override
  String get searchFilterTypeOptionImageLabel => 'Obrázek';

  @override
  String get searchFilterBubbleTypeImageText => 'obrázky';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Video';

  @override
  String get searchFilterBubbleTypeVideoText => 'videa';

  @override
  String get searchFilterFavoriteLabel => 'Oblíbené';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'oblíbené';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'neoblíbené';

  @override
  String get showAllButtonLabel => 'ZOBRAZIT VŠE';

  @override
  String gpsPlaceText(Object place) {
    return 'Poblíž $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'O umístění';

  @override
  String get gpsPlaceAboutDialogContent =>
      'Zde uvedené místo je pouze hrubým odhadem a není zaručeno, že je přesné. Nevyjadřuje naše názory na sporné oblasti';

  @override
  String get collectionPlacesLabel => 'Místa';

  @override
  String get imageSaveOptionDialogTitle => 'Ukládání výsledku';

  @override
  String get imageSaveOptionDialogContent =>
      'Vyberte, kam chcete uložit tento a budoucí zpracované snímky. Pokud jste vybrali server, ale aplikaci se je nepodařilo nahrát, uloží se do vašeho zařízení.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'ZAŘÍZENÍ';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'SERVER';

  @override
  String get initialSyncMessage => 'První synchronizace s vaším serverem';

  @override
  String get loopTooltip => 'Smyčka';

  @override
  String get createCollectionFailureNotification =>
      'Nepodařilo se vytvořit sbírku';

  @override
  String get addItemToCollectionTooltip => 'Přidat do sbírky';

  @override
  String get addItemToCollectionFailureNotification =>
      'Nepodařilo se přidat do sbírky';

  @override
  String get setCollectionCoverFailureNotification =>
      'Nepodařilo se nastavit obal sbírky';

  @override
  String get exportCollectionTooltip => 'Export';

  @override
  String get exportCollectionDialogTitle => 'Exportovat sbírku';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 =>
      'Album na straně serveru';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 =>
      'Vytvořte album na svém serveru, které bude dostupné s jakoukoli aplikací';

  @override
  String get removeCollectionsFailedNotification =>
      'Nepodařilo se odebrat některé sbírky';

  @override
  String get accountSettingsTooltip => 'Nastavení účtu';

  @override
  String get contributorsTooltip => 'Přispěvatelé';

  @override
  String get setAsTooltip => 'Nastavit jako';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return 'Chystáte se odhlásit ze serveru $server';
  }

  @override
  String get appLockUnlockHint => 'Odemknout aplikaci';

  @override
  String get appLockUnlockWrongPassword => 'Nesprávné heslo';

  @override
  String get enabledText => 'Povoleno';

  @override
  String get disabledText => 'Zakázáno';

  @override
  String get trustedCertManagerPageTitle => 'Důvěryhodné certifikáty';

  @override
  String get trustedCertManagerAlreadyTrustedError => 'Již je důvěryhodný';

  @override
  String get trustedCertManagerSelectServer => 'Vyberte server HTTPS';

  @override
  String get trustedCertManagerNoHttpsServerError =>
      'Není dostupný žádný server';

  @override
  String get trustedCertManagerFailedToRemoveCertError =>
      'Nepodařilo se odstranit certifikát';

  @override
  String get missingVideoThumbnailHelpDialogTitle =>
      'Máte problémy s náhledy videí?';

  @override
  String get dontShowAgain => 'Již nezobrazovat';

  @override
  String get mapBrowserDateRangeLabel => 'Rozsah data';

  @override
  String get mapBrowserDateRangeThisMonth => 'Tento měsíc';

  @override
  String get mapBrowserDateRangePrevMonth => 'Předchozí měsíc';

  @override
  String get mapBrowserDateRangeThisYear => 'Tento rok';

  @override
  String get mapBrowserDateRangeCustom => 'Vlastní';

  @override
  String get homeTabMapBrowser => 'Mapa';

  @override
  String get mapBrowserSetDefaultDateRangeButton => 'Nastavit jako výchozí';

  @override
  String get todayText => 'Dnes';

  @override
  String get livePhotoTooltip => 'Živá fotka';

  @override
  String get dragAndDropRearrangeButtons =>
      'Přesuňte tlačítka pro změnu jejich pořadí';

  @override
  String get customizeCollectionsNavBarDescription =>
      'Přesuňte tlačítka pro změnu jejich pořadí, klepněte na tlačítka výše pro jejich minimalizaci';

  @override
  String get customizeButtonsUnsupportedWarning =>
      'Toto tlačítko nelze přizpůsobit';

  @override
  String get placePickerTitle => 'Vyberte si místo';

  @override
  String get albumAddMapTooltip => 'Přidat mapu';

  @override
  String get fileNotFound => 'Soubor nenalezen';

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
      'Neověřený přístup. Pokud problém přetrvává, přihlaste se znovu';

  @override
  String get errorDisconnected =>
      'Nelze se připojit. Server může být offline nebo vaše zařízení může být odpojeno.';

  @override
  String get errorLocked =>
      'Soubor je na serveru uzamčen. Zkuste to prosím znovu později';

  @override
  String get errorInvalidBaseUrl =>
      'Nelze komunikovat. Ujistěte se, že adresa je základní adresou URL vaší instance Nextcloud';

  @override
  String get errorWrongPassword =>
      'Nelze ověřit. Zkontrolujte prosím uživatelské jméno a heslo';

  @override
  String get errorServerError =>
      'Chyba serveru. Ujistěte se, že je server správně nastaven';

  @override
  String get errorAlbumDowngrade =>
      'Toto album nelze upravit, protože bylo vytvořeno pozdější verzí této aplikace. Aktualizujte prosím aplikaci a zkuste to znovu';

  @override
  String get errorNoStoragePermission =>
      'Chybějící oprávnění k přístupu k úložišti';

  @override
  String get errorServerNoCert =>
      'Server certificate not found. Try HTTP instead?';
}
