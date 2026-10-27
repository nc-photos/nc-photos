// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Фото';

  @override
  String get translator => 'Vic';

  @override
  String get photosTabLabel => 'Фото';

  @override
  String get collectionsTooltip => 'Колекції';

  @override
  String get zoomTooltip => 'Приближення';

  @override
  String get settingsMenuLabel => 'Налаштування';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count selected',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Deleting $count items',
      one: 'Deleting 1 item',
    );
    return '\t $_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification =>
      'Всі предмети успішно видалено';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Failed deleting $count items',
      one: 'Failed deleting 1 item',
    );
    return '\t $_temp0';
  }

  @override
  String get archiveTooltip => 'Архів';

  @override
  String get archiveSelectedSuccessNotification =>
      'Всі предмети успішно заархівовано';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Failed archiving $count items',
      one: 'Failed archiving 1 item',
    );
    return '\t $_temp0';
  }

  @override
  String get unarchiveTooltip => 'Розархівувати';

  @override
  String get unarchiveSelectedSuccessNotification =>
      'Всі предмети успішно розархівовано';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Failed unarchiving $count items',
      one: 'Failed unarchiving 1 item',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Видалити';

  @override
  String get deleteSuccessNotification => 'Успішно видалено предмет';

  @override
  String get deleteFailureNotification => 'Помилка видалення предмету';

  @override
  String get removeSelectedFromAlbumFailureNotification =>
      'Не вдалося видалити предмети з альбому';

  @override
  String get addServerTooltip => 'Додати сервер';

  @override
  String removeServerSuccessNotification(Object server) {
    return '$server видалено успішно';
  }

  @override
  String get createAlbumTooltip => 'Новий альбом';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count items',
      one: '1 item',
      zero: 'Empty',
    );
    return '\t $_temp0';
  }

  @override
  String get albumArchiveLabel => 'Архів';

  @override
  String connectingToServer(Object server) {
    return 'Підключення до $server';
  }

  @override
  String get connectingToServer2 =>
      'Очікуємо на підтвердження авторизації сервера';

  @override
  String get connectingToServerInstruction =>
      'Будь ласка, увійдіть через відкритий браузер ';

  @override
  String get nameInputHint => 'Імʼя';

  @override
  String get nameInputInvalidEmpty => 'Імʼя обовʼязкове';

  @override
  String get skipButtonLabel => 'Пропустити';

  @override
  String get confirmButtonLabel => 'Підтвердити';

  @override
  String get signInHeaderText => 'Увійти до серверу Nextcloud';

  @override
  String get signIn2faHintText =>
      'Використайте пароль застосунку, якщо на сервері ввімкнуто двофакторну автентифікацію';

  @override
  String get signInHeaderText2 => 'Увійти до Nextcloud';

  @override
  String get serverAddressInputHint => 'Адреса серверу';

  @override
  String get serverAddressInputInvalidEmpty =>
      'Будь ласка, введіть адресу серверу';

  @override
  String get usernameInputHint => 'Імʼя користувача';

  @override
  String get usernameInputInvalidEmpty =>
      'Будь ласка, введіть імʼя користувача';

  @override
  String get passwordInputHint => 'Пароль';

  @override
  String get passwordInputInvalidEmpty => 'Будь ласка, введіть ваш пароль';

  @override
  String get rootPickerHeaderText => 'Виберіть папки, які потрібно включити';

  @override
  String get rootPickerSubHeaderText =>
      'Буде показано фото лише з вибраних папок. Натисніть «Пропустити», щоб включити всі';

  @override
  String get rootPickerNavigateUpItemText => 'Назад';

  @override
  String get rootPickerUnpickFailureNotification =>
      'Не вдалося скасувати вибір предмета';

  @override
  String get rootPickerListEmptyNotification =>
      'Будь ласка, виберіть хоча б одну папку або натисніть «Пропустити» щоб вибрати все';

  @override
  String get setupWidgetTitle => 'Почати';

  @override
  String get setupSettingsModifyLaterHint =>
      'Ви можете змінити це в налаштуваннях пізніше';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      'Цей застосунок створює папку на сервері Nextcloud для зберігання файлів налаштувань. Будь ласка, не змінюйте та не видаляйте її, якщо не плануєте видалити цей застосунок.';

  @override
  String get settingsWidgetTitle => 'Налаштування';

  @override
  String get settingsLanguageTitle => 'Мова';

  @override
  String get settingsLanguageOptionSystemDefaultLabel =>
      'Система «за замовчуванням»';

  @override
  String get settingsMetadataTitle => 'Файл метаданих';

  @override
  String get settingsExifSupportTitle2 => 'Підтримка EXIF на стороні клієнта';

  @override
  String get settingsExifSupportTrueSubtitle =>
      'Потребує додаткового використання мережі';

  @override
  String get settingsFallbackClientExifTitle =>
      'Використовувати аналізатор на стороні клієнта як резервний';

  @override
  String get settingsFallbackClientExifTrueText =>
      'Якщо Nextcloud не вдалося отримати метадані файлу, використовувати аналізатор на стороні клієнта';

  @override
  String get settingsFallbackClientExifFalseText =>
      'Якщо Nextcloud не вдалося отримати метадані файлу, залишити його без змін';

  @override
  String get settingsFallbackClientExifConfirmDialogTitle =>
      'Увімкнути резервну обробку на стороні клієнта?';

  @override
  String get settingsFallbackClientExifConfirmDialogText =>
      'Зазвичай сервер Nextcloud автоматично обробляє ваші фотографії та зберігає метадані EXIF у фоновому режимі. Однак це фонове завдання може завдання може завершитися невдало через помилку конфігурації або збій сервера. Якщо ввімкнути цю опцію, застосунок самостійно оброблятиме такі файли.';

  @override
  String get settingsBackupOnRemoteExifEditTitle =>
      'Створювати резервну копію перед зміною метаданих (лише для файлів на сервері)';

  @override
  String get settingsMemoriesTitle => 'Спогади';

  @override
  String get settingsMemoriesSubtitle => 'Показати фото зроблені в минулому';

  @override
  String get settingsAccountTitle => 'Акаунт';

  @override
  String get settingsAccountLabelTitle => 'Мітка';

  @override
  String get settingsAccountLabelDescription =>
      'Установіть мітку, яка відображатиметься замість URL-адреси сервера';

  @override
  String get settingsIncludedFoldersTitle => 'Включені папки';

  @override
  String get settingsShareFolderTitle => 'Поділитися папкою';

  @override
  String get settingsShareFolderDialogTitle => 'Знайти папку спільного доступу';

  @override
  String get settingsShareFolderDialogDescription =>
      'Це налаштування відповідає параметру share_folder у файлі config.php. Обидва значення мають бути однаковими.\r\n\r\nБудь ласка, виберіть ту саму папку, що вказана в config.php.';

  @override
  String get settingsShareFolderPickerDescription =>
      'Будь ласка, виберіть ту саму папку, що вказана в config.php. Натисніть «за замовчуванням», якщо параметр не встановлено.';

  @override
  String get settingsPersonProviderTitle => 'Постачальник осіб';

  @override
  String get settingsServerAppSectionTitle => 'Підтримка додатку сервера';

  @override
  String get settingsPhotosDescription =>
      'Налаштуйте вміст вкладки «Фотографії»';

  @override
  String get settingsMemoriesRangeTitle => 'Діапазон спогадів';

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
  String get settingsDeviceMediaTitle => 'Показати медіа з пристрою';

  @override
  String get settingsDeviceMediaDescription =>
      'Відображатимуться вибрані папки';

  @override
  String get settingsViewerTitle => 'Переглядач';

  @override
  String get settingsViewerDescription =>
      'Налаштувати переглядач зображень/відео';

  @override
  String get settingsScreenBrightnessTitle => 'Яскравість екрану';

  @override
  String get settingsScreenBrightnessDescription =>
      'Перевизначити рівень яскравості системи';

  @override
  String get settingsForceRotationTitle => 'Ігнорувати блокування обертання';

  @override
  String get settingsForceRotationDescription =>
      'Обертати екран навіть коли автоматичне обертання вимкнено';

  @override
  String get settingsMapProviderTitle => 'Постачальник мап';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'Налаштувати панель';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle =>
      'Налаштувати нижню панель';

  @override
  String get settingsShowDateInAlbumTitle => 'Групувати фото за датою';

  @override
  String get settingsShowDateInAlbumDescription =>
      'Застосовувати лише коли альбом відсортовано за часом';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'Налаштувати панель навігації';

  @override
  String get settingsImageEditTitle => 'Редактор';

  @override
  String get settingsImageEditDescription =>
      'Налаштувати покращення зображень і редактор зображень';

  @override
  String get settingsImageEditSaveResultsToServerTitle =>
      'Зберегти результати до сервера';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      'Результати зберігаються на сервері, а в разі помилки завантаження - на пристрої';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      'Результати зберігаються на цьому пристрої';

  @override
  String get settingsThemeTitle => 'Тема';

  @override
  String get settingsThemeDescription => 'Налаштувати вигляд застосунку';

  @override
  String get settingsFollowSystemThemeTitle => 'Використовувати темну тему';

  @override
  String get settingsSeedColorTitle => 'Колір теми';

  @override
  String get settingsSeedColorDescription =>
      'Використовується для формування всіх кольорів застосунку';

  @override
  String get settingsSeedColorSystemColorDescription =>
      'Використовувати системний колір';

  @override
  String get settingsSeedColorPickerTitle => 'Виберіть колір';

  @override
  String get settingsThemePrimaryColor => 'Основний';

  @override
  String get settingsThemeSecondaryColor => 'Вторинний';

  @override
  String get settingsThemePresets => 'Шаблони';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel =>
      'Використовувати системний колір';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Темніша тема';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription =>
      'Використовувати чорний в темній темі';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription =>
      'Використовувати темно-сірий в темній темі';

  @override
  String get settingsMiscellaneousTitle => 'Різне';

  @override
  String get settingsDoubleTapExitTitle => 'Подвійний натиск для виходу';

  @override
  String get settingsPhotosTabSortByNameTitle =>
      'Сортувати за імʼям файлу в Фото';

  @override
  String get settingsAppLock => 'Блокування застосунку';

  @override
  String get settingsAppLockTypeBiometric => 'Біометрія';

  @override
  String get settingsAppLockTypePin => 'PIN';

  @override
  String get settingsAppLockTypePassword => 'Пароль';

  @override
  String get settingsAppLockDescription =>
      'Якщо ввімкнено, під час відкриття застосунку потрібно буде пройти автентифікацію. Ця функція НЕ захищає від реальних атак.';

  @override
  String get settingsAppLockSetupBiometricFallbackDialogTitle =>
      'Виберіть резервний спосіб автентифікації, якщо біометрична автентифікація недоступна';

  @override
  String get settingsAppLockSetupPinDialogTitle =>
      'Установіть PIN-код для розблокування застосунку';

  @override
  String get settingsAppLockConfirmPinDialogTitle => 'Повторно введіть PIN-код';

  @override
  String get settingsAppLockSetupPasswordDialogTitle =>
      'Установіть пароль для розблокування застосунку';

  @override
  String get settingsAppLockConfirmPasswordDialogTitle =>
      'Повторно введіть пароль';

  @override
  String get settingsViewerUseOriginalImageTitle =>
      'Показувати оригінальне зображення замість високоякісного попереднього перегляду в переглядачі';

  @override
  String get settingsExperimentalTitle => 'Експерементальні';

  @override
  String get settingsExperimentalDescription =>
      'Функції, які ще не готові для щоденного використання';

  @override
  String get settingsExpertTitle => 'Додатково';

  @override
  String get settingsExpertWarningText =>
      'Будь ласка, переконайтеся, що ви повністю розумієте призначення кожної опції, перш ніж продовжити';

  @override
  String get settingsClearCacheDatabaseTitle => 'Очистити базу даних файлів';

  @override
  String get settingsClearCacheDatabaseDescription =>
      'Очистити кешовану інформацію про файли та запустити повну повторну синхронізацію із сервером';

  @override
  String get settingsClearCacheDatabaseSuccessNotification =>
      'Базу даних успішно очищено. Рекомендуємо перезапустити застосунок';

  @override
  String get settingsManageTrustedCertificateTitle =>
      'Керування довіреними сертифікатами';

  @override
  String get settingsAboutSectionTitle => 'Про застосунок';

  @override
  String get settingsVersionTitle => 'Версія';

  @override
  String get settingsServerVersionTitle => 'Сервер';

  @override
  String get settingsSourceCodeTitle => 'Вихідний код';

  @override
  String get settingsBugReportTitle => 'Повідомити про проблему';

  @override
  String get settingsCaptureLogsTitle => 'Зібрати журнали';

  @override
  String get settingsCaptureLogsDescription =>
      'Допоможіть розробникам знайти помилки';

  @override
  String get settingsTranslatorTitle => 'Перекладач';

  @override
  String get writePreferenceFailureNotification =>
      'Не вдалося змінити налаштування';

  @override
  String get enableButtonLabel => 'Увімкнути';

  @override
  String get enableButtonLabel2 => 'Увімкнути';

  @override
  String get exifSupportNextcloud28Notes =>
      'Підтримка на стороні клієнта доповнює можливості сервера. Застосунок оброблятиме файли й атрибути, які не підтримуються Nextcloud';

  @override
  String get exifSupportConfirmationDialogTitle2 =>
      'Увімкнути підтримку EXIF на стороні клієнта?';

  @override
  String get captureLogDetails =>
      'Щоб зібрати журнали для повідомлення про помилку:\r\n\r\n1. Увімкніть цю опцію.\r\n2. Відтворіть проблему.\r\n3. Вимкніть цю опцію.\r\n4. Знайдіть файл nc-photos.log у папці «Завантаження».\r\n\r\n* Якщо проблема призводить до аварійного завершення роботи застосунку, журнали не вдасться зібрати. У такому разі зверніться до розробника для отримання подальших інструкцій.';

  @override
  String get captureLogSuccessNotification => 'Журнали успішно збережено';

  @override
  String get doneButtonLabel => 'Готово';

  @override
  String get nextButtonLabel => 'Далі';

  @override
  String get connectButtonLabel => 'Підключення';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      'Буде включено всі ваші файли. Це може збільшити використання пам’яті та знизити продуктивність';

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
  String get detailsTooltip => 'Деталі';

  @override
  String get downloadTooltip => 'Завантажити';

  @override
  String get downloadProcessingNotification => 'Завантаження файлів';

  @override
  String get downloadSuccessNotification => 'Файли успішно завантажено';

  @override
  String get downloadFailureNotification => 'Завантаження файлів не здійснено.';

  @override
  String get nextTooltip => 'Далі';

  @override
  String get previousTooltip => 'Попереднє';

  @override
  String get webSelectRangeNotification =>
      'Утримуйте shift + натисніть, щоб виділити все всередині';

  @override
  String get mobileSelectRangeNotification =>
      'Натисніть і утримуйте інший елемент, щоб вибрати все всередині';

  @override
  String get updateDateTimeDialogTitle => 'Змінити дату й час';

  @override
  String get dateSubtitle => 'Дата';

  @override
  String get timeSubtitle => 'Час';

  @override
  String get timeZoneOffsetSubtitle => 'Часовий пояс';

  @override
  String get dateYearInputHint => 'Рік';

  @override
  String get dateMonthInputHint => 'Місяць';

  @override
  String get dateDayInputHint => 'День';

  @override
  String get timeHourInputHint => 'Година';

  @override
  String get timeMinuteInputHint => 'Хвилина';

  @override
  String get timeSecondInputHint => 'Секунда';

  @override
  String get dateTimeInputInvalid => 'Неприпустиме значення';

  @override
  String get updateDateTimeFailureNotification =>
      'Змінення дати і часу не здійснено ';

  @override
  String get albumDirPickerHeaderText =>
      'Виберіть папки, які потрібно повʼязати';

  @override
  String get albumDirPickerSubHeaderText =>
      'Лише фото в повʼязаних папках будуть включено в цей альбом';

  @override
  String get albumDirPickerListEmptyNotification =>
      'Будь ласка, виберіть хоча б одну папку';

  @override
  String get importFoldersTooltip => 'Імпортувати папки';

  @override
  String get albumImporterHeaderText => 'Імпортувати папки як альбоми';

  @override
  String get albumImporterSubHeaderText =>
      'Нижче наведено рекомендовані папки. Залежно від кількості файлів на вашому сервері це може зайняти деякий час';

  @override
  String get importButtonLabel => 'Імпортувати ';

  @override
  String get albumImporterProgressText => 'Імпортувати папки';

  @override
  String get doneButtonTooltip => 'Готово';

  @override
  String get editTooltip => 'Редагувати';

  @override
  String get editAccountConflictFailureNotification =>
      'Акаунт вже існує з тими самими налаштуваннями';

  @override
  String get genericProcessingDialogContent => 'Будь ласка, зачекайте';

  @override
  String get sortTooltip => 'Сортування';

  @override
  String get sortOptionDialogTitle => 'Сортувати за';

  @override
  String get sortOptionTimeAscendingLabel => 'Найстаріші';

  @override
  String get sortOptionTimeDescendingLabel => 'Найновіші';

  @override
  String get sortOptionFilenameAscendingLabel => 'Назва файлу';

  @override
  String get sortOptionFilenameDescendingLabel => 'Назва файлу (за спаданням)';

  @override
  String get sortOptionAlbumNameLabel => 'Назва альбому';

  @override
  String get sortOptionAlbumNameDescendingLabel =>
      'Назва альбому (за спаданням)';

  @override
  String get sortOptionManualLabel => 'Посібник';

  @override
  String get albumEditDragRearrangeNotification =>
      'Натисніть і утримуйте елемент, а потім перетягніть його, щоб змінити порядок вручну';

  @override
  String get albumAddTextTooltip => 'Додати текст';

  @override
  String get shareTooltip => 'Поділитися';

  @override
  String get shareSelectedEmptyNotification => 'Виберіть фото щоб поділитися';

  @override
  String get shareDownloadingDialogContent => 'Завантаження ';

  @override
  String get searchTooltip => 'Пошук';

  @override
  String get clearTooltip => 'Очистити';

  @override
  String get listNoResultsText => 'Немає результатів ';

  @override
  String get listEmptyText => 'Пусто';

  @override
  String get albumTrashLabel => 'Сміття';

  @override
  String get restoreTooltip => 'Відновити';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Restoring $count items',
      one: 'Restoring 1 item',
    );
    return '\t $_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification =>
      'Усі елементи успішно відновлено';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Failed restoring $count items',
      one: 'Failed restoring 1 item',
    );
    return '\t $_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Відновлення елементу';

  @override
  String get restoreSuccessNotification => 'Успішно відновлено елемент';

  @override
  String get restoreFailureNotification => 'Не вдалося відновити елемент';

  @override
  String get deletePermanentlyTooltip => 'Видалити назавжди';

  @override
  String get deletePermanentlyConfirmationDialogTitle => 'Видалити назавжди';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      'Вибрані елементи буде видалено з серверу назавжди. Цю дію неможливо скасувати';

  @override
  String get albumSharedLabel => 'Поширено';

  @override
  String get metadataTaskProcessingNotification =>
      'Обробка метаданих зображень у фоновому режимі';

  @override
  String get configButtonLabel => 'Конфігурація';

  @override
  String get useAsAlbumCoverTooltip => 'Використовувати як обкладинку альбому';

  @override
  String get helpTooltip => 'Допомога';

  @override
  String get helpButtonLabel => 'Допомога';

  @override
  String get removeFromAlbumTooltip => 'Виключити з альбому ';

  @override
  String get changelogTitle => 'Історія змін';

  @override
  String get serverCertErrorDialogTitle =>
      'Сертифікату сервера не можна довіряти';

  @override
  String get serverCertErrorDialogContent =>
      'Сервер може бути зламаний або хтось намагається вкрасти ваші дані';

  @override
  String get advancedButtonLabel => 'Додатково';

  @override
  String get whitelistCertDialogTitle => 'Довіряти невідомому сертифікату?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'Ви можете додати цей сертифікат до довірених, щоб застосунок його приймав.\r\nУВАГА: це становить серйозний ризик для безпеки. Переконайтеся, що сертифікат є самопідписаним вами або виданий довіреною стороною\r\nХост: $host\r\nВідбиток: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel => 'Прийняти ризик і додати до довірених';

  @override
  String get fileSharedByDescription => 'Надіслано вам цим користувачем';

  @override
  String get emptyTrashbinTooltip => 'Очистити смітник';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Очистити смітник ';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      'Всі елементи буде видалено з сервера назавжди. Цю дію буде неможливо скасувати';

  @override
  String get unsetAlbumCoverTooltip => 'Прибрати обкладинку';

  @override
  String get muteTooltip => 'Вимкнути звук';

  @override
  String get unmuteTooltip => 'Увімкнути звук';

  @override
  String get collectionPeopleLabel => 'Люди';

  @override
  String get slideshowTooltip => 'Слайд-шоу ';

  @override
  String get slideshowSetupDialogTitle => 'Налаштувати слайд-шоу';

  @override
  String get slideshowSetupDialogDurationTitle =>
      'Тривалість показу зображення (ХХ:СС)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Перемішати';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Повторити';

  @override
  String get slideshowSetupDialogReverseTitle => 'Перевернути';

  @override
  String get linkCopiedNotification => 'Посилання скопійовано ';

  @override
  String get shareMethodDialogTitle => 'Поширити як';

  @override
  String get shareMethodPreviewTitle => 'Попередній перегляд';

  @override
  String get shareMethodPreviewDescription =>
      'Надсилати зменшену копію зображення для попереднього перегляду в інших застосунках (лише зображення)';

  @override
  String get shareMethodOriginalFileTitle => 'Оригінальний файл';

  @override
  String get shareMethodOriginalFileDescription =>
      'Завантажити оригінальний файл і поділитися в інших додатках';

  @override
  String get shareMethodPublicLinkTitle => 'Публічне посилання';

  @override
  String get shareMethodPublicLinkDescription =>
      'Створити нове публічне посилання. Всі, хто мають посилання мають доступ до файлу';

  @override
  String get shareMethodPasswordLinkTitle => 'Посилання захищене паролем';

  @override
  String get shareMethodPasswordLinkDescription =>
      'Створити нове посилання захищене паролем';

  @override
  String get collectionSharingLabel => 'Ділитися';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Останній раз поширено $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '\t $user ділився/лась з Вами $date';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '\t $user ділився/лась альбомом з Вами $date';
  }

  @override
  String get sharedWithLabel => 'Поділився/лась з';

  @override
  String get unshareTooltip => 'Прибрати доступ';

  @override
  String get unshareSuccessNotification => 'Скасований доступ';

  @override
  String get locationLabel => 'Локація';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloud не підтримує посилання для спільного доступу до кількох файлів. Застосунок натомість СКОПІЮЄ файли в нову папку і поділиться вже цією папкою';

  @override
  String get folderNameInputHint => 'Назва папки';

  @override
  String get folderNameInputInvalidEmpty => 'Будь ласка, введіть назву папки';

  @override
  String get folderNameInputInvalidCharacters => 'Містить недопустимі елементи';

  @override
  String get createShareProgressText => 'Створення поширення';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Failed copying $count items',
      one: 'Failed copying 1 item',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Видалити папку?';

  @override
  String get unshareLinkShareDirDialogContent =>
      'Цю папку створено застосунком для спільного доступу до кількох файлів через посилання. Наразі вона більше ні з ким не спільна. Видалити цю папку?';

  @override
  String get addToCollectionsViewTooltip => 'Додати до колекції ';

  @override
  String get shareAlbumDialogTitle => 'Поділитися з користувачем';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Альбом поширено для $user, але не вдалося поділитися деякими файлами';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'Спільний доступ до альбому скасовано для $user, але не вдалося скасувати доступ до деяких файлам';
  }

  @override
  String get fixSharesTooltip => 'Виправити спільний доступ';

  @override
  String get fixTooltip => 'Виправити';

  @override
  String get fixAllTooltip => 'Виправити все';

  @override
  String missingShareDescription(Object user) {
    return 'Не поширено для $user';
  }

  @override
  String extraShareDescription(Object user) {
    return 'Поширено для $user';
  }

  @override
  String get defaultButtonLabel => 'Стандарт';

  @override
  String get addUserInputHint => 'Додати користувача';

  @override
  String get sharedAlbumInfoDialogTitle => 'Створення спільного альбому';

  @override
  String get sharedAlbumInfoDialogContent =>
      'Спільний альбом дозволяє кільком користувачам одного сервера отримувати доступ до одного й того самого альбому. Перш ніж продовжити, уважно ознайомтеся з обмеженнями';

  @override
  String get learnMoreButtonLabel => 'Дізнатися більше';

  @override
  String get migrateDatabaseProcessingNotification => 'Оновлення бази даних';

  @override
  String get migrateDatabaseFailureNotification =>
      'Не вдалося перенести базу даних';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count years ago',
      one: '1 year ago',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'Домашню папку не знайдено';

  @override
  String get homeFolderNotFoundDialogContent =>
      'Будь ласка, виправте наведений нижче URL-адрес WebDAV. Його можна знайти у вебінтерфейсі Nextcloud';

  @override
  String get homeFolderInputInvalidEmpty =>
      'Будь ласка, введіть назву домашньої папки';

  @override
  String get createCollectionTooltip => 'Нова колекція ';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Альбом на стороні клієнта';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      'Альбом із додатковими функціями, доступний лише в цьому застосунку';

  @override
  String get createCollectionDialogFolderLabel => 'Папка';

  @override
  String get createCollectionDialogFolderDescription => 'Показати фото у папці';

  @override
  String get collectionFavoritesLabel => 'Обране';

  @override
  String get favoriteTooltip => 'Обране';

  @override
  String get favoriteSuccessNotification => 'Додано до обраного';

  @override
  String get favoriteFailureNotification => 'Не вдалося додати до обраного';

  @override
  String get unfavoriteTooltip => 'Виключити з обраного';

  @override
  String get unfavoriteSuccessNotification => 'Виключене з обраного';

  @override
  String get unfavoriteFailureNotification => 'Не вдалося виключити з обраного';

  @override
  String get createCollectionDialogTagLabel => 'Мітка';

  @override
  String get createCollectionDialogTagDescription =>
      'Показати фото зі спеціальними мітками';

  @override
  String get addTagInputHint => 'Додати мітку';

  @override
  String get tagPickerNoTagSelectedNotification =>
      'Будь ласка, додайте хоча б одну мітку';

  @override
  String get backgroundServiceStopping => 'Зупинка служби';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'Низька батарея';

  @override
  String get enhanceTooltip => 'Покращити';

  @override
  String get enhanceButtonLabel => 'Покращити';

  @override
  String get enhanceLowLightTitle =>
      'Покращення знімків за слабкого освітлення ';

  @override
  String get enhanceLowLightDescription =>
      'Освітити ваші фотографії, зроблені в умовах слабкого освітлення';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Яскравість';

  @override
  String get collectionEditedPhotosLabel => 'Відредаговано (локально)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      'Вибрані зображення буде видалено з пристрою назавжди. Цю дію неможна скасувати';

  @override
  String get enhancePortraitBlurTitle => 'Потретне розмиття';

  @override
  String get enhancePortraitBlurDescription =>
      'Розмити задній фон ваших зображень, найкраще для портретів';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Розмиття';

  @override
  String get enhanceSuperResolution4xTitle => 'Суперроздільність (4х)';

  @override
  String get enhanceSuperResolution4xDescription =>
      'Збільште роздільну здатність ваших фотографій у 4 рази від початкової (докладніше про обмеження максимальної роздільної здатності див. у розділі «Довідка»)';

  @override
  String get enhanceStyleTransferTitle => 'Перенесення стилю';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Вибрати стиль';

  @override
  String get enhanceStyleTransferStyleDialogDescription =>
      'Перенести стиль з допоміжного зображення у ваше фото';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification =>
      'Буль ласка, виберіть стиль ';

  @override
  String get enhanceColorPopTitle => 'Кольоровий акцент';

  @override
  String get enhanceColorPopDescription =>
      'Знебарвлюйте фон фотографій. Найкраще працює з портретами.';

  @override
  String get enhanceGenericParamWeightLabel => 'Вага';

  @override
  String get enhanceRetouchTitle => 'Авто ретуш';

  @override
  String get enhanceRetouchDescription =>
      'Автоматично ретушуйте свої фотографії, покращуйте загальну передачу кольорів і насиченість';

  @override
  String get enhanceMotionDeblurTitle => 'Motion deblur';

  @override
  String get enhanceMotionDeblurDescription =>
      'Reduce image blur caused by camera shake';

  @override
  String get enhanceDerainTitle => 'Derain';

  @override
  String get enhanceDerainDescription => 'Remove rain streaks from your photo';

  @override
  String get doubleTapExitNotification => 'Натисніть знову щоби вийти';

  @override
  String get imageEditDiscardDialogTitle => 'Скасувати зміни?';

  @override
  String get imageEditDiscardDialogContent => 'Ваші зміни не збережено';

  @override
  String get discardButtonLabel => 'Скасувати';

  @override
  String get saveTooltip => 'Зберегти';

  @override
  String get imageEditDownloadDialogTitle =>
      'Завантаження зображення з сервера…';

  @override
  String get imageEditProcessDialogTitle => 'Обробка зображення...';

  @override
  String get imageEditSaveDialogTitle => 'Збереження результату…';

  @override
  String get imageEditColorBrightness => 'Яскравість';

  @override
  String get imageEditColorContrast => 'Контраст';

  @override
  String get imageEditColorWhitePoint => 'Точка білого';

  @override
  String get imageEditColorBlackPoint => 'Точка чорного';

  @override
  String get imageEditColorSaturation => 'Насиченість';

  @override
  String get imageEditColorWarmth => 'Теплота';

  @override
  String get imageEditColorTint => 'Тонування';

  @override
  String get imageEditTitle => 'Попередній перегляд редагування';

  @override
  String get imageEditToolbarColorLabel => 'Колір';

  @override
  String get imageEditToolbarTransformLabel => 'Трансформація';

  @override
  String get imageEditTransformOrientation => 'Орієнтація';

  @override
  String get imageEditTransformOrientationClockwise => 'cw';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'ccw';

  @override
  String get imageEditTransformCrop => 'Обрізати';

  @override
  String get imageEditToolbarEffectLabel => 'Ефект';

  @override
  String get imageEditEffectHalftone => 'Полутон';

  @override
  String get imageEditEffectPixelation => 'Пікселізація';

  @override
  String get imageEditEffectPosterization => 'Постеризація';

  @override
  String get imageEditEffectSketch => 'Ескіз';

  @override
  String get imageEditEffectToon => 'Toon';

  @override
  String get imageEditEffectFace => 'Обличчя';

  @override
  String get imageEditEffectParamEdge => 'Контури';

  @override
  String get imageEditEffectParamColor => 'Колір';

  @override
  String get imageEditEffectParamHatching => 'Штрихування';

  @override
  String get imageEditEffectParamJawline => 'Щелепа';

  @override
  String get imageEditEffectParamEyeSize => 'Розмір очей';

  @override
  String get imageEditFaceDetectionRunningMessage => 'Виявлення облич…';

  @override
  String get imageEditNoFaceDetected => 'Облич не виявлено';

  @override
  String get imageEditFaceNotSelected =>
      'Виберіть одне або кілька облич на своїх фотографіях, щоб застосувати ефекти';

  @override
  String get imageEditResetSelectedFaceMessage =>
      'Вибрані обличчя видаляються після коригування налаштувань трансформації зображення';

  @override
  String get imageEditToolbarMarkupLabel => 'Markup';

  @override
  String get imageEditMarkupUndo => 'Undo';

  @override
  String get imageEditBrushRadius => 'Radius';

  @override
  String get imageEditOpenErrorMessage => 'Не вдалося відкрити файл';

  @override
  String get imageEditSaveErrorMessage => 'Помилка при збереженні зображення ';

  @override
  String get categoriesLabel => 'Категорії ';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      'Натисніть «Налаштування», щоб змінити постачальника, або «Допомога», щоб дізнатися більше';

  @override
  String get searchLandingCategoryVideosLabel => 'Відео';

  @override
  String get searchFilterButtonLabel => 'Фільтри';

  @override
  String get searchFilterDialogTitle => 'Пошук фільтрів';

  @override
  String get applyButtonLabel => 'Застосувати ';

  @override
  String get searchFilterOptionAnyLabel => 'Всі';

  @override
  String get searchFilterOptionTrueLabel => 'True';

  @override
  String get searchFilterOptionFalseLabel => 'False';

  @override
  String get searchFilterTypeLabel => 'Тип';

  @override
  String get searchFilterTypeOptionImageLabel => 'Зображення ';

  @override
  String get searchFilterBubbleTypeImageText => 'Зображення ';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Відео';

  @override
  String get searchFilterBubbleTypeVideoText => 'Відео';

  @override
  String get searchFilterFavoriteLabel => 'Обране';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'Обрані';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'Не обрані';

  @override
  String get showAllButtonLabel => 'Показати всі';

  @override
  String gpsPlaceText(Object place) {
    return 'Поряд $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'Про місце';

  @override
  String get gpsPlaceAboutDialogContent =>
      'Позначене тут місце є лише приблизним і не гарантує точності. Воно не відображає нашу позицію щодо будь-яких спірних територій';

  @override
  String get collectionPlacesLabel => 'Місця';

  @override
  String get imageSaveOptionDialogTitle => 'Зберегти результат';

  @override
  String get imageSaveOptionDialogContent =>
      'Виберіть місце для збереження цього та майбутніх оброблених зображень. Якщо ви вибрали сервер, але програмі не вдалося завантажити на нього файл, його буде збережено на вашому пристрої';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'Пристрій';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'Сервер';

  @override
  String get initialSyncMessage => 'Синхронізація з вашим сервером вперше';

  @override
  String get loopTooltip => 'Петля';

  @override
  String get createCollectionFailureNotification =>
      'Не вдалося створити колекцію ';

  @override
  String get addItemToCollectionTooltip => 'Додати до колекції';

  @override
  String get addItemToCollectionFailureNotification =>
      'Не вдалося додати до колекції ';

  @override
  String get setCollectionCoverFailureNotification =>
      'Не вдалося встановити обкладинку колекції ';

  @override
  String get exportCollectionTooltip => 'Експортувати';

  @override
  String get exportCollectionDialogTitle => 'Експортувати колекцію';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 => 'Серверний альбом';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 =>
      'Створити альбом на сервері, доступний у будь-якому додатку';

  @override
  String get removeCollectionsFailedNotification =>
      'Не вдалося виключити деякі колекції ';

  @override
  String get accountSettingsTooltip => 'Налаштування акаунту';

  @override
  String get contributorsTooltip => 'Учасники';

  @override
  String get setAsTooltip => 'Встановити як';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return 'Ви збираєтеся вийти з $server';
  }

  @override
  String get appLockUnlockHint => 'Розблокувати додаток';

  @override
  String get appLockUnlockWrongPassword => 'Невірний пароль';

  @override
  String get enabledText => 'Увімкнено';

  @override
  String get disabledText => 'Вимкнено';

  @override
  String get trustedCertManagerPageTitle => 'Довірені сертифікат';

  @override
  String get trustedCertManagerAlreadyTrustedError => 'Вже довірено';

  @override
  String get trustedCertManagerSelectServer => 'Вибрати HTTPS сервер';

  @override
  String get trustedCertManagerNoHttpsServerError => 'Сервера не доступні';

  @override
  String get trustedCertManagerFailedToRemoveCertError =>
      'Не вдалося видалити сертифікат ';

  @override
  String get missingVideoThumbnailHelpDialogTitle =>
      'Виникли проблеми з мініатюрами відео?';

  @override
  String get dontShowAgain => 'Не показувати більше';

  @override
  String get mapBrowserDateRangeLabel => 'Діапазон дат';

  @override
  String get mapBrowserDateRangeThisMonth => 'Цього місяця';

  @override
  String get mapBrowserDateRangePrevMonth => 'Минулого місяця ';

  @override
  String get mapBrowserDateRangeThisYear => 'Цього року';

  @override
  String get mapBrowserDateRangeCustom => 'Налаштувати';

  @override
  String get homeTabMapBrowser => 'Мапа';

  @override
  String get mapBrowserSetDefaultDateRangeButton =>
      'Встановити за замовчуванням ';

  @override
  String get todayText => 'Сьогодні';

  @override
  String get livePhotoTooltip => 'Живе фото';

  @override
  String get dragAndDropRearrangeButtons =>
      'Перетягніть, щоб змінити порядок кнопок';

  @override
  String get customizeCollectionsNavBarDescription =>
      'Перетягніть, щоб змінити порядок кнопок, торкніться кнопок вище, щоб згорнути їх';

  @override
  String get customizeButtonsUnsupportedWarning =>
      'Цю кнопку не можна налаштувати';

  @override
  String get placePickerTitle => 'Виберіть місце';

  @override
  String get albumAddMapTooltip => 'Додати мапу';

  @override
  String get fileNotFound => 'Файл не знайдено';

  @override
  String get signInViaNextcloudLoginFlowV2 => 'Через Nextcloud Login Flow v2';

  @override
  String get signInViaUsernamePassword => 'Через ім\'я користувача або пароль';

  @override
  String get fileOnDevice => 'На пристрої';

  @override
  String get fileOnCloud => 'У хмарі';

  @override
  String get uploadTooltip => 'Завантажити ';

  @override
  String get uploadFolderPickerTitle => 'Завантажити до';

  @override
  String get opOnlySupportRemoteFiles =>
      'Ця функція підтримує лише віддалені файли на вашому сервері Nextcloud. Будь-які вибрані локальні файли ігноруються';

  @override
  String get opOnlySupportLocalFiles =>
      'Ця функція підтримує лише локальні файли на вашому пристрої. Будь-які вибрані віддалені файли ігноруються.';

  @override
  String get uploadDialogPath => 'Шлях';

  @override
  String get uploadDialogBatchConvert => 'Пакетне перетворення ';

  @override
  String get uploadBatchConvertWarningText1 =>
      'Ваші фотографії будуть стиснуті перед завантаженням на сервер';

  @override
  String get uploadBatchConvertWarningText2 =>
      'Фотографії з рухом НЕ підтримуються, і вони будуть завантажені як нерухомі зображення.';

  @override
  String get uploadBatchConvertWarningText3 =>
      'Деякі метадані можуть бути змінені або видалені.';

  @override
  String get uploadBatchConvertWarningText4 =>
      'Підтримувані вихідні формати: JPEG, PNG, WEBP, BMP, HEIC';

  @override
  String get uploadBatchConvertSettings => 'Налаштування конверсії';

  @override
  String get uploadBatchConvertSettingsFormat => 'Формат';

  @override
  String get uploadBatchConvertSettingsQuality => 'Якість';

  @override
  String get uploadBatchConvertSettingsDownscaling => 'Зменшення масштабу';

  @override
  String get viewerLastPageText => 'Більше фотографій немає';

  @override
  String get deleteMergedFileDialogServerOnlyButton => 'Лише сервер';

  @override
  String get deleteMergedFileDialogLocalOnlyButton => 'Лише пристрій';

  @override
  String get deleteMergedFileDialogBothButton => 'Обидва ';

  @override
  String get deleteMergedFileDialogContent =>
      'Деякі файли існують як на вашому сервері, так і на вашому пристрої. Звідки нам слід видалити ці файли?';

  @override
  String get deleteSingleMergedFileDialogContent =>
      'Файл існує як на вашому сервері, так і на вашому пристрої. Звідки нам видалити цей файл?';

  @override
  String get collectionAddItemTitle => 'Куди вставити елемент?';

  @override
  String greetingsMorning(Object user) {
    return 'Доброго ранку, $user';
  }

  @override
  String greetingsAfternoon(Object user) {
    return 'Добрий день, $user';
  }

  @override
  String greetingsNight(Object user) {
    return 'Доброго вечора, $user';
  }

  @override
  String get recognizeInstructionDialogTitle =>
      'Налаштування, необхідне для інтеграції Recognize';

  @override
  String get recognizeInstructionDialogContent =>
      'Починаючи з Nextcloud 33, для підтримки Recognize потрібен серверний застосунок.';

  @override
  String get recognizeInstructionDialogButton => 'Відкрити путівник';

  @override
  String get editMetadataWriteProgressTitle => 'Завантаження файлу';

  @override
  String get addLocationTitle => 'Додати локацію';

  @override
  String metadataEditBackupNotification(Object backup) {
    return 'Оригінальний файл збережено як $backup';
  }

  @override
  String get imageEnhancerModelDownloadDialogText => 'Downloading AI model...';

  @override
  String get imageEnhancerProcessDialogTitle => 'Almost there';

  @override
  String get imageEnhancerProcessDialogText =>
      'Your image will now be processed in the background. You\'ll get a notification when it\'s done.';

  @override
  String get imageEnhancerResultFailedNotifTitle => 'Failed to process image';

  @override
  String get imageEnhancerResultSuccessfulNotifTitle =>
      'Image processed successfully';

  @override
  String get imageEnhancerResultSuccessfulNotifContent =>
      'Tap to view the result';

  @override
  String get imageSegmentPicker6PointLimit => 'Only up to 6 points are allowed';

  @override
  String get imageSegmentPickerInitFailedText => 'Failed to initialize';

  @override
  String get imageSegmentPickerInstruction =>
      'Tap on screen to add or remove points of interest';

  @override
  String get postCrashReportDialogText =>
      'The app crashed during the previous run. Sending the log to the developer could help to diagnose the issue. Do you wish to export the log?';

  @override
  String get postCrashReportSubmitDialogText =>
      'Log saved, please report the issue to the developer on GitHub or via email with the log file attached. Thank you.';

  @override
  String get postCrashReportSubmitEmailButton => 'Email';

  @override
  String get swipeSelectGuide =>
      'Long press and swipe to select multiple items';

  @override
  String get selectionModePreviewGuide =>
      'In selection mode, long press an item to open it';

  @override
  String get placeSortOptionPhotoCount => 'Most photos';

  @override
  String get placeSortOptionName => 'Place name';

  @override
  String get errorUnauthenticated =>
      'Неавторизований доступ. Будь ласка, увійдіть ще раз, якщо проблема не зникне';

  @override
  String get errorDisconnected =>
      'Не вдається підключитися. Сервер може бути офлайн або ваш пристрій може бути відключений';

  @override
  String get errorLocked => 'Файл заблоковано на сервері. Спробуйте пізніше';

  @override
  String get errorInvalidBaseUrl =>
      'Не вдалося зв’язатися. Переконайтеся, що адреса є базовою URL-адресою вашого екземпляра Nextcloud';

  @override
  String get errorWrongPassword =>
      'Не вдалося автентифікувати. Будь ласка, перевірте ім\'я користувача та пароль';

  @override
  String get errorServerError =>
      'Помилка сервера. Переконайтеся, що сервер налаштовано правильно';

  @override
  String get errorAlbumDowngrade =>
      'Неможливо змінити цей альбом, оскільки його було створено пізнішою версією цього додатка. Оновіть додаток і повторіть спробу';

  @override
  String get errorNoStoragePermission => 'Потрібен дозвіл на доступ до сховища';

  @override
  String get errorServerNoCert =>
      'Сертифікат сервера не знайдено. Спробувати HTTP?';
}
