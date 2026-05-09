// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Fotos';

  @override
  String get translator => 'fernosan';

  @override
  String get photosTabLabel => 'Fotos';

  @override
  String get collectionsTooltip => 'Coleções';

  @override
  String get zoomTooltip => 'Zoom';

  @override
  String get settingsMenuLabel => 'Configurações';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selecionadas',
      one: '1 selecionada',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Apagando $count itens',
      one: 'Apagando 1 item',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification =>
      'Todos os itens foram apagados com sucesso';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Falha ao apagar $count itens',
      one: 'Falha ao apagar 1 item',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Arquivados';

  @override
  String get archiveSelectedSuccessNotification =>
      'Todos os itens foram arquivados com sucesso';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Falha ao arquivar  $count itens',
      one: 'Falha ao arquivar 1 item',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Desarquivar';

  @override
  String get unarchiveSelectedSuccessNotification =>
      'Todos os itens foram desarquivados com sucesso';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Falha ao desarquivar $count itens',
      one: 'Falha ao desarquivar 1 item',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Apagar';

  @override
  String get deleteSuccessNotification => 'Item apagado com sucesso';

  @override
  String get deleteFailureNotification => 'Falhou ao apagar o item';

  @override
  String get removeSelectedFromAlbumFailureNotification =>
      'Falha ao remover os itens selecionados do álbum';

  @override
  String get addServerTooltip => 'Cadastrar servidor';

  @override
  String removeServerSuccessNotification(Object server) {
    return 'O servidor $server foi removido';
  }

  @override
  String get createAlbumTooltip => 'Novo álbum';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count itens',
      one: '1 item',
      zero: 'Vazio',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Arquivo';

  @override
  String connectingToServer(Object server) {
    return 'Conectando ao\n$server';
  }

  @override
  String get connectingToServer2 => 'Esperando pela autorização do servidor';

  @override
  String get connectingToServerInstruction =>
      'Por favor autentique pelo navegador';

  @override
  String get nameInputHint => 'Nome';

  @override
  String get nameInputInvalidEmpty => 'Name is required';

  @override
  String get skipButtonLabel => 'Pular';

  @override
  String get confirmButtonLabel => 'Confirma';

  @override
  String get signInHeaderText => 'Cadastre seu servidor Nextcloud';

  @override
  String get signIn2faHintText =>
      'Use uma senha de aplicativo se você possui 2fa habilitada no servidor';

  @override
  String get signInHeaderText2 => 'Nextcloud\nSLogar-se';

  @override
  String get serverAddressInputHint => 'Endereço do servidor';

  @override
  String get serverAddressInputInvalidEmpty => 'Insira o endereço do servidor';

  @override
  String get usernameInputHint => 'Nome de usuário';

  @override
  String get usernameInputInvalidEmpty => 'Insira o nome de usuário';

  @override
  String get passwordInputHint => 'Senha';

  @override
  String get passwordInputInvalidEmpty => 'Insira a sua senha';

  @override
  String get rootPickerHeaderText => 'Escolha as pastas a serem incluídas';

  @override
  String get rootPickerSubHeaderText =>
      'Apenas as fotos dentro das pastas serão incluídas. Pressione Pular para incluir todos os itens';

  @override
  String get rootPickerNavigateUpItemText => '(voltar)';

  @override
  String get rootPickerUnpickFailureNotification =>
      'Falha ao desfazer a seleção do item';

  @override
  String get rootPickerListEmptyNotification =>
      'Selecione ao menos uma pasta ou pressione Pular para incluir todas';

  @override
  String get setupWidgetTitle => 'Primeiros passos';

  @override
  String get setupSettingsModifyLaterHint =>
      'Você pode modificar isso mais tarde em Configurações';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      'Esse app cria uma pasta na raiz do seu armazenamento Nextcloud para armazenar arquivos de preferências. Por favor não a modifique ou a remova a não ser que você tenha a intenção de desinstalar este app';

  @override
  String get settingsWidgetTitle => 'Configurações';

  @override
  String get settingsLanguageTitle => 'Língua';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => 'O padrão do sistema';

  @override
  String get settingsMetadataTitle => 'File metadata';

  @override
  String get settingsExifSupportTitle2 => 'Client-side EXIF support';

  @override
  String get settingsExifSupportTrueSubtitle =>
      'Requer consumo de dados elevado';

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
  String get settingsMemoriesTitle => 'Memórias';

  @override
  String get settingsMemoriesSubtitle => 'Mostra fotos tiradas no passado';

  @override
  String get settingsAccountTitle => 'Conta';

  @override
  String get settingsAccountLabelTitle => 'Apelido';

  @override
  String get settingsAccountLabelDescription =>
      'Set a label to be shown in place of the server URL';

  @override
  String get settingsIncludedFoldersTitle => 'Pastas inclusas';

  @override
  String get settingsShareFolderTitle => 'Pasta compartilhada';

  @override
  String get settingsShareFolderDialogTitle =>
      'Localizar a pasta compartilhada';

  @override
  String get settingsShareFolderDialogDescription =>
      'Essa configuração corresponde ao parâmetro share_folder em config.php. Os dois valores DEVEM ser idênticos.\n\nPor favor localize a mesma pasta referenciada em seu arquivo config.php.';

  @override
  String get settingsShareFolderPickerDescription =>
      'Selecione a mesma pasta que a configurada no arquivo config.php de seu servidor. Presisone Padrão se você não modificou o parâmetro.';

  @override
  String get settingsPersonProviderTitle => 'Person provider';

  @override
  String get settingsServerAppSectionTitle => 'Suporte a app do servidor';

  @override
  String get settingsPhotosDescription =>
      'Customize os conteúdos mostrados na aba Fotos';

  @override
  String get settingsMemoriesRangeTitle => 'Janela de data para memórias';

  @override
  String settingsMemoriesRangeValueText(num range) {
    String _temp0 = intl.Intl.pluralLogic(
      range,
      locale: localeName,
      other: '+-$range dias',
      one: '+-$range dia',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeviceMediaTitle => 'Show device media';

  @override
  String get settingsDeviceMediaDescription =>
      'Selected folders will be displayed';

  @override
  String get settingsViewerTitle => 'Visualização';

  @override
  String get settingsViewerDescription =>
      'Customize a visualização de image e video';

  @override
  String get settingsScreenBrightnessTitle => 'Brilho da tela';

  @override
  String get settingsScreenBrightnessDescription =>
      'Ignora o nivel de brilho do sistema';

  @override
  String get settingsForceRotationTitle =>
      'Ignorar a trava de rotação do sistema';

  @override
  String get settingsForceRotationDescription =>
      'Rodar a tela mesmo que a rotação do sistema estiver travada';

  @override
  String get settingsMapProviderTitle => 'Provedor de mapa';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'Customize app bar';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle =>
      'Customize bottom app bar';

  @override
  String get settingsShowDateInAlbumTitle => 'Agrupe as fotos por data';

  @override
  String get settingsShowDateInAlbumDescription =>
      'Se aplica apenas quando está organizado cronologicamente';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'Customize navigation bar';

  @override
  String get settingsImageEditTitle => 'Editor';

  @override
  String get settingsImageEditDescription =>
      'Customize o editor de aprimoramento de imagens';

  @override
  String get settingsEnhanceMaxResolutionTitle2 =>
      'Resolução das imagens aprimoradas';

  @override
  String get settingsEnhanceMaxResolutionDescription =>
      'Resoluções de entrara maiores que a determinada serão reduzidas. Fotos em alta resolução requerem significativamente mais memória RAM e processamento. Por gentileza reduza o parâmetro de resolução das imagens aprimoradas caso o app trave';

  @override
  String get settingsImageEditSaveResultsToServerTitle =>
      'Salve os resultados diretamente no servidor';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      'Os resultados são salvos no servidor, e caso encontre problemas, salva localmente';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      'Os resultados são salvos localmente';

  @override
  String get settingsThemeTitle => 'Tema';

  @override
  String get settingsThemeDescription => 'Customize a aparência do app';

  @override
  String get settingsFollowSystemThemeTitle => 'Seguir o tema do sistema';

  @override
  String get settingsSeedColorTitle => 'Cor do tema';

  @override
  String get settingsSeedColorDescription =>
      'Pode ser usado para customizar todas as cores do app';

  @override
  String get settingsSeedColorSystemColorDescription => 'Use system color';

  @override
  String get settingsSeedColorPickerTitle => 'Escolha uma cor';

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
  String get settingsUseBlackInDarkThemeTitle => 'Tema mais escuro';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription =>
      'Usar fundo com preto absoluto';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription =>
      'Use fundo com cinza escuro';

  @override
  String get settingsMiscellaneousTitle => 'Miscelânea';

  @override
  String get settingsDoubleTapExitTitle => 'Toque duas vezes para sair do app';

  @override
  String get settingsPhotosTabSortByNameTitle =>
      'Organize fotos por nome do arquivo';

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
  String get settingsExperimentalTitle => 'Experimental';

  @override
  String get settingsExperimentalDescription =>
      'Novidades que não estão prontas ao uso do dia a dia';

  @override
  String get settingsExpertTitle => 'Avançado';

  @override
  String get settingsExpertWarningText =>
      'Entenda os riscos e objetivos de cada opção antes de prosseguir';

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
  String get settingsAboutSectionTitle => 'Sobre';

  @override
  String get settingsVersionTitle => 'Versão';

  @override
  String get settingsServerVersionTitle => 'Server';

  @override
  String get settingsSourceCodeTitle => 'Código-fonte';

  @override
  String get settingsBugReportTitle => 'Reportar problema';

  @override
  String get settingsCaptureLogsTitle => 'Registrar logs';

  @override
  String get settingsCaptureLogsDescription =>
      'Ajude o desenvolvedor a encontrar bugs';

  @override
  String get settingsTranslatorTitle => 'Tradutor';

  @override
  String get settingsRestartNeededDialog =>
      'Please restart the app to apply changes';

  @override
  String get writePreferenceFailureNotification =>
      'Falhou em salvar as preferências';

  @override
  String get enableButtonLabel => 'HABILITADO';

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
      'Para reportar bugs:\n\n1. Ative essa configuração\n2. Reproduza o problema\n3. Desative essa configuração\n4. Procure por nc-photos.log na pasta de download\n\n*Se o bug fizer que o app trave, nenhum log será gravado. Nesse caso, por gentileza contacte o desenvolvedor do app para instruções adicionais';

  @override
  String get captureLogSuccessNotification => 'Logs gravados com sucesso';

  @override
  String get doneButtonLabel => 'PRONTO';

  @override
  String get nextButtonLabel => 'PRÓXIMO';

  @override
  String get connectButtonLabel => 'CONECTAR';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      'Todos os seus arquivos serão incluídos. Isso poderá aumentar o uso de memória RAM e prejudicar a performance';

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
  String get detailsTooltip => 'Detalhes';

  @override
  String get downloadTooltip => 'Download';

  @override
  String get downloadProcessingNotification => 'Baixando arquivo';

  @override
  String get downloadSuccessNotification => 'Download finalizado com sucesso';

  @override
  String get downloadFailureNotification => 'Falha no download';

  @override
  String get nextTooltip => 'Próximo';

  @override
  String get previousTooltip => 'Anterior';

  @override
  String get webSelectRangeNotification =>
      'Segure shift + clique para selecionar itens intermediários';

  @override
  String get mobileSelectRangeNotification =>
      'Use um toque longo para selecionar itens intermediários';

  @override
  String get updateDateTimeDialogTitle => 'Modificar data e hora';

  @override
  String get dateSubtitle => 'Data';

  @override
  String get timeSubtitle => 'Hora';

  @override
  String get dateYearInputHint => 'Ano';

  @override
  String get dateMonthInputHint => 'Mês';

  @override
  String get dateDayInputHint => 'Dia';

  @override
  String get timeHourInputHint => 'Hora';

  @override
  String get timeMinuteInputHint => 'Minuto';

  @override
  String get timeSecondInputHint => 'Segundos';

  @override
  String get dateTimeInputInvalid => 'Valor inválido';

  @override
  String get updateDateTimeFailureNotification =>
      'Falha ao modificar data e hora';

  @override
  String get albumDirPickerHeaderText => 'Escolha as pastas a serem associadas';

  @override
  String get albumDirPickerSubHeaderText =>
      'Somente as fotos nas pastas associadas serão incluídas nesse álbum';

  @override
  String get albumDirPickerListEmptyNotification =>
      'Escolha pelo menos uma pasta';

  @override
  String get importFoldersTooltip => 'Importar pastas';

  @override
  String get albumImporterHeaderText => 'Importar pastas como álbuns';

  @override
  String get albumImporterSubHeaderText =>
      'Pastas sugeridas são listadas abaixo. Dependendo no número de arquivos no seu servidor, isso pode demorar um pouco para terminar';

  @override
  String get importButtonLabel => 'IMPORTAR';

  @override
  String get albumImporterProgressText => 'Importando pastas';

  @override
  String get doneButtonTooltip => 'Pronto';

  @override
  String get editTooltip => 'Editar';

  @override
  String get editAccountConflictFailureNotification =>
      'Uma conta já existe com essas mesmas configurações';

  @override
  String get genericProcessingDialogContent => 'Por favor, espere';

  @override
  String get sortTooltip => 'Organizar';

  @override
  String get sortOptionDialogTitle => 'Organizar por';

  @override
  String get sortOptionTimeAscendingLabel => 'Antigas primeiro';

  @override
  String get sortOptionTimeDescendingLabel => 'Recentes primeiro';

  @override
  String get sortOptionFilenameAscendingLabel => 'Por nome de arquivo';

  @override
  String get sortOptionFilenameDescendingLabel => 'Por nome de arquivo (Z-A)';

  @override
  String get sortOptionAlbumNameLabel => 'Por nome do álbum';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'Nome do álbum (A-Z)';

  @override
  String get sortOptionManualLabel => 'Organização manual';

  @override
  String get albumEditDragRearrangeNotification =>
      'Use toque longo para arrastar um item para organizá-lo manualmente';

  @override
  String get albumAddTextTooltip => 'Adicionar texto';

  @override
  String get shareTooltip => 'Compartilhar';

  @override
  String get shareSelectedEmptyNotification =>
      'Selecione as fotos a serem compartilhadas';

  @override
  String get shareDownloadingDialogContent => 'Baixando';

  @override
  String get searchTooltip => 'Busca';

  @override
  String get clearTooltip => 'Limpar';

  @override
  String get listNoResultsText => 'Sem resultados';

  @override
  String get listEmptyText => 'Vazio';

  @override
  String get albumTrashLabel => 'Lixeira';

  @override
  String get restoreTooltip => 'Recuperar';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Recuperando $count itens',
      one: 'Recuperando 1 item',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification =>
      'Todos os itens forma recuperados com sucesso';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Falha ao recuperar $count itens',
      one: 'Falha ao recuperar 1 item',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Recuperando item';

  @override
  String get restoreSuccessNotification => 'Item recuperado com sucesso';

  @override
  String get restoreFailureNotification => 'Falha ao recuperar o item';

  @override
  String get deletePermanentlyTooltip => 'Apagar permanentemente';

  @override
  String get deletePermanentlyConfirmationDialogTitle =>
      'Apagar permanentemente';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      'Os itens selecionados serão apagados permanentemente do servidor.\n\nEssa ação é irreversível';

  @override
  String get albumSharedLabel => 'Compartilhadas';

  @override
  String get metadataTaskProcessingNotification =>
      'Processando metadados das imagens em segundo plano';

  @override
  String get configButtonLabel => 'CONFIGURAÇÃO';

  @override
  String get useAsAlbumCoverTooltip => 'Use como capa de álbum';

  @override
  String get helpTooltip => 'Ajuda';

  @override
  String get helpButtonLabel => 'AJUDA';

  @override
  String get removeFromAlbumTooltip => 'Remover do álbum';

  @override
  String get changelogTitle => 'Histórico de mudanças';

  @override
  String get serverCertErrorDialogTitle =>
      'O certificado SSL do servidor parece não confiável';

  @override
  String get serverCertErrorDialogContent =>
      'O servidor pode ter sido hackeado ou alguém pode estar tentando reoubar suas informações';

  @override
  String get advancedButtonLabel => 'AVANÇADAS';

  @override
  String get whitelistCertDialogTitle =>
      'Acreditar em certificado não confiável?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'Você pode fazer com que o app aceite um certificado não confiável. CUIDADO! isso configura um grande risco de segurança. Tenha certeza que seu certifico seja auto-assinado por você ou por terceiro de confiança\n\nServidor: $host\nImpressão digital: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel =>
      'ACEITAR O RISCO E ADICIONE COMO CONFIÁVEL';

  @override
  String get fileSharedByDescription => 'Compartilhado com você pelo usuário';

  @override
  String get emptyTrashbinTooltip => 'Esvaziar lixeira';

  @override
  String get emptyTrashbinConfirmationDialogTitle =>
      'Tem certeza de que quer esvaziar a lixeira?';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      'Todos os itens serão apagados permanentemente do servidor remoto.\n\nThis action is nonreversible';

  @override
  String get unsetAlbumCoverTooltip => 'Desmarcar como capa de álbum';

  @override
  String get muteTooltip => 'Sem áudio';

  @override
  String get unmuteTooltip => 'Reativer som';

  @override
  String get collectionPeopleLabel => 'Pessoas';

  @override
  String get slideshowTooltip => 'Slideshow';

  @override
  String get slideshowSetupDialogTitle => 'Configurar slideshow';

  @override
  String get slideshowSetupDialogDurationTitle =>
      'Duração do slideshow (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Aleatório';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Repetir';

  @override
  String get slideshowSetupDialogReverseTitle => 'De trás pra frente';

  @override
  String get linkCopiedNotification => 'Link copiado';

  @override
  String get shareMethodDialogTitle => 'Compartilhe como';

  @override
  String get shareMethodPreviewTitle => 'Previsão';

  @override
  String get shareMethodPreviewDescription =>
      'Compartilha um arquivo com qualidade menor para outros aplicativos (apenas para imagens)';

  @override
  String get shareMethodOriginalFileTitle => 'Original file';

  @override
  String get shareMethodOriginalFileDescription =>
      'Baixa o arquivo original e compartilhe com outros appps';

  @override
  String get shareMethodPublicLinkTitle => 'Link público';

  @override
  String get shareMethodPublicLinkDescription =>
      'Cria um endereço público no servidor. Qualquer pessoa com o endereço pode acessar o arquivo';

  @override
  String get shareMethodPasswordLinkTitle => 'Link protegido por senha';

  @override
  String get shareMethodPasswordLinkDescription =>
      'Cria um link protegido por senha no servidor';

  @override
  String get collectionSharingLabel => 'Compartilhados';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Compartilhado por último em $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user compartilhou com você em $date';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user compartilhou o álbum com você em $date';
  }

  @override
  String get sharedWithLabel => 'Compartilhado com';

  @override
  String get unshareTooltip => 'Desfazer o compartilhamento';

  @override
  String get unshareSuccessNotification => 'Compartilhamento removido';

  @override
  String get locationLabel => 'Local';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloud não tem suporte para link único para vários arquivos. Em vez disso, o app vai COPIAR os arquivos para uma nova pasta e compartilhá-la.';

  @override
  String get folderNameInputHint => 'Nome da pasta';

  @override
  String get folderNameInputInvalidEmpty =>
      'Por favor entre com o nome da pasta';

  @override
  String get folderNameInputInvalidCharacters => 'Contém caracteres inválidos';

  @override
  String get createShareProgressText => 'Criando compartilhamento';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Falhou ao copiar $count itens',
      one: 'Falhou ao copiar 1 item',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Apagar pasta?';

  @override
  String get unshareLinkShareDirDialogContent =>
      'Essa pasta foi criada automaticamente pelo app para compartilhar vários arquivos ao mesmo tempo através de um link. No momento ela não é mais compartilhada com ninguém. Quer apagar esta pasta?';

  @override
  String get addToCollectionsViewTooltip => 'Adicionar à minha coleção';

  @override
  String get shareAlbumDialogTitle => 'Compartilhar com usuário';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Álbum foi compartilhado com $user, porém falhou em prover alguns arquivos';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'Compartilhamento de álbum removido para $user, porém falhou em remover o compartilhamento de alguns arquivos';
  }

  @override
  String get fixSharesTooltip => 'Consertar compartilhamentos';

  @override
  String get fixTooltip => 'Consertar';

  @override
  String get fixAllTooltip => 'Consertar tudo';

  @override
  String missingShareDescription(Object user) {
    return 'Não compartilhado com $user';
  }

  @override
  String extraShareDescription(Object user) {
    return 'Compartilhado com $user';
  }

  @override
  String get defaultButtonLabel => 'PADRÃO';

  @override
  String get addUserInputHint => 'Adicionar usuário';

  @override
  String get sharedAlbumInfoDialogTitle =>
      'Introdução aos álbums compartilhados';

  @override
  String get sharedAlbumInfoDialogContent =>
      'Álbuns compartilhados permitem multiplos usuários em um mesmo servidor Nextcloud a acessar o mesmo álbum. Por favor leia com atenção às limitações antes de prosseguir';

  @override
  String get learnMoreButtonLabel => 'APRENDA MAIS';

  @override
  String get migrateDatabaseProcessingNotification =>
      'Atualizando banco de dados';

  @override
  String get migrateDatabaseFailureNotification =>
      'Falhou em migrar a base de dados';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Há $count anos',
      one: 'Há 1 ano',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'Pasta inicial não encontrada';

  @override
  String get homeFolderNotFoundDialogContent =>
      'Por favor corrija o URL WebDAV URL abaixo. Você pode encontrar o URL na interface web do Nextcloud.';

  @override
  String get homeFolderInputInvalidEmpty =>
      'Entre com o nome da sua pasta inicial';

  @override
  String get createCollectionTooltip => 'Nova coleção';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Client-side album';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      'Album with extra features, accessible only with this app';

  @override
  String get createCollectionDialogFolderLabel => 'Pasta';

  @override
  String get createCollectionDialogFolderDescription =>
      'Mostre fotos dentro da pasta';

  @override
  String get collectionFavoritesLabel => 'Favoritas';

  @override
  String get favoriteTooltip => 'Favoritar';

  @override
  String get favoriteSuccessNotification => 'Adicionada aos favoritos';

  @override
  String get favoriteFailureNotification => 'Falha ao adicionar como favorita';

  @override
  String get unfavoriteTooltip => 'Desfavoritar';

  @override
  String get unfavoriteSuccessNotification => 'Removida dos favoritos';

  @override
  String get unfavoriteFailureNotification => 'Falha ao remover dos favoritos';

  @override
  String get createCollectionDialogTagLabel => 'Etiqueta';

  @override
  String get createCollectionDialogTagDescription =>
      'Mostre fotos com etiquetas específicas';

  @override
  String get addTagInputHint => 'Adicionar etiqueta';

  @override
  String get tagPickerNoTagSelectedNotification =>
      'Por favor adicione ao menos uma etiqueta';

  @override
  String get backgroundServiceStopping => 'Parando serviço de plano de fundo';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'A bateria está fraca';

  @override
  String get enhanceTooltip => 'Aprimorar';

  @override
  String get enhanceButtonLabel => 'APRIMORAR';

  @override
  String get enhanceIntroDialogTitle => 'Aprimore uma foto';

  @override
  String get enhanceIntroDialogDescription =>
      'Suas fotos são processadas localmente no aparelho. Por padrão, elas são reduzidas a 2048x1536. Você pode ajustar a resolução en configurações';

  @override
  String get enhanceLowLightTitle => 'Retoque para pouca luz';

  @override
  String get enhanceLowLightDescription =>
      'Clareia as fotos tiradas em ambientes com pouca luz';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Brilho';

  @override
  String get collectionEditedPhotosLabel => 'Editatas (local)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      'Itens selecionados serão apagados permanentemente do aparelho.\n\nEssa ação é irreversível';

  @override
  String get enhancePortraitBlurTitle => 'Desfoque para de retrato';

  @override
  String get enhancePortraitBlurDescription =>
      'Desfoca o plano de fundo das imagens. Funcioma melhor para retratos';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Nível de desfoque';

  @override
  String get enhanceSuperResolution4xTitle => 'Super-resolução (4x)';

  @override
  String get enhanceSuperResolution4xDescription =>
      'Aumenta as fotos em 4x (veja a Ajuda para detalhes)';

  @override
  String get enhanceStyleTransferTitle => 'Transferir estilo';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Selecione um estilo';

  @override
  String get enhanceStyleTransferStyleDialogDescription =>
      'Transfere um estilo de uma imagem de referencia para outra';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification =>
      'Por favor, selecione um estilo';

  @override
  String get enhanceColorPopTitle => 'Destaque de cores';

  @override
  String get enhanceColorPopDescription =>
      'Torna o fundo preto e branco. Funciona melhor com retratos';

  @override
  String get enhanceGenericParamWeightLabel => 'Intensidade';

  @override
  String get enhanceRetouchTitle => 'Auto-retoque';

  @override
  String get enhanceRetouchDescription =>
      'Aprimora as fotos de forma automatizada. Melhora a matiz e saturação';

  @override
  String get doubleTapExitNotification => 'Toque novamente pra sair';

  @override
  String get imageEditDiscardDialogTitle => 'Descartar modificações?';

  @override
  String get imageEditDiscardDialogContent => 'Suas mudanças não foram salvas';

  @override
  String get discardButtonLabel => 'DESCARTAR';

  @override
  String get saveTooltip => 'SALVAR';

  @override
  String get imageEditDownloadDialogTitle => 'Downloading image from server...';

  @override
  String get imageEditProcessDialogTitle => 'Processing image...';

  @override
  String get imageEditSaveDialogTitle => 'Saving result...';

  @override
  String get imageEditColorBrightness => 'Brilho';

  @override
  String get imageEditColorContrast => 'Contrate';

  @override
  String get imageEditColorWhitePoint => 'Branco referencial';

  @override
  String get imageEditColorBlackPoint => 'Preto referencial';

  @override
  String get imageEditColorSaturation => 'Saturação';

  @override
  String get imageEditColorWarmth => 'Temperatura de cor';

  @override
  String get imageEditColorTint => 'Matiz';

  @override
  String get imageEditTitle => 'Previsão das edições';

  @override
  String get imageEditToolbarColorLabel => 'Cor';

  @override
  String get imageEditToolbarTransformLabel => 'Transforme';

  @override
  String get imageEditTransformOrientation => 'Orientação';

  @override
  String get imageEditTransformOrientationClockwise => 'Para a direita';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'Para a esquerda';

  @override
  String get imageEditTransformCrop => 'Cortar';

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
  String get categoriesLabel => 'Categorias';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      'Press settings to switch provider or press help to learn more';

  @override
  String get searchLandingCategoryVideosLabel => 'Vídeos';

  @override
  String get searchFilterButtonLabel => 'FILTROS';

  @override
  String get searchFilterDialogTitle => 'Filtros de buscaSearch filters';

  @override
  String get applyButtonLabel => 'APLICAR';

  @override
  String get searchFilterOptionAnyLabel => 'Todas';

  @override
  String get searchFilterOptionTrueLabel => 'Verdadeiro';

  @override
  String get searchFilterOptionFalseLabel => 'Falso';

  @override
  String get searchFilterTypeLabel => 'Tipo';

  @override
  String get searchFilterTypeOptionImageLabel => 'Imagem';

  @override
  String get searchFilterBubbleTypeImageText => 'imagens';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Vídeo';

  @override
  String get searchFilterBubbleTypeVideoText => 'vídeos';

  @override
  String get searchFilterFavoriteLabel => 'Favoritas';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'favoritas';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'não favoritas';

  @override
  String get showAllButtonLabel => 'MOSTRE TUDO';

  @override
  String gpsPlaceText(Object place) {
    return 'Próximo a $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'Sobre o lugar';

  @override
  String get gpsPlaceAboutDialogContent =>
      'A localização é uma estimativa grosseira e não garante precisão. Não representa nossas visões ou opiniões sobre regiões disputadas.';

  @override
  String get collectionPlacesLabel => 'Lugares';

  @override
  String get imageSaveOptionDialogTitle => 'Salvando o resultado';

  @override
  String get imageSaveOptionDialogContent =>
      'Selecione onde salvar esse e futuros arquivos processados. Se você escolheu o servidor, e houve falha no upload, ele será salvo no aparelho.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'APARELHO';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'SERVIDOR';

  @override
  String get initialSyncMessage =>
      'Sincronizando com o servidor pela primeira vez';

  @override
  String get loopTooltip => 'Reinício automático';

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
  String get recognizeInstructionDialogTitle =>
      'Setup required for Recognize integration';

  @override
  String get recognizeInstructionDialogContent =>
      'Since Nextcloud 33, a server-side app is required to support Recognize.';

  @override
  String get recognizeInstructionDialogButton => 'Open Guide';

  @override
  String get errorUnauthenticated =>
      'Acesso não autenticado. Por favor faça login novamente se o problema persistir';

  @override
  String get errorDisconnected =>
      'Não foi possível conectar. O servidor pode estar offline ou o seu dispositivo pode estar desconectado da rede';

  @override
  String get errorLocked =>
      'O arquivo está bloqueado no servidor. Por favor tente novamente mais tarde';

  @override
  String get errorInvalidBaseUrl =>
      'Não foi possível comunicar. Por favor tenha certeza de que o endereço seja a base URL do seu servidor Nextcloud';

  @override
  String get errorWrongPassword =>
      'A autenticação não foi possível. Por favor confira o nome de usuário e a senha';

  @override
  String get errorServerError =>
      'Erro no servidor. Por favor tenha certeza de que o servidor esteja configurado corretamente ou contacte seu administrador Nextcloud';

  @override
  String get errorAlbumDowngrade =>
      'Não foi possível modificar o álbum, pois ele foi criado por um versão posterior desse app. Por favor atualize o app e tente novamente';

  @override
  String get errorNoStoragePermission =>
      'Requer permissão para acessar o armazenamento';

  @override
  String get errorServerNoCert =>
      'Server certificate not found. Try HTTP instead?';
}
