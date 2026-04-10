// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Fotos';

  @override
  String get translator => 'luckkmaxx';

  @override
  String get photosTabLabel => 'Fotos';

  @override
  String get collectionsTooltip => 'Colecciones';

  @override
  String get zoomTooltip => 'Zoom';

  @override
  String get settingsMenuLabel => 'Ajustes';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seleccionados',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Borrando $count elementos',
      one: 'Borrando 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification => 'Elementos borrados';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Error al borrar $count elementos',
      one: 'Error al borrar 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Archivar';

  @override
  String get archiveSelectedSuccessNotification => 'Archivado';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Error al archivar $count elementos',
      one: 'Error al archivar 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Desarchivar selección';

  @override
  String get unarchiveSelectedSuccessNotification => 'Selección desarchivada';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Error al desarchivar $count elementos',
      one: 'Error al desarchivar 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Eliminar';

  @override
  String get deleteSuccessNotification => 'Elemento borrado';

  @override
  String get deleteFailureNotification => 'Error al borrar elemento';

  @override
  String get removeSelectedFromAlbumFailureNotification =>
      'Error al quitar elementos del álbum';

  @override
  String get addServerTooltip => 'Añadir servidor';

  @override
  String removeServerSuccessNotification(Object server) {
    return 'Quitado $server';
  }

  @override
  String get createAlbumTooltip => 'Crear nuevo álbum';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count elementos',
      one: '1 elemento',
      zero: 'Empty',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Archivado';

  @override
  String connectingToServer(Object server) {
    return 'Conectando a\n$server';
  }

  @override
  String get connectingToServer2 => 'Esperando autorización del servidor';

  @override
  String get connectingToServerInstruction =>
      'Por favor inicia sesión con el navegador que se ha abierto';

  @override
  String get nameInputHint => 'Nombre';

  @override
  String get nameInputInvalidEmpty => 'Nombre requerido';

  @override
  String get skipButtonLabel => 'SALTAR';

  @override
  String get confirmButtonLabel => 'CONFIRMAR';

  @override
  String get signInHeaderText => 'Iniciar sesión en servidor Nextcloud';

  @override
  String get signIn2faHintText =>
      'Usa una contraseña de aplicación si el servidor tiene activada la autenticación de doble factor.';

  @override
  String get signInHeaderText2 => 'Nextcloud\nIdentifícate';

  @override
  String get serverAddressInputHint => 'Dirección del servidor';

  @override
  String get serverAddressInputInvalidEmpty =>
      'Introduce la dirección del servidor';

  @override
  String get usernameInputHint => 'Usuario';

  @override
  String get usernameInputInvalidEmpty => 'Introduce tu nombre de usuario';

  @override
  String get passwordInputHint => 'Contraseña';

  @override
  String get passwordInputInvalidEmpty => 'Introduce tu contraseña';

  @override
  String get rootPickerHeaderText =>
      'Selecciona las carpetas que serán añadidas';

  @override
  String get rootPickerSubHeaderText =>
      'Solo se mostrará el contenido de las carpetas seleccionadas. Toca SALTAR para incluir todas';

  @override
  String get rootPickerNavigateUpItemText => '(atrás)';

  @override
  String get rootPickerUnpickFailureNotification =>
      'Error al desmarcar elemento';

  @override
  String get rootPickerListEmptyNotification =>
      'Por favor, selecciona al menos una carpeta o toca SALTAR para seleccionar todas';

  @override
  String get setupWidgetTitle => 'Empecemos';

  @override
  String get setupSettingsModifyLaterHint =>
      'Puedes cambiarlo luego en Ajustes';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      'Está aplicación crea una carpeta oculta en Nextcloud para guardar las preferencias. Por favor no la modifiques o elimines a no ser que quieras desinstalar ésta aplicación.';

  @override
  String get settingsWidgetTitle => 'Ajustes';

  @override
  String get settingsLanguageTitle => 'Idioma';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => 'Sistema';

  @override
  String get settingsMetadataTitle => 'Metadatos';

  @override
  String get settingsExifSupportTitle2 => 'Soporte EXIF en Cliente';

  @override
  String get settingsExifSupportTrueSubtitle =>
      'Requiere un uso mayor de la red';

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
  String get settingsMemoriesTitle => 'Recuerdos';

  @override
  String get settingsMemoriesSubtitle => 'Muestra fotos tomadas en el pasado';

  @override
  String get settingsAccountTitle => 'Cuenta';

  @override
  String get settingsAccountLabelTitle => 'Etiqueta';

  @override
  String get settingsAccountLabelDescription =>
      'Pon un nombre para mostrarse en lugar de la URL del servidor';

  @override
  String get settingsIncludedFoldersTitle => 'Carpetas incluídas';

  @override
  String get settingsShareFolderTitle => 'Carpeta \'share\'';

  @override
  String get settingsShareFolderDialogTitle =>
      'Ubicación de la carpeta \'share\'';

  @override
  String get settingsShareFolderDialogDescription =>
      'Ésta configuración corresponde al parametro \'share_folder\' en config.php. Ambos valores DEBEN ser idénticos\n\nPor favor, utiliza la misma carpeta que la configurada en config.php';

  @override
  String get settingsShareFolderPickerDescription =>
      'Por favor, utiliza la misma carpeta que la configurada en config.php. Toca en predeterminado si no tienes configurado éste parámetro';

  @override
  String get settingsPersonProviderTitle => 'Proveedor de personas';

  @override
  String get settingsServerAppSectionTitle => 'Usar apps del servidor';

  @override
  String get settingsPhotosDescription =>
      'Personaliza el contenido de la pestaña \'Fotos\'';

  @override
  String get settingsMemoriesRangeTitle => 'Rango de recuerdos';

  @override
  String settingsMemoriesRangeValueText(num range) {
    String _temp0 = intl.Intl.pluralLogic(
      range,
      locale: localeName,
      other: '+-$range días',
      one: '+-$range día',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeviceMediaTitle => 'Show device media';

  @override
  String get settingsDeviceMediaDescription =>
      'Selected folders will be displayed';

  @override
  String get settingsViewerTitle => 'Visualización';

  @override
  String get settingsViewerDescription =>
      'Personaliza la visualización de imágenes/vídeos';

  @override
  String get settingsScreenBrightnessTitle => 'Brillo de pantalla';

  @override
  String get settingsScreenBrightnessDescription =>
      'Establecer nivel de brillo al visualizar';

  @override
  String get settingsForceRotationTitle => 'Forzar rotación automática';

  @override
  String get settingsForceRotationDescription =>
      'Rotar pantalla aunque la auto-rotación esté desactivada en el sistema';

  @override
  String get settingsMapProviderTitle => 'Proveedor de mapas';

  @override
  String get settingsViewerCustomizeAppBarTitle =>
      'Personalizar barra de opciones';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle =>
      'Personalizar barra de opciones inferior';

  @override
  String get settingsShowDateInAlbumTitle => 'Agrupar fotos por fecha';

  @override
  String get settingsShowDateInAlbumDescription =>
      'Se aplica sólo cuando el álbum esté ordenado por fecha';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'Personalizar barra de navegación';

  @override
  String get settingsImageEditTitle => 'Editor';

  @override
  String get settingsImageEditDescription =>
      'Personaliza la edición y retoque de imágenes';

  @override
  String get settingsEnhanceMaxResolutionTitle2 =>
      'Resolución máxima al guardar retoques';

  @override
  String get settingsEnhanceMaxResolutionDescription =>
      'Las fotos con mayor resolución que la ajustada serán reducidas.\n\nLas fotos con resolución alta requerirán más memoria y tiempo para procesarlas. Reduce el valor de este ajuste si la aplicación se cuelga.';

  @override
  String get settingsImageEditSaveResultsToServerTitle =>
      'Guardar en el servidor';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      'Las imágenes editadas se guardarán en el servidor, pero si falla se guardarán en el dispositivo';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      'Las imágenes editadas se guardan en éste dispositivo';

  @override
  String get settingsThemeTitle => 'Apariencia';

  @override
  String get settingsThemeDescription => 'Personaliza la apariencia de la app';

  @override
  String get settingsFollowSystemThemeTitle => 'Tema del sistema';

  @override
  String get settingsSeedColorTitle => 'Color del tema';

  @override
  String get settingsSeedColorDescription =>
      'Usado para extrapolar todos los colores usados en la app';

  @override
  String get settingsSeedColorSystemColorDescription => 'Material You';

  @override
  String get settingsSeedColorPickerTitle => 'Elige un color';

  @override
  String get settingsThemePrimaryColor => 'Primario';

  @override
  String get settingsThemeSecondaryColor => 'Secundario';

  @override
  String get settingsThemePresets => 'Predefinidos';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel =>
      'Usar Material You';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Tema negro';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription =>
      'Usar negro puro cuando se activa el tema oscuro';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription =>
      'Usar gris cuando se activa el tema oscuro';

  @override
  String get settingsMiscellaneousTitle => 'Otros ajustes';

  @override
  String get settingsDoubleTapExitTitle => 'Tocar dos veces atrás para salir';

  @override
  String get settingsPhotosTabSortByNameTitle =>
      'Ordenar por nombre de archivo en \'Fotos\'';

  @override
  String get settingsAppLock => 'Bloquear la app';

  @override
  String get settingsAppLockTypeBiometric => 'Biométrico';

  @override
  String get settingsAppLockTypePin => 'PIN';

  @override
  String get settingsAppLockTypePassword => 'Contraseña';

  @override
  String get settingsAppLockDescription =>
      'Si se habilita, se te pedirá que te autentifiques cuando antes la aplicación. Esta función NO te protege contra ataques del mundo real.';

  @override
  String get settingsAppLockSetupBiometricFallbackDialogTitle =>
      'Elige otra opción cuando biométrico no está disponible';

  @override
  String get settingsAppLockSetupPinDialogTitle =>
      'Establece un PIN para desbloquear la aplicación';

  @override
  String get settingsAppLockConfirmPinDialogTitle =>
      'Introduce el mismo PIN otra vez';

  @override
  String get settingsAppLockSetupPasswordDialogTitle =>
      'Establece una contraseña para desbloquear la aplicación';

  @override
  String get settingsAppLockConfirmPasswordDialogTitle =>
      'Introduce la misma contraseña otra vez';

  @override
  String get settingsViewerUseOriginalImageTitle =>
      'Show original image instead of high quality preview in viewer';

  @override
  String get settingsExperimentalTitle => 'Experimental';

  @override
  String get settingsExperimentalDescription =>
      'Características que no están listas para uso diario';

  @override
  String get settingsExpertTitle => 'Avanzado';

  @override
  String get settingsExpertWarningText =>
      'Por favor asegúrate de que entiendes lo que hace cada opción antes de continuar.';

  @override
  String get settingsClearCacheDatabaseTitle =>
      'Limpiar base de datos de archivos.';

  @override
  String get settingsClearCacheDatabaseDescription =>
      'Limpia la información de archivos cacheados y realiza una resincronización completa con el servidor.';

  @override
  String get settingsClearCacheDatabaseSuccessNotification =>
      'Base de datos limpiada con éxito. Es recomendable que reinicies la aplicación.';

  @override
  String get settingsManageTrustedCertificateTitle =>
      'Administrar certificados de confianza';

  @override
  String get settingsUseNewHttpEngine => 'Usar nuevo motor HTTP';

  @override
  String get settingsUseNewHttpEngineDescription =>
      'El nuevo motor HTTP basado en Chromium, soporta nuevos estándares como HTTP/2* y HTTP/3 QUIC*.\n\nLimitaciones:\nYa no podemos administrar los certificados autofirmados. Debes importar tus certificados CA al almacén de confianza del sistema para que funcionen.\n\n* HTTPS requerido para HTTP/2 y HTTP/3 QUIC*.';

  @override
  String get settingsAboutSectionTitle => 'Acerca de';

  @override
  String get settingsVersionTitle => 'Versión';

  @override
  String get settingsServerVersionTitle => 'Servidor';

  @override
  String get settingsSourceCodeTitle => 'Código fuente';

  @override
  String get settingsBugReportTitle => 'Reportar fallos';

  @override
  String get settingsCaptureLogsTitle => 'Guardar registros';

  @override
  String get settingsCaptureLogsDescription =>
      'Ayuda al desarrollador a diagnosticar fallos';

  @override
  String get settingsTranslatorTitle => 'Traductor';

  @override
  String get settingsRestartNeededDialog =>
      'Por favor reinicia la aplicación para aplicar los cambios';

  @override
  String get writePreferenceFailureNotification =>
      'Error al establecer preferencia';

  @override
  String get enableButtonLabel => 'HABILITAR';

  @override
  String get enableButtonLabel2 => 'Enable';

  @override
  String get exifSupportNextcloud28Notes =>
      'El soporte para el lado del Cliente complementa a tu servidor. La aplicación procesará los archivos y atributos que Nextcloud no soporta';

  @override
  String get exifSupportConfirmationDialogTitle2 =>
      '¿Habilitar el soporte EXIF para el lado del Cliente?';

  @override
  String get captureLogDetails =>
      'Para guardar registros y reportar fallos:\n\n1. Habilita ésta opción\n2. Reproduce el fallo\n3. Desabilita ésta opción\n4. Busca nc-photos.log en la carpeta de descargas\n\n*Si el fallo provoca que la aplicación se cierre, no se puede guardar el registro. En ese caso, por favor contacta con el desarrollador para más instrucciones';

  @override
  String get captureLogSuccessNotification => 'Registros guargados';

  @override
  String get doneButtonLabel => 'LISTO';

  @override
  String get nextButtonLabel => 'SIGUIENTE';

  @override
  String get connectButtonLabel => 'CONECTAR';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      'Se incluirán todos tus archivos. Esto puede incrementar el uso de memoria y degradar el rendimiento.';

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
  String get detailsTooltip => 'Detalles';

  @override
  String get downloadTooltip => 'Descargar';

  @override
  String get downloadProcessingNotification => 'Descargando archivo';

  @override
  String get downloadSuccessNotification => 'Archivo descargado';

  @override
  String get downloadFailureNotification => 'Error al descargar';

  @override
  String get nextTooltip => 'Siguiente';

  @override
  String get previousTooltip => 'Anterior';

  @override
  String get webSelectRangeNotification =>
      'Mantén Shift + click para seleccionar todo entre medias';

  @override
  String get mobileSelectRangeNotification =>
      'Mantenga presionado otro elemento para seleccionar todo entre ellos';

  @override
  String get updateDateTimeDialogTitle => 'Modificar fecha y hora';

  @override
  String get dateSubtitle => 'Fecha';

  @override
  String get timeSubtitle => 'Hora';

  @override
  String get dateYearInputHint => 'Año';

  @override
  String get dateMonthInputHint => 'Mes';

  @override
  String get dateDayInputHint => 'Día';

  @override
  String get timeHourInputHint => 'Hora';

  @override
  String get timeMinuteInputHint => 'Minuto';

  @override
  String get timeSecondInputHint => 'Segundo';

  @override
  String get dateTimeInputInvalid => 'Valor inválido';

  @override
  String get updateDateTimeFailureNotification =>
      'Error al modificar fecha y hora';

  @override
  String get albumDirPickerHeaderText =>
      'Selecciona las carpetas a asociar con el álbum';

  @override
  String get albumDirPickerSubHeaderText =>
      'Sólo el contenido de las carpetas asociadas se incluirán en éste álbum';

  @override
  String get albumDirPickerListEmptyNotification =>
      'Por favor selecciona al menos una carpeta';

  @override
  String get importFoldersTooltip => 'Importar carpetas';

  @override
  String get albumImporterHeaderText => 'Importar carpetas como álbumes';

  @override
  String get albumImporterSubHeaderText =>
      'Las carpetas disponibles se muestran a continuación. Dependiendo de la cantidad de archivos en tu servidor, esto podría tardar un rato en terminar.';

  @override
  String get importButtonLabel => 'IMPORTAR';

  @override
  String get albumImporterProgressText => 'Importando carpetas';

  @override
  String get doneButtonTooltip => 'Listo';

  @override
  String get editTooltip => 'Editar';

  @override
  String get editAccountConflictFailureNotification =>
      'Ya existe una cuenta con los mismos ajustes';

  @override
  String get genericProcessingDialogContent => 'Por favor, espera';

  @override
  String get sortTooltip => 'Ordenar';

  @override
  String get sortOptionDialogTitle => 'Ordenar por';

  @override
  String get sortOptionTimeAscendingLabel => 'Antiguos primero';

  @override
  String get sortOptionTimeDescendingLabel => 'Nuevos primero';

  @override
  String get sortOptionFilenameAscendingLabel => 'Nombre de archivo';

  @override
  String get sortOptionFilenameDescendingLabel => 'Nombre de archivo (inverso)';

  @override
  String get sortOptionAlbumNameLabel => 'Nombre del álbum';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'Nombre del álbum (inverso)';

  @override
  String get sortOptionManualLabel => 'Manual';

  @override
  String get albumEditDragRearrangeNotification =>
      'Mantén presionado y arrastra un elemento para reordenarlo manualmente';

  @override
  String get albumAddTextTooltip => 'Añadir texto';

  @override
  String get shareTooltip => 'Compartir';

  @override
  String get shareSelectedEmptyNotification =>
      'Selecciona algunas fotos para compartir';

  @override
  String get shareDownloadingDialogContent => 'Descargando';

  @override
  String get searchTooltip => 'Buscar';

  @override
  String get clearTooltip => 'Limpiar';

  @override
  String get listNoResultsText => 'Sin resultados';

  @override
  String get listEmptyText => 'Vacío';

  @override
  String get albumTrashLabel => 'Papelera';

  @override
  String get restoreTooltip => 'Restaurar';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restaurando $count elementos',
      one: 'Restaurando 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification => 'Restaurados';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fallo al restaurar $count elementos',
      one: 'Fallo al restaurar 1 elemento',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Restaurando elemento';

  @override
  String get restoreSuccessNotification => 'Elemento restaurado';

  @override
  String get restoreFailureNotification => 'Error al restaurar elemento';

  @override
  String get deletePermanentlyTooltip => 'Borrar permanentemente';

  @override
  String get deletePermanentlyConfirmationDialogTitle =>
      'Borrar PERMANENTEMENTE';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      'Los elementos seleccionados se eliminarán permanentemente del servidor.\n\n¡Ésta acción es irreversible!';

  @override
  String get albumSharedLabel => 'Compartido';

  @override
  String get metadataTaskProcessingNotification =>
      'Procesando metadatos en segundo plano';

  @override
  String get configButtonLabel => 'CONFIGURAR';

  @override
  String get useAsAlbumCoverTooltip => 'Usar como portada';

  @override
  String get helpTooltip => 'Ayuda';

  @override
  String get helpButtonLabel => 'AYUDA';

  @override
  String get removeFromAlbumTooltip => 'Quitar del álbum';

  @override
  String get changelogTitle => 'Registro de cambios';

  @override
  String get serverCertErrorDialogTitle =>
      'No se puede confiar en el certificado del servidor';

  @override
  String get serverCertErrorDialogContent =>
      'El servidor podría ser hackeado o alguien podría robar su información';

  @override
  String get advancedButtonLabel => 'AVANZADO';

  @override
  String get whitelistCertDialogTitle =>
      '¿Poner en lista blanca certificado desconocido?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'Puedes poner en lista blanca el certificado para hacer que la aplicación lo acepte. ADVERTENCIA: Esto supone un gran riesgo de seguridad. Asegúrate de que el certificado está firmado por ti mismo o una entidad de confianza\n\nHost: $host\nFingerprint: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel =>
      'ASUMIR RIESGO Y AÑADIR A LISTA BLANCA';

  @override
  String get fileSharedByDescription => 'Compartido contigo por éste usuario';

  @override
  String get emptyTrashbinTooltip => 'Vaciar papelera';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Vaciar papelera';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      'Todos los elementos se eliminarán permanentemente del servidor.\n\nÉsta acción es irreversible';

  @override
  String get unsetAlbumCoverTooltip => 'Restablecer portada';

  @override
  String get muteTooltip => 'Silenciar';

  @override
  String get unmuteTooltip => 'Sonar';

  @override
  String get collectionPeopleLabel => 'Personas';

  @override
  String get slideshowTooltip => 'Presentación';

  @override
  String get slideshowSetupDialogTitle => 'Configurar diapositivas';

  @override
  String get slideshowSetupDialogDurationTitle => 'Duración por foto (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Al azar';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Repetir';

  @override
  String get slideshowSetupDialogReverseTitle => 'Orden inverso';

  @override
  String get linkCopiedNotification => 'Enlace copiado';

  @override
  String get shareMethodDialogTitle => 'Compartir como';

  @override
  String get shareMethodPreviewTitle => 'Imagen preliminar';

  @override
  String get shareMethodPreviewDescription =>
      'Compartir una versión de calidad reducida con otras apps (sólo para imágenes)';

  @override
  String get shareMethodOriginalFileTitle => 'Archivo original';

  @override
  String get shareMethodOriginalFileDescription =>
      'Descargar el archivo original y compartirlo con otras apps';

  @override
  String get shareMethodPublicLinkTitle => 'Enlace público';

  @override
  String get shareMethodPublicLinkDescription =>
      'Crea en el servidor un nuevo enlace público. Cualquiera con el enlace puede acceder al archivo';

  @override
  String get shareMethodPasswordLinkTitle => 'Enlace protegido con contraseña';

  @override
  String get shareMethodPasswordLinkDescription =>
      'Crea en el servidor un nuevo enlace protegido con contraseña';

  @override
  String get collectionSharingLabel => 'Compartiendo';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Compartido por última vez el $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user lo compartió contigo el $date';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user compartió el álbum contigo el $date';
  }

  @override
  String get sharedWithLabel => 'Compartido con';

  @override
  String get unshareTooltip => 'Dejar de compartir';

  @override
  String get unshareSuccessNotification => 'Has dejado de compartirlo';

  @override
  String get locationLabel => 'Ubicación';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloud no soporta compartir enlaces para múltiples archivos. La aplicación en su lugar COPIARÁ los archivos a una nueva carpeta y compartirá esa capeta.';

  @override
  String get folderNameInputHint => 'Nombre de la carpeta';

  @override
  String get folderNameInputInvalidEmpty =>
      'Introduce un nombre para la carpeta';

  @override
  String get folderNameInputInvalidCharacters =>
      'Contiene caracteres inválidos';

  @override
  String get createShareProgressText => 'Compartiendo';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Fallo al copiar $count items',
      one: 'Fallo al copiar 1 item',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => '¿Borrar carpeta?';

  @override
  String get unshareLinkShareDirDialogContent =>
      'Ésta carpeta fue creada por la app para compartir múltiples archivos en un enlace. Ya no se comparte con nadie, ¿quieres borrarla?';

  @override
  String get addToCollectionsViewTooltip => 'Añadir a colección';

  @override
  String get shareAlbumDialogTitle => 'Compartir con un usuario';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Álbum compartido con $user, pero algunos archivos fallaron al compartirlos';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'Álbum no compartido con $user, pero algunos archivos fallaron al dejar de compartirlos';
  }

  @override
  String get fixSharesTooltip => 'Reparar compartidos';

  @override
  String get fixTooltip => 'Reparar';

  @override
  String get fixAllTooltip => 'Reparar todo';

  @override
  String missingShareDescription(Object user) {
    return 'No compartido con $user';
  }

  @override
  String extraShareDescription(Object user) {
    return 'Compartido con $user';
  }

  @override
  String get defaultButtonLabel => 'PREDETERMINADO';

  @override
  String get addUserInputHint => 'Añadir usuario';

  @override
  String get sharedAlbumInfoDialogTitle =>
      'Presentación de álbumes compartidos';

  @override
  String get sharedAlbumInfoDialogContent =>
      'Álbumes compartidos permite a múltiples usuarios del mismo servidor acceder al mismo álbum. Por favor lee cuidadosamente las limitaciones antes de continuar';

  @override
  String get learnMoreButtonLabel => 'APRENDER MÁS';

  @override
  String get migrateDatabaseProcessingNotification =>
      'Actualizando base de datos';

  @override
  String get migrateDatabaseFailureNotification =>
      'Error al migrar base de datos';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'hace $count años',
      one: 'hace 1 año',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'Carpeta inicial no encontrada';

  @override
  String get homeFolderNotFoundDialogContent =>
      'Por favor corrige la URL WebDAV que se muestra abajo. Puedes encontrar la URL en la interfaz web de Nextcloud.';

  @override
  String get homeFolderInputInvalidEmpty =>
      'Por favor introduce el nombre de tu carpeta inicial';

  @override
  String get createCollectionTooltip => 'Nueva colección';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Álbum lado Cliente';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      'Álbum con características adicionales, accesible sólo con ésta aplicación';

  @override
  String get createCollectionDialogFolderLabel => 'Carpeta';

  @override
  String get createCollectionDialogFolderDescription =>
      'Muestra fotos de una carpeta';

  @override
  String get collectionFavoritesLabel => 'Favoritos';

  @override
  String get favoriteTooltip => 'Favorito';

  @override
  String get favoriteSuccessNotification => 'Añadido a favoritos';

  @override
  String get favoriteFailureNotification => 'Error al añadir a favoritos';

  @override
  String get unfavoriteTooltip => 'NO favorito';

  @override
  String get unfavoriteSuccessNotification => 'Quitado de favoritos';

  @override
  String get unfavoriteFailureNotification => 'Error al quitar de favoritos';

  @override
  String get createCollectionDialogTagLabel => 'Etiqueta';

  @override
  String get createCollectionDialogTagDescription =>
      'Muestra fotos con las etiquetas especificadas';

  @override
  String get addTagInputHint => 'Añadir etiqueta';

  @override
  String get tagPickerNoTagSelectedNotification =>
      'Por favor añade al menos 1 etiqueta';

  @override
  String get backgroundServiceStopping => 'Deteniendo servicio';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'Batería baja';

  @override
  String get enhanceTooltip => 'Retocar';

  @override
  String get enhanceButtonLabel => 'RETOCAR';

  @override
  String get enhanceIntroDialogTitle => 'Retoca tus fotos';

  @override
  String get enhanceIntroDialogDescription =>
      'Tus fotos son procesadas localmente en tu dispositivo. Por defecto, son reducidas a 2048x1536. Puedes ajustar la resolución de guardado en Ajustes>Editor';

  @override
  String get enhanceLowLightTitle => 'Mejorar poca luz';

  @override
  String get enhanceLowLightDescription =>
      'Ilumina tu foto tomada en entornos oscuros';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Iluminación';

  @override
  String get collectionEditedPhotosLabel => 'Editado (local)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      'Las fotos seleccionadas se eliminarán permanentemente del dispositivo.\n\nÉsta acción es irreversible';

  @override
  String get enhancePortraitBlurTitle => 'Desenfoque de retrato';

  @override
  String get enhancePortraitBlurDescription =>
      'Desenfoca el fondo de tu foto. Obtendrás mejores resultados en retratos';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Desenfoque';

  @override
  String get enhanceSuperResolution4xTitle => 'Super-resolución (4x)';

  @override
  String get enhanceSuperResolution4xDescription =>
      'Incrementa 4 veces la resolución original de tu foto (mira la ayuda para saber cómo se aplica la máxima resolución)';

  @override
  String get enhanceStyleTransferTitle => 'Fusionar estilo';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Elige un estilo';

  @override
  String get enhanceStyleTransferStyleDialogDescription =>
      'Transfiere a tu foto el estilo de una imagen elegida';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification =>
      'Por favor, elige un estilo';

  @override
  String get enhanceColorPopTitle => 'Resaltar color';

  @override
  String get enhanceColorPopDescription =>
      'Reduce la saturación del fondo de tu foto. Obtendrás mejores resultados en retratos';

  @override
  String get enhanceGenericParamWeightLabel => 'Intensidad';

  @override
  String get enhanceRetouchTitle => 'Auto retoque';

  @override
  String get enhanceRetouchDescription =>
      'Retoca tu foto automáticamente. Mejora el color y el estado general';

  @override
  String get doubleTapExitNotification => 'Toca otra vez para salir';

  @override
  String get imageEditDiscardDialogTitle => '¿Descartar cambios?';

  @override
  String get imageEditDiscardDialogContent => 'Tus cambios no están guardados';

  @override
  String get discardButtonLabel => 'DESCARTAR';

  @override
  String get saveTooltip => 'Guardar';

  @override
  String get imageEditDownloadDialogTitle => 'Downloading image from server...';

  @override
  String get imageEditProcessDialogTitle => 'Processing image...';

  @override
  String get imageEditSaveDialogTitle => 'Saving result...';

  @override
  String get imageEditColorBrightness => 'Brillo';

  @override
  String get imageEditColorContrast => 'Contraste';

  @override
  String get imageEditColorWhitePoint => 'Blancos';

  @override
  String get imageEditColorBlackPoint => 'Negros';

  @override
  String get imageEditColorSaturation => 'Saturación';

  @override
  String get imageEditColorWarmth => 'Temperatura';

  @override
  String get imageEditColorTint => 'Tinte';

  @override
  String get imageEditTitle => 'Editar imagen';

  @override
  String get imageEditToolbarColorLabel => 'Color';

  @override
  String get imageEditToolbarTransformLabel => 'Transformar';

  @override
  String get imageEditTransformOrientation => 'Orientación';

  @override
  String get imageEditTransformOrientationClockwise => 'dcha';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'izq';

  @override
  String get imageEditTransformCrop => 'Recortar';

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
  String get categoriesLabel => 'Categorías';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      'Toca ajustes para elegir un proveedor o ayuda para aprender más';

  @override
  String get searchLandingCategoryVideosLabel => 'Vídeos';

  @override
  String get searchFilterButtonLabel => 'FILTROS';

  @override
  String get searchFilterDialogTitle => 'Filtros de búsqueda';

  @override
  String get applyButtonLabel => 'APLICAR';

  @override
  String get searchFilterOptionAnyLabel => 'Cualquiera';

  @override
  String get searchFilterOptionTrueLabel => 'Si';

  @override
  String get searchFilterOptionFalseLabel => 'No';

  @override
  String get searchFilterTypeLabel => 'Tipo';

  @override
  String get searchFilterTypeOptionImageLabel => 'Imagen';

  @override
  String get searchFilterBubbleTypeImageText => 'imágenes';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Vídeo';

  @override
  String get searchFilterBubbleTypeVideoText => 'vídeos';

  @override
  String get searchFilterFavoriteLabel => 'Favorito';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'favoritos';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'no favoritos';

  @override
  String get showAllButtonLabel => 'MOSTRAR TODO';

  @override
  String gpsPlaceText(Object place) {
    return 'Cerca de $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'Acerca de lugares';

  @override
  String get gpsPlaceAboutDialogContent =>
      'Los lugares mostrados aquí sólo son una estimación y no garantizan ninguna precisión.';

  @override
  String get collectionPlacesLabel => 'Lugares';

  @override
  String get imageSaveOptionDialogTitle => 'Ubicación de las ediciones';

  @override
  String get imageSaveOptionDialogContent =>
      'Selecciona dónde guardar ésta y las futuras imágenes. Si eliges Servidor y la app falla al subirlo, se guardará en el dispositivo.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'DISPOSITIVO';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'SERVIDOR';

  @override
  String get initialSyncMessage =>
      'Sincronizando con tu servidor por primera vez';

  @override
  String get loopTooltip => 'Bucle';

  @override
  String get createCollectionFailureNotification => 'Error al crear colección';

  @override
  String get addItemToCollectionTooltip => 'Añadir a colección';

  @override
  String get addItemToCollectionFailureNotification =>
      'Error al añadir a colección';

  @override
  String get setCollectionCoverFailureNotification =>
      'Error al establecer portada de colección';

  @override
  String get exportCollectionTooltip => 'Exportar';

  @override
  String get exportCollectionDialogTitle => 'Exportar colección';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 =>
      'Álbum lado Servidor';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 =>
      'Crea un álbum en tu servidor, accesible con cualquier aplicación.';

  @override
  String get removeCollectionsFailedNotification =>
      'Error al quitar algunas colecciones';

  @override
  String get accountSettingsTooltip => 'Configurar cuenta';

  @override
  String get contributorsTooltip => 'Contribuidores';

  @override
  String get setAsTooltip => 'Establecer como';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return 'Estás a punto de cerrar sesión en $server';
  }

  @override
  String get appLockUnlockHint => 'Desbloquear la app';

  @override
  String get appLockUnlockWrongPassword => 'Contraseña incorrecta';

  @override
  String get enabledText => 'Habilitado';

  @override
  String get disabledText => 'Deshabilitado';

  @override
  String get trustedCertManagerPageTitle => 'Certificados de confianza';

  @override
  String get trustedCertManagerAlreadyTrustedError => 'Ya confiables';

  @override
  String get trustedCertManagerSelectServer => 'Selecciona el servidor HTTPS';

  @override
  String get trustedCertManagerNoHttpsServerError =>
      'No hay servidores disponibles';

  @override
  String get trustedCertManagerFailedToRemoveCertError =>
      'Fallo al quitar certificado';

  @override
  String get missingVideoThumbnailHelpDialogTitle =>
      '¿Problemas con las miniaturas de vídeos?';

  @override
  String get dontShowAgain => 'No mostrar otra vez';

  @override
  String get mapBrowserDateRangeLabel => 'Rango de fechas';

  @override
  String get mapBrowserDateRangeThisMonth => 'Este mes';

  @override
  String get mapBrowserDateRangePrevMonth => 'El mes pasado';

  @override
  String get mapBrowserDateRangeThisYear => 'Este año';

  @override
  String get mapBrowserDateRangeCustom => 'Personalizado';

  @override
  String get homeTabMapBrowser => 'Mapa';

  @override
  String get mapBrowserSetDefaultDateRangeButton => 'Usar por defecto';

  @override
  String get todayText => 'Hoy';

  @override
  String get livePhotoTooltip => 'Live photo';

  @override
  String get dragAndDropRearrangeButtons =>
      'Arrastra y suelta para reordenar los botones';

  @override
  String get customizeCollectionsNavBarDescription =>
      'Arrastra y suelta para reordenar los botones, toca cada botón para minimizarlo';

  @override
  String get customizeButtonsUnsupportedWarning =>
      'Este botón no se puede personalizar';

  @override
  String get placePickerTitle => 'Elige un lugar';

  @override
  String get albumAddMapTooltip => 'Añadir mapa';

  @override
  String get fileNotFound => 'Archivo no encontrado';

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
      'No estás autentificado. Por favor inicia sesión otra vez si el problema continúa.';

  @override
  String get errorDisconnected =>
      'No se pudo conectar. El servidor no está en línea o tu dispositivo está desconectado.';

  @override
  String get errorLocked =>
      'Archivo bloqueado en el servidor. Inténtalo de nuevo más tarde.';

  @override
  String get errorInvalidBaseUrl =>
      'No se pudo comunicar. Asegúrate que la dirección es la URL base de tu Nextcloud.';

  @override
  String get errorWrongPassword =>
      'No se pudo autentificar. Verifica tu usuario y contraseña.';

  @override
  String get errorServerError =>
      'Error del servidor. Asegúrate que el servidor está configurado correctamente.';

  @override
  String get errorAlbumDowngrade =>
      'No puede modificarse este álbum ya que fue creado por una versión más reciente de esta app. Por favor, actualiza la app e inténtalo de nuevo.';

  @override
  String get errorNoStoragePermission =>
      'Se requiere permiso de acceso al almacenamiento';

  @override
  String get errorServerNoCert =>
      'Server certificate not found. Try HTTP instead?';
}
