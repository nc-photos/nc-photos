// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get appTitle => 'Photos';

  @override
  String get translator => 'Albe';

  @override
  String get photosTabLabel => 'Foto';

  @override
  String get collectionsTooltip => 'Collezioni';

  @override
  String get zoomTooltip => 'Zoom';

  @override
  String get settingsMenuLabel => 'Impostazioni';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selezionati',
      one: '1 selezionato',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Eliminando $count elementi',
      one: 'Eliminando 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification =>
      'Tutti gli elementi sono stati eliminati correttamente';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fallita l\'eliminazione di $count elementi',
      one: 'Fallita l\'eliminazione di un elemento',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Archivio';

  @override
  String get archiveSelectedSuccessNotification =>
      'Tutti gli elementi sono stati archiviati con successo';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fallita archiviazione di $count elementi',
      one: 'Fallita archiviazione di 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Rimuovi dall\'archivio';

  @override
  String get unarchiveSelectedSuccessNotification =>
      'Tutti gli elementi sono stati rimossi dall\'archivio con successo';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Non è stato possibile rimuovere $count elementi dall\'archivio',
      one: 'Non è stato possibile rimuovere 1 elemento dall\'archivio',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Elimina';

  @override
  String get deleteSuccessNotification => 'Elemento cancellato correttamente';

  @override
  String get deleteFailureNotification => 'Fallita cancellazione elemento';

  @override
  String get removeSelectedFromAlbumFailureNotification =>
      'Fallita rimozione di elementi dall\'album';

  @override
  String get addServerTooltip => 'Aggiungi server';

  @override
  String removeServerSuccessNotification(Object server) {
    return '$server rimosso con successo';
  }

  @override
  String get createAlbumTooltip => 'Crea album';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementi',
      one: '1 elemento',
      zero: 'Vuoto',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Archivio';

  @override
  String connectingToServer(Object server) {
    return 'Connessione a\n$server';
  }

  @override
  String get connectingToServer2 => 'In attesa di autorizzazione dal server';

  @override
  String get connectingToServerInstruction =>
      'Per favore accedi attraverso il browser aperto';

  @override
  String get nameInputHint => 'Nome';

  @override
  String get nameInputInvalidEmpty => 'Il nome è necessario';

  @override
  String get skipButtonLabel => 'SALTA';

  @override
  String get confirmButtonLabel => 'CONFERMA';

  @override
  String get signInHeaderText => 'Accedi al server Nextcloud';

  @override
  String get signIn2faHintText =>
      'Usa la password per app se hai attivato l\'autenticazione a due fattori nel server';

  @override
  String get signInHeaderText2 => 'Nextcloud\nAccedi';

  @override
  String get serverAddressInputHint => 'Indirizzo del server';

  @override
  String get serverAddressInputInvalidEmpty =>
      'Per favore inserisci l\'indirizzo del server';

  @override
  String get usernameInputHint => 'Nome utente';

  @override
  String get usernameInputInvalidEmpty =>
      'Per favore scrivi il tuo nome utente';

  @override
  String get passwordInputHint => 'Password';

  @override
  String get passwordInputInvalidEmpty =>
      'Per favore inserisci la tua password';

  @override
  String get rootPickerHeaderText => 'Scegli le cartelle da includere';

  @override
  String get rootPickerSubHeaderText =>
      'Verranno mostrate solo le foto all\'interno delle cartelle. Premi Salta per includerle tutte';

  @override
  String get rootPickerNavigateUpItemText => '(indietro)';

  @override
  String get rootPickerUnpickFailureNotification =>
      'Fallita deselezione elemento';

  @override
  String get rootPickerListEmptyNotification =>
      'Per favore seleziona almeno una cartella o premi salta per includerle tutte';

  @override
  String get setupWidgetTitle => 'Cominciamo';

  @override
  String get setupSettingsModifyLaterHint =>
      'Puoi cambiare scelta più tardi nelle Impostazioni';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      'Questa app crea una cartella nel server Nextcloud per salvare i file relativo alle tue preferenze. Per favore non modificarla o rimuoverla a meno che tu non stia pianificando di rimuovere questa app';

  @override
  String get settingsWidgetTitle => 'Impostazioni';

  @override
  String get settingsLanguageTitle => 'Lingua';

  @override
  String get settingsLanguageOptionSystemDefaultLabel =>
      'Impostazione di sistema';

  @override
  String get settingsMetadataTitle => 'Metadati del file';

  @override
  String get settingsExifSupportTitle2 => 'Client-side EXIF support';

  @override
  String get settingsExifSupportTrueSubtitle => 'Richiede un uso extra di dati';

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
  String get settingsMemoriesTitle => 'Ricordi';

  @override
  String get settingsMemoriesSubtitle => 'Mostra foto scattate in passato';

  @override
  String get settingsAccountTitle => 'Account';

  @override
  String get settingsAccountLabelTitle => 'Etichetta';

  @override
  String get settingsAccountLabelDescription =>
      'Imposta una etichetta da mostrare al posto del URL del server';

  @override
  String get settingsIncludedFoldersTitle => 'Cartelle incluse';

  @override
  String get settingsShareFolderTitle => 'Cartella condivisa';

  @override
  String get settingsShareFolderDialogTitle =>
      'Localizza la cartella condivisa';

  @override
  String get settingsShareFolderDialogDescription =>
      'Questo parametro corrisponde a share_folder in config.PHP. I due valori DEVONO essere identici.\n\nPer favore definisci il percorso della cartella come in config.php.';

  @override
  String get settingsShareFolderPickerDescription =>
      'Per favore definisci il percorso della cartella come in config.php. Seleziona default de non hai impostato il parametro.';

  @override
  String get settingsPersonProviderTitle => 'Person provider';

  @override
  String get settingsServerAppSectionTitle => 'Supporto all\'app lato server';

  @override
  String get settingsPhotosDescription =>
      'Personalizza i contenuti mostrati nella tab Foto';

  @override
  String get settingsMemoriesRangeTitle => 'Intervallo dei ricordi';

  @override
  String settingsMemoriesRangeValueText(num range) {
    String _temp0 = intl.Intl.pluralLogic(
      range,
      locale: localeName,
      other: '+-$range giorni',
      one: '+-$range giorno',
    );
    return '$_temp0\n';
  }

  @override
  String get settingsDeviceMediaTitle => 'Show device media';

  @override
  String get settingsDeviceMediaDescription =>
      'Selected folders will be displayed';

  @override
  String get settingsViewerTitle => 'Vista';

  @override
  String get settingsViewerDescription =>
      'Personalizza la vista di immagini/video';

  @override
  String get settingsScreenBrightnessTitle => 'Luminosità dello schermo';

  @override
  String get settingsScreenBrightnessDescription =>
      'Sovrascrivi il livello di luminosità di sistema';

  @override
  String get settingsForceRotationTitle => 'Ignora il blocco della rotazione';

  @override
  String get settingsForceRotationDescription =>
      'Ruota lo schermo anche quando la rotazione automatica è disabilitata';

  @override
  String get settingsMapProviderTitle => 'Fornitore di mappe';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'Customize app bar';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle =>
      'Customize bottom app bar';

  @override
  String get settingsShowDateInAlbumTitle => 'Raggruppa le foto per data';

  @override
  String get settingsShowDateInAlbumDescription =>
      'Si applica solo quando l\'album viene ordinato per data';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'Customize navigation bar';

  @override
  String get settingsImageEditTitle => 'Editor';

  @override
  String get settingsImageEditDescription =>
      'Personalizza i miglioramenti e l\'editor dell\'immagine';

  @override
  String get settingsEnhanceMaxResolutionTitle2 =>
      'Risoluzione dell\'immagine per i miglioramenti';

  @override
  String get settingsEnhanceMaxResolutionDescription =>
      'Le immagini più grandi della risoluzione selezionata verranno scalate.\n\nLe immagini ad alta risoluzione richiedono memoria e tempo di processo significativamente più lunghi. Per favore riduci gquesto parametro se l\'app va in crash durante il miglioramento delle tue foto.';

  @override
  String get settingsImageEditSaveResultsToServerTitle =>
      'Salva i risultati sul server';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      'I risultati sono salvati sul server, il salvataggio locale è fallito';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      'I risultati sono salvati su questo dispositivo';

  @override
  String get settingsThemeTitle => 'Tema';

  @override
  String get settingsThemeDescription => 'Personalizza l\'aspetto dell\'app';

  @override
  String get settingsFollowSystemThemeTitle => 'Segui il tema di sistema';

  @override
  String get settingsSeedColorTitle => 'Colore del tema';

  @override
  String get settingsSeedColorDescription =>
      'Usato per derivare tutti i colori dell\'app';

  @override
  String get settingsSeedColorSystemColorDescription =>
      'Usa in colori di sistema';

  @override
  String get settingsSeedColorPickerTitle => 'Seleziona un colore';

  @override
  String get settingsThemePrimaryColor => 'Primary';

  @override
  String get settingsThemeSecondaryColor => 'Secondary';

  @override
  String get settingsThemePresets => 'Presets';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel =>
      'USA I COLORI DI SISTEMA';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Tema più scuro';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription =>
      'Usa il nero nel tema scuro';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription =>
      'Usa grigio scuro nel tema scuro';

  @override
  String get settingsMiscellaneousTitle => 'Varie';

  @override
  String get settingsDoubleTapExitTitle => 'Doppio tap per uscire';

  @override
  String get settingsPhotosTabSortByNameTitle =>
      'Ordina per nome del file in Photos';

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
  String get settingsExperimentalTitle => 'Sperimentale';

  @override
  String get settingsExperimentalDescription =>
      'Feature non ancora pronte per l\'uso quotidiano';

  @override
  String get settingsExpertTitle => 'Avanzate';

  @override
  String get settingsExpertWarningText =>
      'Per favore assicurati di capire a fondo cosa fa ciascuna opzione prima di procedere';

  @override
  String get settingsClearCacheDatabaseTitle => 'Pulisci il database';

  @override
  String get settingsClearCacheDatabaseDescription =>
      'Pulisci la cache e ripeti la sincronizzazione completa con il server';

  @override
  String get settingsClearCacheDatabaseSuccessNotification =>
      'Il database è stato pulito con successo. È raccomandato il riavvio dell\'app.';

  @override
  String get settingsManageTrustedCertificateTitle =>
      'Manage trusted certificates';

  @override
  String get settingsUseNewHttpEngine => 'Use new HTTP engine';

  @override
  String get settingsUseNewHttpEngineDescription =>
      'New HTTP engine based on Chromium, supporting new standards like HTTP/2* and HTTP/3 QUIC*.\n\nLimitations:\nSelf-signed certs can no longer be managed by us. You must import your CA certs to the system trust store for them to work.\n\n* HTTPS is required for HTTP/2 and HTTP/3';

  @override
  String get settingsAboutSectionTitle => 'Altro';

  @override
  String get settingsVersionTitle => 'Versione';

  @override
  String get settingsServerVersionTitle => 'Server';

  @override
  String get settingsSourceCodeTitle => 'Codice sorgente';

  @override
  String get settingsBugReportTitle => 'Riporta un problema';

  @override
  String get settingsCaptureLogsTitle => 'Cattura i log';

  @override
  String get settingsCaptureLogsDescription =>
      'Aiuta gli sviluppatori a identificare bug';

  @override
  String get settingsTranslatorTitle => 'Traduttore';

  @override
  String get settingsRestartNeededDialog =>
      'Please restart the app to apply changes';

  @override
  String get writePreferenceFailureNotification =>
      'Fallita impostazione preferenza';

  @override
  String get enableButtonLabel => 'ABILITA';

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
      'Per registrare un log per riportare un bug:\n\n1. Abilita questa opzione\n2. Riproduci il problema\n3. Disabilita questa opzione\n4. Cerca il file nc-photos.log nella cartella Download\n\n* Non sarà generaro alcun log se il problema causa il crash dell\'app. In questo caso contatta gli sviluppatori per avere ulteriori istruzioni';

  @override
  String get captureLogSuccessNotification => 'Log salvato con successo';

  @override
  String get doneButtonLabel => 'FATTO';

  @override
  String get nextButtonLabel => 'PROSSIMO';

  @override
  String get connectButtonLabel => 'CONNETTI';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      'Tutti i tuoi file saranno inclusi\n Questo aumenterà l\'utilizzo di memoria e degraderà le prestazioni';

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
  String get detailsTooltip => 'Dettagli';

  @override
  String get downloadTooltip => 'Scarica';

  @override
  String get downloadProcessingNotification => 'File in scaricamento';

  @override
  String get downloadSuccessNotification => 'File scaricato correttamente';

  @override
  String get downloadFailureNotification => 'Scaricamento del file fallito';

  @override
  String get nextTooltip => 'Successivo';

  @override
  String get previousTooltip => 'Precedente';

  @override
  String get webSelectRangeNotification =>
      'Tieni premuto e clicca per selezionare tutto nell\'intervallo';

  @override
  String get mobileSelectRangeNotification =>
      'Tieni premuto un altro elemento per selezionare tutto nell\'intervallo';

  @override
  String get updateDateTimeDialogTitle => 'Modifica la data e l\'ora';

  @override
  String get dateSubtitle => 'Data';

  @override
  String get timeSubtitle => 'Ora';

  @override
  String get dateYearInputHint => 'Anno';

  @override
  String get dateMonthInputHint => 'Mese';

  @override
  String get dateDayInputHint => 'Giorno';

  @override
  String get timeHourInputHint => 'Ora';

  @override
  String get timeMinuteInputHint => 'Minuto';

  @override
  String get timeSecondInputHint => 'Secondo';

  @override
  String get dateTimeInputInvalid => 'Valore non valido';

  @override
  String get updateDateTimeFailureNotification =>
      'Modifica di ora e data fallita';

  @override
  String get albumDirPickerHeaderText => 'Seleziona le cartelle da associare';

  @override
  String get albumDirPickerSubHeaderText =>
      'Solo le foto nelle cartelle da associare saranno incluse in questo album';

  @override
  String get albumDirPickerListEmptyNotification =>
      'Per favore seleziona almeno una cartella';

  @override
  String get importFoldersTooltip => 'Importa cartelle';

  @override
  String get albumImporterHeaderText => 'Importa le cartelle come album';

  @override
  String get albumImporterSubHeaderText =>
      'Le cartelle suggerite sono elencate in basso. A seconda del numero di file nel tuo server ci può mettere un po\'';

  @override
  String get importButtonLabel => 'IMPORTA';

  @override
  String get albumImporterProgressText =>
      'importazione delle cartelle in corso';

  @override
  String get doneButtonTooltip => 'Fatto';

  @override
  String get editTooltip => 'Modifica';

  @override
  String get editAccountConflictFailureNotification =>
      'Esiste già un account con le stesse impostazioni';

  @override
  String get genericProcessingDialogContent => 'Attendi per favore';

  @override
  String get sortTooltip => 'Ordina';

  @override
  String get sortOptionDialogTitle => 'Ordina per';

  @override
  String get sortOptionTimeAscendingLabel => 'Prima i più vecchi';

  @override
  String get sortOptionTimeDescendingLabel => 'Prima i più recenti';

  @override
  String get sortOptionFilenameAscendingLabel => 'Nome del file';

  @override
  String get sortOptionFilenameDescendingLabel => 'Nome del file (decrescente)';

  @override
  String get sortOptionAlbumNameLabel => 'Nome dell\'album';

  @override
  String get sortOptionAlbumNameDescendingLabel =>
      'Nome dell\'album (decrescente)';

  @override
  String get sortOptionManualLabel => 'Manuale';

  @override
  String get albumEditDragRearrangeNotification =>
      'Tieni premuto e sposta un elemento per riposizionarlo manualmente';

  @override
  String get albumAddTextTooltip => 'Aggiungi testo';

  @override
  String get shareTooltip => 'Condividi';

  @override
  String get shareSelectedEmptyNotification =>
      'Seleziona alcune foto da condividere';

  @override
  String get shareDownloadingDialogContent => 'Scaricamento in corso';

  @override
  String get searchTooltip => 'Cerca';

  @override
  String get clearTooltip => 'Pulisci';

  @override
  String get listNoResultsText => 'Nessun risultato';

  @override
  String get listEmptyText => 'Vuoto';

  @override
  String get albumTrashLabel => 'Cestino';

  @override
  String get restoreTooltip => 'Ripristina';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ripristino $count elementi',
      one: 'Ripristino 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification =>
      'Tutto gli elementi sono stati ripristinati';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Ripristino $count elementi fallito',
      one: 'Ripristino 1 elemento fallito',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Ripristino in corso';

  @override
  String get restoreSuccessNotification =>
      'Elementi ripristinati correttamente';

  @override
  String get restoreFailureNotification => 'Ripristino fallito';

  @override
  String get deletePermanentlyTooltip => 'Elimina definitivamente';

  @override
  String get deletePermanentlyConfirmationDialogTitle =>
      'Eliminato definitivamente';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      'Gli elementi elezionati verranno cancellati definitivamente dal server';

  @override
  String get albumSharedLabel => 'Condiviso';

  @override
  String get metadataTaskProcessingNotification =>
      'Processando i metadati delle immagini in background';

  @override
  String get configButtonLabel => 'CONFIGURAZIONE';

  @override
  String get useAsAlbumCoverTooltip => 'Usa come copertina dell\'album';

  @override
  String get helpTooltip => 'Aiuto';

  @override
  String get helpButtonLabel => 'AIUTO';

  @override
  String get removeFromAlbumTooltip => 'Rimuovi dall\'album';

  @override
  String get changelogTitle => 'Registro delle modifiche';

  @override
  String get serverCertErrorDialogTitle =>
      'Il certificato del server non è sicuro';

  @override
  String get serverCertErrorDialogContent =>
      'Il server può essere stato compromesso oppure qualcuno sta cercando di rubare le tue informazioni';

  @override
  String get advancedButtonLabel => 'AVANZATE';

  @override
  String get whitelistCertDialogTitle =>
      'Vuoi accettare un certificato sconosciuto?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'È possibile inserire il certificato nella lista bianca per far sì che l\'applicazione lo accetti. ATTENZIONE: questo comporta un grande rischio per la sicurezza. Assicuratevi che il certificato sia autofirmato da voi o da una persona fidata\n\nHost: $host\nImpronta digitale: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel =>
      'ACCETTA IL RISCHIO E METTI IN LISTA BIANCA';

  @override
  String get fileSharedByDescription => 'Condiviso con te da questo utente';

  @override
  String get emptyTrashbinTooltip => 'Svuota il cestino';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Svuota il cestino';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      'Tutti gli elementi saranno cancellati permanentemente dal server.\n\nQuesta azione non è reversibile.';

  @override
  String get unsetAlbumCoverTooltip => 'Rimuovi copertina';

  @override
  String get muteTooltip => 'Silenzia';

  @override
  String get unmuteTooltip => 'Unmute';

  @override
  String get collectionPeopleLabel => 'Persone';

  @override
  String get slideshowTooltip => 'Slideshow';

  @override
  String get slideshowSetupDialogTitle => 'Imposta slideshow';

  @override
  String get slideshowSetupDialogDurationTitle =>
      'Durata dell\'immagine (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Mischia';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Ripeti';

  @override
  String get slideshowSetupDialogReverseTitle => 'Inverti';

  @override
  String get linkCopiedNotification => 'Link copiato';

  @override
  String get shareMethodDialogTitle => 'Condividi come';

  @override
  String get shareMethodPreviewTitle => 'Anteprima';

  @override
  String get shareMethodPreviewDescription =>
      'Condividi con altre app una anteprima di qualità ridotta (solo immagini)';

  @override
  String get shareMethodOriginalFileTitle => 'File originale';

  @override
  String get shareMethodOriginalFileDescription =>
      'Scarica il file originale e condividilo con altre app';

  @override
  String get shareMethodPublicLinkTitle => 'Collegamento pubblico';

  @override
  String get shareMethodPublicLinkDescription =>
      'Crea un nuovo collegamento pubblico sul server. Chiunque abbia il collegamento può accedere al file';

  @override
  String get shareMethodPasswordLinkTitle =>
      'Collegamento protetto da password';

  @override
  String get shareMethodPasswordLinkDescription =>
      'Crea un nuovo collegamento protetto da password al server';

  @override
  String get collectionSharingLabel => 'Condivisione';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Ultima condivisione il $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user ha condiviso con te il $date';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user ha condiviso con te un albun il $date';
  }

  @override
  String get sharedWithLabel => 'Condiviso con';

  @override
  String get unshareTooltip => 'Rimuovi condivisione';

  @override
  String get unshareSuccessNotification => 'Condivisione rimossa';

  @override
  String get locationLabel => 'Luogo';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloud non supporta collegamenti di condivisione a file multipli. L\'app invece COPIA i file un una nuova cartella e condivide la cartella.';

  @override
  String get folderNameInputHint => 'Nome della cartella';

  @override
  String get folderNameInputInvalidEmpty =>
      'Per favore inserisci il nome della cartella';

  @override
  String get folderNameInputInvalidCharacters =>
      'Contiene caratteri non validi';

  @override
  String get createShareProgressText => 'Creando la condivisione';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Copia $count elementi fallita',
      one: 'Copia 1 elemento fallita',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Cancellare la cartella?';

  @override
  String get unshareLinkShareDirDialogContent =>
      'Questa cartella è stata creata dall\'app per condividere più file come link. Ora non è più condivisa con alcuno, vuoi cancellarla?';

  @override
  String get addToCollectionsViewTooltip => 'Aggiungi a Collezioni';

  @override
  String get shareAlbumDialogTitle => 'Condividi con';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Album condiviso con $user, ma alcuni file non sono stati condivisi per un problema';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'La condivisione dell\'album è stata rimossa con $user, ma è fallita per alcuni file';
  }

  @override
  String get fixSharesTooltip => 'Aggiusta le condivisioni';

  @override
  String get fixTooltip => 'Aggiusta';

  @override
  String get fixAllTooltip => 'Aggiusta tutto';

  @override
  String missingShareDescription(Object user) {
    return 'Non condiviso con $user';
  }

  @override
  String extraShareDescription(Object user) {
    return 'Condiviso con $user';
  }

  @override
  String get defaultButtonLabel => 'PREDEFINITO';

  @override
  String get addUserInputHint => 'Aggiungi utente';

  @override
  String get sharedAlbumInfoDialogTitle => 'Album condiviso';

  @override
  String get sharedAlbumInfoDialogContent =>
      'Gli album condivisi permettono a più utenti dello stesso server di accedere allo stesso album. Per favore leggi attentamente le limitazioni prima di procedere';

  @override
  String get learnMoreButtonLabel => 'MOSTRA DI PIÙ';

  @override
  String get migrateDatabaseProcessingNotification => 'Aggiornando il databasw';

  @override
  String get migrateDatabaseFailureNotification =>
      'Migrazione del database fallita';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count anni fa',
      one: '1 anno fa',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle =>
      'La cartella home non è stata trovata';

  @override
  String get homeFolderNotFoundDialogContent =>
      'Per favore correggi l\'URL WebDAV qui sotto. Puoi trovare l\'URL nell\'interfaccia web di Nextcloud.';

  @override
  String get homeFolderInputInvalidEmpty =>
      'Per favore inserisci il nome della tua cartella home';

  @override
  String get createCollectionTooltip => 'Nuova collezione';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Client-side album';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      'Album with extra features, accessible only with this app';

  @override
  String get createCollectionDialogFolderLabel => 'Cartella';

  @override
  String get createCollectionDialogFolderDescription =>
      'Mostra le foto dentro una cartella';

  @override
  String get collectionFavoritesLabel => 'Preferiti';

  @override
  String get favoriteTooltip => 'Preferito';

  @override
  String get favoriteSuccessNotification => 'Aggiunto ai preferiti';

  @override
  String get favoriteFailureNotification =>
      'Non aggiunto ai preferiti per un problema';

  @override
  String get unfavoriteTooltip => 'Rimovi dai preferiti';

  @override
  String get unfavoriteSuccessNotification => 'Rimosso dai preferiti';

  @override
  String get unfavoriteFailureNotification =>
      'Non rimosso dai preferiti per errore';

  @override
  String get createCollectionDialogTagLabel => 'Tag';

  @override
  String get createCollectionDialogTagDescription =>
      'Mostra le foto con un tag specifico';

  @override
  String get addTagInputHint => 'Aggiungi tag';

  @override
  String get tagPickerNoTagSelectedNotification =>
      'Per favore aggiungi almeno un tag';

  @override
  String get backgroundServiceStopping => 'Fermando il servizio';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'La batteria è scarica';

  @override
  String get enhanceTooltip => 'Migliora';

  @override
  String get enhanceButtonLabel => 'MIGLIORA';

  @override
  String get enhanceIntroDialogTitle => 'Migliora le tue foto';

  @override
  String get enhanceIntroDialogDescription =>
      'Le tue foto sono processate localmente nel tuo dispositivo. Sono ridotte a 2048x1536 per preimpostazione. Puoi modificare la risoluzione di uscita su Impostazioni';

  @override
  String get enhanceLowLightTitle => 'Migliora sottoesposizione';

  @override
  String get enhanceLowLightDescription =>
      'Aumenta la luminosità delle foto sottoesposte';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Luminosità';

  @override
  String get collectionEditedPhotosLabel => 'Modificata (localmente)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      'Gli elementi selezionati saranno eliminati permanentemente dal dispositivo.\n\nQuesta azione è irreversibile';

  @override
  String get enhancePortraitBlurTitle => 'Sfocatura del ritratto';

  @override
  String get enhancePortraitBlurDescription =>
      'Sfoca lo sfondo delle tue foto, funziona al meglio con i ritratti';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Sfocatura';

  @override
  String get enhanceSuperResolution4xTitle => 'Super risoluzione (4x)';

  @override
  String get enhanceSuperResolution4xDescription =>
      'Quadruplica la risoluzione delle tue foto (consulta la guida per dettagli su come si applica la massima risoluzione)';

  @override
  String get enhanceStyleTransferTitle => 'Trasferisci stile';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Scegli uno stile';

  @override
  String get enhanceStyleTransferStyleDialogDescription =>
      'Trasferisci lo stile dell\'immagine da una immagine di riferimento alle tue foto';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification =>
      'Scegli uno stile';

  @override
  String get enhanceColorPopTitle => 'Color pop';

  @override
  String get enhanceColorPopDescription =>
      'Desatura lo sfondo, funziona al meglio con i primi piani';

  @override
  String get enhanceGenericParamWeightLabel => 'Peso';

  @override
  String get enhanceRetouchTitle => 'Auto ritocco';

  @override
  String get enhanceRetouchDescription =>
      'Ritocca automaticamente le tue foto, migliora il colore e vitalità';

  @override
  String get doubleTapExitNotification => 'Un altro tap per uscire';

  @override
  String get imageEditDiscardDialogTitle => 'Scarti le modifiche?';

  @override
  String get imageEditDiscardDialogContent =>
      'Le tue modifiche non sono state salvate';

  @override
  String get discardButtonLabel => 'SCARTA';

  @override
  String get saveTooltip => 'Salva';

  @override
  String get imageEditDownloadDialogTitle => 'Downloading image from server...';

  @override
  String get imageEditProcessDialogTitle => 'Processing image...';

  @override
  String get imageEditSaveDialogTitle => 'Saving result...';

  @override
  String get imageEditColorBrightness => 'Luminosità';

  @override
  String get imageEditColorContrast => 'Contrasto';

  @override
  String get imageEditColorWhitePoint => 'Punto bianco';

  @override
  String get imageEditColorBlackPoint => 'Punto nero';

  @override
  String get imageEditColorSaturation => 'Saturazione';

  @override
  String get imageEditColorWarmth => 'Calore';

  @override
  String get imageEditColorTint => 'Tinta';

  @override
  String get imageEditTitle => 'Anteprima modifiche';

  @override
  String get imageEditToolbarColorLabel => 'Colore';

  @override
  String get imageEditToolbarTransformLabel => 'Trasforma';

  @override
  String get imageEditTransformOrientation => 'Orientamento';

  @override
  String get imageEditTransformOrientationClockwise => 'orario';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'antiorario';

  @override
  String get imageEditTransformCrop => 'Taglia';

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
  String get categoriesLabel => 'Categorie';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      'Premere impostazioni per cambiare fornitore o premere aiuto per saperne di più';

  @override
  String get searchLandingCategoryVideosLabel => 'Video';

  @override
  String get searchFilterButtonLabel => 'FILTRI';

  @override
  String get searchFilterDialogTitle => 'Cerca filtri';

  @override
  String get applyButtonLabel => 'APPLICA';

  @override
  String get searchFilterOptionAnyLabel => 'Qualunque';

  @override
  String get searchFilterOptionTrueLabel => 'Vero';

  @override
  String get searchFilterOptionFalseLabel => 'Falso';

  @override
  String get searchFilterTypeLabel => 'Tipo';

  @override
  String get searchFilterTypeOptionImageLabel => 'Immagine';

  @override
  String get searchFilterBubbleTypeImageText => 'immagini';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Video';

  @override
  String get searchFilterBubbleTypeVideoText => 'video';

  @override
  String get searchFilterFavoriteLabel => 'Preferito';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'preferiti';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'non preferiti';

  @override
  String get showAllButtonLabel => 'MOSTRA TUTTO';

  @override
  String gpsPlaceText(Object place) {
    return 'Vicinanze $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'Info sul posto';

  @override
  String get gpsPlaceAboutDialogContent =>
      'La posizione è approssimativa e non c\'è garanzia circa l\'accuratezza. Non rappresenta la nostra visione su alcuna area disputata.';

  @override
  String get collectionPlacesLabel => 'Luoghi';

  @override
  String get imageSaveOptionDialogTitle => 'Salvataggio del riaultato';

  @override
  String get imageSaveOptionDialogContent =>
      'Seleziona dove salvare le immagini processate. Se hai scelto di salvarle sul server e l\'app non riesce a caricarle, verranno salvare sul tuo dispositivo.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'DISPOSITIVO';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'SERVER';

  @override
  String get initialSyncMessage => 'Prima sincronizzazione con il server';

  @override
  String get loopTooltip => 'Ciclo';

  @override
  String get createCollectionFailureNotification =>
      'Fallita la creazione di una collezione';

  @override
  String get addItemToCollectionTooltip => 'Aggiungi a collezione';

  @override
  String get addItemToCollectionFailureNotification =>
      'Non aggiunto alla collezione per un problema';

  @override
  String get setCollectionCoverFailureNotification =>
      'Copertina non impostata per un problema';

  @override
  String get exportCollectionTooltip => 'Esporta';

  @override
  String get exportCollectionDialogTitle => 'Esporta collezione';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 => 'Server-side album';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 =>
      'Create an album on your server, accessible with any app';

  @override
  String get removeCollectionsFailedNotification =>
      'Qualche collezione non è stata rimossa per un problema';

  @override
  String get accountSettingsTooltip => 'Impostazioni account';

  @override
  String get contributorsTooltip => 'Contributori';

  @override
  String get setAsTooltip => 'Imposta come';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return 'Stai per scollegarti da $server';
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
      'Accesso non autenticato. Accedi nuovamente se il problema persiste';

  @override
  String get errorDisconnected =>
      'Impossibile connettersi. Il server può essere offline o il tuo dispositivo può essere disconnesso';

  @override
  String get errorLocked => 'Il file è bloccato nel server. Riprova più tardi';

  @override
  String get errorInvalidBaseUrl =>
      'Impossibile comunicare. Verifica che l\'indirizzo sia l\'URL di base della tua istanza Nextcloud';

  @override
  String get errorWrongPassword =>
      'Impossibile autenticarsi. Verifica nome utente e password';

  @override
  String get errorServerError =>
      'Errore del server. Verifica la configurazione del server';

  @override
  String get errorAlbumDowngrade =>
      'Non è possibile modificare l\'album perché creato con una versione successiva di questa app. Aggiorna l\'app e riprova';

  @override
  String get errorNoStoragePermission =>
      'Richiede il permesso di accedere all\'archivio';

  @override
  String get errorServerNoCert =>
      'Server certificate not found. Try HTTP instead?';
}
