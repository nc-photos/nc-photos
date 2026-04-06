// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get appTitle => 'Zdjęcia';

  @override
  String get translator => 'szymok\nShieldziak';

  @override
  String get photosTabLabel => 'Zdjęcia';

  @override
  String get collectionsTooltip => 'Kolekcje';

  @override
  String get zoomTooltip => 'Powiększenie';

  @override
  String get settingsMenuLabel => 'Ustawienia';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Wybrano $count',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Usuwanie elementów w ilości: $count',
      one: 'Usuwanie jednego elementu',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification => 'Wszystkie wybrane elementy zostały usunięte pomyślnie';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nie udało się usunąć elementów w ilości: $count',
      one: 'Nie udało się usunąć jednego elementu',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Archiwizuj';

  @override
  String get archiveSelectedSuccessNotification => 'Wszystkie wybrane elementy zostały zarchiwizowane pomyślnie';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nie udało się zarchiwizować elementów w ilości $count',
      one: 'Nie udało się zarchiwizować jednego elementu',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Przywróc z archiwum';

  @override
  String get unarchiveSelectedSuccessNotification => 'Wszystkie wybrane elementy zostały pomyślnie przywrócone z archiwum';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nie udało się przywrócić elementów z archiwum w ilości: $count',
      one: 'Nie udało się przywrócić jednego elementu z archiwum',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Usuń';

  @override
  String get deleteSuccessNotification => 'Element usunięty pomyślnie';

  @override
  String get deleteFailureNotification => 'Nie udało się usunąć elementu';

  @override
  String get removeSelectedFromAlbumFailureNotification => 'Nie udało się usunąć elementów z albumu';

  @override
  String get addServerTooltip => 'Dodaj serwer';

  @override
  String removeServerSuccessNotification(Object server) {
    return 'Pomyślnie usunięto serwer $server';
  }

  @override
  String get createAlbumTooltip => 'Nowy album';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Liczba elementów w albumie: $count',
      zero: 'Brak elementów',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Archiwum';

  @override
  String connectingToServer(Object server) {
    return 'Łączenie z $server';
  }

  @override
  String get connectingToServer2 => 'Czekamy aż serwer nas autoryzuje';

  @override
  String get connectingToServerInstruction => 'Proszę zalogować się otwartą przeglądarką';

  @override
  String get nameInputHint => 'Nazwa';

  @override
  String get nameInputInvalidEmpty => 'Nazwa jest wymagana';

  @override
  String get skipButtonLabel => 'POMIŃ';

  @override
  String get confirmButtonLabel => 'POTWIERDŹ';

  @override
  String get signInHeaderText => 'Zaloguj się do serwera Nextcloud';

  @override
  String get signIn2faHintText => 'Jeśli korzystasz z weryfikacji dwuetapowej, użyj hasła aplikacji';

  @override
  String get signInHeaderText2 => 'Logowanie Nextcloud';

  @override
  String get serverAddressInputHint => 'Adres serwera';

  @override
  String get serverAddressInputInvalidEmpty => 'Proszę podać adres serwera';

  @override
  String get usernameInputHint => 'Nazwa użytkownika';

  @override
  String get usernameInputInvalidEmpty => 'Proszę podać nazwę użytkownika';

  @override
  String get passwordInputHint => 'Hasło';

  @override
  String get passwordInputInvalidEmpty => 'Proszę podać hasło';

  @override
  String get rootPickerHeaderText => 'Proszę wybrać foldery do uwzględnienia';

  @override
  String get rootPickerSubHeaderText => 'Wyświtlane będą wyłącznie zdjęcia wewnątrz folderów. Wciśnij Pomiń, aby uwzględnić wszystkie';

  @override
  String get rootPickerNavigateUpItemText => '(WSTECZ)';

  @override
  String get rootPickerUnpickFailureNotification => 'Nie udało się odznaczyć elementu';

  @override
  String get rootPickerListEmptyNotification => 'Proszę wybrać przynajmniej jeden folder, lub wcisnąć Pomiń, aby uwzględnić wszystkie';

  @override
  String get setupWidgetTitle => 'Zaczynamy!';

  @override
  String get setupSettingsModifyLaterHint => 'Można to zmienić później w Ustawieniach';

  @override
  String get setupHiddenPrefDirNoticeDetail => 'Ta aplikacja tworzy folder na serwerze Nextcloud do przechowywania plików preferencji. Proszę go nie modyfikować ani nie usuwać, chyba że planujesz usunąć tę aplikację.';

  @override
  String get settingsWidgetTitle => 'Ustawienia';

  @override
  String get settingsLanguageTitle => 'Język';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => 'Domyślny systemu';

  @override
  String get settingsMetadataTitle => 'Metadane pliku';

  @override
  String get settingsExifSupportTitle2 => 'Client-side EXIF support';

  @override
  String get settingsExifSupportTrueSubtitle => 'Wymaga dodatkowego wykorzystania sieci';

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
  String get settingsMemoriesTitle => 'Wspomnienia';

  @override
  String get settingsMemoriesSubtitle => 'Pokaż zdjęcia z przeszłości';

  @override
  String get settingsAccountTitle => 'Konto';

  @override
  String get settingsAccountLabelTitle => 'Etykieta';

  @override
  String get settingsAccountLabelDescription => 'Ustaw etykietę wyświetlaną zamiast adresu URL serwera';

  @override
  String get settingsIncludedFoldersTitle => 'Uwzględniane foldery';

  @override
  String get settingsShareFolderTitle => 'Udostępnij folder';

  @override
  String get settingsShareFolderDialogTitle => 'Zlokalizuj folder udostępniany';

  @override
  String get settingsShareFolderDialogDescription => 'To ustawienie odpowiada parametrowi share_folder w config.php. Obie wartości MUSZĄ być identyczne. Proszę zlokalizować ten sam folder, który jest ustawiony w config.php.';

  @override
  String get settingsShareFolderPickerDescription => 'Proszę zlokalizować ten sam folder, który jest ustawiony w config.php. Naciśnij domyślne jeśli nie ustawiłeś parametru.';

  @override
  String get settingsPersonProviderTitle => 'Dostawca Rozpoznawania';

  @override
  String get settingsServerAppSectionTitle => 'Wsparcie dla aplikacji serwera';

  @override
  String get settingsPhotosDescription => 'Dostosuj zawartość wyświetlaną na karcie Zdjęcia';

  @override
  String get settingsMemoriesRangeTitle => 'Zakres wspomnień';

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
  String get settingsViewerTitle => 'Przeglądarka';

  @override
  String get settingsViewerDescription => 'Dostosowywanie przeglądarki obrazów/wideo';

  @override
  String get settingsScreenBrightnessTitle => 'Jasność ekranu';

  @override
  String get settingsScreenBrightnessDescription => 'Zastąp systemowe ustawienia jasności';

  @override
  String get settingsForceRotationTitle => 'Zignoruj systemową blokadę orientacji ekranu';

  @override
  String get settingsForceRotationDescription => 'Obracaj ekran nawet gdy autoobracanie jest wyłączone';

  @override
  String get settingsMapProviderTitle => 'Dostawca map';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'Customize app bar';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle => 'Customize bottom app bar';

  @override
  String get settingsShowDateInAlbumTitle => 'Grupuj zdjęcia według daty';

  @override
  String get settingsShowDateInAlbumDescription => 'Zastosuj tylko wtedy, gdy album jest posortowany według czasu';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle => 'Customize navigation bar';

  @override
  String get settingsImageEditTitle => 'Edytor';

  @override
  String get settingsImageEditDescription => 'Dostosuj ulepszenia obrazu i edytor obrazów';

  @override
  String get settingsEnhanceMaxResolutionTitle2 => 'Rozdzielczość obrazu dla ulepszeń';

  @override
  String get settingsEnhanceMaxResolutionDescription => 'Zdjęcia większe niż wybrana rozdzielczość zostaną zmniejszone. Zdjęcia w wysokiej rozdzielczości wymagają znacznie więcej pamięci i czasu na przetwarzanie. Obniż to ustawienie, jeśli aplikacja uległa awarii podczas poprawiania zdjęć.';

  @override
  String get settingsImageEditSaveResultsToServerTitle => 'Zapisz rezultat na serwerze';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription => 'Rezultaty są zapisywane na serwerze, a w przypadku niepowodzenia wracają do pamięci urządzenia';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription => 'Rezultaty są zapisywane na tym urządzeniu';

  @override
  String get settingsThemeTitle => 'Motyw';

  @override
  String get settingsThemeDescription => 'Dostosuj wygląd aplikacji';

  @override
  String get settingsFollowSystemThemeTitle => 'Zostosuj motyw systemu';

  @override
  String get settingsSeedColorTitle => 'Kolor motywu';

  @override
  String get settingsSeedColorDescription => 'Służy do ustawienia wszystkich kolorów używanych w aplikacji';

  @override
  String get settingsSeedColorSystemColorDescription => 'Użyj koloru systemowego';

  @override
  String get settingsSeedColorPickerTitle => 'Wybierz kolor';

  @override
  String get settingsThemePrimaryColor => 'Primary';

  @override
  String get settingsThemeSecondaryColor => 'Secondary';

  @override
  String get settingsThemePresets => 'Presets';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel => 'UŻYJ KOLORU SYSTEMU';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Ciemniejszy motyw';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription => 'Używaj czerni w ciemnym motywie';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription => 'Używaj szarości w ciemnym motywie';

  @override
  String get settingsMiscellaneousTitle => 'Różne';

  @override
  String get settingsDoubleTapExitTitle => 'Kliknij dwukrotnie, aby wyjść';

  @override
  String get settingsPhotosTabSortByNameTitle => 'Rozdzielczość obrazu dla ulepszeń';

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
  String get settingsExperimentalTitle => 'Eksperymentalne';

  @override
  String get settingsExperimentalDescription => 'Funkcje, które nie są gotowe do codziennego użytku';

  @override
  String get settingsExpertTitle => 'Zaawansowane';

  @override
  String get settingsExpertWarningText => 'Przed kontynuowaniem upewnij się, że w pełni rozumiesz działanie każdej opcji';

  @override
  String get settingsClearCacheDatabaseTitle => 'Wyczyść bazę danych plików';

  @override
  String get settingsClearCacheDatabaseDescription => 'Wyczyść informacje o pliku w pamięci podręcznej i uruchom pełną ponowną synchronizację z serwerem';

  @override
  String get settingsClearCacheDatabaseSuccessNotification => 'Baza danych została pomyślnie wyczyszczona.  Sugerujemy ponowne uruchomienie aplikacji';

  @override
  String get settingsManageTrustedCertificateTitle => 'Manage trusted certificates';

  @override
  String get settingsUseNewHttpEngine => 'Use new HTTP engine';

  @override
  String get settingsUseNewHttpEngineDescription => 'New HTTP engine based on Chromium, supporting new standards like HTTP/2* and HTTP/3 QUIC*.\n\nLimitations:\nSelf-signed certs can no longer be managed by us. You must import your CA certs to the system trust store for them to work.\n\n* HTTPS is required for HTTP/2 and HTTP/3';

  @override
  String get settingsAboutSectionTitle => 'O aplikacji';

  @override
  String get settingsVersionTitle => 'Wersja';

  @override
  String get settingsServerVersionTitle => 'Serwer';

  @override
  String get settingsSourceCodeTitle => 'Kod źródłowy';

  @override
  String get settingsBugReportTitle => 'Zgłoś błąd';

  @override
  String get settingsCaptureLogsTitle => 'Przechwyć logi';

  @override
  String get settingsCaptureLogsDescription => 'Pomóż w diagnozowaniu błędów';

  @override
  String get settingsTranslatorTitle => 'Translator';

  @override
  String get settingsRestartNeededDialog => 'Please restart the app to apply changes';

  @override
  String get writePreferenceFailureNotification => 'Nie udało się ustawić preferencji';

  @override
  String get enableButtonLabel => 'WŁĄCZ';

  @override
  String get enableButtonLabel2 => 'Enable';

  @override
  String get exifSupportNextcloud28Notes => 'Client-side support complements your server. The app will process files and attributes not supported by Nextcloud';

  @override
  String get exifSupportConfirmationDialogTitle2 => 'Enable client-side EXIF support?';

  @override
  String get captureLogDetails => 'Aby pobrać logi do raportu o błędzie: \n1. Włącz to ustawienie:\n2. Wykonaj kroki generujące problem \n3. Wyłącz to ustawienie:\n4. Poszukaj pliku nc-photos.log w folderze pobierania* Jeśli problem spowoduje zawieszenie się aplikacji, nie będzie można przechwycić żadnych logów. W takim przypadku skontaktuj się z deweloperem, aby uzyskać dalsze instrukcje.';

  @override
  String get captureLogSuccessNotification => 'Logi zapisane pomyślnie';

  @override
  String get doneButtonLabel => 'GOTOWE';

  @override
  String get nextButtonLabel => 'NASTĘPNY';

  @override
  String get connectButtonLabel => 'POŁĄCZ';

  @override
  String get rootPickerSkipConfirmationDialogContent2 => 'Wszystkie Twoje pliki zostaną uwzględnione. Może to zwiększyć użycie pamięci i pogorszyć wydajność';

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
  String get detailsTooltip => 'Szczegóły';

  @override
  String get downloadTooltip => 'Pobierz';

  @override
  String get downloadProcessingNotification => 'Pobieranie pliku';

  @override
  String get downloadSuccessNotification => 'Plik pobrany pomyślnie';

  @override
  String get downloadFailureNotification => 'Nie udało się pobrać pliku';

  @override
  String get nextTooltip => 'Dalej';

  @override
  String get previousTooltip => 'Wstecz';

  @override
  String get webSelectRangeNotification => 'Przytrzymaj shift i kliknij aby zazczyć elementy pomiędzy';

  @override
  String get mobileSelectRangeNotification => 'Przytrzymaj inny element aby zazczyć elementy pomiędzy';

  @override
  String get updateDateTimeDialogTitle => 'Zmień datę & czas';

  @override
  String get dateSubtitle => 'Data';

  @override
  String get timeSubtitle => 'Czas';

  @override
  String get dateYearInputHint => 'Rok';

  @override
  String get dateMonthInputHint => 'Miesiąc';

  @override
  String get dateDayInputHint => 'Dzień';

  @override
  String get timeHourInputHint => 'Godzina';

  @override
  String get timeMinuteInputHint => 'Minuta';

  @override
  String get timeSecondInputHint => 'Sekunda';

  @override
  String get dateTimeInputInvalid => 'Niewłaściwa wartość';

  @override
  String get updateDateTimeFailureNotification => 'Nie udało się zmodyfikować daty i czasu';

  @override
  String get albumDirPickerHeaderText => 'Wybierz foldery, które mają być powiązane';

  @override
  String get albumDirPickerSubHeaderText => 'W tym albumie znajdą się tylko zdjęcia z powiązanych folderów';

  @override
  String get albumDirPickerListEmptyNotification => 'Proszę wybrać co najmniej jeden folder';

  @override
  String get importFoldersTooltip => 'Importuj foldery';

  @override
  String get albumImporterHeaderText => 'Importuj foldery jako albumy';

  @override
  String get albumImporterSubHeaderText => 'Sugerowane foldery są wskazane poniżej. W zależności od ilości plików na Twoim serwerze, może to trochę potrwać.';

  @override
  String get importButtonLabel => 'IMPORT';

  @override
  String get albumImporterProgressText => 'Importowanie folderów';

  @override
  String get doneButtonTooltip => 'Gotowe';

  @override
  String get editTooltip => 'Edytuj';

  @override
  String get editAccountConflictFailureNotification => 'Konto z tymi samymi ustawieniami już istnieje';

  @override
  String get genericProcessingDialogContent => 'Proszę czekać';

  @override
  String get sortTooltip => 'Sorowanie';

  @override
  String get sortOptionDialogTitle => 'Sortuj według';

  @override
  String get sortOptionTimeAscendingLabel => 'Od najstarszych';

  @override
  String get sortOptionTimeDescendingLabel => 'Od najnowszych';

  @override
  String get sortOptionFilenameAscendingLabel => 'Nazwa pliku';

  @override
  String get sortOptionFilenameDescendingLabel => 'Nazwa pliku (malejąco)';

  @override
  String get sortOptionAlbumNameLabel => 'Nazwa albumu (rosnąco)';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'Nazwa albumu (malejąco)';

  @override
  String get sortOptionManualLabel => 'Ręcznie';

  @override
  String get albumEditDragRearrangeNotification => 'Przytrzymaj i przeciągnij element, aby zmienić układ';

  @override
  String get albumAddTextTooltip => 'Dodaj tekst';

  @override
  String get shareTooltip => 'Share';

  @override
  String get shareSelectedEmptyNotification => 'Wybierz zdjęcia do udostępnienia';

  @override
  String get shareDownloadingDialogContent => 'Pobieranie';

  @override
  String get searchTooltip => 'Szukaj';

  @override
  String get clearTooltip => 'Czyść';

  @override
  String get listNoResultsText => 'Brak wyników';

  @override
  String get listEmptyText => 'Pusto';

  @override
  String get albumTrashLabel => 'Kosz';

  @override
  String get restoreTooltip => 'Przywróć';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Przywracanie eleentów w ilości: $count',
      one: 'Przywracanie jednego elementu',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification => 'Wszystkie elementy przywrócone pomyślnie';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nie udało się przywrócić elementów w ilości: $count',
      one: 'Nie udało się przywrócić jednego elementu',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Przywracanie elementu';

  @override
  String get restoreSuccessNotification => 'Pomyślnie przywrócono element';

  @override
  String get restoreFailureNotification => 'Nie udało się przywrócić elementu';

  @override
  String get deletePermanentlyTooltip => 'Usuń na stałe';

  @override
  String get deletePermanentlyConfirmationDialogTitle => 'Usuń na stałe';

  @override
  String get deletePermanentlyConfirmationDialogContent => 'SWybrane elementy zostaną trwale usunięte z serwera..\n\nTej akcji nie można cofnąć';

  @override
  String get albumSharedLabel => 'Udostępnione';

  @override
  String get metadataTaskProcessingNotification => 'Przetwarzanie metadanych obrazu w tle';

  @override
  String get configButtonLabel => 'KONFIGURACJA';

  @override
  String get useAsAlbumCoverTooltip => 'Użyj jako okładki albumu';

  @override
  String get helpTooltip => 'Pomoc';

  @override
  String get helpButtonLabel => 'POMOC';

  @override
  String get removeFromAlbumTooltip => 'Usuń z albumu';

  @override
  String get changelogTitle => 'Opis zmian';

  @override
  String get serverCertErrorDialogTitle => 'Certyfikat serwera jest niezaufany';

  @override
  String get serverCertErrorDialogContent => 'Serwer może zostać zhakowany lub ktoś może próbować wykraść twoje informacje';

  @override
  String get advancedButtonLabel => 'ZAAWANSOWANE';

  @override
  String get whitelistCertDialogTitle => 'Dodać nieznany certyfikat do listy wyjątków (biała lista)?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'Możesz umieścić certyfikat na białej liście, aby aplikacja go zaakceptowała. UWAGA: Stanowi to duże zagrożenie dla bezpieczeństwa. Upewnij się, że certyfikat jest podpisany samodzielnie przez Ciebie lub zaufaną osobę.\n\nGospodarz: $host\nOdcisk palca: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel => 'ZAAKCEPTUJ RYZYKO I WPISZ NA BIAŁĄ LISTĘ';

  @override
  String get fileSharedByDescription => 'Udostępnione tobie przez tego użytkownika';

  @override
  String get emptyTrashbinTooltip => 'Opróżnij kosz';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Opróżnij kosz';

  @override
  String get emptyTrashbinConfirmationDialogContent => 'Wszystkie elementy zostaną trwale usunięte z serwera.\n\nTo działanie jest nieodwracalne';

  @override
  String get unsetAlbumCoverTooltip => 'Odznacz okładkę';

  @override
  String get muteTooltip => 'Wycisz';

  @override
  String get unmuteTooltip => 'Wyłącz wyciszenie';

  @override
  String get collectionPeopleLabel => 'Osoby';

  @override
  String get slideshowTooltip => 'Pokaz zdjęć';

  @override
  String get slideshowSetupDialogTitle => 'Ustaw pokaz zdjęć';

  @override
  String get slideshowSetupDialogDurationTitle => 'Czas przeglądania zdjęcia (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Wymieszaj';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Powtórz';

  @override
  String get slideshowSetupDialogReverseTitle => 'Powrót';

  @override
  String get linkCopiedNotification => 'Link skopiowany';

  @override
  String get shareMethodDialogTitle => 'Udostępnij jako';

  @override
  String get shareMethodPreviewTitle => 'Podgląd';

  @override
  String get shareMethodPreviewDescription => 'Udostępnij podgląd w obniżonej jakości innym aplikacjom (obsługuje tylko obrazy)';

  @override
  String get shareMethodOriginalFileTitle => 'Oryginalny plik';

  @override
  String get shareMethodOriginalFileDescription => 'Pobierz oryginalny plik i udostępnij go innym aplikacjom';

  @override
  String get shareMethodPublicLinkTitle => 'Publiczny link';

  @override
  String get shareMethodPublicLinkDescription => 'Utwórz publiczny link, element pozostanie na serwerze, każda osoba posiadająca link będzie miała dostęp do pliku';

  @override
  String get shareMethodPasswordLinkTitle => 'Link zabezpieczony hasłem';

  @override
  String get shareMethodPasswordLinkDescription => 'Utwórz link zabezpieczony hasłem, element pozostanie na serwerze, jednak dostęp do pliku będzie możliwy wyłącznie po podaniu hasła';

  @override
  String get collectionSharingLabel => 'Udostępniane';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Ostatnio udostępnione $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user udostępnił Tobie $date';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user udostępnił album $date';
  }

  @override
  String get sharedWithLabel => 'Współdzielone z';

  @override
  String get unshareTooltip => 'Zakończ udostępnianie';

  @override
  String get unshareSuccessNotification => 'Udostępnianie zakończone';

  @override
  String get locationLabel => 'Lokalizacja pliku';

  @override
  String get multipleFilesLinkShareDialogContent => 'Nextcloud nie obsługuje udostępniania linku dla wielu plików. Aplikacja zamiast tego skopiuje pliki do nowego folderu i udostępni ten folder.';

  @override
  String get folderNameInputHint => 'Nazwa folderu';

  @override
  String get folderNameInputInvalidEmpty => 'Proszę podać nazwę folderu';

  @override
  String get folderNameInputInvalidCharacters => 'Zawiera niedozwolone znaki';

  @override
  String get createShareProgressText => 'Tworzenie udziału';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Nie udało się skopiować elementów w ilości: $count',
      one: 'Nie udało się skopiować jednego elementu',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Usunąć folder?';

  @override
  String get unshareLinkShareDirDialogContent => 'Ten folder został utworzony przez aplikację do udostępniania wielu plików jako link. Teraz nie jest on już udostępniany, czy chcesz usunąć ten folder?';

  @override
  String get addToCollectionsViewTooltip => 'Dodaj do kolekcji';

  @override
  String get shareAlbumDialogTitle => 'Udostępnij użytkownikowi';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Album współdzielony z $user, jednak nie udało się udostępnić niektórych plików';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'Zakończono współdzielenie albumu z $user, jednak nie udało się zakończyć udostępniania niektórych plików';
  }

  @override
  String get fixSharesTooltip => 'Napraw udziały';

  @override
  String get fixTooltip => 'Napraw';

  @override
  String get fixAllTooltip => 'Napraw wszystko';

  @override
  String missingShareDescription(Object user) {
    return 'Nie współdzielone z $user';
  }

  @override
  String extraShareDescription(Object user) {
    return 'Współdzielone z $user';
  }

  @override
  String get defaultButtonLabel => 'DOMYŚLNE';

  @override
  String get addUserInputHint => 'Dodaj użytkownika';

  @override
  String get sharedAlbumInfoDialogTitle => 'Prezentacja współdzielonego albumu';

  @override
  String get sharedAlbumInfoDialogContent => 'Współdzielony album umożliwia wielu użytkownikom na tym samym serwerze dostęp do tego samego albumu. Proszę uważnie przeczytać ograniczenia przed kontynuowaniem.';

  @override
  String get learnMoreButtonLabel => 'DOWIEDZ SIĘ WIĘCEJ';

  @override
  String get migrateDatabaseProcessingNotification => 'Aktualizacja bazy danych';

  @override
  String get migrateDatabaseFailureNotification => 'Migracja bazy danych zakończona niepowodzeniem';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count lat temu',
      few: '$count lata temu',
      one: 'W zeszłym roku',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'Nie odnaleziono folderu domowego';

  @override
  String get homeFolderNotFoundDialogContent => 'Proszę podać prawidłowy adres URL WebDAV. Możesz go znaleźć w interfejsie webowym Nextcloud, dostępnym poprzez przeglądarkę.';

  @override
  String get homeFolderInputInvalidEmpty => 'Proszę podać nazwę folderu domowego';

  @override
  String get createCollectionTooltip => 'Nowa kolekcja';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Client-side album';

  @override
  String get createCollectionDialogAlbumDescription2 => 'Album with extra features, accessible only with this app';

  @override
  String get createCollectionDialogFolderLabel => 'Folder';

  @override
  String get createCollectionDialogFolderDescription => 'Pokaż zdjęcia w folderze';

  @override
  String get collectionFavoritesLabel => 'Ulubione';

  @override
  String get favoriteTooltip => 'Ulubiony';

  @override
  String get favoriteSuccessNotification => 'Dodano do ulubionych';

  @override
  String get favoriteFailureNotification => 'Nie udało się dodać do ulubionych';

  @override
  String get unfavoriteTooltip => 'Usuń z ulubionych';

  @override
  String get unfavoriteSuccessNotification => 'Usunięto z ulubionych';

  @override
  String get unfavoriteFailureNotification => 'Nie udało się usunąć z ulubionych';

  @override
  String get createCollectionDialogTagLabel => 'Tag';

  @override
  String get createCollectionDialogTagDescription => 'Pokaż zdjęcia z określonymi tagami';

  @override
  String get addTagInputHint => 'Dodaj tag';

  @override
  String get tagPickerNoTagSelectedNotification => 'Dodaj przynajmniej 1 tag';

  @override
  String get backgroundServiceStopping => 'Zatrzymywanie usługi';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'Niski poziom baterii';

  @override
  String get enhanceTooltip => 'Ulepsz';

  @override
  String get enhanceButtonLabel => 'ULEPSZ';

  @override
  String get enhanceIntroDialogTitle => 'Ulepsz swoje zdjęcia';

  @override
  String get enhanceIntroDialogDescription => 'Twoje zdjęcia są przetwarzane lokalnie na Twoim urządzeniu. Domyślnie są one skalowane do rozdzielczości 2048x1536. Rozdzielczość wyjściową możesz dostosować w Ustawieniach';

  @override
  String get enhanceLowLightTitle => 'Ulepszenia przy słabym oświetleniu';

  @override
  String get enhanceLowLightDescription => 'Rozjaśnij swoje zdjęcia zrobione w warunkach słabego oświetlenia';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Jasność';

  @override
  String get collectionEditedPhotosLabel => 'Edytowane (lokalnie)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent => 'Wybrane elementy zostaną trwale usunięte z tego urządzenia.\n\nTo działanie jest nieodwracalne';

  @override
  String get enhancePortraitBlurTitle => 'Rozmycie portretowe';

  @override
  String get enhancePortraitBlurDescription => 'Rozmyj tło swoich zdjęć, najlepiej sprawdza się w przypadku portretów';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Ilość rozmycia';

  @override
  String get enhanceSuperResolution4xTitle => 'Super rozdzielczość (4x)';

  @override
  String get enhanceSuperResolution4xDescription => 'Powiększ swoje zdjęcia do 4x rozdzielczości oryginalnej (zobacz Pomoc, aby uzyskać szczegółowe informacje na temat stosowania tu maksymalnej rozdzielczości)';

  @override
  String get enhanceStyleTransferTitle => 'Transfer stylu';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Wybierz styl';

  @override
  String get enhanceStyleTransferStyleDialogDescription => 'Przenieś styl obrazu z obrazu referencyjnego na swoje zdjęcia';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification => 'Proszę wybierz styl';

  @override
  String get enhanceColorPopTitle => 'Color pop';

  @override
  String get enhanceColorPopDescription => 'Zmniejsz nasycenie tła swoich zdjęć, najlepiej sprawdza się w przypadku portretów';

  @override
  String get enhanceGenericParamWeightLabel => 'Waga';

  @override
  String get enhanceRetouchTitle => 'Automatyczny retusz';

  @override
  String get enhanceRetouchDescription => 'Automatycznie retuszuj swoje zdjęcia, poprawiaj ogólny kolor i intensywność';

  @override
  String get doubleTapExitNotification => 'Stuknij ponownie, aby wyjść';

  @override
  String get imageEditDiscardDialogTitle => 'Odrzucić zmiany?';

  @override
  String get imageEditDiscardDialogContent => 'Twoje zmiany nie zostały zapisane';

  @override
  String get discardButtonLabel => 'ODRZUĆ';

  @override
  String get saveTooltip => 'Zapisz';

  @override
  String get imageEditDownloadDialogTitle => 'Downloading image from server...';

  @override
  String get imageEditProcessDialogTitle => 'Processing image...';

  @override
  String get imageEditSaveDialogTitle => 'Saving result...';

  @override
  String get imageEditColorBrightness => 'Jasność';

  @override
  String get imageEditColorContrast => 'Kontrast';

  @override
  String get imageEditColorWhitePoint => 'Biały punkt';

  @override
  String get imageEditColorBlackPoint => 'Czarny punkt';

  @override
  String get imageEditColorSaturation => 'Nasycenie';

  @override
  String get imageEditColorWarmth => 'Ciepło';

  @override
  String get imageEditColorTint => 'Odcień';

  @override
  String get imageEditTitle => 'Podgląd zmian';

  @override
  String get imageEditToolbarColorLabel => 'Kolor';

  @override
  String get imageEditToolbarTransformLabel => 'Przekształć';

  @override
  String get imageEditTransformOrientation => 'Orientacja';

  @override
  String get imageEditTransformOrientationClockwise => 'cw';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'ccw';

  @override
  String get imageEditTransformCrop => 'Przytnij';

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
  String get categoriesLabel => 'Kategorie';

  @override
  String get searchLandingPeopleListEmptyText2 => 'Naciśnij ustawienia, aby zmienić dostawcę lub naciśnij pomoc, aby dowiedzieć się więcej';

  @override
  String get searchLandingCategoryVideosLabel => 'Wideo';

  @override
  String get searchFilterButtonLabel => 'FILTRY';

  @override
  String get searchFilterDialogTitle => 'Filtry wyszukiwania';

  @override
  String get applyButtonLabel => 'ZASTOSUJ';

  @override
  String get searchFilterOptionAnyLabel => 'Każde';

  @override
  String get searchFilterOptionTrueLabel => 'Prawda';

  @override
  String get searchFilterOptionFalseLabel => 'Fałsz';

  @override
  String get searchFilterTypeLabel => 'Typ';

  @override
  String get searchFilterTypeOptionImageLabel => 'Obraz';

  @override
  String get searchFilterBubbleTypeImageText => 'obrazy';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Wideo';

  @override
  String get searchFilterBubbleTypeVideoText => 'wideo';

  @override
  String get searchFilterFavoriteLabel => 'Ulubione';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'ulubione';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'nie ulubione';

  @override
  String get showAllButtonLabel => 'POKAŻ WSZYSTKO';

  @override
  String gpsPlaceText(Object place) {
    return 'Niedaleko $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'O miejscu';

  @override
  String get gpsPlaceAboutDialogContent => 'Miejsce pokazane tutaj jest jedynie przybliżonym szacunkiem i nie gwarantuje się, że będzie dokładne. Nie reprezentuje naszych poglądów na żadne sporne obszary.';

  @override
  String get collectionPlacesLabel => 'Miejsca';

  @override
  String get imageSaveOptionDialogTitle => 'Zapisywanie wyniku';

  @override
  String get imageSaveOptionDialogContent => 'Wybierz, gdzie zapisać ten i przyszłe przetworzone obrazy. Jeśli wybrałeś serwer, ale aplikacji nie udało się go przesłać, zostanie on zapisany na Twoim urządzeniu.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'URZĄDZENIE';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'SERWER';

  @override
  String get initialSyncMessage => 'Synchronizacja z serwerem po raz pierwszy';

  @override
  String get loopTooltip => 'Pętla';

  @override
  String get createCollectionFailureNotification => 'Nie udało się utworzyć kolekcji';

  @override
  String get addItemToCollectionTooltip => 'Dodaj do kolekcji';

  @override
  String get addItemToCollectionFailureNotification => 'Nie udało się dodać do kolekcji';

  @override
  String get setCollectionCoverFailureNotification => 'Nie udało się ustawić okładki kolekcji';

  @override
  String get exportCollectionTooltip => 'Eksportuj';

  @override
  String get exportCollectionDialogTitle => 'Eksportuj kolekcję';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 => 'Server-side album';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 => 'Create an album on your server, accessible with any app';

  @override
  String get removeCollectionsFailedNotification => 'Nie udało się usunąć niektórych kolekcji';

  @override
  String get accountSettingsTooltip => 'Ustawienia konta';

  @override
  String get contributorsTooltip => 'Współautorzy';

  @override
  String get setAsTooltip => 'Ustaw jako';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return 'Zamierzasz się wylogować z $server';
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
  String get errorUnauthenticated => 'Nieautoryzowany dostęp. Jeśli problem będzie się powstarzał zaloguj się ponownie';

  @override
  String get errorDisconnected => 'Nie można się połączyć. Serwer może być offline lub Twoje urządzenie może być odłączone.';

  @override
  String get errorLocked => 'Plik jest zablokowany na serwerze. Proszę spróbować później';

  @override
  String get errorInvalidBaseUrl => 'Nie można się połączyć. Upewnij się, że adres jest adresem URL Twojego serwera Nextcloud.';

  @override
  String get errorWrongPassword => 'Nie można uwierzytelnić. Proszę sprawdzić nazwę użytkownika i hasło.';

  @override
  String get errorServerError => 'Błąd serwera. Proszę upewnić się, że serwer jest poprawnie skonfigurowany.';

  @override
  String get errorAlbumDowngrade => 'Nie można zmodyfikować tego albumu, ponieważ został on utworzony przez inną wersję tej aplikacji. Proszę zaktualizować aplikację i spróbować ponownie.';

  @override
  String get errorNoStoragePermission => 'Wymagany dostęp do pamięci';

  @override
  String get errorServerNoCert => 'Server certificate not found. Try HTTP instead?';
}
