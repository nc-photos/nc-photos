// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Фото';

  @override
  String get translator => 'kvasenok\nmeixnt & eriane\nRandomRoot';

  @override
  String get photosTabLabel => 'Фото';

  @override
  String get collectionsTooltip => 'Альбомы';

  @override
  String get zoomTooltip => 'Размер миниатюр';

  @override
  String get settingsMenuLabel => 'Настройки';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Выбрано $count фото',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Удаление $count фото',
      one: 'Удаление фото',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification => 'Выбранные фото перемещены в корзину';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не удалось удалить $count фото',
      one: 'Не удалось удалить фото',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Отправить в архив';

  @override
  String get archiveSelectedSuccessNotification => 'Выбранные фото отправлены в архив';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не удалось отправить $count фото в архив',
      one: 'Не удалось отправить фото в архив',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Вернуть из архива';

  @override
  String get unarchiveSelectedSuccessNotification => 'Выбранные фото возвращены из архива';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не удалось вернуть $count фото из архива',
      one: 'Не удалось вернуть фото из архива',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Удалить';

  @override
  String get deleteSuccessNotification => 'Файл удалён';

  @override
  String get deleteFailureNotification => 'Не удалось удалить файл';

  @override
  String get removeSelectedFromAlbumFailureNotification => 'Не удалось убрать фото из альбома';

  @override
  String get addServerTooltip => 'Добавить сервер';

  @override
  String removeServerSuccessNotification(Object server) {
    return 'Сервер $server удалён';
  }

  @override
  String get createAlbumTooltip => 'Новый альбом';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count фото',
      one: '1 фото',
      zero: 'Пустой',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Архив';

  @override
  String connectingToServer(Object server) {
    return 'Подключение к серверу\n$server';
  }

  @override
  String get connectingToServer2 => 'Ожидание ответа от сервера';

  @override
  String get connectingToServerInstruction => 'Пожалуйста, авторизуйтесь через браузер';

  @override
  String get nameInputHint => 'Название альбома';

  @override
  String get nameInputInvalidEmpty => 'Введите название';

  @override
  String get skipButtonLabel => 'ПРОПУСТИТЬ';

  @override
  String get confirmButtonLabel => 'ПОДТВЕРДИТЬ';

  @override
  String get signInHeaderText => 'Войти на сервер Nextcloud';

  @override
  String get signIn2faHintText => 'Воспользуйтесь паролем приложения, если на сервере действует двухфакторная аутентификация';

  @override
  String get signInHeaderText2 => 'Nextcloud\nВход';

  @override
  String get serverAddressInputHint => 'Адрес сервера';

  @override
  String get serverAddressInputInvalidEmpty => 'Укажите адрес сервера';

  @override
  String get usernameInputHint => 'Логин';

  @override
  String get usernameInputInvalidEmpty => 'Введите логин';

  @override
  String get passwordInputHint => 'Пароль';

  @override
  String get passwordInputInvalidEmpty => 'Введите пароль';

  @override
  String get rootPickerHeaderText => 'Выберите папки с фотографиями';

  @override
  String get rootPickerSubHeaderText => 'Будут отображаться фото, содержащиеся только в указанных папках. Нажмите Пропустить, чтобы выбрать все';

  @override
  String get rootPickerNavigateUpItemText => '(назад)';

  @override
  String get rootPickerUnpickFailureNotification => 'Не удалось исключить папку';

  @override
  String get rootPickerListEmptyNotification => 'Выберите хотя бы одну папку или нажмите Пропустить, чтобы выбрать все';

  @override
  String get setupWidgetTitle => 'Начнём!';

  @override
  String get setupSettingsModifyLaterHint => 'Вы можете изменить это позже в настройках';

  @override
  String get setupHiddenPrefDirNoticeDetail => 'Это приложение создаёт папку для хранения настроек на сервере Nextcloud. Не удаляйте и не изменяйте её содержимое, пока используете приложение';

  @override
  String get settingsWidgetTitle => 'Настройки';

  @override
  String get settingsLanguageTitle => 'Язык';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => 'По умолчанию';

  @override
  String get settingsMetadataTitle => 'Метаданные файла';

  @override
  String get settingsExifSupportTitle2 => 'Client-side EXIF support';

  @override
  String get settingsExifSupportTrueSubtitle => 'Повышенный расход трафика';

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
  String get settingsMemoriesTitle => 'Воспоминания';

  @override
  String get settingsMemoriesSubtitle => 'Показывать фото, сделанные в прошлом';

  @override
  String get settingsAccountTitle => 'Учётная запись';

  @override
  String get settingsAccountLabelTitle => 'Ярлык';

  @override
  String get settingsAccountLabelDescription => 'Установить текст, который будет отображаться вместо URL-адреса сервера';

  @override
  String get settingsIncludedFoldersTitle => 'Выбранные папки';

  @override
  String get settingsShareFolderTitle => 'Общая папка';

  @override
  String get settingsShareFolderDialogTitle => 'Выберите общую папку';

  @override
  String get settingsShareFolderDialogDescription => 'Эта настройка соответствует параметру share_folder в config.php. Эти два значения ДОЛЖНЫ быть одинаковыми.\n\nВыберите ту же папку, которая указана в файле config.php.';

  @override
  String get settingsShareFolderPickerDescription => 'Выберите ту же папку, которая указана в файле config.php. Нажмите кнопку по умолчанию, если вы не задавали этот параметр.';

  @override
  String get settingsPersonProviderTitle => 'Провайдер распознавания лиц';

  @override
  String get settingsServerAppSectionTitle => 'Поддержка серверных приложений';

  @override
  String get settingsPhotosDescription => 'Настройка содержимого, отображаемого на вкладке Фото';

  @override
  String get settingsMemoriesRangeTitle => 'Диапазон воспоминаний';

  @override
  String settingsMemoriesRangeValueText(num range) {
    String _temp0 = intl.Intl.pluralLogic(
      range,
      locale: localeName,
      other: '+-$range дней',
      one: '+-$range день',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeviceMediaTitle => 'Show device media';

  @override
  String get settingsDeviceMediaDescription => 'Selected folders will be displayed';

  @override
  String get settingsViewerTitle => 'Просмотр';

  @override
  String get settingsViewerDescription => 'Настройки просмотра фото/видео';

  @override
  String get settingsScreenBrightnessTitle => 'Яркость экрана';

  @override
  String get settingsScreenBrightnessDescription => 'Настройка яркости экрана независимо от системных настроек';

  @override
  String get settingsForceRotationTitle => 'Игнорировать блокировку поворота экрана';

  @override
  String get settingsForceRotationDescription => 'Поворачивать экран даже если выключен автоповорот';

  @override
  String get settingsMapProviderTitle => 'Постащик карт';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'Customize app bar';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle => 'Customize bottom app bar';

  @override
  String get settingsShowDateInAlbumTitle => 'Группировать фото по дате';

  @override
  String get settingsShowDateInAlbumDescription => 'Применяется только в том случае, если альбом отсортирован по времени';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle => 'Customize navigation bar';

  @override
  String get settingsImageEditTitle => 'Редактор';

  @override
  String get settingsImageEditDescription => 'Настроить параметры улучшений и редактора изображений';

  @override
  String get settingsEnhanceMaxResolutionTitle2 => 'Разрешение изображения для улучшений';

  @override
  String get settingsEnhanceMaxResolutionDescription => 'Фотографии, размер которых превышает выбранное разрешение, будут уменьшены.\n\nДля обработки фотографий высокого разрешения требуется значительно больше памяти и времени. Уменьшите этот параметр, если при улучшении фотографий произошел сбой приложения.';

  @override
  String get settingsImageEditSaveResultsToServerTitle => 'Сохранить результат на сервер';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription => 'Результаты сохраняются на сервере, а в случае неудачи - на устройстве';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription => 'Результаты сохраняются на этом устройстве';

  @override
  String get settingsThemeTitle => 'Оформление';

  @override
  String get settingsThemeDescription => 'Настройки внешнего вида приложения';

  @override
  String get settingsFollowSystemThemeTitle => 'Использовать системные настройки';

  @override
  String get settingsSeedColorTitle => 'Цвет темы';

  @override
  String get settingsSeedColorDescription => 'Для получения всех цветов, используемых в приложении';

  @override
  String get settingsSeedColorSystemColorDescription => 'Использовать цвет системы';

  @override
  String get settingsSeedColorPickerTitle => 'Выберите цвет';

  @override
  String get settingsThemePrimaryColor => 'Primary';

  @override
  String get settingsThemeSecondaryColor => 'Secondary';

  @override
  String get settingsThemePresets => 'Presets';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel => 'ИСПОЛЬЗОВАТЬ ЦВЕТ СИСТЕМЫ';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Тёмная тема';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription => 'Чёрный';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription => 'Тёмно-серый';

  @override
  String get settingsMiscellaneousTitle => 'Разное';

  @override
  String get settingsDoubleTapExitTitle => 'Двойной тап для выхода';

  @override
  String get settingsPhotosTabSortByNameTitle => 'Сортировка по имени в Фото';

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
  String get settingsExperimentalTitle => 'Экспериментальные';

  @override
  String get settingsExperimentalDescription => 'Функции, которые не готовы к повседневному использованию';

  @override
  String get settingsExpertTitle => 'Расширенные';

  @override
  String get settingsExpertWarningText => 'Прежде чем приступить к работе, убедитесь, что вы полностью понимаете, что делает каждый параметр';

  @override
  String get settingsClearCacheDatabaseTitle => 'Очистить базу данных файлов';

  @override
  String get settingsClearCacheDatabaseDescription => 'Очистить кэш и запустить полную синхронизацию с сервером';

  @override
  String get settingsClearCacheDatabaseSuccessNotification => 'База данных успешно очищена. Пожалуйста, перезапустите приложение';

  @override
  String get settingsManageTrustedCertificateTitle => 'Manage trusted certificates';

  @override
  String get settingsUseNewHttpEngine => 'Use new HTTP engine';

  @override
  String get settingsUseNewHttpEngineDescription => 'New HTTP engine based on Chromium, supporting new standards like HTTP/2* and HTTP/3 QUIC*.\n\nLimitations:\nSelf-signed certs can no longer be managed by us. You must import your CA certs to the system trust store for them to work.\n\n* HTTPS is required for HTTP/2 and HTTP/3';

  @override
  String get settingsAboutSectionTitle => 'О программе';

  @override
  String get settingsVersionTitle => 'Версия';

  @override
  String get settingsServerVersionTitle => 'Сервер';

  @override
  String get settingsSourceCodeTitle => 'Исходный код';

  @override
  String get settingsBugReportTitle => 'Сообщить о проблеме';

  @override
  String get settingsCaptureLogsTitle => 'Собирать логи';

  @override
  String get settingsCaptureLogsDescription => 'Помощь разработчику в диагностике ошибок';

  @override
  String get settingsTranslatorTitle => 'Переводчик';

  @override
  String get settingsRestartNeededDialog => 'Please restart the app to apply changes';

  @override
  String get writePreferenceFailureNotification => 'Не удалось сохранить настройки';

  @override
  String get enableButtonLabel => 'ВКЛЮЧИТЬ';

  @override
  String get enableButtonLabel2 => 'Enable';

  @override
  String get exifSupportNextcloud28Notes => 'Client-side support complements your server. The app will process files and attributes not supported by Nextcloud';

  @override
  String get exifSupportConfirmationDialogTitle2 => 'Enable client-side EXIF support?';

  @override
  String get captureLogDetails => 'Чтобы собрать логи для отправки отчета об ошибке:\n\n1. Включите эту настройку\n2. Воспроизведите проблему\n3. Отключите эту настройку\n4. Найдите файл nc-photos.log в папке загрузки\n\n*Если проблема привела к аварийному завершению работы приложения, логи собрать не удастся. В этом случае, пожалуйста, свяжитесь с разработчиком для получения дальнейших инструкций.';

  @override
  String get captureLogSuccessNotification => 'Логи успешно сохранены';

  @override
  String get doneButtonLabel => 'ЗАВЕРШИТЬ';

  @override
  String get nextButtonLabel => 'ДАЛЕЕ';

  @override
  String get connectButtonLabel => 'ПОДКЛЮЧИТЬСЯ';

  @override
  String get rootPickerSkipConfirmationDialogContent2 => 'Будут добавлены все ваши файлы. Это может увеличить использование памяти и снизить производительность';

  @override
  String megapixelCount(Object count) {
    return '$count Мп';
  }

  @override
  String secondCountSymbol(Object count) {
    return '$count с';
  }

  @override
  String millimeterCountSymbol(Object count) {
    return '$count мм';
  }

  @override
  String get detailsTooltip => 'Подробности';

  @override
  String get downloadTooltip => 'Скачать';

  @override
  String get downloadProcessingNotification => 'Скачивание файла';

  @override
  String get downloadSuccessNotification => 'Файл скачан';

  @override
  String get downloadFailureNotification => 'Не удалось скачать файл';

  @override
  String get nextTooltip => 'Далее';

  @override
  String get previousTooltip => 'Назад';

  @override
  String get webSelectRangeNotification => 'Кликните мышью, зажав Shift, чтобы выбрать несколько объектов';

  @override
  String get mobileSelectRangeNotification => 'Длительным нажатием на второй объект можно выбрать все остальные между ним и первым';

  @override
  String get updateDateTimeDialogTitle => 'Изменить время и дату';

  @override
  String get dateSubtitle => 'Дата';

  @override
  String get timeSubtitle => 'Время';

  @override
  String get dateYearInputHint => 'Год';

  @override
  String get dateMonthInputHint => 'Месяц';

  @override
  String get dateDayInputHint => 'День';

  @override
  String get timeHourInputHint => 'Час';

  @override
  String get timeMinuteInputHint => 'Минута';

  @override
  String get timeSecondInputHint => 'Секунда';

  @override
  String get dateTimeInputInvalid => 'Некорректное значение';

  @override
  String get updateDateTimeFailureNotification => 'Не удалось изменить время и дату';

  @override
  String get albumDirPickerHeaderText => 'Выберите папки, которые нужно связать с альбомом';

  @override
  String get albumDirPickerSubHeaderText => 'Будут отображаться фото, содержащиеся только в указанных папках';

  @override
  String get albumDirPickerListEmptyNotification => 'Выберите хотя бы одну папку';

  @override
  String get importFoldersTooltip => 'Импорт папки';

  @override
  String get albumImporterHeaderText => 'Импорт папок в виде альбомов';

  @override
  String get albumImporterSubHeaderText => 'Доступные для импорта папки перечислены ниже. В зависимости от количества файлов, процесс может занять продолжительное время';

  @override
  String get importButtonLabel => 'ИМПОРТ';

  @override
  String get albumImporterProgressText => 'Importing folders';

  @override
  String get doneButtonTooltip => 'Завершить';

  @override
  String get editTooltip => 'Редактирование';

  @override
  String get editAccountConflictFailureNotification => 'Запись с такими настройками уже существует';

  @override
  String get genericProcessingDialogContent => 'Пожалуйста, подождите';

  @override
  String get sortTooltip => 'Сортировка';

  @override
  String get sortOptionDialogTitle => 'Сортировка';

  @override
  String get sortOptionTimeAscendingLabel => 'Сначала старые';

  @override
  String get sortOptionTimeDescendingLabel => 'Сначала новые';

  @override
  String get sortOptionFilenameAscendingLabel => 'Имя';

  @override
  String get sortOptionFilenameDescendingLabel => 'Имя (по убыванию)';

  @override
  String get sortOptionAlbumNameLabel => 'Название альбома';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'Название альбома (в обратном порядке)';

  @override
  String get sortOptionManualLabel => 'Вручную';

  @override
  String get albumEditDragRearrangeNotification => 'Удерживайте, а затем перетаскивайте фото, чтобы упорядочить их вручную';

  @override
  String get albumAddTextTooltip => 'Добавить текст';

  @override
  String get shareTooltip => 'Поделиться';

  @override
  String get shareSelectedEmptyNotification => 'Выберите фотографии, чтобы поделиться';

  @override
  String get shareDownloadingDialogContent => 'Загрузка';

  @override
  String get searchTooltip => 'Поиск';

  @override
  String get clearTooltip => 'Очистить';

  @override
  String get listNoResultsText => 'Ничего не найдено';

  @override
  String get listEmptyText => 'Ничего нет';

  @override
  String get albumTrashLabel => 'Корзина';

  @override
  String get restoreTooltip => 'Восстановить';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Восстановление $count фото',
      one: 'Восстановление 1 фото',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification => 'Выбранные фото восстановлены';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не удалось восстановить $count фото',
      one: 'Не удалось восстановить 1 фото',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Восстановить';

  @override
  String get restoreSuccessNotification => 'Файл восстановлен';

  @override
  String get restoreFailureNotification => 'Не удалось восстановить файл';

  @override
  String get deletePermanentlyTooltip => 'Удалить окончательно';

  @override
  String get deletePermanentlyConfirmationDialogTitle => 'Окончательное удаление';

  @override
  String get deletePermanentlyConfirmationDialogContent => 'Выбранные файлы будут навсегда удалены с сервера.\n\nЭто необратимое действие';

  @override
  String get albumSharedLabel => 'Общий доступ';

  @override
  String get metadataTaskProcessingNotification => 'Обрабатываются метаданные изображений';

  @override
  String get configButtonLabel => 'НАСТРОЙКИ';

  @override
  String get useAsAlbumCoverTooltip => 'Использовать как обложку альбома';

  @override
  String get helpTooltip => 'Справка';

  @override
  String get helpButtonLabel => 'СПРАВКА';

  @override
  String get removeFromAlbumTooltip => 'Убрать из альбома';

  @override
  String get changelogTitle => 'Список изменений';

  @override
  String get serverCertErrorDialogTitle => 'Недоверенный сертификат сервера';

  @override
  String get serverCertErrorDialogContent => 'Возможно, сервер взломан или злоумышленники пытаются похитить ваши данные.';

  @override
  String get advancedButtonLabel => 'ДОПОЛНИТЕЛЬНО';

  @override
  String get whitelistCertDialogTitle => 'Всё равно доверять этому сертификату?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'Вы можете добавить этот сертификат в список исключений. ВНИМАНИЕ: Это значительное изменение в системе безопасности. Убедитесь, что это сертификат, подписанный вами или доверенной стороной\n\nСервер: $host\nОтпечаток сертификата: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel => 'ДОВЕРЯТЬ ЭТОМУ СЕРТИФИКАТУ';

  @override
  String get fileSharedByDescription => 'Поделился пользователь';

  @override
  String get emptyTrashbinTooltip => 'Очистить корзину';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Очистить корзину?';

  @override
  String get emptyTrashbinConfirmationDialogContent => 'Выбранные файлы будут навсегда удалены с сервера.\n\nЭто действие необратимо';

  @override
  String get unsetAlbumCoverTooltip => 'Сбросить обложку альбома';

  @override
  String get muteTooltip => 'Убрать звук';

  @override
  String get unmuteTooltip => 'Включить звук';

  @override
  String get collectionPeopleLabel => 'Люди';

  @override
  String get slideshowTooltip => 'Слайд-шоу';

  @override
  String get slideshowSetupDialogTitle => 'Настройка слайд-шоу';

  @override
  String get slideshowSetupDialogDurationTitle => 'Длительность показа изображения (ММ:СС)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Перемешать';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Повтор';

  @override
  String get slideshowSetupDialogReverseTitle => 'Обратный';

  @override
  String get linkCopiedNotification => 'Ссылка скопирована';

  @override
  String get shareMethodDialogTitle => 'Поделиться как';

  @override
  String get shareMethodPreviewTitle => 'Предпросмотр';

  @override
  String get shareMethodPreviewDescription => 'Передавать другим приложениям предпросмотр с низким качеством (только фото)';

  @override
  String get shareMethodOriginalFileTitle => 'Исходный файл';

  @override
  String get shareMethodOriginalFileDescription => 'Загрузить исходный файл и передать его другим приложениям';

  @override
  String get shareMethodPublicLinkTitle => 'Общедоступная ссылка';

  @override
  String get shareMethodPublicLinkDescription => 'Создайте новую общедоступную ссылку на сервере. Любой человек, имеющий доступ к ссылке, сможет получить доступ к файлу';

  @override
  String get shareMethodPasswordLinkTitle => 'Ссылка с защитой паролем';

  @override
  String get shareMethodPasswordLinkDescription => 'Создайте на сервере новую ссылку, защищенную паролем';

  @override
  String get collectionSharingLabel => 'Общий доступ';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Общий доступ предоставлен $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user предоставил(а) доступ $date';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user предоставил(а) доступ к альбому $date';
  }

  @override
  String get sharedWithLabel => 'Общий доступ предоставлен';

  @override
  String get unshareTooltip => 'Отменить общий доступ';

  @override
  String get unshareSuccessNotification => 'Общий доступ отменен';

  @override
  String get locationLabel => 'Расположение';

  @override
  String get multipleFilesLinkShareDialogContent => 'Nextcloud не поддерживает ссылки общего доступа для нескольких файлов. Вместо этого приложение скопирует файлы в новую папку и предоставит общий доступ к этой папке.';

  @override
  String get folderNameInputHint => 'Имя папки';

  @override
  String get folderNameInputInvalidEmpty => 'Введите имя папки';

  @override
  String get folderNameInputInvalidCharacters => 'Содержит недопустимые символы';

  @override
  String get createShareProgressText => 'Предоставление общего доступа';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Не удалось скопировать $count элементов',
      few: 'Не удалось скопировать $count элемента',
      one: 'Не удалось скопировать $count элемент',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Удалить папку?';

  @override
  String get unshareLinkShareDirDialogContent => 'Эта папка была создана предоставления общего доступа к нескольким файлами в виде ссылки. Теперь она больше не используется для общего доступа с другими пользователями, хотите удалить эту папку?';

  @override
  String get addToCollectionsViewTooltip => 'Добавить в коллекцию';

  @override
  String get shareAlbumDialogTitle => 'Предоставить общий доступ пользователю';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Ползователю $user предоставлен общий доступ к альбому, но не удалось предоставить общий доступ к некоторым файлам';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'У ползователя $user отозван общий доступ к альбому, но не удалось отозвать общий доступ к некоторым файлам';
  }

  @override
  String get fixSharesTooltip => 'Исправить общий доступ';

  @override
  String get fixTooltip => 'Исправить';

  @override
  String get fixAllTooltip => 'Исправить всё';

  @override
  String missingShareDescription(Object user) {
    return 'У пользователя $user нет общего доступа к файлу';
  }

  @override
  String extraShareDescription(Object user) {
    return 'У пользователя $user есть общий доступ к файлу';
  }

  @override
  String get defaultButtonLabel => 'ПО УМОЛЧАНИЮ';

  @override
  String get addUserInputHint => 'Добавить пользователя';

  @override
  String get sharedAlbumInfoDialogTitle => 'Представляем общий доступ к альбомам';

  @override
  String get sharedAlbumInfoDialogContent => 'Общий доступ к альбому позволяет нескольким пользователям на одном сервере получить доступ к одному и тому же альбому. Пожалуйста, внимательно ознакомьтесь с ограничениями, прежде чем продолжить';

  @override
  String get learnMoreButtonLabel => 'УЗНАТЬ БОЛЬШЕ';

  @override
  String get migrateDatabaseProcessingNotification => 'Обновление базы данных';

  @override
  String get migrateDatabaseFailureNotification => 'Не удалось перенести базу данных';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count лет назад',
      few: '2 года назад',
      one: '1 год назад',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'Домашняя папка не найдена';

  @override
  String get homeFolderNotFoundDialogContent => 'Исправьте URL-адрес WebDAV, показанный ниже. URL можно найти в веб-интерфейсе Nextcloud.';

  @override
  String get homeFolderInputInvalidEmpty => 'Введите имя домашней папки';

  @override
  String get createCollectionTooltip => 'Новая коллекция';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Client-side album';

  @override
  String get createCollectionDialogAlbumDescription2 => 'Album with extra features, accessible only with this app';

  @override
  String get createCollectionDialogFolderLabel => 'Папка';

  @override
  String get createCollectionDialogFolderDescription => 'Показать фото внутри папки';

  @override
  String get collectionFavoritesLabel => 'Избранное';

  @override
  String get favoriteTooltip => 'Добавить в избранное';

  @override
  String get favoriteSuccessNotification => 'Добавлено в избранное';

  @override
  String get favoriteFailureNotification => 'Не удалось добавить в избранное';

  @override
  String get unfavoriteTooltip => 'Удалить из избранного';

  @override
  String get unfavoriteSuccessNotification => 'Удалено из избранного';

  @override
  String get unfavoriteFailureNotification => 'Не удалось удалить из избранного';

  @override
  String get createCollectionDialogTagLabel => 'Тэг';

  @override
  String get createCollectionDialogTagDescription => 'Показать фото с определенными тегами';

  @override
  String get addTagInputHint => 'Добавить тэг';

  @override
  String get tagPickerNoTagSelectedNotification => 'Добавьте хотя бы 1 тег';

  @override
  String get backgroundServiceStopping => 'Остановка службы';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'Батарея разряжена';

  @override
  String get enhanceTooltip => 'Улучшить';

  @override
  String get enhanceButtonLabel => 'УЛУЧШИТЬ';

  @override
  String get enhanceIntroDialogTitle => 'Улучшите ваши фото';

  @override
  String get enhanceIntroDialogDescription => 'Обработка фотографий производится на устройстве. По умолчанию они уменьшаются до 2048x1536. Настроить выходное разрешение можно в Настройках';

  @override
  String get enhanceLowLightTitle => 'Улучшение освещения';

  @override
  String get enhanceLowLightDescription => 'Повыcить яркость фотографий, сделанных в условиях недостаточной освещенности';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Яркость';

  @override
  String get collectionEditedPhotosLabel => 'Изменено (локально)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent => 'Выбранные элементы будут удалены с данного устройства навсегда.\n\nЭто действие является необратимым';

  @override
  String get enhancePortraitBlurTitle => 'Размытие заднего фона';

  @override
  String get enhancePortraitBlurDescription => 'Размытие фона фотографий, лучше всего работает с портретами';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Размытость';

  @override
  String get enhanceSuperResolution4xTitle => 'Супер-разрешение (4x)';

  @override
  String get enhanceSuperResolution4xDescription => 'Увеличение фотографий до 4x от исходного разрешения (подробнее о том, как это работает, см. в справке)';

  @override
  String get enhanceStyleTransferTitle => 'Перенос стиля';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Выберите стиль';

  @override
  String get enhanceStyleTransferStyleDialogDescription => 'Перенос стиля изображения с эталонного изображения на ваши фотографии';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification => 'Пожалуйста, выберите стиль';

  @override
  String get enhanceColorPopTitle => 'Обесцветить фон';

  @override
  String get enhanceColorPopDescription => 'Обесцветить фон фотографий, лучше всего работает с портретами';

  @override
  String get enhanceGenericParamWeightLabel => 'Вес';

  @override
  String get enhanceRetouchTitle => 'Авторетушь';

  @override
  String get enhanceRetouchDescription => 'Автоматически ретушировать фото, улучшить цвет и сочность';

  @override
  String get doubleTapExitNotification => 'Для выхода тапните еще раз';

  @override
  String get imageEditDiscardDialogTitle => 'Сбросить изменения?';

  @override
  String get imageEditDiscardDialogContent => 'Изменения не сохранены';

  @override
  String get discardButtonLabel => 'СБРОСИТЬ';

  @override
  String get saveTooltip => 'Сохранить';

  @override
  String get imageEditDownloadDialogTitle => 'Downloading image from server...';

  @override
  String get imageEditProcessDialogTitle => 'Processing image...';

  @override
  String get imageEditSaveDialogTitle => 'Saving result...';

  @override
  String get imageEditColorBrightness => 'Яркость';

  @override
  String get imageEditColorContrast => 'Контрастность';

  @override
  String get imageEditColorWhitePoint => 'Белая точка';

  @override
  String get imageEditColorBlackPoint => 'Черная точка';

  @override
  String get imageEditColorSaturation => 'Насыщенность';

  @override
  String get imageEditColorWarmth => 'Теплота';

  @override
  String get imageEditColorTint => 'Оттенок';

  @override
  String get imageEditTitle => 'Предпросмотр';

  @override
  String get imageEditToolbarColorLabel => 'Цвет';

  @override
  String get imageEditToolbarTransformLabel => 'Преобразовать';

  @override
  String get imageEditTransformOrientation => 'Поворот';

  @override
  String get imageEditTransformOrientationClockwise => 'cw';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'ccw';

  @override
  String get imageEditTransformCrop => 'Обрезать';

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
  String get categoriesLabel => 'Категории';

  @override
  String get searchLandingPeopleListEmptyText2 => 'Нажмите на настройки, чтобы сменить провайдера или воспользуйтесь справкой';

  @override
  String get searchLandingCategoryVideosLabel => 'Видео';

  @override
  String get searchFilterButtonLabel => 'ФИЛЬТРЫ';

  @override
  String get searchFilterDialogTitle => 'Фильтры поиска';

  @override
  String get applyButtonLabel => 'ПРИМЕНИТЬ';

  @override
  String get searchFilterOptionAnyLabel => 'Любой';

  @override
  String get searchFilterOptionTrueLabel => 'Истина';

  @override
  String get searchFilterOptionFalseLabel => 'Ложь';

  @override
  String get searchFilterTypeLabel => 'Тип';

  @override
  String get searchFilterTypeOptionImageLabel => 'Фото';

  @override
  String get searchFilterBubbleTypeImageText => 'фото';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Видео';

  @override
  String get searchFilterBubbleTypeVideoText => 'видео';

  @override
  String get searchFilterFavoriteLabel => 'Избранное';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'избранное';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'не избранное';

  @override
  String get showAllButtonLabel => 'ПОКАЗАТЬ ВСЕ';

  @override
  String gpsPlaceText(Object place) {
    return 'Около $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'О месте';

  @override
  String get gpsPlaceAboutDialogContent => 'Не гарантируется точность информации о местоположении данной точки. Оно не отражает нашу точку зрения на какие-либо спорные территории.';

  @override
  String get collectionPlacesLabel => 'Места';

  @override
  String get imageSaveOptionDialogTitle => 'Сохранить результат';

  @override
  String get imageSaveOptionDialogContent => 'Выберите место сохранения обработанных изображений. Если вы выберете сервер, но произойдет ошибка при загрузке, то они будет сохранены на вашем устройстве.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'УСТРОЙСТВО';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'СЕРВЕР';

  @override
  String get initialSyncMessage => 'Синхронизация с сервером в первый раз';

  @override
  String get loopTooltip => 'Повтор';

  @override
  String get createCollectionFailureNotification => 'Не удалось создать альбом';

  @override
  String get addItemToCollectionTooltip => 'Добавить в альбом';

  @override
  String get addItemToCollectionFailureNotification => 'Не удалось добавить в альбом';

  @override
  String get setCollectionCoverFailureNotification => 'Не удалось установить обложку альбома';

  @override
  String get exportCollectionTooltip => 'Экспорт';

  @override
  String get exportCollectionDialogTitle => 'Экспорт альбома';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 => 'Server-side album';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 => 'Create an album on your server, accessible with any app';

  @override
  String get removeCollectionsFailedNotification => 'Не удалось удалить некоторые альбомы';

  @override
  String get accountSettingsTooltip => 'Настройка аккаунта';

  @override
  String get contributorsTooltip => 'Контрибьюторы';

  @override
  String get setAsTooltip => 'Установить как';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return 'Вы собираетесь выйти из $server';
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
  String get errorUnauthenticated => 'Неавторизованный доступ. Если ошибка возникает снова, попробуйте перелогиниться';

  @override
  String get errorDisconnected => 'Не удаётся подключиться. Сервер может быть недоступен либо ваше устройство не подключено к сети';

  @override
  String get errorLocked => 'Файл заблокирован на сервере. Попробуйте повторить позже';

  @override
  String get errorInvalidBaseUrl => 'Не удаётся подключиться. Проверьте, что адрес вашего Nextcloud указан верно';

  @override
  String get errorWrongPassword => 'Не удаётся войти на сервер. Проверьте, правильно ли указаны логин и пароль';

  @override
  String get errorServerError => 'Ошибка сервера. Проверьте, правильно ли настроен ваш сервер';

  @override
  String get errorAlbumDowngrade => 'Невозможно изменить этот альбом, так как он был создан более поздней версией этого приложения. Обновите приложение и повторите попытку';

  @override
  String get errorNoStoragePermission => 'Необходимо разрешение на доступ к хранилищу';

  @override
  String get errorServerNoCert => 'Server certificate not found. Try HTTP instead?';
}
