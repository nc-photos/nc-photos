// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '写真';

  @override
  String get translator => 'yoking\nnkming2';

  @override
  String get photosTabLabel => '写真';

  @override
  String get collectionsTooltip => 'コレクション';

  @override
  String get zoomTooltip => '拡大';

  @override
  String get settingsMenuLabel => '設定';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個 選択中',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のアイテムを削除中',
      one: '1個のアイテムを削除中',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification => '全てのアイテムを削除しました';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のアイテムの削除に失敗しました',
      one: '1個のアイテムの削除に失敗しました',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'アーカイブに移動';

  @override
  String get archiveSelectedSuccessNotification => '全てのファイルをアーカイブに移動しました';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のファイルをアーカイブに移動できませんでした',
      one: '1個のファイルをアーカイブに移動できませんでした',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'アーカイブを解除';

  @override
  String get unarchiveSelectedSuccessNotification => '全てのファイルのアーカイブを解除しました';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のファイルのアーカイブ解除に失敗しました',
      one: '1個のファイルのアーカイブ解除に失敗しました',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => '削除';

  @override
  String get deleteSuccessNotification => 'ファイルを削除しました';

  @override
  String get deleteFailureNotification => 'ファイルを削除できませんでした';

  @override
  String get removeSelectedFromAlbumFailureNotification =>
      'アルバムからアイテムを削除できませんでした';

  @override
  String get addServerTooltip => 'サーバーを追加';

  @override
  String removeServerSuccessNotification(Object server) {
    return '$serverを削除しました。';
  }

  @override
  String get createAlbumTooltip => '新しいアルバム';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のアイテム',
      one: '1個のアイテム',
      zero: '空',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'アーカイブ';

  @override
  String connectingToServer(Object server) {
    return '$serverに接続中';
  }

  @override
  String get connectingToServer2 => 'サーバーの承認を待っています';

  @override
  String get connectingToServerInstruction => '開いたブラウザからサインインしてください';

  @override
  String get nameInputHint => '名前';

  @override
  String get nameInputInvalidEmpty => '名前は必須です';

  @override
  String get skipButtonLabel => 'スキップ';

  @override
  String get confirmButtonLabel => '確認';

  @override
  String get signInHeaderText => 'Nextcloudサーバーにサインイン';

  @override
  String get signIn2faHintText => 'サーバーで二要素認証が有効になっている場合は、アプリパスワードを使用してください';

  @override
  String get signInHeaderText2 => 'Nextcloud サインイン';

  @override
  String get serverAddressInputHint => 'サーバーアドレス';

  @override
  String get serverAddressInputInvalidEmpty => 'サーバーアドレスを入力';

  @override
  String get usernameInputHint => 'ユーザー名';

  @override
  String get usernameInputInvalidEmpty => 'ユーザー名を入力';

  @override
  String get passwordInputHint => 'パスワード';

  @override
  String get passwordInputInvalidEmpty => 'パスワードを入力';

  @override
  String get rootPickerHeaderText => '含めるフォルダを選択してください';

  @override
  String get rootPickerSubHeaderText =>
      'フォルダ内の写真のみが表示されます。\nすべてを表示するには「スキップ」を押してください。';

  @override
  String get rootPickerNavigateUpItemText => '(戻る)';

  @override
  String get rootPickerUnpickFailureNotification => 'アイテムの選択解除に失敗しました';

  @override
  String get rootPickerListEmptyNotification =>
      '少なくとも1つのフォルダを選択するか、スキップを押してすべてを含めてください。';

  @override
  String get setupWidgetTitle => '始める';

  @override
  String get setupSettingsModifyLaterHint => '後で設定で変更できます';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      'このアプリは、Nextcloudサーバー上に設定ファイルを保存するためのフォルダを作成します。このアプリを削除する予定がない限り、このフォルダを変更または削除しないでください。';

  @override
  String get settingsWidgetTitle => '設定';

  @override
  String get settingsLanguageTitle => '言語';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => 'デフォルト';

  @override
  String get settingsMetadataTitle => 'メタデータ';

  @override
  String get settingsExifSupportTitle2 => '内蔵EXIFリーダーを使う';

  @override
  String get settingsExifSupportTrueSubtitle => 'ネットワークの通信が増えます';

  @override
  String get settingsFallbackClientExifTitle => 'サーバー側の処理が失敗した場合にアプリで処理する';

  @override
  String get settingsFallbackClientExifTrueText =>
      'サーバー側の処理が失敗した場合にアプリでEXIFデータを読み込みます';

  @override
  String get settingsFallbackClientExifFalseText =>
      'サーバー側の処理が失敗した場合でもアプリでEXIFデータを読み込みません';

  @override
  String get settingsFallbackClientExifConfirmDialogTitle =>
      'サーバー側の処理が失敗した場合にアプリで処理しますか？';

  @override
  String get settingsFallbackClientExifConfirmDialogText =>
      '通常、サーバー側は自動的に写真を処理し、EXIFデータを処理し、保存します。しかし、設定の問題やサーバーのバグにより、処理が失敗することがあります。有効にすると、これらのファイルをアプリで処理します。';

  @override
  String get settingsMemoriesTitle => '思い出';

  @override
  String get settingsMemoriesSubtitle => '過去に撮影した写真を表示する';

  @override
  String get settingsAccountTitle => 'アカウント';

  @override
  String get settingsAccountLabelTitle => 'あだ名';

  @override
  String get settingsAccountLabelDescription => 'サーバーURLの代わりに表示されるあだ名を設定する';

  @override
  String get settingsIncludedFoldersTitle => '含まれるフォルダ';

  @override
  String get settingsShareFolderTitle => '共有フォルダのパス';

  @override
  String get settingsShareFolderDialogTitle => '共有フォルダを見つける';

  @override
  String get settingsShareFolderDialogDescription =>
      'この設定はconfig.phpのshare_folderパラメータに対応しています。必ず同じフォルダを指定してください。';

  @override
  String get settingsShareFolderPickerDescription =>
      'config.phpで設定したフォルダと同じフォルダを指定してください。パラメータを設定していない場合は、デフォルトを押してください。';

  @override
  String get settingsPersonProviderTitle => 'フェイスグループ機能の提供元';

  @override
  String get settingsServerAppSectionTitle => 'サーバーアプリとの連携';

  @override
  String get settingsPhotosDescription => '写真タブに表示されるコンテンツをカスタマイズする';

  @override
  String get settingsMemoriesRangeTitle => '思い出の連続日数';

  @override
  String settingsMemoriesRangeValueText(num range) {
    String _temp0 = intl.Intl.pluralLogic(
      range,
      locale: localeName,
      other: '+-$range日',
      one: '+-$range日',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeviceMediaTitle => 'デバイスの写真を表示する';

  @override
  String get settingsDeviceMediaDescription => '選択したフォルダ内の写真がタイムラインに表示されます';

  @override
  String get settingsViewerTitle => 'ビューア';

  @override
  String get settingsViewerDescription => '画像/動画ビューアをカスタマイズする';

  @override
  String get settingsScreenBrightnessTitle => '画面の明るさ';

  @override
  String get settingsScreenBrightnessDescription => 'システムの明るさレベルを上書きする';

  @override
  String get settingsForceRotationTitle => '回転ロックを無視する';

  @override
  String get settingsForceRotationDescription => '自動回転が無効になっている場合でも画面を回転する';

  @override
  String get settingsMapProviderTitle => '地図の提供元';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'アプリバーをカスタマイズ';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle => '下部アプリバーをカスタマイズ';

  @override
  String get settingsShowDateInAlbumTitle => '日付別に写真をグループ化';

  @override
  String get settingsShowDateInAlbumDescription =>
      'アルバムが時間順に並べ替えられている場合にのみ適用されます。';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'ナビゲーションバーをカスタマイズ';

  @override
  String get settingsImageEditTitle => 'エディタ';

  @override
  String get settingsImageEditDescription => '画像の強化と画像エディタをカスタマイズ';

  @override
  String get settingsEnhanceMaxResolutionTitle2 => '強化のための画像解像度';

  @override
  String get settingsEnhanceMaxResolutionDescription =>
      '選択した解像度より大きい写真は縮小されます。高解像度の写真は、処理に多くのメモリと時間を必要とします。写真の補正中にアプリがクラッシュした場合は、この設定を下げてください。';

  @override
  String get settingsImageEditSaveResultsToServerTitle => '結果をサーバーに保存する';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      '結果はサーバーに保存され、失敗した場合はデバイスのストレージに保存されます。';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      '結果はこのデバイスに保存されます。';

  @override
  String get settingsThemeTitle => 'テーマ';

  @override
  String get settingsThemeDescription => 'アプリの外観をカスタマイズする';

  @override
  String get settingsFollowSystemThemeTitle => 'システムのデフォルトテーマを使用する';

  @override
  String get settingsSeedColorTitle => '配色';

  @override
  String get settingsSeedColorDescription => '選んだ色を元にアプリ全体の配色が生成されます';

  @override
  String get settingsSeedColorSystemColorDescription => 'システムカラーを使用';

  @override
  String get settingsSeedColorPickerTitle => '色を選ぶ';

  @override
  String get settingsThemePrimaryColor => 'メインカラー';

  @override
  String get settingsThemeSecondaryColor => 'アクセントカラー';

  @override
  String get settingsThemePresets => 'プリセット';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel => 'システムカラーを使用';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'ダークテーマをより黒くする';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription => 'ダークテーマの背景を黒にします';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription =>
      'ダークテーマの背景を暗いグレーにします';

  @override
  String get settingsMiscellaneousTitle => 'その他';

  @override
  String get settingsDoubleTapExitTitle => '終了前に確認する';

  @override
  String get settingsPhotosTabSortByNameTitle => '写真をファイル名で並べ替える';

  @override
  String get settingsAppLock => 'アプリロック';

  @override
  String get settingsAppLockTypeBiometric => '生体認証';

  @override
  String get settingsAppLockTypePin => 'PIN';

  @override
  String get settingsAppLockTypePassword => 'パスワード';

  @override
  String get settingsAppLockDescription =>
      '有効にすると、アプリを開くときに認証が求められます。この機能は、現実世界の攻撃からあなたを保護するものではありません。';

  @override
  String get settingsAppLockSetupBiometricFallbackDialogTitle =>
      '生体認証が利用できない場合のフォールバックを選択してください';

  @override
  String get settingsAppLockSetupPinDialogTitle =>
      'アプリのロックを解除するためのPINを設定してください';

  @override
  String get settingsAppLockConfirmPinDialogTitle => '同じPINをもう一度入力してください';

  @override
  String get settingsAppLockSetupPasswordDialogTitle =>
      'アプリのロックを解除するためのパスワードを設定してください';

  @override
  String get settingsAppLockConfirmPasswordDialogTitle =>
      '同じパスワードをもう一度入力してください';

  @override
  String get settingsViewerUseOriginalImageTitle =>
      'ビュアーでやや画質が下げた画像よりオリジナル画像を使用';

  @override
  String get settingsExperimentalTitle => '実験的';

  @override
  String get settingsExperimentalDescription => '通常用途には適さない機能です。';

  @override
  String get settingsExpertTitle => '上級者向け設定';

  @override
  String get settingsExpertWarningText => '続行する前に、各設定の機能を十分に理解してください。';

  @override
  String get settingsClearCacheDatabaseTitle => 'ファイルデータベースをクリア';

  @override
  String get settingsClearCacheDatabaseDescription =>
      'キャッシュされたファイル情報をクリアして、サーバーと再同期を行います';

  @override
  String get settingsClearCacheDatabaseSuccessNotification =>
      'データベースが正常にクリアされました。アプリを再起動してください。';

  @override
  String get settingsManageTrustedCertificateTitle => '信頼済み証明書の管理';

  @override
  String get settingsUseNewHttpEngine => '新しいHTTPエンジンを使用';

  @override
  String get settingsUseNewHttpEngineDescription =>
      'Chromiumベースの新しいHTTPエンジンで、HTTP/2*やHTTP/3 QUIC*などの新しい標準をサポートします。\n\n制限事項:\n自己署名証明書は管理できなくなりました。動作させるには、CA証明書をシステムの信頼ストアにインポートする必要があります。\n\n* HTTP/2およびHTTP/3にはHTTPSが必要です';

  @override
  String get settingsAboutSectionTitle => 'アプリ情報';

  @override
  String get settingsVersionTitle => 'バージョン';

  @override
  String get settingsServerVersionTitle => 'サーバー';

  @override
  String get settingsSourceCodeTitle => 'ソースコード';

  @override
  String get settingsBugReportTitle => '不具合を報告';

  @override
  String get settingsCaptureLogsTitle => 'ログを記録';

  @override
  String get settingsCaptureLogsDescription =>
      '記録したログを開発者と共有すると、不具合の特定や修正に役立ちます';

  @override
  String get settingsTranslatorTitle => '翻訳者';

  @override
  String get settingsRestartNeededDialog => '変更を適用するにはアプリを再起動してください';

  @override
  String get writePreferenceFailureNotification => '設定に失敗しました';

  @override
  String get enableButtonLabel => '有効にする';

  @override
  String get enableButtonLabel2 => '有効にする';

  @override
  String get exifSupportNextcloud28Notes =>
      '有効にすると、Nextcloudでサポートされていない画像や動画をアプリ側で処理します';

  @override
  String get exifSupportConfirmationDialogTitle2 => 'アプリ内蔵のEXIFリーダーを有効にしますか？';

  @override
  String get captureLogDetails =>
      'バグレポート用のログを取得するには：\n1. この設定を有効にする\n2. 問題を発生させる\n3. この設定を無効にする\n4. ダウンロードフォルダでnc-photos.logを探す\n\n※問題によってアプリがクラッシュした場合は、ログを取得できません。その場合は、開発者に連絡して詳細な手順をご確認ください。';

  @override
  String get captureLogSuccessNotification => 'ログを保存しました';

  @override
  String get doneButtonLabel => '完了';

  @override
  String get nextButtonLabel => '次';

  @override
  String get connectButtonLabel => '接続';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      'すべてのファイルが含まれます。これによりメモリ使用量が増加し、パフォーマンスが低下する可能性があります。';

  @override
  String megapixelCount(Object count) {
    return '${count}MP';
  }

  @override
  String secondCountSymbol(Object count) {
    return '$count秒';
  }

  @override
  String millimeterCountSymbol(Object count) {
    return '${count}mm';
  }

  @override
  String get detailsTooltip => '詳細';

  @override
  String get downloadTooltip => 'ダウンロード';

  @override
  String get downloadProcessingNotification => 'ファイルをダウンロードしています';

  @override
  String get downloadSuccessNotification => 'ファイルのダウンロードに成功しました';

  @override
  String get downloadFailureNotification => 'ファイルのダウンロードに失敗しました';

  @override
  String get nextTooltip => '次';

  @override
  String get previousTooltip => '前';

  @override
  String get webSelectRangeNotification =>
      'Shiftキーを押しながらクリックすると、その間にある全てのアイテムを選択できます。';

  @override
  String get mobileSelectRangeNotification =>
      '別のアイテムを長押しすると、その間にあるすべてのアイテムが選択されます';

  @override
  String get updateDateTimeDialogTitle => '日付と時刻を変更する';

  @override
  String get dateSubtitle => '日付';

  @override
  String get timeSubtitle => '時間';

  @override
  String get dateYearInputHint => '年';

  @override
  String get dateMonthInputHint => '月';

  @override
  String get dateDayInputHint => '日';

  @override
  String get timeHourInputHint => '時間';

  @override
  String get timeMinuteInputHint => '分';

  @override
  String get timeSecondInputHint => '秒';

  @override
  String get dateTimeInputInvalid => '無効な値です';

  @override
  String get updateDateTimeFailureNotification => '日付と時刻の変更に失敗しました';

  @override
  String get albumDirPickerHeaderText => '関連付けるフォルダを選択してください';

  @override
  String get albumDirPickerSubHeaderText => 'このアルバムには、関連付けられたフォルダ内の写真のみが含まれます';

  @override
  String get albumDirPickerListEmptyNotification => '少なくとも1つのフォルダを選択してください';

  @override
  String get importFoldersTooltip => 'フォルダをインポートする';

  @override
  String get albumImporterHeaderText => 'フォルダをアルバムとしてインポート';

  @override
  String get albumImporterSubHeaderText =>
      '推奨フォルダは以下に記載されています。サーバー上のファイル数によっては、完了までに時間がかかる場合があります。';

  @override
  String get importButtonLabel => 'インポート';

  @override
  String get albumImporterProgressText => 'フォルダのインポート';

  @override
  String get doneButtonTooltip => '完了';

  @override
  String get editTooltip => '編集';

  @override
  String get editAccountConflictFailureNotification => '同じ設定のアカウントが既に存在します';

  @override
  String get genericProcessingDialogContent => 'お待ち下さい';

  @override
  String get sortTooltip => 'ソート';

  @override
  String get sortOptionDialogTitle => '並べ替え';

  @override
  String get sortOptionTimeAscendingLabel => '古い順';

  @override
  String get sortOptionTimeDescendingLabel => '新着順';

  @override
  String get sortOptionFilenameAscendingLabel => 'ファイル名';

  @override
  String get sortOptionFilenameDescendingLabel => 'ファイル名 (降順)';

  @override
  String get sortOptionAlbumNameLabel => 'アルバム名';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'アルバム名 (降順)';

  @override
  String get sortOptionManualLabel => 'マニュアル';

  @override
  String get albumEditDragRearrangeNotification =>
      'アイテムを長押ししてドラッグすると、手動で並べ替えることができます。';

  @override
  String get albumAddTextTooltip => 'テキストを追加';

  @override
  String get shareTooltip => '共有';

  @override
  String get shareSelectedEmptyNotification => '共有する写真を選択してください';

  @override
  String get shareDownloadingDialogContent => 'ダウンロード中';

  @override
  String get searchTooltip => '検索';

  @override
  String get clearTooltip => 'クリア';

  @override
  String get listNoResultsText => '結果なし';

  @override
  String get listEmptyText => '空';

  @override
  String get albumTrashLabel => 'ゴミ箱';

  @override
  String get restoreTooltip => '復元する';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のアイテムを復元中',
      one: '1個のアイテムを復元中',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification => '全てのアイテムを復元しました';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のアイテムの復元に失敗しました',
      one: '1個のアイテムの復元に失敗しました',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'アイテムを復元しています';

  @override
  String get restoreSuccessNotification => 'アイテムを復元しました';

  @override
  String get restoreFailureNotification => 'アイテムの復元に失敗しました';

  @override
  String get deletePermanentlyTooltip => '完全に削除';

  @override
  String get deletePermanentlyConfirmationDialogTitle => '永久的に削除';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      '選択したアイテムはサーバーから完全に削除されます。この操作はもとに戻せません。';

  @override
  String get albumSharedLabel => '共有';

  @override
  String get metadataTaskProcessingNotification => '画像のメタデータを処理しています';

  @override
  String get configButtonLabel => '設定';

  @override
  String get useAsAlbumCoverTooltip => 'アルバムカバーとして使用';

  @override
  String get helpTooltip => 'ヘルプ';

  @override
  String get helpButtonLabel => 'ヘルプ';

  @override
  String get removeFromAlbumTooltip => 'アルバムから削除';

  @override
  String get changelogTitle => '変更履歴';

  @override
  String get serverCertErrorDialogTitle => 'サーバー証明書を信頼できません';

  @override
  String get serverCertErrorDialogContent =>
      'サーバーがハッキングされているか、誰かがあなたの情報を盗もうとしている可能性があります。';

  @override
  String get advancedButtonLabel => 'アドバンスド';

  @override
  String get whitelistCertDialogTitle => '不明な証明書をホワイトリストに追加しますか?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return '証明書をホワイトリストに登録すると、アプリが証明書を受け入れるようになります。\n警告: これは大きなセキュリティリスクをもたらします。証明書がご自身または信頼できる第三者によって自己署名されていることを確認してください。\n\nホスト: $host\nフィンガープリント: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel => 'リスクを受け入れてホワイトリストに登録';

  @override
  String get fileSharedByDescription => 'このユーザーによってあなたと共有されました';

  @override
  String get emptyTrashbinTooltip => 'ゴミ箱を空にする';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'ゴミ箱を空にする';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      'すべてのアイテムはサーバーから完全に削除されます。この操作は元に戻せません。';

  @override
  String get unsetAlbumCoverTooltip => 'カバーを解除';

  @override
  String get muteTooltip => 'ミュート';

  @override
  String get unmuteTooltip => 'ミュート解除';

  @override
  String get collectionPeopleLabel => '人物';

  @override
  String get slideshowTooltip => 'スライドショー';

  @override
  String get slideshowSetupDialogTitle => 'スライドショーの設定';

  @override
  String get slideshowSetupDialogDurationTitle => '画像の長さ (MM:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'シャッフル';

  @override
  String get slideshowSetupDialogRepeatTitle => '繰り返す';

  @override
  String get slideshowSetupDialogReverseTitle => '反転する';

  @override
  String get linkCopiedNotification => 'リンクをコピーしました';

  @override
  String get shareMethodDialogTitle => '共有';

  @override
  String get shareMethodPreviewTitle => 'プレビュー';

  @override
  String get shareMethodPreviewDescription => '低品質のプレビューを他のアプリと共有する (画像のみ)';

  @override
  String get shareMethodOriginalFileTitle => '元のファイル';

  @override
  String get shareMethodOriginalFileDescription => '元のファイルをダウンロードして他のアプリと共有する';

  @override
  String get shareMethodPublicLinkTitle => '公開リンク';

  @override
  String get shareMethodPublicLinkDescription =>
      'サーバーに新しい公開リンクを作成します。リンクを知っている人はだれでもファイルにアクセスできます。';

  @override
  String get shareMethodPasswordLinkTitle => 'パスワード保護されたリンク';

  @override
  String get shareMethodPasswordLinkDescription =>
      'サーバー上に新しいパスワード保護されたリンクを作成する';

  @override
  String get collectionSharingLabel => '共有';

  @override
  String fileLastSharedDescription(Object date) {
    return '最後に共有された日: $date';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$userさんが$dateに共有しました';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$userさんがこのアルバムを$dateに共有しました';
  }

  @override
  String get sharedWithLabel => '共有相手';

  @override
  String get unshareTooltip => '共有解除';

  @override
  String get unshareSuccessNotification => '共有を解除しました';

  @override
  String get locationLabel => '位置';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloudは複数ファイルの共有リンクをサポートしていません。代わりに、アプリはファイルを新しいフォルダにコピーし、そのフォルダを共有します。';

  @override
  String get folderNameInputHint => 'フォルダ名';

  @override
  String get folderNameInputInvalidEmpty => 'フォルダ名を入力してください';

  @override
  String get folderNameInputInvalidCharacters => '無効な文字が含まれています';

  @override
  String get createShareProgressText => '共有を作成中';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count個のアイテムのコピーに失敗しました',
      one: '1個のアイテムのコピーに失敗しました',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'フォルダを削除しますか？';

  @override
  String get unshareLinkShareDirDialogContent =>
      'このフォルダは、複数のファイルをリンクとして共有するためにアプリによって作成されました。現在、どのパーティとも共有されていません。このフォルダを削除しますか？';

  @override
  String get addToCollectionsViewTooltip => 'コレクションに追加';

  @override
  String get shareAlbumDialogTitle => 'ユーザーと共有';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'アルバムは$userと共有されましたが、一部のファイルの共有に失敗しました';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'アルバムは$userとの共有を解除されましたが、一部のファイルの共有解除に失敗しました';
  }

  @override
  String get fixSharesTooltip => '共有を修正';

  @override
  String get fixTooltip => '修正';

  @override
  String get fixAllTooltip => 'すべて修正';

  @override
  String missingShareDescription(Object user) {
    return '$userと共有されていません';
  }

  @override
  String extraShareDescription(Object user) {
    return '$userと共有済み';
  }

  @override
  String get defaultButtonLabel => 'デフォルト';

  @override
  String get addUserInputHint => 'ユーザーを追加';

  @override
  String get sharedAlbumInfoDialogTitle => '共有アルバムの紹介';

  @override
  String get sharedAlbumInfoDialogContent =>
      '共有アルバムを使用すると、同じサーバー上の複数のユーザーが同じアルバムにアクセスできます。続行する前に、制限事項をよくお読みください';

  @override
  String get learnMoreButtonLabel => '詳細';

  @override
  String get migrateDatabaseProcessingNotification => 'データベースを更新中';

  @override
  String get migrateDatabaseFailureNotification => 'データベースの移行に失敗しました';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count年前',
      one: '1年前',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'ホームフォルダが見つかりません';

  @override
  String get homeFolderNotFoundDialogContent =>
      '以下に示すWebDAV URLを修正してください。URLはNextcloud Webインターフェースで確認できます。';

  @override
  String get homeFolderInputInvalidEmpty => 'ホームフォルダの名前を入力してください';

  @override
  String get createCollectionTooltip => '新しいコレクション';

  @override
  String get createCollectionDialogAlbumLabel2 => 'クライアント側アルバム';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      '追加機能を備えたアルバム、このアプリでのみアクセス可能';

  @override
  String get createCollectionDialogFolderLabel => 'フォルダ';

  @override
  String get createCollectionDialogFolderDescription => 'フォルダ内の写真を表示';

  @override
  String get collectionFavoritesLabel => 'お気に入り';

  @override
  String get favoriteTooltip => 'お気に入りに追加';

  @override
  String get favoriteSuccessNotification => 'お気に入りに追加しました';

  @override
  String get favoriteFailureNotification => 'お気に入りへの追加に失敗しました';

  @override
  String get unfavoriteTooltip => 'お気に入りから削除';

  @override
  String get unfavoriteSuccessNotification => 'お気に入りから削除しました';

  @override
  String get unfavoriteFailureNotification => 'お気に入りからの削除に失敗しました';

  @override
  String get createCollectionDialogTagLabel => 'タグ';

  @override
  String get createCollectionDialogTagDescription => '特定のタグが付いた写真を表示';

  @override
  String get addTagInputHint => 'タグを追加';

  @override
  String get tagPickerNoTagSelectedNotification => '少なくとも1つのタグを追加してください';

  @override
  String get backgroundServiceStopping => 'サービスを停止中';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'バッテリー残量が少なくなっています';

  @override
  String get enhanceTooltip => '補正';

  @override
  String get enhanceButtonLabel => '補正';

  @override
  String get enhanceIntroDialogTitle => '写真を補正';

  @override
  String get enhanceIntroDialogDescription =>
      '写真はデバイス上でローカルに処理されます。デフォルトでは、2048x1536に縮小されます。出力解像度は設定で調整できます';

  @override
  String get enhanceLowLightTitle => '低照度補正';

  @override
  String get enhanceLowLightDescription => '暗い場所で撮影した写真を明るくします';

  @override
  String get enhanceLowLightParamBrightnessLabel => '明るさ';

  @override
  String get collectionEditedPhotosLabel => '編集済み (ローカル)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      '選択したアイテムはこのデバイスから完全に削除されます。\n\nこの操作は元に戻せません';

  @override
  String get enhancePortraitBlurTitle => 'ポートレートぼかし';

  @override
  String get enhancePortraitBlurDescription => '写真の背景をぼかします。ポートレートに最適です';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'ぼかし具合';

  @override
  String get enhanceSuperResolution4xTitle => '超解像 (4x)';

  @override
  String get enhanceSuperResolution4xDescription =>
      '写真を元の解像度の4倍に拡大します (最大解像度の適用方法についてはヘルプを参照してください)';

  @override
  String get enhanceStyleTransferTitle => 'スタイル転送';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'スタイルを選択';

  @override
  String get enhanceStyleTransferStyleDialogDescription => '参照画像のスタイルを写真に転送します';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification => 'スタイルを選択してください';

  @override
  String get enhanceColorPopTitle => 'カラーポップ';

  @override
  String get enhanceColorPopDescription => '写真の背景の彩度を下げます。ポートレートに最適です';

  @override
  String get enhanceGenericParamWeightLabel => '強度';

  @override
  String get enhanceRetouchTitle => '自動レタッチ';

  @override
  String get enhanceRetouchDescription => '写真を自動的にレタッチし、全体的な色と鮮やかさを向上させます';

  @override
  String get doubleTapExitNotification => 'もう一度タップして終了';

  @override
  String get imageEditDiscardDialogTitle => '変更を破棄しますか？';

  @override
  String get imageEditDiscardDialogContent => '変更は保存されていません';

  @override
  String get discardButtonLabel => '破棄';

  @override
  String get saveTooltip => '保存';

  @override
  String get imageEditDownloadDialogTitle => 'サーバーから写真をダウンロード中...';

  @override
  String get imageEditProcessDialogTitle => '写真を処理中...';

  @override
  String get imageEditSaveDialogTitle => '処理した写真を保存中...';

  @override
  String get imageEditColorBrightness => '明るさ';

  @override
  String get imageEditColorContrast => 'コントラスト';

  @override
  String get imageEditColorWhitePoint => 'ホワイトポイント';

  @override
  String get imageEditColorBlackPoint => 'ブラックポイント';

  @override
  String get imageEditColorSaturation => '彩度';

  @override
  String get imageEditColorWarmth => '暖かさ';

  @override
  String get imageEditColorTint => '色合い';

  @override
  String get imageEditTitle => '編集をプレビュー';

  @override
  String get imageEditToolbarColorLabel => '色';

  @override
  String get imageEditToolbarTransformLabel => '変形';

  @override
  String get imageEditTransformOrientation => '向き';

  @override
  String get imageEditTransformOrientationClockwise => '時計回り';

  @override
  String get imageEditTransformOrientationCounterclockwise => '反時計回り';

  @override
  String get imageEditTransformCrop => '切り抜き';

  @override
  String get imageEditToolbarEffectLabel => 'エフェクト';

  @override
  String get imageEditEffectHalftone => '網点';

  @override
  String get imageEditEffectPixelation => 'ピクセル化';

  @override
  String get imageEditEffectPosterization => 'ポスタリゼーション';

  @override
  String get imageEditEffectSketch => 'スケッチ化';

  @override
  String get imageEditEffectToon => '漫画化';

  @override
  String get imageEditEffectFace => '顔';

  @override
  String get imageEditEffectParamEdge => 'エッジ';

  @override
  String get imageEditEffectParamColor => '色';

  @override
  String get imageEditEffectParamHatching => 'ハッチング';

  @override
  String get imageEditEffectParamJawline => 'あごの輪郭';

  @override
  String get imageEditEffectParamEyeSize => '目の大きさ';

  @override
  String get imageEditFaceDetectionRunningMessage => '顔を検出中...';

  @override
  String get imageEditNoFaceDetected => '顔が検出されませんでした';

  @override
  String get imageEditFaceNotSelected => '検出された顔を1つ以上選択してエフェクトを適用してください';

  @override
  String get imageEditResetSelectedFaceMessage =>
      '画像の変形設定を調整した後、選択した顔はクリアされます。お手数ですが、もう一度選択してください';

  @override
  String get imageEditOpenErrorMessage => '写真を読み込むことができません';

  @override
  String get imageEditSaveErrorMessage => '写真を保存できません';

  @override
  String get categoriesLabel => 'カテゴリ';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      '設定を押してフェイスグループ機能の提供元を切り替えるか、ヘルプを押して詳細を確認してください';

  @override
  String get searchLandingCategoryVideosLabel => '動画';

  @override
  String get searchFilterButtonLabel => 'フィルター';

  @override
  String get searchFilterDialogTitle => '検索フィルター';

  @override
  String get applyButtonLabel => '適用';

  @override
  String get searchFilterOptionAnyLabel => 'すべて';

  @override
  String get searchFilterOptionTrueLabel => 'はい';

  @override
  String get searchFilterOptionFalseLabel => 'いいえ';

  @override
  String get searchFilterTypeLabel => '種類';

  @override
  String get searchFilterTypeOptionImageLabel => '画像';

  @override
  String get searchFilterBubbleTypeImageText => '画像';

  @override
  String get searchFilterTypeOptionVideoLabel => '動画';

  @override
  String get searchFilterBubbleTypeVideoText => '動画';

  @override
  String get searchFilterFavoriteLabel => 'お気に入り';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'お気に入り';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'お気に入り以外';

  @override
  String get showAllButtonLabel => 'すべて表示';

  @override
  String gpsPlaceText(Object place) {
    return '$place付近';
  }

  @override
  String get gpsPlaceAboutDialogTitle => '場所について';

  @override
  String get gpsPlaceAboutDialogContent =>
      'ここに表示される場所はおおよその推定であり、正確であることは保証されていません。紛争地域に関する当社の見解を表すものではありません。';

  @override
  String get collectionPlacesLabel => '場所';

  @override
  String get imageSaveOptionDialogTitle => '結果の保存';

  @override
  String get imageSaveOptionDialogContent =>
      '今回および今後の処理済み画像の保存場所を選択してください。サーバーを選択してもアプリがアップロードに失敗した場合、デバイスに保存されます。';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'デバイス';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'サーバー';

  @override
  String get initialSyncMessage => '初めてサーバーと同期しています';

  @override
  String get loopTooltip => 'ループ';

  @override
  String get createCollectionFailureNotification => 'コレクションの作成に失敗しました';

  @override
  String get addItemToCollectionTooltip => 'コレクションに追加';

  @override
  String get addItemToCollectionFailureNotification => 'コレクションへの追加に失敗しました';

  @override
  String get setCollectionCoverFailureNotification => 'コレクションカバーの設定に失敗しました';

  @override
  String get exportCollectionTooltip => 'エクスポート';

  @override
  String get exportCollectionDialogTitle => 'コレクションをエクスポート';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 => 'サーバー側アルバム';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 =>
      'サーバー上にアルバムを作成し、どのアプリからでもアクセス可能';

  @override
  String get removeCollectionsFailedNotification => '一部のコレクションの削除に失敗しました';

  @override
  String get accountSettingsTooltip => 'アカウント設定';

  @override
  String get contributorsTooltip => '貢献者';

  @override
  String get setAsTooltip => '他で使う';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return '$server からサインアウトしようとしています';
  }

  @override
  String get appLockUnlockHint => 'アプリのロックを解除';

  @override
  String get appLockUnlockWrongPassword => 'パスワードが正しくありません';

  @override
  String get enabledText => '有効';

  @override
  String get disabledText => '無効';

  @override
  String get trustedCertManagerPageTitle => '信頼済み証明書';

  @override
  String get trustedCertManagerAlreadyTrustedError => 'すでに信頼されています';

  @override
  String get trustedCertManagerSelectServer => 'HTTPSサーバーを選択';

  @override
  String get trustedCertManagerNoHttpsServerError => '利用可能なサーバーがありません';

  @override
  String get trustedCertManagerFailedToRemoveCertError => '証明書の削除に失敗しました';

  @override
  String get missingVideoThumbnailHelpDialogTitle => '動画のサムネイルに問題がありますか？';

  @override
  String get dontShowAgain => '次回から表示しない';

  @override
  String get mapBrowserDateRangeLabel => '日付範囲';

  @override
  String get mapBrowserDateRangeThisMonth => '今月';

  @override
  String get mapBrowserDateRangePrevMonth => '先月';

  @override
  String get mapBrowserDateRangeThisYear => '今年';

  @override
  String get mapBrowserDateRangeCustom => 'カスタム';

  @override
  String get homeTabMapBrowser => '地図';

  @override
  String get mapBrowserSetDefaultDateRangeButton => 'デフォルトとして設定';

  @override
  String get todayText => '今日';

  @override
  String get livePhotoTooltip => 'Live Photos';

  @override
  String get dragAndDropRearrangeButtons => 'ドラッグ＆ドロップでボタンを並べ替え';

  @override
  String get customizeCollectionsNavBarDescription =>
      'ドラッグ＆ドロップでボタンを並べ替え、上のボタンをタップして最小化します';

  @override
  String get customizeButtonsUnsupportedWarning => 'このボタンはカスタマイズできません';

  @override
  String get placePickerTitle => '場所を選択';

  @override
  String get albumAddMapTooltip => '地図を追加';

  @override
  String get fileNotFound => 'ファイルが見つかりません';

  @override
  String get signInViaNextcloudLoginFlowV2 => 'NextcloudのLogin Flow v2でサインイン';

  @override
  String get signInViaUsernamePassword => 'ユーザー名とパスワードでサインイン';

  @override
  String get fileOnDevice => 'デバイス内';

  @override
  String get fileOnCloud => 'アップロード済み';

  @override
  String get uploadTooltip => 'アップロード';

  @override
  String get uploadFolderPickerTitle => 'アップロード先を選択します';

  @override
  String get opOnlySupportRemoteFiles =>
      'この機能はバックアップ済みの写真のみをサポートします。バックアップされていない写真は無視されます';

  @override
  String get opOnlySupportLocalFiles =>
      'この機能はデバイス内の写真のみをサポートします。サーバー上の写真は無視されます';

  @override
  String get uploadDialogPath => 'アップロード先';

  @override
  String get uploadDialogBatchConvert => '一括変換';

  @override
  String get uploadBatchConvertWarningText1 => '写真は圧縮または変換したのちアップロードされます。';

  @override
  String get uploadBatchConvertWarningText2 =>
      'Live Photosおよびモーションフォトはサポートされておらず、静止画像としてアップロードされます。';

  @override
  String get uploadBatchConvertWarningText3 => '一部のメタデータは変更または削除される場合があります。';

  @override
  String get uploadBatchConvertWarningText4 =>
      'サポートされている画像ファイル形式はJPEG、PNG、WEBP、BMPおよびHEICのみ。';

  @override
  String get uploadBatchConvertSettings => '変換設定';

  @override
  String get uploadBatchConvertSettingsFormat => 'ファイル形式';

  @override
  String get uploadBatchConvertSettingsQuality => '画質';

  @override
  String get uploadBatchConvertSettingsDownscaling => '縮小';

  @override
  String get viewerLastPageText => '最後の写真です';

  @override
  String get deleteMergedFileDialogServerOnlyButton => 'サーバー上のみ';

  @override
  String get deleteMergedFileDialogLocalOnlyButton => 'デバイス内のみ';

  @override
  String get deleteMergedFileDialogBothButton => '両方';

  @override
  String get deleteMergedFileDialogContent =>
      '一部の写真はサーバーとデバイスの両方にあります。これらの写真をどこから削除しますか？';

  @override
  String get deleteSingleMergedFileDialogContent =>
      'この写真はサーバーとデバイスの両方にあります。この写真をどこから削除しますか？';

  @override
  String get collectionAddItemTitle => 'どこに入れますか？';

  @override
  String greetingsMorning(Object user) {
    return '$userさん、おはよう';
  }

  @override
  String greetingsAfternoon(Object user) {
    return '$userさん、こんにちは';
  }

  @override
  String greetingsNight(Object user) {
    return '$userさん、こんばんは';
  }

  @override
  String get recognizeInstructionDialogTitle => 'Recognize連携の設定';

  @override
  String get recognizeInstructionDialogContent =>
      'Nextcloud 33以降でRecognizeアプリと連携するには、サーバーアプリをインストール必要があります。';

  @override
  String get recognizeInstructionDialogButton => '手順へ';

  @override
  String get errorUnauthenticated => '認証されていないアクセスです。問題が解決しない場合は、再度サインインしてください';

  @override
  String get errorDisconnected => '接続できません。サーバーがオフラインか、デバイスが切断されている可能性があります';

  @override
  String get errorLocked => 'ファイルはサーバー上でロックされています。後でもう一度お試しください';

  @override
  String get errorInvalidBaseUrl =>
      '通信できません。アドレスがNextcloudインスタンスのベースURLであることを確認してください';

  @override
  String get errorWrongPassword => '認証できません。ユーザー名とパスワードを再確認してください';

  @override
  String get errorServerError => 'サーバーエラー。サーバーが正しく設定されていることを確認してください';

  @override
  String get errorAlbumDowngrade =>
      'このアルバムは新しいバージョンのアプリで作成されたため、変更できません。アプリを更新して、もう一度お試しください';

  @override
  String get errorNoStoragePermission => 'ストレージアクセス権限が必要です';

  @override
  String get errorServerNoCert => 'サーバー証明書が正しく設定されていません。暗号化されていないHTTPで接続しますか？';
}
