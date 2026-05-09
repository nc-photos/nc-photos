// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '相册';

  @override
  String get translator => 'zerolin\n老兄';

  @override
  String get photosTabLabel => '照片';

  @override
  String get collectionsTooltip => '收藏库';

  @override
  String get zoomTooltip => '放大';

  @override
  String get settingsMenuLabel => '设置';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已选 $count 项',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在删除 $count 个项目',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification => '成功删除所有项目';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '未能删除 $count 个项目',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => '归档';

  @override
  String get archiveSelectedSuccessNotification => '成功归档所有项目';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '未能归档 $count 个项目',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => '取消归档';

  @override
  String get unarchiveSelectedSuccessNotification => '成功取消归档所有项目';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '未能取消归档 $count 个项目',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => '删除';

  @override
  String get deleteSuccessNotification => '成功删除';

  @override
  String get deleteFailureNotification => '未能删除';

  @override
  String get removeSelectedFromAlbumFailureNotification => '未能从相册中移除项目';

  @override
  String get addServerTooltip => '添加服务器';

  @override
  String removeServerSuccessNotification(Object server) {
    return '成功移除 $server';
  }

  @override
  String get createAlbumTooltip => '新建相册';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 项内容',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => '归档';

  @override
  String connectingToServer(Object server) {
    return '正在连接\n$server';
  }

  @override
  String get connectingToServer2 => '等待服务器授权';

  @override
  String get connectingToServerInstruction => '请在打开的浏览器窗口中登入';

  @override
  String get nameInputHint => '名称';

  @override
  String get nameInputInvalidEmpty => '名字不能为空';

  @override
  String get skipButtonLabel => '跳过';

  @override
  String get confirmButtonLabel => '确认';

  @override
  String get signInHeaderText => '登录 Nextcloud 服务器';

  @override
  String get signIn2faHintText => '若你的服务器使用双重认证，请使用应用程式密码登录';

  @override
  String get signInHeaderText2 => 'Nextcloud\n登入';

  @override
  String get serverAddressInputHint => '服务器地址';

  @override
  String get serverAddressInputInvalidEmpty => '请输入服务器网址';

  @override
  String get usernameInputHint => '帐户名';

  @override
  String get usernameInputInvalidEmpty => '请输入帐户名';

  @override
  String get passwordInputHint => '密码';

  @override
  String get passwordInputInvalidEmpty => '请输入密码';

  @override
  String get rootPickerHeaderText => '请选择照片文件夹';

  @override
  String get rootPickerSubHeaderText => 'App 只会显示已选取文件夹内的照片，如需包含所有文件夹，请按跳过';

  @override
  String get rootPickerNavigateUpItemText => '(返回上级目录)';

  @override
  String get rootPickerUnpickFailureNotification => '未能取消选取文件夹';

  @override
  String get rootPickerListEmptyNotification => '请选取至少一个文件夹或按跳过';

  @override
  String get setupWidgetTitle => '开始使用';

  @override
  String get setupSettingsModifyLaterHint => '你亦可稍后于设置页面中修改';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      '本 App 将于你的 Nextcloud 服务器中添加一个文件夹以储存配置文档，除非你计划删除本 App，否则请不要更改或删除文件夹的内容';

  @override
  String get settingsWidgetTitle => '设置';

  @override
  String get settingsLanguageTitle => '语言';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => '系统语言';

  @override
  String get settingsMetadataTitle => 'File metadata';

  @override
  String get settingsExifSupportTitle2 => 'Client-side EXIF support';

  @override
  String get settingsExifSupportTrueSubtitle => '需要额外的网络流量';

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
  String get settingsMemoriesTitle => '回忆';

  @override
  String get settingsMemoriesSubtitle => '显示你过去的照片';

  @override
  String get settingsAccountTitle => '帐号';

  @override
  String get settingsAccountLabelTitle => '标签';

  @override
  String get settingsAccountLabelDescription => '设置一个标签以代替服务器URL显示';

  @override
  String get settingsIncludedFoldersTitle => '已选取的文件夹';

  @override
  String get settingsShareFolderTitle => '共享文件夹';

  @override
  String get settingsShareFolderDialogTitle => '设置共享文件夹';

  @override
  String get settingsShareFolderDialogDescription =>
      '此设置必需与你服务器上的设置一致，请参考服务器上 config.php 内的 share_folder 项目';

  @override
  String get settingsShareFolderPickerDescription =>
      '请选择与 config.php 中 share_folder 路径一致的文件夹，若你从未更改服务器设置，请按默认';

  @override
  String get settingsPersonProviderTitle => 'Person provider';

  @override
  String get settingsServerAppSectionTitle => '服务器 App 支持';

  @override
  String get settingsPhotosDescription => '自定义在图片页展示的内容';

  @override
  String get settingsMemoriesRangeTitle => '回忆天数';

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
  String get settingsDeviceMediaDescription =>
      'Selected folders will be displayed';

  @override
  String get settingsViewerTitle => '查看器';

  @override
  String get settingsViewerDescription => '设置照片和视频查看器';

  @override
  String get settingsScreenBrightnessTitle => '屏幕亮度';

  @override
  String get settingsScreenBrightnessDescription => '覆盖系统亮度设置';

  @override
  String get settingsForceRotationTitle => '无视屏幕旋转锁定';

  @override
  String get settingsForceRotationDescription => '在系统锁定屏幕旋转时支持自动旋轉';

  @override
  String get settingsMapProviderTitle => '地图供应商';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'Customize app bar';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle =>
      'Customize bottom app bar';

  @override
  String get settingsShowDateInAlbumTitle => '显示日期分类';

  @override
  String get settingsShowDateInAlbumDescription => '只应用于以日期排序的相册';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'Customize navigation bar';

  @override
  String get settingsImageEditTitle => '编辑器';

  @override
  String get settingsImageEditDescription => '自定义图片增强与编辑器';

  @override
  String get settingsEnhanceMaxResolutionTitle2 => '图片增强的分辨率';

  @override
  String get settingsEnhanceMaxResolutionDescription =>
      '大于选定分辨率的图片会被缩小。\n\n高分辨率的图片需要更多的内存和时间进行处理。如果增强图片时应用发生了崩溃，请降低该数值。';

  @override
  String get settingsImageEditSaveResultsToServerTitle => '将编辑后的图片保存至服务器';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      '编辑后的图片会保存到服务器，出错仍会保存到本地';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      '编辑后的图片已保存到设备';

  @override
  String get settingsThemeTitle => '主题';

  @override
  String get settingsThemeDescription => '设置 App 的外观';

  @override
  String get settingsFollowSystemThemeTitle => '跟随系统主题';

  @override
  String get settingsSeedColorTitle => '主题色';

  @override
  String get settingsSeedColorDescription =>
      'Used to derive all colors used in the app';

  @override
  String get settingsSeedColorSystemColorDescription => 'Use system color';

  @override
  String get settingsSeedColorPickerTitle => '选择颜色';

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
  String get settingsUseBlackInDarkThemeTitle => '黑色主题';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription => '深色主题中使用黑色背景';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription => '深色主题中使用深色背景';

  @override
  String get settingsMiscellaneousTitle => 'Miscellaneous';

  @override
  String get settingsDoubleTapExitTitle => '双击退出';

  @override
  String get settingsPhotosTabSortByNameTitle => '通过文件名排列图片';

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
  String get settingsExperimentalTitle => '实验';

  @override
  String get settingsExperimentalDescription => '可能不稳定的实验性功能';

  @override
  String get settingsExpertTitle => '高级';

  @override
  String get settingsExpertWarningText => '在进行操作前请确保您完全理解每个选择的作用';

  @override
  String get settingsClearCacheDatabaseTitle => '清除文件数据库';

  @override
  String get settingsClearCacheDatabaseDescription => '清理缓存的文件信息并完全从服务器重新同步';

  @override
  String get settingsClearCacheDatabaseSuccessNotification => '存数据已清除，建议重启应用';

  @override
  String get settingsManageTrustedCertificateTitle =>
      'Manage trusted certificates';

  @override
  String get settingsUseNewHttpEngine => 'Use new HTTP engine';

  @override
  String get settingsUseNewHttpEngineDescription =>
      'New HTTP engine based on Chromium, supporting new standards like HTTP/2* and HTTP/3 QUIC*.\n\nLimitations:\nSelf-signed certs can no longer be managed by us. You must import your CA certs to the system trust store for them to work.\n\n* HTTPS is required for HTTP/2 and HTTP/3';

  @override
  String get settingsAboutSectionTitle => '关于';

  @override
  String get settingsVersionTitle => '版本';

  @override
  String get settingsServerVersionTitle => '服务器';

  @override
  String get settingsSourceCodeTitle => '源代码';

  @override
  String get settingsBugReportTitle => '问题反馈';

  @override
  String get settingsCaptureLogsTitle => '收集 App 事件日志';

  @override
  String get settingsCaptureLogsDescription => '帮助开发者分析 bug';

  @override
  String get settingsTranslatorTitle => '翻译';

  @override
  String get settingsRestartNeededDialog =>
      'Please restart the app to apply changes';

  @override
  String get writePreferenceFailureNotification => '未能储存设置';

  @override
  String get enableButtonLabel => '启用';

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
      '如需记录事件日志以反馈问题:\n\n1. 启用本设置\n2. 重现一次你遇到的问题\n3. 禁用本设置\n4. 在装置的下载文件夹寻找 nc-photos.log 文件\n\n*此功能不支持使 App 强制关闭的问题，如遇此种情况，请直接联络开发者';

  @override
  String get captureLogSuccessNotification => '成功储存事件日志';

  @override
  String get doneButtonLabel => '完成';

  @override
  String get nextButtonLabel => '下一项';

  @override
  String get connectButtonLabel => '连接';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      '你服务器上的所有文件将会被添加到 App，这将提高内存用量并有机会影响 App 的性能';

  @override
  String megapixelCount(Object count) {
    return '$count百万像素';
  }

  @override
  String secondCountSymbol(Object count) {
    return '$count秒';
  }

  @override
  String millimeterCountSymbol(Object count) {
    return '$count毫米';
  }

  @override
  String get detailsTooltip => '详情';

  @override
  String get downloadTooltip => '下载';

  @override
  String get downloadProcessingNotification => '正在下载文件';

  @override
  String get downloadSuccessNotification => '成功下载文件';

  @override
  String get downloadFailureNotification => '未能下载文件';

  @override
  String get nextTooltip => '下一项';

  @override
  String get previousTooltip => '上一项';

  @override
  String get webSelectRangeNotification => '按下 shit 键点击以选取两项目之间的所有项目';

  @override
  String get mobileSelectRangeNotification => '长按以选取两项目之间的所有项目';

  @override
  String get updateDateTimeDialogTitle => '修改日期和时间';

  @override
  String get dateSubtitle => '日期';

  @override
  String get timeSubtitle => '时间';

  @override
  String get dateYearInputHint => '年';

  @override
  String get dateMonthInputHint => '月';

  @override
  String get dateDayInputHint => '日';

  @override
  String get timeHourInputHint => '时';

  @override
  String get timeMinuteInputHint => '分';

  @override
  String get timeSecondInputHint => '秒';

  @override
  String get dateTimeInputInvalid => '输入错误';

  @override
  String get updateDateTimeFailureNotification => '未能修改日期和时间';

  @override
  String get albumDirPickerHeaderText => '选取绑定的文件夹';

  @override
  String get albumDirPickerSubHeaderText => '相册只会包含已绑定文件夹内的照片';

  @override
  String get albumDirPickerListEmptyNotification => '请选取至少一个文件夹';

  @override
  String get importFoldersTooltip => '导入文件夹';

  @override
  String get albumImporterHeaderText => '导入文件夹为相册';

  @override
  String get albumImporterSubHeaderText =>
      '于下表列出推荐的文件夹。若你的服务器包含大量文件夹，将可能增加所需的时间';

  @override
  String get importButtonLabel => '导入';

  @override
  String get albumImporterProgressText => '正在导入文件夹';

  @override
  String get doneButtonTooltip => '完成';

  @override
  String get editTooltip => '修改';

  @override
  String get editAccountConflictFailureNotification => '已存在相同设置的帐号';

  @override
  String get genericProcessingDialogContent => '请等候';

  @override
  String get sortTooltip => '排序';

  @override
  String get sortOptionDialogTitle => '排序方式';

  @override
  String get sortOptionTimeAscendingLabel => '由旧到新';

  @override
  String get sortOptionTimeDescendingLabel => '由新到旧';

  @override
  String get sortOptionFilenameAscendingLabel => '文件名';

  @override
  String get sortOptionFilenameDescendingLabel => '文件名（降序）';

  @override
  String get sortOptionAlbumNameLabel => '相册名称';

  @override
  String get sortOptionAlbumNameDescendingLabel => '相册名称(降序)';

  @override
  String get sortOptionManualLabel => '手动';

  @override
  String get albumEditDragRearrangeNotification => '长按拖曳项目以改变排序';

  @override
  String get albumAddTextTooltip => '添加文字';

  @override
  String get shareTooltip => '分享';

  @override
  String get shareSelectedEmptyNotification => '请选取要分享的照片';

  @override
  String get shareDownloadingDialogContent => '正在下载';

  @override
  String get searchTooltip => '搜寻';

  @override
  String get clearTooltip => '清除';

  @override
  String get listNoResultsText => '0 项内容';

  @override
  String get listEmptyText => '0 项内容';

  @override
  String get albumTrashLabel => '回收站';

  @override
  String get restoreTooltip => '还原';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在还原 $count 个项目',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification => '成功还原所有项目';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '未能还原 $count 个项目',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => '正在还原';

  @override
  String get restoreSuccessNotification => '成功还原';

  @override
  String get restoreFailureNotification => '未能还原';

  @override
  String get deletePermanentlyTooltip => '永久删除';

  @override
  String get deletePermanentlyConfirmationDialogTitle => '永久删除';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      '将于你的服务器上永久删除所选的文件。\n\n此为不可逆操作';

  @override
  String get albumSharedLabel => '已分享';

  @override
  String get metadataTaskProcessingNotification => '正在背景读取照片的中继数据';

  @override
  String get configButtonLabel => '设置';

  @override
  String get useAsAlbumCoverTooltip => '设为相册封面';

  @override
  String get helpTooltip => '帮助';

  @override
  String get helpButtonLabel => '帮助';

  @override
  String get removeFromAlbumTooltip => '从相册中移除';

  @override
  String get changelogTitle => '更新日志';

  @override
  String get serverCertErrorDialogTitle => '不安全的服务器证书';

  @override
  String get serverCertErrorDialogContent => '此服务器可能遭到入侵或你的网络正被监听';

  @override
  String get advancedButtonLabel => '进阶设置';

  @override
  String get whitelistCertDialogTitle => '把服务器证书添加白名单?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return '你可以把此服务器证书添加 App 的白名单。警告：此行为有可能构成安全风险，请确保此证书的来源可信\n\n主机: $host\n指纹: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel => '明白风险并添加白名单';

  @override
  String get fileSharedByDescription => '为此用户分享给你';

  @override
  String get emptyTrashbinTooltip => '清空回收站';

  @override
  String get emptyTrashbinConfirmationDialogTitle => '清空回收站';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      '将于你的服务器上永久删除所有文件。\n\n此为不可逆操作';

  @override
  String get unsetAlbumCoverTooltip => '取消设为相册封面';

  @override
  String get muteTooltip => '静音';

  @override
  String get unmuteTooltip => '取消静音';

  @override
  String get collectionPeopleLabel => '人物';

  @override
  String get slideshowTooltip => '幻灯片';

  @override
  String get slideshowSetupDialogTitle => '设置幻燈片';

  @override
  String get slideshowSetupDialogDurationTitle => '照片时长 (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => '随机';

  @override
  String get slideshowSetupDialogRepeatTitle => '重复';

  @override
  String get slideshowSetupDialogReverseTitle => 'Reverse';

  @override
  String get linkCopiedNotification => '已复制链接';

  @override
  String get shareMethodDialogTitle => '分享方式';

  @override
  String get shareMethodPreviewTitle => '预览';

  @override
  String get shareMethodPreviewDescription => '将低质量的预览分享到其他应用（仅支持图片）';

  @override
  String get shareMethodOriginalFileTitle => '原始文件';

  @override
  String get shareMethodOriginalFileDescription => '下载并分享原始文件到其他应用';

  @override
  String get shareMethodPublicLinkTitle => '公开链接';

  @override
  String get shareMethodPublicLinkDescription => '于服务器上建立新的公开链接，所有开启链接的人都能存取文件';

  @override
  String get shareMethodPasswordLinkTitle => '密码保护链接';

  @override
  String get shareMethodPasswordLinkDescription => '于服务器上建立新的密码保护链接';

  @override
  String get collectionSharingLabel => '分享';

  @override
  String fileLastSharedDescription(Object date) {
    return '于 $date 分享';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user 于 $date 分享给你';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user 于 $date 分享相册给你';
  }

  @override
  String get sharedWithLabel => '分享详情';

  @override
  String get unshareTooltip => '取消分享';

  @override
  String get unshareSuccessNotification => '已移除分享';

  @override
  String get locationLabel => '地点';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloud 并不支持建立多文件的分享链接，App 将会复制选取的文件到一新的文件夹，并分享该文件夹';

  @override
  String get folderNameInputHint => '文件夹名称';

  @override
  String get folderNameInputInvalidEmpty => '请输入文件夹名称';

  @override
  String get folderNameInputInvalidCharacters => '包含不支持的字母';

  @override
  String get createShareProgressText => '正在建立分享';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '未能复制 $count 个项目',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => '删除文件夹?';

  @override
  String get unshareLinkShareDirDialogContent =>
      '此文件夹本是 App 为了分享多文件而建立的，而此文件夹现在已没有任何分享，你希望删除此文件夹吗?';

  @override
  String get addToCollectionsViewTooltip => '添加到收藏库';

  @override
  String get shareAlbumDialogTitle => '分享给用户';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return '成功分享相册给 $user，但部分照片未能分享';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return '成功取消分享相册给 $user，但部分照片未能取消分享';
  }

  @override
  String get fixSharesTooltip => '修复分享';

  @override
  String get fixTooltip => '修复';

  @override
  String get fixAllTooltip => '修复全部';

  @override
  String missingShareDescription(Object user) {
    return '未有分享到 $user';
  }

  @override
  String extraShareDescription(Object user) {
    return '已分享到 $user';
  }

  @override
  String get defaultButtonLabel => '默认';

  @override
  String get addUserInputHint => '添加用户';

  @override
  String get sharedAlbumInfoDialogTitle => '关于共享相册';

  @override
  String get sharedAlbumInfoDialogContent =>
      '共享相册容许同一服务器上的多名用户存取相同的相册，请于使用本功能前细阅说明和限制';

  @override
  String get learnMoreButtonLabel => '更多说明';

  @override
  String get migrateDatabaseProcessingNotification => '正在更新数据库';

  @override
  String get migrateDatabaseFailureNotification => '未能更新数据库';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 年前',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => '未找到用户文件夹';

  @override
  String get homeFolderNotFoundDialogContent =>
      '请更正下面的 WebDAV 网址，你可以在 Nextcloud 网页界面中找到正确的网址';

  @override
  String get homeFolderInputInvalidEmpty => '请输入用户文件夹的名称';

  @override
  String get createCollectionTooltip => '新建照片集';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Client-side album';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      'Album with extra features, accessible only with this app';

  @override
  String get createCollectionDialogFolderLabel => '文件夹';

  @override
  String get createCollectionDialogFolderDescription => '显示文件夹内的照片';

  @override
  String get collectionFavoritesLabel => '收藏';

  @override
  String get favoriteTooltip => '添加到收藏';

  @override
  String get favoriteSuccessNotification => '成功添加到收藏';

  @override
  String get favoriteFailureNotification => '未能添加到收藏';

  @override
  String get unfavoriteTooltip => '从收藏移除';

  @override
  String get unfavoriteSuccessNotification => '成功从收藏移除';

  @override
  String get unfavoriteFailureNotification => '未能从收藏移除';

  @override
  String get createCollectionDialogTagLabel => '标签';

  @override
  String get createCollectionDialogTagDescription => '显示特定标签的文件';

  @override
  String get addTagInputHint => '添加标签';

  @override
  String get tagPickerNoTagSelectedNotification => '请添加至少一个标签';

  @override
  String get backgroundServiceStopping => '正在停止后台服务';

  @override
  String get metadataTaskPauseLowBatteryNotification => '电量不足';

  @override
  String get enhanceTooltip => '增强';

  @override
  String get enhanceButtonLabel => '图片增强';

  @override
  String get enhanceIntroDialogTitle => '增强你的图片';

  @override
  String get enhanceIntroDialogDescription =>
      '你的图片将会在本地处理，默认情况下会降低分辨率至2048x1536，你可以随时在设置的输出分辨率中调整';

  @override
  String get enhanceLowLightTitle => '弱光优化';

  @override
  String get enhanceLowLightDescription => '在弱光环境下提亮您的照片';

  @override
  String get enhanceLowLightParamBrightnessLabel => '亮度';

  @override
  String get collectionEditedPhotosLabel => '本地编辑';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      '被选择的项目将会被永久的从此设备中删除\n\n这个操作是不可逆的';

  @override
  String get enhancePortraitBlurTitle => '背景虚化';

  @override
  String get enhancePortraitBlurDescription => '虚化背景，最适用于肖像照片';

  @override
  String get enhancePortraitBlurParamBlurLabel => '模糊度';

  @override
  String get enhanceSuperResolution4xTitle => '超分辨率（4x）';

  @override
  String get enhanceSuperResolution4xDescription =>
      '将您的照片放大到原始分辨率的4倍（有关最大分辨率如何作用的信息，请参阅帮助）';

  @override
  String get enhanceStyleTransferTitle => '风格转变';

  @override
  String get enhanceStyleTransferStyleDialogTitle => '选择风格';

  @override
  String get enhanceStyleTransferStyleDialogDescription => '将您的照片转变为参考图片的风格';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification => '选择风格';

  @override
  String get enhanceColorPopTitle => 'Color pop';

  @override
  String get enhanceColorPopDescription => '模糊背景，最实用于肖像图';

  @override
  String get enhanceGenericParamWeightLabel => '宽度';

  @override
  String get enhanceRetouchTitle => 'Auto retouch';

  @override
  String get enhanceRetouchDescription => '自动修饰您的照片，提高整体色彩和生动感';

  @override
  String get doubleTapExitNotification => '再次点击以退出';

  @override
  String get imageEditDiscardDialogTitle => '放弃更改？';

  @override
  String get imageEditDiscardDialogContent => '你的更改未被保存';

  @override
  String get discardButtonLabel => '放弃';

  @override
  String get saveTooltip => '保存';

  @override
  String get imageEditDownloadDialogTitle => 'Downloading image from server...';

  @override
  String get imageEditProcessDialogTitle => 'Processing image...';

  @override
  String get imageEditSaveDialogTitle => 'Saving result...';

  @override
  String get imageEditColorBrightness => '亮度';

  @override
  String get imageEditColorContrast => 'Contrast';

  @override
  String get imageEditColorWhitePoint => 'White point';

  @override
  String get imageEditColorBlackPoint => 'Black point';

  @override
  String get imageEditColorSaturation => 'Saturation';

  @override
  String get imageEditColorWarmth => 'Warmth';

  @override
  String get imageEditColorTint => 'Tint';

  @override
  String get imageEditTitle => 'Preview edits';

  @override
  String get imageEditToolbarColorLabel => 'Color';

  @override
  String get imageEditToolbarTransformLabel => 'Transform';

  @override
  String get imageEditTransformOrientation => 'Orientation';

  @override
  String get imageEditTransformOrientationClockwise => 'cw';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'ccw';

  @override
  String get imageEditTransformCrop => 'Crop';

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
  String get categoriesLabel => '类别';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      'Press settings to switch provider or press help to learn more';

  @override
  String get searchLandingCategoryVideosLabel => '视频';

  @override
  String get searchFilterButtonLabel => '过滤器';

  @override
  String get searchFilterDialogTitle => '搜索过滤器';

  @override
  String get applyButtonLabel => '应用';

  @override
  String get searchFilterOptionAnyLabel => '任意';

  @override
  String get searchFilterOptionTrueLabel => '是';

  @override
  String get searchFilterOptionFalseLabel => '否';

  @override
  String get searchFilterTypeLabel => '类别';

  @override
  String get searchFilterTypeOptionImageLabel => '图片';

  @override
  String get searchFilterBubbleTypeImageText => '图片';

  @override
  String get searchFilterTypeOptionVideoLabel => '视频';

  @override
  String get searchFilterBubbleTypeVideoText => '视频';

  @override
  String get searchFilterFavoriteLabel => '收藏';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'favorites';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'not favorites';

  @override
  String get showAllButtonLabel => '展示全部';

  @override
  String gpsPlaceText(Object place) {
    return 'Near $place';
  }

  @override
  String get gpsPlaceAboutDialogTitle => '关于地点';

  @override
  String get gpsPlaceAboutDialogContent => '展示的地点仅是一个粗略的估计值。它不代表我们对有争议地区的观点。';

  @override
  String get collectionPlacesLabel => '地点';

  @override
  String get imageSaveOptionDialogTitle => '保存结果';

  @override
  String get imageSaveOptionDialogContent =>
      'Select where to save this and future processed images. If you picked server but the app failed to upload it, it will be saved on your device.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => '设备';

  @override
  String get imageSaveOptionDialogServerButtonLabel => '服务器';

  @override
  String get initialSyncMessage => '这是从服务器的第一次同步';

  @override
  String get loopTooltip => 'Loop';

  @override
  String get createCollectionFailureNotification => '创建影集失败';

  @override
  String get addItemToCollectionTooltip => '添加到影集';

  @override
  String get addItemToCollectionFailureNotification => '添加到影集失败';

  @override
  String get setCollectionCoverFailureNotification => '设置影集封面失败';

  @override
  String get exportCollectionTooltip => '导出';

  @override
  String get exportCollectionDialogTitle => '导出影集';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 => 'Server-side album';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 =>
      'Create an album on your server, accessible with any app';

  @override
  String get removeCollectionsFailedNotification => '删除影集失败';

  @override
  String get accountSettingsTooltip => '账号设置';

  @override
  String get contributorsTooltip => '贡献者';

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
  String get errorUnauthenticated => '未授权的存取，若问题持续请重新登录';

  @override
  String get errorDisconnected => '无法建立连接，服务器可能正在维护或你的装置已离线';

  @override
  String get errorLocked => '文件于服务器上被锁定，请稍候重试';

  @override
  String get errorInvalidBaseUrl => '无法建立连接，请确认网址为你 Nextcloud 服务器的基底网址';

  @override
  String get errorWrongPassword => '服务器授权失败，请确认你的帐户名和密码为正确';

  @override
  String get errorServerError => '服务器错误，请确认服务器设置无误';

  @override
  String get errorAlbumDowngrade => '无法修改新版本 App 所储存的相册，请更新 App 后重试';

  @override
  String get errorNoStoragePermission => '需要存取装置文件的权限';

  @override
  String get errorServerNoCert =>
      'Server certificate not found. Try HTTP instead?';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get appTitle => '相簿';

  @override
  String get translator => 'zerolin';

  @override
  String get photosTabLabel => '相片';

  @override
  String get collectionsTooltip => '收藏庫';

  @override
  String get zoomTooltip => '放大';

  @override
  String get settingsMenuLabel => '設定';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '已選 $count 項',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在刪除 $count 個項目',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification => '成功刪除所有項目';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '未能刪除 $count 個項目',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => '封存';

  @override
  String get archiveSelectedSuccessNotification => '成功封存所有項目';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '未能封存 $count 個項目',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => '取消封存';

  @override
  String get unarchiveSelectedSuccessNotification => '成功取消封存所有項目';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '未能取消封存 $count 個項目',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => '刪除';

  @override
  String get deleteSuccessNotification => '成功刪除';

  @override
  String get deleteFailureNotification => '未能刪除';

  @override
  String get removeSelectedFromAlbumFailureNotification => '未能從相簿中移除項目';

  @override
  String get addServerTooltip => '新增伺服器';

  @override
  String removeServerSuccessNotification(Object server) {
    return '成功移除 $server';
  }

  @override
  String get createAlbumTooltip => '新增相簿';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 個項目',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => '封存庫';

  @override
  String connectingToServer(Object server) {
    return '正在連接\n$server';
  }

  @override
  String get nameInputHint => '名稱';

  @override
  String get skipButtonLabel => '跳過';

  @override
  String get confirmButtonLabel => '確認';

  @override
  String get signInHeaderText => '登入 Nextcloud 伺服器';

  @override
  String get signIn2faHintText => '若你的伺服器使用雙重認證，請以應用程式密碼登入';

  @override
  String get serverAddressInputHint => '伺服器地址';

  @override
  String get serverAddressInputInvalidEmpty => '請輸入伺服器地址';

  @override
  String get usernameInputHint => '用戶名稱';

  @override
  String get usernameInputInvalidEmpty => '請輸入用戶名稱';

  @override
  String get passwordInputHint => '密碼';

  @override
  String get passwordInputInvalidEmpty => '請輸入密碼';

  @override
  String get rootPickerHeaderText => '請選擇相片資料夾';

  @override
  String get rootPickerSubHeaderText => 'App 只會顯示已選取資料夾內的相片，如需包含所有資料夾，請按跳過';

  @override
  String get rootPickerNavigateUpItemText => '(返回上一層)';

  @override
  String get rootPickerUnpickFailureNotification => '未能取消選取資料夾';

  @override
  String get rootPickerListEmptyNotification => '請選取至少一個資料夾或按跳過';

  @override
  String get setupWidgetTitle => '開始使用';

  @override
  String get setupSettingsModifyLaterHint => '你亦可稍後於設定頁面中修改';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      '本 App 將於你的 Nextcloud 伺服器中新增一個資料夾以儲存設定文件，除非你計劃刪除本 App，否則請不要更改或刪除資料夾的內容';

  @override
  String get settingsWidgetTitle => '設定';

  @override
  String get settingsLanguageTitle => '語言';

  @override
  String get settingsExifSupportTrueSubtitle => '需要額外的網絡用量';

  @override
  String get settingsMemoriesTitle => '回憶';

  @override
  String get settingsMemoriesSubtitle => '顯示你過去的相片';

  @override
  String get settingsAccountTitle => '帳戶';

  @override
  String get settingsIncludedFoldersTitle => '已選取的資料夾';

  @override
  String get settingsShareFolderTitle => '共享資料夾';

  @override
  String get settingsShareFolderDialogTitle => '設置共享資料夾';

  @override
  String get settingsShareFolderDialogDescription =>
      '此設定必需與你伺服器上的設置一致，請參考伺服器上 config.php 內的 share_folder 項目';

  @override
  String get settingsShareFolderPickerDescription =>
      '請選擇與 config.php 中 share_folder 路徑一致的資料夾，若你從未更改伺服器設置，請按默認';

  @override
  String get settingsServerAppSectionTitle => '伺服器 App 支援';

  @override
  String get settingsViewerTitle => '檢視器';

  @override
  String get settingsViewerDescription => '設置相片和影片檢視器';

  @override
  String get settingsScreenBrightnessTitle => '螢幕亮度';

  @override
  String get settingsScreenBrightnessDescription => '覆蓋系統亮度設定';

  @override
  String get settingsForceRotationTitle => '無視螢幕旋轉鎖定';

  @override
  String get settingsForceRotationDescription => '在系統鎖定螢幕旋轉時保持自動旋轉';

  @override
  String get settingsMapProviderTitle => '地圖供應商';

  @override
  String get settingsShowDateInAlbumTitle => '顯示日期分類';

  @override
  String get settingsShowDateInAlbumDescription => '只應用於以日期排序的相簿';

  @override
  String get settingsThemeTitle => '主題';

  @override
  String get settingsThemeDescription => '設置 App 的外觀';

  @override
  String get settingsFollowSystemThemeTitle => '跟隨系統主題';

  @override
  String get settingsUseBlackInDarkThemeTitle => '黑色主題';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription => '深色主題中使用黑色背景';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription => '深色主題中使用深色背景';

  @override
  String get settingsExperimentalTitle => '實驗';

  @override
  String get settingsExperimentalDescription => '可能不穩定的實驗性功能';

  @override
  String get settingsAboutSectionTitle => '關於';

  @override
  String get settingsVersionTitle => '版本';

  @override
  String get settingsSourceCodeTitle => '源代碼';

  @override
  String get settingsBugReportTitle => '問題匯報';

  @override
  String get settingsCaptureLogsTitle => '收集 App 事件日誌';

  @override
  String get settingsCaptureLogsDescription => '幫助開發者分析 bug';

  @override
  String get settingsTranslatorTitle => '翻譯';

  @override
  String get writePreferenceFailureNotification => '未能儲存設定';

  @override
  String get enableButtonLabel => '啟用';

  @override
  String get captureLogDetails =>
      '如需記錄事件日誌以匯報問題:\n\n1. 啟用本設定\n2. 重現一次你遇到的問題\n3. 禁用本設定\n4. 在裝置的下載資料夾尋找 nc-photos.log 檔案\n\n*此功能不支援使 App 強制關閉的問題，如遇此種情況，請直接聯絡開發者';

  @override
  String get captureLogSuccessNotification => '成功儲存事件日誌';

  @override
  String get doneButtonLabel => '完成';

  @override
  String get nextButtonLabel => '下一項';

  @override
  String get connectButtonLabel => '連接';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      '你伺服器上的所有檔案將會被加入到 App，這將提高記憶體用量並有機會影響 App 的性能';

  @override
  String megapixelCount(Object count) {
    return '$count百萬像素';
  }

  @override
  String secondCountSymbol(Object count) {
    return '$count秒';
  }

  @override
  String millimeterCountSymbol(Object count) {
    return '$count毫米';
  }

  @override
  String get detailsTooltip => '詳情';

  @override
  String get downloadTooltip => '下載';

  @override
  String get downloadProcessingNotification => '正在下載檔案';

  @override
  String get downloadSuccessNotification => '成功下載檔案';

  @override
  String get downloadFailureNotification => '未能下載檔案';

  @override
  String get nextTooltip => '下一項';

  @override
  String get previousTooltip => '上一項';

  @override
  String get webSelectRangeNotification => '按下 shit 鍵點擊以選取兩項目之間的所有項目';

  @override
  String get mobileSelectRangeNotification => '長按以選取兩項目之間的所有項目';

  @override
  String get updateDateTimeDialogTitle => '修改日期和時間';

  @override
  String get dateSubtitle => '日期';

  @override
  String get timeSubtitle => '時間';

  @override
  String get dateYearInputHint => '年';

  @override
  String get dateMonthInputHint => '月';

  @override
  String get dateDayInputHint => '日';

  @override
  String get timeHourInputHint => '時';

  @override
  String get timeMinuteInputHint => '分';

  @override
  String get timeSecondInputHint => '秒';

  @override
  String get dateTimeInputInvalid => '輸入錯誤';

  @override
  String get updateDateTimeFailureNotification => '未能修改日期和時間';

  @override
  String get albumDirPickerHeaderText => '選取綁定的資料夾';

  @override
  String get albumDirPickerSubHeaderText => '相簿只會包含已綁定資料夾內的相片';

  @override
  String get albumDirPickerListEmptyNotification => '請選取至少一個資料夾';

  @override
  String get importFoldersTooltip => '導入資料夾';

  @override
  String get albumImporterHeaderText => '導入資料夾為相簿';

  @override
  String get albumImporterSubHeaderText =>
      '於下表列出推薦的資料夾。若你的伺服器包含大量資料夾，將可能增加所需的時間';

  @override
  String get importButtonLabel => '導入';

  @override
  String get albumImporterProgressText => '正在導入資料夾';

  @override
  String get doneButtonTooltip => '完成';

  @override
  String get editTooltip => '修改';

  @override
  String get editAccountConflictFailureNotification => '已存在相同設置的帳戶';

  @override
  String get genericProcessingDialogContent => '請等候';

  @override
  String get sortTooltip => '排序';

  @override
  String get sortOptionDialogTitle => '排序方式';

  @override
  String get sortOptionTimeAscendingLabel => '由舊到新';

  @override
  String get sortOptionTimeDescendingLabel => '由新到舊';

  @override
  String get sortOptionAlbumNameLabel => '相簿名稱';

  @override
  String get sortOptionAlbumNameDescendingLabel => '相簿名稱(降序)';

  @override
  String get sortOptionManualLabel => '手動';

  @override
  String get albumEditDragRearrangeNotification => '長按拖曳項目以改變排序';

  @override
  String get albumAddTextTooltip => '新增文字';

  @override
  String get shareTooltip => '分享';

  @override
  String get shareSelectedEmptyNotification => '請選取要分享的相片';

  @override
  String get shareDownloadingDialogContent => '正在下載';

  @override
  String get searchTooltip => '搜尋';

  @override
  String get clearTooltip => '清除';

  @override
  String get listNoResultsText => '0 個項目';

  @override
  String get listEmptyText => '0 個項目';

  @override
  String get albumTrashLabel => '垃圾桶';

  @override
  String get restoreTooltip => '還原';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '正在還原 $count 個項目',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification => '成功還原所有項目';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '未能還原 $count 個項目',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => '正在還原';

  @override
  String get restoreSuccessNotification => '成功還原';

  @override
  String get restoreFailureNotification => '未能還原';

  @override
  String get deletePermanentlyTooltip => '永久刪除';

  @override
  String get deletePermanentlyConfirmationDialogTitle => '永久刪除';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      '將於你的伺服器上永久刪除所選的檔案。\n\n此為不可逆操作';

  @override
  String get albumSharedLabel => '已分享';

  @override
  String get metadataTaskProcessingNotification => '正在背景讀取相片的中繼資料';

  @override
  String get configButtonLabel => '設定';

  @override
  String get useAsAlbumCoverTooltip => '設為相簿封面';

  @override
  String get helpTooltip => '幫助';

  @override
  String get helpButtonLabel => '幫助';

  @override
  String get removeFromAlbumTooltip => '從相簿中移除';

  @override
  String get changelogTitle => '更新日誌';

  @override
  String get serverCertErrorDialogTitle => '不安全的伺服器憑證';

  @override
  String get serverCertErrorDialogContent => '此伺服器可能遭到入侵或你的網絡正被竊聽';

  @override
  String get advancedButtonLabel => '進階設定';

  @override
  String get whitelistCertDialogTitle => '把伺服器憑證加入白名單?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return '你可以把此伺服器憑證加入 App 的白名單。警告：此行為有可能構成安全風險，請確保此憑證的來源可信\n\n主機: $host\n指紋: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel => '明白風險並加入白名單';

  @override
  String get fileSharedByDescription => '為此用戶分享給你';

  @override
  String get emptyTrashbinTooltip => '清空垃圾桶';

  @override
  String get emptyTrashbinConfirmationDialogTitle => '清空垃圾桶';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      '將於你的伺服器上永久刪除所有檔案。\n\n此為不可逆操作';

  @override
  String get unsetAlbumCoverTooltip => '取消設為相簿封面';

  @override
  String get muteTooltip => '靜音';

  @override
  String get unmuteTooltip => '解除靜音';

  @override
  String get collectionPeopleLabel => '人物';

  @override
  String get slideshowTooltip => '幻燈片';

  @override
  String get slideshowSetupDialogTitle => '設置幻燈片';

  @override
  String get slideshowSetupDialogDurationTitle => '相片時長 (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => '隨機';

  @override
  String get slideshowSetupDialogRepeatTitle => '重複';

  @override
  String get linkCopiedNotification => '已複製連結';

  @override
  String get shareMethodDialogTitle => '分享方式';

  @override
  String get shareMethodPublicLinkTitle => '公開連結';

  @override
  String get shareMethodPublicLinkDescription => '於伺服器上建立新的公開連結，所有開啟連結的人都能存取檔案';

  @override
  String get shareMethodPasswordLinkTitle => '密碼保護連結';

  @override
  String get shareMethodPasswordLinkDescription => '於伺服器上建立新的密碼保護連結';

  @override
  String get collectionSharingLabel => '分享';

  @override
  String fileLastSharedDescription(Object date) {
    return '於 $date 分享';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user 於 $date 分享給你';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user 於 $date 分享相簿給你';
  }

  @override
  String get sharedWithLabel => '分享詳情';

  @override
  String get unshareTooltip => '取消分享';

  @override
  String get unshareSuccessNotification => '已移除分享';

  @override
  String get locationLabel => '地點';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloud 並不支援建立多檔案的分享連結，App 將會複製選取的檔案至一新的資料夾，並分享該資料夾';

  @override
  String get folderNameInputHint => '資料夾名稱';

  @override
  String get folderNameInputInvalidEmpty => '請輸入資料夾名稱';

  @override
  String get folderNameInputInvalidCharacters => '包含不支援的字母';

  @override
  String get createShareProgressText => '正在建立分享';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '未能複製 $count 個項目',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => '刪除資料夾?';

  @override
  String get unshareLinkShareDirDialogContent =>
      '此資料夾本是 App 為了分享多檔案而建立的，而此資料夾現在已沒有任何分享，你希望刪除此資料夾嗎?';

  @override
  String get addToCollectionsViewTooltip => '新增至收藏庫';

  @override
  String get shareAlbumDialogTitle => '分享給用戶';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return '成功分享相簿給 $user，但部分相片未能分享';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return '成功取消分享相簿給 $user，但部分相片未能取消分享';
  }

  @override
  String get fixSharesTooltip => '修正分享';

  @override
  String get fixTooltip => '修正';

  @override
  String get fixAllTooltip => '修正全部';

  @override
  String missingShareDescription(Object user) {
    return '未有分享至 $user';
  }

  @override
  String extraShareDescription(Object user) {
    return '已分享至 $user';
  }

  @override
  String get defaultButtonLabel => '默認';

  @override
  String get addUserInputHint => '新增用戶';

  @override
  String get sharedAlbumInfoDialogTitle => '關於共享相簿';

  @override
  String get sharedAlbumInfoDialogContent =>
      '共享相簿容許同一伺服器上的多名用戶存取相同的相簿，請於使用本功能前細閱說明和限制';

  @override
  String get learnMoreButtonLabel => '更多說明';

  @override
  String get migrateDatabaseProcessingNotification => '正在更新數據庫';

  @override
  String get migrateDatabaseFailureNotification => '未能更新數據庫';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count 年前',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => '未找到用戶資料夾';

  @override
  String get homeFolderNotFoundDialogContent =>
      '請修正下面的 WebDAV 地址，你可以於 Nextcloud 網頁介面中找到正確的地址';

  @override
  String get homeFolderInputInvalidEmpty => '請輸入用戶資料夾的名稱';

  @override
  String get createCollectionTooltip => '新增相片集';

  @override
  String get createCollectionDialogFolderLabel => '資料夾';

  @override
  String get createCollectionDialogFolderDescription => '顯示資料夾內的相片';

  @override
  String get collectionFavoritesLabel => '我的最愛';

  @override
  String get favoriteTooltip => '新增至我的最愛';

  @override
  String get favoriteSuccessNotification => '成功新增至我的最愛';

  @override
  String get favoriteFailureNotification => '未能新增至我的最愛';

  @override
  String get unfavoriteTooltip => '從我的最愛移除';

  @override
  String get unfavoriteSuccessNotification => '成功從我的最愛移除';

  @override
  String get unfavoriteFailureNotification => '未能從我的最愛移除';

  @override
  String get createCollectionDialogTagLabel => '標籤';

  @override
  String get createCollectionDialogTagDescription => '顯示特定標籤的檔案';

  @override
  String get addTagInputHint => '新增標籤';

  @override
  String get tagPickerNoTagSelectedNotification => '請新增至少一個標籤';

  @override
  String get backgroundServiceStopping => '正在停止背景服務';

  @override
  String get metadataTaskPauseLowBatteryNotification => '電量不足';

  @override
  String get errorUnauthenticated => '未授權的存取，若問題持續請重新登入';

  @override
  String get errorDisconnected => '無法建立連線，服務器可能正在維護或你的裝置已離線';

  @override
  String get errorLocked => '檔案於伺服器上被鎖定，請稍候重試';

  @override
  String get errorInvalidBaseUrl => '無法建立連線，請確認網絡地址為你 Nextcloud 伺服器的基底地址';

  @override
  String get errorWrongPassword => '無法建立授權，請確認你的用戶名稱和密碼為正確';

  @override
  String get errorServerError => '伺服器錯誤，請確認伺服器設置無誤';

  @override
  String get errorAlbumDowngrade => '無法修改新版本 App 所儲存的相簿，請更新 App 後重試';

  @override
  String get errorNoStoragePermission => '需要存取裝置檔案的權限';
}
