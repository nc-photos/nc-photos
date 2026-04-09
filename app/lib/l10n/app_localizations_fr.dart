// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Photos';

  @override
  String get translator => 'mgreil\nFymyte\nChoukajohn';

  @override
  String get photosTabLabel => 'Photos';

  @override
  String get collectionsTooltip => 'Collections';

  @override
  String get zoomTooltip => 'Zoom';

  @override
  String get settingsMenuLabel => 'Paramètres';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sélectionnés',
      one: '$count sélectionné',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Suppression de $count éléments',
      one: 'Suppression de 1 élément',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification =>
      'Tous les éléments ont été supprimés avec succès';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Échec de la suppression de $count éléments',
      one: 'Échec de la suppression de 1 élément',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Archiver';

  @override
  String get archiveSelectedSuccessNotification =>
      'Tous les éléments ont été archivés avec succès';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Échec de l\'archivage de $count éléments',
      one: 'Échec de l\'archivage de 1 élément',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Désarchiver';

  @override
  String get unarchiveSelectedSuccessNotification =>
      'Tous les éléments ont été désarchivés avec succès';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Échec du désarchivage de $count éléments',
      one: 'Échec du désarchivage de 1 élément',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Supprimer';

  @override
  String get deleteSuccessNotification => 'Élément supprimé avec succès';

  @override
  String get deleteFailureNotification =>
      'Échec de la suppression de l\'élément';

  @override
  String get removeSelectedFromAlbumFailureNotification =>
      'Échec de la suppression des éléments de l\'album';

  @override
  String get addServerTooltip => 'Ajouter un serveur';

  @override
  String removeServerSuccessNotification(Object server) {
    return '$server supprimé avec succès';
  }

  @override
  String get createAlbumTooltip => 'Créer un nouvel album';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count éléments',
      one: '1 élément',
      zero: 'Vide',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Archive';

  @override
  String connectingToServer(Object server) {
    return 'Connexion à\n$server';
  }

  @override
  String get connectingToServer2 => 'En attente d\'autorisation du server';

  @override
  String get connectingToServerInstruction =>
      'En attente de connexion via navigateur';

  @override
  String get nameInputHint => 'Nom';

  @override
  String get nameInputInvalidEmpty => 'Ce champ est requis';

  @override
  String get skipButtonLabel => 'IGNORER';

  @override
  String get confirmButtonLabel => 'CONFIRMER';

  @override
  String get signInHeaderText => 'Connectez-vous à un serveur Nextcloud';

  @override
  String get signIn2faHintText =>
      'Utilisez un mot de passe d\'application si vous avez activé l\'authentification à deux facteurs sur le serveur';

  @override
  String get signInHeaderText2 => 'Connexion a Nextcloud';

  @override
  String get serverAddressInputHint => 'Adresse du serveur';

  @override
  String get serverAddressInputInvalidEmpty =>
      'Veuillez saisir l\'adresse du serveur';

  @override
  String get usernameInputHint => 'Nom d\'utilisateur';

  @override
  String get usernameInputInvalidEmpty =>
      'Veuillez entrer votre nom d\'utilisateur';

  @override
  String get passwordInputHint => 'Mot de passe';

  @override
  String get passwordInputInvalidEmpty => 'Veuillez entrer votre mot de passe';

  @override
  String get rootPickerHeaderText => 'Choisissez les dossiers à inclure';

  @override
  String get rootPickerSubHeaderText =>
      'Seules les photos à l\'intérieur des dossiers seront affichées. Appuyez sur Ignorer pour tout inclure';

  @override
  String get rootPickerNavigateUpItemText => '(retourner en arrière)';

  @override
  String get rootPickerUnpickFailureNotification =>
      'Échec de la désélection de l\'élement';

  @override
  String get rootPickerListEmptyNotification =>
      'Veuillez choisir au moins un dossier ou appuyez sur ignorer pour tout inclure';

  @override
  String get setupWidgetTitle => 'Commencer';

  @override
  String get setupSettingsModifyLaterHint =>
      'Vous pouvez modifier cela plus tard dans les paramètres';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      'Cette application crée un dossier sur le serveur Nextcloud pour stocker les fichiers de préférences. Veuillez ne pas le modifier ou le supprimer à moins que vous ne prévoyiez de supprimer cette application';

  @override
  String get settingsWidgetTitle => 'Paramètres';

  @override
  String get settingsLanguageTitle => 'Langue';

  @override
  String get settingsLanguageOptionSystemDefaultLabel =>
      'Utiliser la langue système';

  @override
  String get settingsMetadataTitle => 'Métadonnées';

  @override
  String get settingsExifSupportTitle2 => 'Prise en charge EXIF ​​côté client';

  @override
  String get settingsExifSupportTrueSubtitle =>
      'Demande une utilisation plus intense du réseau';

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
  String get settingsMemoriesTitle => 'Souvenirs';

  @override
  String get settingsMemoriesSubtitle => 'Voir les photos prises dans le passé';

  @override
  String get settingsAccountTitle => 'Compte';

  @override
  String get settingsAccountLabelTitle => 'Nom';

  @override
  String get settingsAccountLabelDescription =>
      'Utiliser ce nom pour remplacer l\'URL du server';

  @override
  String get settingsIncludedFoldersTitle => 'Dossiers inclus';

  @override
  String get settingsShareFolderTitle => 'Dossier de partage';

  @override
  String get settingsShareFolderDialogTitle =>
      'Localisez le dossier de partage';

  @override
  String get settingsShareFolderDialogDescription =>
      'Ce paramètre correspond au paramètre share_folder dans config.php. Les deux valeurs DOIVENT être identiques.\n\nVeuillez localiser le même dossier que celui défini dans config.php.';

  @override
  String get settingsShareFolderPickerDescription =>
      'Veuillez localiser le même dossier que celui défini dans config.php. Appuyez sur default si vous n\'avez pas défini le paramètre.';

  @override
  String get settingsPersonProviderTitle =>
      'Application de reconnaissance faciale';

  @override
  String get settingsServerAppSectionTitle =>
      'Prise en charge de l\'application serveur';

  @override
  String get settingsPhotosDescription =>
      'Sélectionner le contenu de l\'onglet photo';

  @override
  String get settingsMemoriesRangeTitle => 'Intervalle';

  @override
  String settingsMemoriesRangeValueText(num range) {
    String _temp0 = intl.Intl.pluralLogic(
      range,
      locale: localeName,
      other: '+-$range jours',
      one: '+-$range jour',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeviceMediaTitle => 'Show device media';

  @override
  String get settingsDeviceMediaDescription =>
      'Selected folders will be displayed';

  @override
  String get settingsViewerTitle => 'Visionneur';

  @override
  String get settingsViewerDescription =>
      'Personnaliser le visionneur de vidéo/image';

  @override
  String get settingsScreenBrightnessTitle => 'Luminosité d\'écran';

  @override
  String get settingsScreenBrightnessDescription =>
      'Remplacer le niveau de luminosité du système';

  @override
  String get settingsForceRotationTitle =>
      'Ignorer le verrouillage de la rotation';

  @override
  String get settingsForceRotationDescription =>
      'Faire pivoter l\'écran même lorsque la rotation automatique est désactivée';

  @override
  String get settingsMapProviderTitle => 'Fournisseur de carte';

  @override
  String get settingsViewerCustomizeAppBarTitle =>
      'Personnaliser la barre d\'applications';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle =>
      'Personnaliser la barre d\'application inférieure';

  @override
  String get settingsShowDateInAlbumTitle => 'Regrouper les photos par date';

  @override
  String get settingsShowDateInAlbumDescription =>
      'Appliquer uniquement lorsque l\'album est trié par heure';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'Personnaliser la barre de navigation';

  @override
  String get settingsImageEditTitle => 'Editeur';

  @override
  String get settingsImageEditDescription =>
      'Personnaliser l\'amélioration des images et l\'éditeur';

  @override
  String get settingsEnhanceMaxResolutionTitle2 =>
      'Résolution des images pour l\'amélioration';

  @override
  String get settingsEnhanceMaxResolutionDescription =>
      'Les photos avec une resolution supérieure seront réduites.\n\nLes images hautes résolutions prennent beaucoup plus de temps et de mémoire à traîter. Baisser cette résolution si l\'application se ferme pendants le traitement de vos photos.';

  @override
  String get settingsImageEditSaveResultsToServerTitle =>
      'Enregistrer les résultats sur le server';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      'Les résultats sont sauvegardées sur le server, ou sur l\'appareil si l\'envoi échou.';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      'Les résultats sont sauvegardés sur l\'appareil';

  @override
  String get settingsThemeTitle => 'Thème';

  @override
  String get settingsThemeDescription =>
      'Personnalisez l\'apparence de l\'application';

  @override
  String get settingsFollowSystemThemeTitle => 'Suivre le thème système';

  @override
  String get settingsSeedColorTitle => 'Couleur principale';

  @override
  String get settingsSeedColorDescription =>
      'Utilisée pour déduire les couleurs de l\'application';

  @override
  String get settingsSeedColorSystemColorDescription =>
      'Utiliser les couleurs système';

  @override
  String get settingsSeedColorPickerTitle => 'Choisissez une couleur';

  @override
  String get settingsThemePrimaryColor => 'Primaire';

  @override
  String get settingsThemeSecondaryColor => 'Secondaire';

  @override
  String get settingsThemePresets => 'Préréglages';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel =>
      'COULEURS SYSTÈME';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Thème plus sombre';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription =>
      'Utiliser le noir dans le thème sombre';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription =>
      'Utiliser le gris foncé dans le thème sombre';

  @override
  String get settingsMiscellaneousTitle => 'Divers';

  @override
  String get settingsDoubleTapExitTitle => 'Tapper deux fois pour quitter';

  @override
  String get settingsPhotosTabSortByNameTitle => 'Trier par nom de fichier';

  @override
  String get settingsAppLock => 'Verrouillage de l\'application';

  @override
  String get settingsAppLockTypeBiometric => 'Biométrique';

  @override
  String get settingsAppLockTypePin => 'PIN';

  @override
  String get settingsAppLockTypePassword => 'Mot de passe';

  @override
  String get settingsAppLockDescription =>
      'Si cette option est activée, il vous sera demandé de vous authentifier à l\'ouverture de l\'application. Cette fonctionnalité ne vous protège PAS contre les attaques réelles.';

  @override
  String get settingsAppLockSetupBiometricFallbackDialogTitle =>
      'Choisissez une solution de secours lorsque la biométrie n\'est pas disponible';

  @override
  String get settingsAppLockSetupPinDialogTitle =>
      'Définir le code PIN pour déverrouiller l\'application';

  @override
  String get settingsAppLockConfirmPinDialogTitle =>
      'Saisissez à nouveau le même code PIN';

  @override
  String get settingsAppLockSetupPasswordDialogTitle =>
      'Définir le mot de passe pour déverrouiller l\'application';

  @override
  String get settingsAppLockConfirmPasswordDialogTitle =>
      'Saisissez à nouveau le même mot de passe';

  @override
  String get settingsViewerUseOriginalImageTitle =>
      'Show original image instead of high quality preview in viewer';

  @override
  String get settingsExperimentalTitle => 'Expérimental';

  @override
  String get settingsExperimentalDescription =>
      'Des fonctionnalités qui ne sont pas prêtes pour une utilisation quotidienne';

  @override
  String get settingsExpertTitle => 'Options avancées';

  @override
  String get settingsExpertWarningText =>
      'Soyer certains de comprendre chaque option avant de continuer';

  @override
  String get settingsClearCacheDatabaseTitle => 'Effacer la base de données';

  @override
  String get settingsClearCacheDatabaseDescription =>
      'Effacer les données mis en cache et relancer une synchronisation complète avec le server';

  @override
  String get settingsClearCacheDatabaseSuccessNotification =>
      'Base de données effacé avec succès. Vous pouvez redemander l\'application';

  @override
  String get settingsManageTrustedCertificateTitle =>
      'Gérer les certificats de confiance';

  @override
  String get settingsUseNewHttpEngine => 'Utiliser le nouveau moteur HTTP';

  @override
  String get settingsUseNewHttpEngineDescription =>
      'Nouveau moteur HTTP basé sur Chromium, prenant en charge de nouvelles normes telles que HTTP/2* et HTTP/3 QUIC*.\n\nLimitations :\nNous ne pouvons plus gérer les certificats auto-signés. Vous devez importer vos certificats CA dans le magasin de confiance du système pour qu\'ils fonctionnent.\n\n* HTTPS est requis pour HTTP/2 et HTTP/3';

  @override
  String get settingsAboutSectionTitle => 'À propos';

  @override
  String get settingsVersionTitle => 'Version';

  @override
  String get settingsServerVersionTitle => 'Serveur';

  @override
  String get settingsSourceCodeTitle => 'Code source';

  @override
  String get settingsBugReportTitle => 'Signaler un problème';

  @override
  String get settingsCaptureLogsTitle => 'Capturer les logs';

  @override
  String get settingsCaptureLogsDescription =>
      'Aider le développeur à diagnostiquer les bugs';

  @override
  String get settingsTranslatorTitle => 'Traducteurs';

  @override
  String get settingsRestartNeededDialog =>
      'Veuillez redémarrer l\'application pour appliquer les modifications';

  @override
  String get writePreferenceFailureNotification =>
      'Échec du réglage des préférences';

  @override
  String get enableButtonLabel => 'ACTIVER';

  @override
  String get enableButtonLabel2 => 'Enable';

  @override
  String get exifSupportNextcloud28Notes =>
      'Le support côté client complète votre serveur. L\'application traitera les fichiers et les attributs non pris en charge par Nextcloud';

  @override
  String get exifSupportConfirmationDialogTitle2 =>
      'Activer la prise en charge EXIF côté client ?';

  @override
  String get captureLogDetails =>
      'Pour prendre des logs pour un rapport de bug :\n\n1. Activez ce paramètre\n2. Reproduisez le problème\n3. Désactivez ce paramètre\n4. Recherchez nc-photos.log dans le dossier de téléchargement\n\n*Si le problème provoque le blocage de l\'application, aucun log ne peut être capturé. Dans ce cas, veuillez contacter le développeur pour plus d\'instructions';

  @override
  String get captureLogSuccessNotification => 'Logs enregistrés avec succès';

  @override
  String get doneButtonLabel => 'TERMINÉ';

  @override
  String get nextButtonLabel => 'SUIVANT';

  @override
  String get connectButtonLabel => 'CONNECTER';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      'Tous vos fichiers seront inclus. Cela peut augmenter l\'utilisation de la mémoire et dégrader les performances';

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
  String get detailsTooltip => 'Détails';

  @override
  String get downloadTooltip => 'Télécharger';

  @override
  String get downloadProcessingNotification => 'Téléchargement du fichier';

  @override
  String get downloadSuccessNotification => 'Fichier téléchargé avec succès';

  @override
  String get downloadFailureNotification =>
      'Échec du téléchargement du fichier';

  @override
  String get nextTooltip => 'Suivant';

  @override
  String get previousTooltip => 'Précédent';

  @override
  String get webSelectRangeNotification =>
      'Maintenez la touche Maj enfoncée + cliquez pour tout sélectionner entre les deux';

  @override
  String get mobileSelectRangeNotification =>
      'Appuyez longuement sur un autre élément pour tout sélectionner entre';

  @override
  String get updateDateTimeDialogTitle => 'Modifier la date et l\'heure';

  @override
  String get dateSubtitle => 'Date';

  @override
  String get timeSubtitle => 'Heure';

  @override
  String get dateYearInputHint => 'Année';

  @override
  String get dateMonthInputHint => 'Mois';

  @override
  String get dateDayInputHint => 'Jour';

  @override
  String get timeHourInputHint => 'Heure';

  @override
  String get timeMinuteInputHint => 'Minute';

  @override
  String get timeSecondInputHint => 'Seconde';

  @override
  String get dateTimeInputInvalid => 'Valeure invalide';

  @override
  String get updateDateTimeFailureNotification =>
      'Échec de la modification de la date et de l\'heure';

  @override
  String get albumDirPickerHeaderText => 'Choisissez les dossiers à associer';

  @override
  String get albumDirPickerSubHeaderText =>
      'Seules les photos des dossiers associés seront incluses dans cet album';

  @override
  String get albumDirPickerListEmptyNotification =>
      'Veuillez choisir au moins un dossier';

  @override
  String get importFoldersTooltip => 'Importer des dossiers';

  @override
  String get albumImporterHeaderText =>
      'Importer des dossiers sous forme d\'albums';

  @override
  String get albumImporterSubHeaderText =>
      'Les dossiers suggérés sont répertoriés ci-dessous. Selon le nombre de fichiers sur votre serveur, cela peut prendre un certain temps';

  @override
  String get importButtonLabel => 'IMPORTER';

  @override
  String get albumImporterProgressText => 'Importation de dossiers';

  @override
  String get doneButtonTooltip => 'Terminé';

  @override
  String get editTooltip => 'Modifier';

  @override
  String get editAccountConflictFailureNotification =>
      'Un compte existe déjà avec les mêmes paramètres';

  @override
  String get genericProcessingDialogContent => 'S\'il vous plaît, attendez';

  @override
  String get sortTooltip => 'Trier';

  @override
  String get sortOptionDialogTitle => 'Trier par';

  @override
  String get sortOptionTimeAscendingLabel => 'Le plus âgé en premier';

  @override
  String get sortOptionTimeDescendingLabel => 'Le plus récent d\'abord';

  @override
  String get sortOptionFilenameAscendingLabel => 'Nom de fichier';

  @override
  String get sortOptionFilenameDescendingLabel => 'Nom de fichier (descendant)';

  @override
  String get sortOptionAlbumNameLabel => 'Nom d\'album';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'Nom d\'album (inversé)';

  @override
  String get sortOptionManualLabel => 'Manuel';

  @override
  String get albumEditDragRearrangeNotification =>
      'Appuyez longuement sur un élément et faites-le glisser pour le réorganiser manuellement';

  @override
  String get albumAddTextTooltip => 'Ajouter du texte';

  @override
  String get shareTooltip => 'Partager';

  @override
  String get shareSelectedEmptyNotification =>
      'Sélectionnez quelques photos à partager';

  @override
  String get shareDownloadingDialogContent => 'Téléchargement';

  @override
  String get searchTooltip => 'Chercher';

  @override
  String get clearTooltip => 'Nettoyer';

  @override
  String get listNoResultsText => 'Aucun résultat';

  @override
  String get listEmptyText => 'Vide';

  @override
  String get albumTrashLabel => 'Corbeille';

  @override
  String get restoreTooltip => 'Restaurer';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restauration de $count éléments',
      one: 'Restauration d\'1 élément',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification =>
      'Tous les éléments ont été restaurés avec succès';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Échec de la restauration de $count éléments',
      one: 'Échec de la restauration de 1 élément',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Restauration de l\'élément';

  @override
  String get restoreSuccessNotification => 'Élément restauré avec succès';

  @override
  String get restoreFailureNotification =>
      'Échec de la restauration de l\'élément';

  @override
  String get deletePermanentlyTooltip => 'Supprimer définitivement';

  @override
  String get deletePermanentlyConfirmationDialogTitle =>
      'Supprimer définitivement';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      'Les éléments sélectionnés seront supprimés définitivement du serveur.\n\nCette action est irréversible';

  @override
  String get albumSharedLabel => 'Partagé';

  @override
  String get metadataTaskProcessingNotification =>
      'Traitement des métadonnées de l\'image en arrière-plan';

  @override
  String get configButtonLabel => 'CONFIGURER';

  @override
  String get useAsAlbumCoverTooltip => 'Utiliser comme couverture d\'album';

  @override
  String get helpTooltip => 'Aide';

  @override
  String get helpButtonLabel => 'AIDE';

  @override
  String get removeFromAlbumTooltip => 'Retirer de l\'album';

  @override
  String get changelogTitle => 'Journal des modifications';

  @override
  String get serverCertErrorDialogTitle =>
      'Le certificat du serveur ne peut pas être approuvé';

  @override
  String get serverCertErrorDialogContent =>
      'Le serveur peut être piraté ou quelqu\'un essaie de voler vos informations';

  @override
  String get advancedButtonLabel => 'AVANCÉ';

  @override
  String get whitelistCertDialogTitle =>
      'Certificat inconnu de la liste blanche ?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'Vous pouvez ajouter le certificat à la liste blanche pour que l\'application l\'accepte. AVERTISSEMENT : Cela pose un grand risque pour la sécurité. Assurez-vous que le certificat est auto-signé par vous ou une partie de confiance\n\nHôte : $host\nEmpreinte digitale : $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel =>
      'ACCEPTER LE RISQUE ET AJOUTER À LA LISTE BLANCHE';

  @override
  String get fileSharedByDescription => 'Partagé avec vous par cet utilisateur';

  @override
  String get emptyTrashbinTooltip => 'Vider la corbeille';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Vider la corbeille';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      'Tous les éléments seront définitivement supprimés du serveur.\n\nCette action est irréversible';

  @override
  String get unsetAlbumCoverTooltip => 'Enlever la couverture';

  @override
  String get muteTooltip => 'Mettre en sourdine';

  @override
  String get unmuteTooltip => 'Rétablir le son';

  @override
  String get collectionPeopleLabel => 'Personnes';

  @override
  String get slideshowTooltip => 'Diaporama';

  @override
  String get slideshowSetupDialogTitle => 'Configuration diaporama';

  @override
  String get slideshowSetupDialogDurationTitle => 'Durée image (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Mélanger';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Répéter';

  @override
  String get slideshowSetupDialogReverseTitle => 'Inverser';

  @override
  String get linkCopiedNotification => 'Lien copié';

  @override
  String get shareMethodDialogTitle => 'Partager comme';

  @override
  String get shareMethodPreviewTitle => 'Aperçu';

  @override
  String get shareMethodPreviewDescription =>
      'Partager un aperçu de plus basse qualité aux autres application (ne supporte que les images)';

  @override
  String get shareMethodOriginalFileTitle => 'Fichier original';

  @override
  String get shareMethodOriginalFileDescription =>
      'Télécharge le fichier original et le partage aux autres applications';

  @override
  String get shareMethodPublicLinkTitle => 'Lien public';

  @override
  String get shareMethodPublicLinkDescription =>
      'Créez un nouveau lien public sur le serveur. Toute personne disposant du lien peut accéder au fichier';

  @override
  String get shareMethodPasswordLinkTitle => 'Lien protégé par mot de passe';

  @override
  String get shareMethodPasswordLinkDescription =>
      'Créer un nouveau lien protégé par mot de passe sur le serveur';

  @override
  String get collectionSharingLabel => 'Partage';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Dernier partage le $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user a partagé avec vous le $date';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user a partagé un album avec vous le $date';
  }

  @override
  String get sharedWithLabel => 'Partagé avec';

  @override
  String get unshareTooltip => 'Annuler le partage';

  @override
  String get unshareSuccessNotification => 'Partage supprimé';

  @override
  String get locationLabel => 'Emplacement';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloud ne prend pas en charge le lien de partage pour plusieurs fichiers. L\'application copiera à la place les fichiers dans un nouveau dossier et partagera le dossier à la place.';

  @override
  String get folderNameInputHint => 'Nom de dossier';

  @override
  String get folderNameInputInvalidEmpty => 'Veuillez entrer le nom du dossier';

  @override
  String get folderNameInputInvalidCharacters =>
      'Contient des caractères non valides';

  @override
  String get createShareProgressText => 'Créé un partage';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Échec de la copie de $count éléments',
      one: 'Échec de la copie de 1 élément',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Supprimer le dossier ?';

  @override
  String get unshareLinkShareDirDialogContent =>
      'Ce dossier a été créé par l\'application pour partager plusieurs fichiers sous forme de lien. Il n\'est désormais plus partagé avec aucun tiers, voulez-vous supprimer ce dossier ?';

  @override
  String get addToCollectionsViewTooltip => 'Ajouter à la collection';

  @override
  String get shareAlbumDialogTitle => 'Partager avec un utilisateur';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Album partagé avec $user, mais échec du partage de certains fichiers';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'Suppression de partage de l\'album avec $user, mais échec du partage de certains fichiers';
  }

  @override
  String get fixSharesTooltip => 'Fixer les partages';

  @override
  String get fixTooltip => 'Réparer';

  @override
  String get fixAllTooltip => 'Tout réparer';

  @override
  String missingShareDescription(Object user) {
    return 'Non partagé avec $user';
  }

  @override
  String extraShareDescription(Object user) {
    return 'Partagé avec $user';
  }

  @override
  String get defaultButtonLabel => 'DÉFAUT';

  @override
  String get addUserInputHint => 'Ajouter un utilisateur';

  @override
  String get sharedAlbumInfoDialogTitle => 'Présentation de l\'album partagé';

  @override
  String get sharedAlbumInfoDialogContent =>
      'L\'album partagé permet à plusieurs utilisateurs sur le même serveur d\'accéder au même album. Veuillez lire attentivement les limitations avant de continuer';

  @override
  String get learnMoreButtonLabel => 'EN APPRENDRE PLUS';

  @override
  String get migrateDatabaseProcessingNotification =>
      'Mise à jour de la base de données';

  @override
  String get migrateDatabaseFailureNotification =>
      'Échec de la migration de la base de données';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count ans',
      one: 'Il y a 1 an',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'Dossier personnel introuvable';

  @override
  String get homeFolderNotFoundDialogContent =>
      'Veuillez corriger l\'URL WebDAV indiquée ci-dessous. Vous pouvez trouver l\'URL dans l\'interface Web de Nextcloud.';

  @override
  String get homeFolderInputInvalidEmpty =>
      'Veuillez saisir le nom de votre dossier personnel';

  @override
  String get createCollectionTooltip => 'Nouvelle collection';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Album côté client';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      'Album avec des fonctionnalités supplémentaires, accessible uniquement avec cette application';

  @override
  String get createCollectionDialogFolderLabel => 'Dossier';

  @override
  String get createCollectionDialogFolderDescription =>
      'Afficher les photos dans un dossier';

  @override
  String get collectionFavoritesLabel => 'Favoris';

  @override
  String get favoriteTooltip => 'Favoris';

  @override
  String get favoriteSuccessNotification => 'Ajouté aux favoris';

  @override
  String get favoriteFailureNotification => 'Échec de l\'ajout aux favoris';

  @override
  String get unfavoriteTooltip => 'Supprimer des favoris';

  @override
  String get unfavoriteSuccessNotification => 'Supprimé des favoris';

  @override
  String get unfavoriteFailureNotification =>
      'Échec de la suppression des favoris';

  @override
  String get createCollectionDialogTagLabel => 'Tag';

  @override
  String get createCollectionDialogTagDescription =>
      'Afficher les photos avec des tags spécifiques';

  @override
  String get addTagInputHint => 'Ajouter un tag';

  @override
  String get tagPickerNoTagSelectedNotification =>
      'Veuillez ajouter au moins 1 tag';

  @override
  String get backgroundServiceStopping => 'Arrêt du service';

  @override
  String get metadataTaskPauseLowBatteryNotification =>
      'La batterie est faible';

  @override
  String get enhanceTooltip => 'Améliorer';

  @override
  String get enhanceButtonLabel => 'AMÉLIORER';

  @override
  String get enhanceIntroDialogTitle => 'Amélioré vos photos';

  @override
  String get enhanceIntroDialogDescription =>
      'Vos photos sont traîter sur l\'appareil. Par défaut, elle sont réduite à 2048x1546. Vous pouvez ajuster la résolution dans les paramètres';

  @override
  String get enhanceLowLightTitle => 'Amélioration pour basse lumière';

  @override
  String get enhanceLowLightDescription =>
      'Augmente la luminosité des photos prise en environnement peu lumineux';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Luminosité';

  @override
  String get collectionEditedPhotosLabel => 'Edité (local)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      'Les éléments sélectionné serons supprimer définitivement de l\'appareil.\n\nCette action n\'est pas réversible';

  @override
  String get enhancePortraitBlurTitle => 'Flou d\'arrière plan';

  @override
  String get enhancePortraitBlurDescription =>
      'Ajoute un effet de flou a l\'arrière de vos photos, fonctionne mieux pour les portraits';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Niveau de flou';

  @override
  String get enhanceSuperResolution4xTitle => 'Super-resolution (4x)';

  @override
  String get enhanceSuperResolution4xDescription =>
      'Augmente la résolution de vos photos par 4 (voir l\'aide pour plus de détail sur la résolution maximum)';

  @override
  String get enhanceStyleTransferTitle => 'Transfert de style';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Choisissez un style';

  @override
  String get enhanceStyleTransferStyleDialogDescription =>
      'Transferer le style d\'une image de référence sur vos photos';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification =>
      'Choisissez un style';

  @override
  String get enhanceColorPopTitle => 'Augmenter le contraste';

  @override
  String get enhanceColorPopDescription =>
      'Desature l\'arrière plan des photos, fonctionne mieux avec les portraits';

  @override
  String get enhanceGenericParamWeightLabel => 'Poids';

  @override
  String get enhanceRetouchTitle => 'Retouche automatique';

  @override
  String get enhanceRetouchDescription =>
      'Retouche automatiquement vos photos, ameliore l\'éclat des couleurs';

  @override
  String get doubleTapExitNotification =>
      'Tapper une deuxième fois pour quitter';

  @override
  String get imageEditDiscardDialogTitle => 'Quitter sans enregistrer ?';

  @override
  String get imageEditDiscardDialogContent =>
      'Vos changements ne sont pas sauvegardés';

  @override
  String get discardButtonLabel => 'Quitter';

  @override
  String get saveTooltip => 'Sauvegarder';

  @override
  String get imageEditDownloadDialogTitle => 'Downloading image from server...';

  @override
  String get imageEditProcessDialogTitle => 'Processing image...';

  @override
  String get imageEditSaveDialogTitle => 'Saving result...';

  @override
  String get imageEditColorBrightness => 'Luminosité';

  @override
  String get imageEditColorContrast => 'Contraste';

  @override
  String get imageEditColorWhitePoint => 'Point blanc';

  @override
  String get imageEditColorBlackPoint => 'Point noir';

  @override
  String get imageEditColorSaturation => 'Saturation';

  @override
  String get imageEditColorWarmth => 'Chaleur';

  @override
  String get imageEditColorTint => 'Teinte';

  @override
  String get imageEditTitle => 'Aperçu des modifications';

  @override
  String get imageEditToolbarColorLabel => 'Couleur';

  @override
  String get imageEditToolbarTransformLabel => 'Transformation';

  @override
  String get imageEditTransformOrientation => 'Orientation';

  @override
  String get imageEditTransformOrientationClockwise => 'h';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'ah';

  @override
  String get imageEditTransformCrop => 'Rogner';

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
  String get categoriesLabel => 'Catégories';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      'Appuyer sur paramètres pour changer de fournisseur ou aide pour en savoir plus';

  @override
  String get searchLandingCategoryVideosLabel => 'Vidéos';

  @override
  String get searchFilterButtonLabel => 'FILTRES';

  @override
  String get searchFilterDialogTitle => 'Filtres';

  @override
  String get applyButtonLabel => 'APPLIQUER';

  @override
  String get searchFilterOptionAnyLabel => 'Tous';

  @override
  String get searchFilterOptionTrueLabel => 'Vrai';

  @override
  String get searchFilterOptionFalseLabel => 'Faux';

  @override
  String get searchFilterTypeLabel => 'Type';

  @override
  String get searchFilterTypeOptionImageLabel => 'Image';

  @override
  String get searchFilterBubbleTypeImageText => 'images';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Vidéo';

  @override
  String get searchFilterBubbleTypeVideoText => 'vidéos';

  @override
  String get searchFilterFavoriteLabel => 'Favoris';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'favoris';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'Non favoris';

  @override
  String get showAllButtonLabel => 'Tous';

  @override
  String gpsPlaceText(Object place) {
    return 'A proximité de $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'A propos';

  @override
  String get gpsPlaceAboutDialogContent =>
      'La localisation affiché n\'est qu\'une estimation et n\'est pas garantie d\'être exact. Ceci ne represente en rien notre point de vu sur des espaces disputés.';

  @override
  String get collectionPlacesLabel => 'Localisation';

  @override
  String get imageSaveOptionDialogTitle => 'Sauvegarder';

  @override
  String get imageSaveOptionDialogContent =>
      'Sélectionner où sauvegarder les images traitées. Si vous choisissez sur le serveur mais que l\'envoi échoué, l\'image sera sauvegardée sur l\'appareil';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'APPAREIL';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'SERVEUR';

  @override
  String get initialSyncMessage =>
      'Synchronisation avec le serveur pour la première fois';

  @override
  String get loopTooltip => 'Répéter';

  @override
  String get createCollectionFailureNotification =>
      'La création de la collection a échouée';

  @override
  String get addItemToCollectionTooltip => 'Ajouter a la collection';

  @override
  String get addItemToCollectionFailureNotification =>
      'L\'ajout a la collection a échoué';

  @override
  String get setCollectionCoverFailureNotification =>
      'Le changement de la couverture a échoué';

  @override
  String get exportCollectionTooltip => 'Exporter';

  @override
  String get exportCollectionDialogTitle => 'Exporter la collection';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 => 'Album côté serveur';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 =>
      'Créez un album sur votre serveur, accessible avec n\'importe quelle application';

  @override
  String get removeCollectionsFailedNotification =>
      'La suppression des collections a échouée';

  @override
  String get accountSettingsTooltip => 'Paramètres du compte';

  @override
  String get contributorsTooltip => 'Contributeur';

  @override
  String get setAsTooltip => 'Utiliser comme';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return 'Vous êtes sur le point de vous déconnecter de $server';
  }

  @override
  String get appLockUnlockHint => 'Déverrouiller l\'application';

  @override
  String get appLockUnlockWrongPassword => 'Mot de passe incorrect';

  @override
  String get enabledText => 'Activé';

  @override
  String get disabledText => 'Désactivé';

  @override
  String get trustedCertManagerPageTitle => 'Certificats de confiance';

  @override
  String get trustedCertManagerAlreadyTrustedError => 'Déjà approuvé';

  @override
  String get trustedCertManagerSelectServer => 'Sélectionnez le serveur HTTPS';

  @override
  String get trustedCertManagerNoHttpsServerError => 'Aucun serveur disponible';

  @override
  String get trustedCertManagerFailedToRemoveCertError =>
      'Impossible de supprimer le certificat';

  @override
  String get missingVideoThumbnailHelpDialogTitle =>
      'Vous rencontrez des problèmes avec les miniatures des vidéos ?';

  @override
  String get dontShowAgain => 'Ne plus afficher';

  @override
  String get mapBrowserDateRangeLabel => 'Plage de dates';

  @override
  String get mapBrowserDateRangeThisMonth => 'Ce mois-ci';

  @override
  String get mapBrowserDateRangePrevMonth => 'Mois précédent';

  @override
  String get mapBrowserDateRangeThisYear => 'Cette année';

  @override
  String get mapBrowserDateRangeCustom => 'Personnalisée';

  @override
  String get homeTabMapBrowser => 'Carte';

  @override
  String get mapBrowserSetDefaultDateRangeButton => 'Définir par défaut';

  @override
  String get todayText => 'Aujourd\'hui';

  @override
  String get livePhotoTooltip => 'Photo en direct';

  @override
  String get dragAndDropRearrangeButtons =>
      'Faites un glisser-déposer pour réorganiser les boutons';

  @override
  String get customizeCollectionsNavBarDescription =>
      'Faites un glisser-déposer pour réorganiser les boutons, appuyez sur les boutons ci-dessus pour les minimiser';

  @override
  String get customizeButtonsUnsupportedWarning =>
      'Ce bouton ne peut pas être personnalisé';

  @override
  String get placePickerTitle => 'Choisissez un endroit';

  @override
  String get albumAddMapTooltip => 'Ajouter une carte';

  @override
  String get fileNotFound => 'Fichier introuvable';

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
      'Accès non authentifié. Veuillez vous reconnecter si le problème persiste';

  @override
  String get errorDisconnected =>
      'Impossible de se connecter. Le serveur peut être hors ligne ou votre appareil peut être déconnecté';

  @override
  String get errorLocked =>
      'Le fichier est verrouillé sur le serveur. Veuillez réessayer plus tard';

  @override
  String get errorInvalidBaseUrl =>
      'Impossible de communiquer. Veuillez vous assurer que l\'adresse est l\'URL de base de votre instance Nextcloud';

  @override
  String get errorWrongPassword =>
      'Impossible à authentifier. Veuillez vérifier le nom d\'utilisateur et le mot de passe';

  @override
  String get errorServerError =>
      'Erreur du serveur. Veuillez vous assurer que le serveur est correctement configuré';

  @override
  String get errorAlbumDowngrade =>
      'Impossible de modifier cet album car il a été créé par une version ultérieure de cette application. Veuillez mettre à jour l\'application et réessayer';

  @override
  String get errorNoStoragePermission =>
      'Exiger une autorisation d\'accès au stockage';

  @override
  String get errorServerNoCert =>
      'Server certificate not found. Try HTTP instead?';
}
