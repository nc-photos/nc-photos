// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get appTitle => 'Fotoğraflar';

  @override
  String get translator => 'Ali Yasin Yeşilyaprak';

  @override
  String get photosTabLabel => 'Fotoğraflar';

  @override
  String get collectionsTooltip => 'Koleksiyonlar';

  @override
  String get zoomTooltip => 'Yakınlaştır';

  @override
  String get settingsMenuLabel => 'Ayarlar';

  @override
  String selectionAppBarTitle(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count seçildi',
    );
    return '$_temp0';
  }

  @override
  String deleteSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe siliniyor',
      one: '1 öğe siliniyor',
    );
    return '$_temp0';
  }

  @override
  String get deleteSelectedSuccessNotification =>
      'Tüm öğeler başarıyla silindi';

  @override
  String deleteSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe silinemedi',
      one: '1 öğe silinemedi',
    );
    return '$_temp0';
  }

  @override
  String get archiveTooltip => 'Arşiv';

  @override
  String get archiveSelectedSuccessNotification =>
      'Tüm öğeler başarıyla arşivlendi';

  @override
  String archiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe arşivlenemedi',
      one: '1 öğe arşivlenemedi',
    );
    return '$_temp0';
  }

  @override
  String get unarchiveTooltip => 'Arşivden çıkar';

  @override
  String get unarchiveSelectedSuccessNotification =>
      'Tüm öğeler başarıyla arşivden kaldırıldı';

  @override
  String unarchiveSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe arşivden kaldırılamadı',
      one: '1 öğe arşivden kaldırılamadı',
    );
    return '$_temp0';
  }

  @override
  String get deleteTooltip => 'Sil';

  @override
  String get deleteSuccessNotification => 'Öğeler başarıyla silindi';

  @override
  String get deleteFailureNotification => 'Öğeler silinirken bir hata oluştu';

  @override
  String get removeSelectedFromAlbumFailureNotification =>
      'Öğe albümden kaldırılırken bir hata oluştu';

  @override
  String get addServerTooltip => 'Sunucu Ekle';

  @override
  String removeServerSuccessNotification(Object server) {
    return '$server başarıyla kaldırıldı';
  }

  @override
  String get createAlbumTooltip => 'Yeni Albüm';

  @override
  String albumSize(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe',
      one: '1 öğe',
      zero: 'Empty',
    );
    return '$_temp0';
  }

  @override
  String get albumArchiveLabel => 'Arşiv';

  @override
  String connectingToServer(Object server) {
    return '$server\'a\nBağlanılıyor';
  }

  @override
  String get connectingToServer2 =>
      'Sunucu tarafından yetkilendirme bekleniyor';

  @override
  String get connectingToServerInstruction =>
      'Lütfen açılan tarayıcı üzerinden giriş yapın';

  @override
  String get nameInputHint => 'İsim';

  @override
  String get nameInputInvalidEmpty => 'İsim gereklidir';

  @override
  String get skipButtonLabel => 'ATLA';

  @override
  String get confirmButtonLabel => 'ONAYLA';

  @override
  String get signInHeaderText => 'Nextcloud sunucunuzda oturum açın';

  @override
  String get signIn2faHintText =>
      'İki aşamalı doğrulamayı etkinleştirdiyseniz bir uygulama şifresi kullanın';

  @override
  String get signInHeaderText2 => 'Nextcloud\nGiriş Yap';

  @override
  String get serverAddressInputHint => 'Sunucu Adresi';

  @override
  String get serverAddressInputInvalidEmpty => 'Lütfen sunucu adresinizi girin';

  @override
  String get usernameInputHint => 'Kullanıcı adı';

  @override
  String get usernameInputInvalidEmpty => 'Lütfen kullanıcı adınızı girin';

  @override
  String get passwordInputHint => 'Şifre';

  @override
  String get passwordInputInvalidEmpty => 'Lütfen şifrenizi girin';

  @override
  String get rootPickerHeaderText => 'Dahil edilecek klasörleri seçin';

  @override
  String get rootPickerSubHeaderText =>
      'Yalnızca klasörlerin içindeki fotoğraflar gösterilecektir. Tümünü eklemek için Atla\'ya basın';

  @override
  String get rootPickerNavigateUpItemText => '(geri gel)';

  @override
  String get rootPickerUnpickFailureNotification =>
      'Öğenin seçimi kaldırılamadı';

  @override
  String get rootPickerListEmptyNotification =>
      'Lütfen en az bir klasör seçin veya tümünü eklemek için atla tuşuna basın';

  @override
  String get setupWidgetTitle => 'Başlarken';

  @override
  String get setupSettingsModifyLaterHint =>
      'Bu ayarı istediğiniz zaman ayarlardan değiştirebilirsiniz';

  @override
  String get setupHiddenPrefDirNoticeDetail =>
      'Bu uygulama, ayarlarınızı depolamak için Nextcloud sunucusunda bir klasör oluşturur. Bu uygulamayı kaldırmayı planlamıyorsanız lütfen değiştirmeyin veya kaldırmayın';

  @override
  String get settingsWidgetTitle => 'Ayarlar';

  @override
  String get settingsLanguageTitle => 'Dil';

  @override
  String get settingsLanguageOptionSystemDefaultLabel => 'Sistem Varsayılanı';

  @override
  String get settingsMetadataTitle => 'Dosya Üstverisi';

  @override
  String get settingsExifSupportTitle2 => 'Uygulama taraflı EXIF ​​desteği';

  @override
  String get settingsExifSupportTrueSubtitle =>
      'Bu özellik daha fazla ağ kullanımına sebep olabilir';

  @override
  String get settingsFallbackClientExifTitle =>
      'Uygulama tarafı EXIF işleyiciye geri dön';

  @override
  String get settingsFallbackClientExifTrueText =>
      'Nextcloud dosya meta verilerini çıkarmayı başaramazsa, bunun yerine uygulama tarafı işleyiciyi kullanın';

  @override
  String get settingsFallbackClientExifFalseText =>
      'Nextcloud dosya meta verilerini çıkarmayı başaramadıysa olduğu gibi bırakın';

  @override
  String get settingsFallbackClientExifConfirmDialogTitle =>
      'Uygulama tarafı EXIF işleyiciyi etkinleştir?';

  @override
  String get settingsFallbackClientExifConfirmDialogText =>
      'Normalde Nextcloud sunucusu fotoğraflarınızı otomatik olarak işler ve EXIF ​​meta verilerini arka planda depolar. Ancak arka plan görevi yapılandırma sorunu veya sunucu hatası nedeniyle başarısız olabilir. Etkinleştirilirse, bu dosyaları uygulamada işleriz.';

  @override
  String get settingsMemoriesTitle => 'Anılar';

  @override
  String get settingsMemoriesSubtitle => 'Geçmişte çekilen fotoğrafları gör';

  @override
  String get settingsAccountTitle => 'Hesap';

  @override
  String get settingsAccountLabelTitle => 'Başlık';

  @override
  String get settingsAccountLabelDescription =>
      'Sunucu URL\'si yerine gösterilecek bir başlık ayarlayın';

  @override
  String get settingsIncludedFoldersTitle => 'Dahil edilen Klasörler';

  @override
  String get settingsShareFolderTitle => 'Paylaşım Klasörü';

  @override
  String get settingsShareFolderDialogTitle => 'Paylaşım klasörünü bulun';

  @override
  String get settingsShareFolderDialogDescription =>
      'Bu ayar config.php\'de bulunan share_folder parametresine karşılık gelir. Bu iki değer aynı OLMALIDIR.\n\nLütfen config.php dosyasındakiyle aynı şekilde ayarlayın.';

  @override
  String get settingsShareFolderPickerDescription =>
      'Lütfen config.php dosyasındakiyle aynı şekilde ayarlayın. Parametreyi ayarlamadıysanız varsayılana basabilirsiniz.';

  @override
  String get settingsPersonProviderTitle => 'Kişi Sağlayıcısı';

  @override
  String get settingsServerAppSectionTitle => 'Sunucu eklentileri desteği';

  @override
  String get settingsPhotosDescription =>
      'Fotoğraflar sekmesinin içeriklerini özelleştirin';

  @override
  String get settingsMemoriesRangeTitle => 'Anılar aralığı';

  @override
  String settingsMemoriesRangeValueText(num range) {
    String _temp0 = intl.Intl.pluralLogic(
      range,
      locale: localeName,
      other: '+-$range gün',
      one: '+-$range gün',
    );
    return '$_temp0';
  }

  @override
  String get settingsDeviceMediaTitle => 'Cihazdaki medya dosyalarını göster';

  @override
  String get settingsDeviceMediaDescription =>
      'Seçilen klasörler görüntülenecektir';

  @override
  String get settingsViewerTitle => 'Görüntüleyici';

  @override
  String get settingsViewerDescription =>
      'Fotoğraf/Video görüntüleyicinizi Özelleştirin';

  @override
  String get settingsScreenBrightnessTitle => 'Ekran Parlaklığı';

  @override
  String get settingsScreenBrightnessDescription =>
      'Sistem parlaklık düzeyini geçersiz kıl';

  @override
  String get settingsForceRotationTitle => 'Döndürme kilidini yoksay';

  @override
  String get settingsForceRotationDescription =>
      'Bu ayar Otomatik Döndürme ayarı devre dışı olsa dahi ekranı döndürmenizi sağlar';

  @override
  String get settingsMapProviderTitle => 'Harita Sağlayıcısı';

  @override
  String get settingsViewerCustomizeAppBarTitle => 'Altbarı Özelleştir';

  @override
  String get settingsViewerCustomizeBottomAppBarTitle => 'Altbarı Özelleştir';

  @override
  String get settingsShowDateInAlbumTitle =>
      'Fotoğrafları tarihe göre gruplara ayır';

  @override
  String get settingsShowDateInAlbumDescription =>
      'Yalnızca albüm zamana göre sıralandığında uygula';

  @override
  String get settingsCollectionsCustomizeNavigationBarTitle =>
      'Gezinme çubuğunu özelleştir';

  @override
  String get settingsImageEditTitle => 'Editör';

  @override
  String get settingsImageEditDescription =>
      'Görüntü iyileştirmelerini ve görüntü düzenleyiciyi özelleştirin';

  @override
  String get settingsEnhanceMaxResolutionTitle2 =>
      'İyileştirmeler için görüntü çözünürlüğü';

  @override
  String get settingsEnhanceMaxResolutionDescription =>
      'Seçilen çözünürlükten daha büyük fotoğrafların çözünürlüğü otomatik olarak küçültülecektir.\n\nYüksek çözünürlüklü fotoğrafların işlenmesi daha fazla bellek ve zaman gerektirir. Fotoğraflarınızı iyileştirirken uygulama çökerse lütfen bu ayarı düşürün.';

  @override
  String get settingsImageEditSaveResultsToServerTitle =>
      'Düzenlenmiş versiyonu Sunucuya kaydet';

  @override
  String get settingsImageEditSaveResultsToServerTrueDescription =>
      'Düzenlenmiş versiyon sunucuya kaydedilir, başarısız olursa cihaz depolama alanına kaydedilir';

  @override
  String get settingsImageEditSaveResultsToServerFalseDescription =>
      'Düzenlenmiş versiyon bu cihaza kaydedildi';

  @override
  String get settingsThemeTitle => 'Tema';

  @override
  String get settingsThemeDescription => 'Uygulamanın görünümünü özelleştirin';

  @override
  String get settingsFollowSystemThemeTitle => 'Sistem temasını kullan';

  @override
  String get settingsSeedColorTitle => 'Tema rengi';

  @override
  String get settingsSeedColorDescription =>
      'Uygulamada kullanılan tüm renkleri türetmek için kullanılır';

  @override
  String get settingsSeedColorSystemColorDescription => 'Sistem rengini kullan';

  @override
  String get settingsSeedColorPickerTitle => 'Bir renk seçin';

  @override
  String get settingsThemePrimaryColor => 'Birincil';

  @override
  String get settingsThemeSecondaryColor => 'İkincil';

  @override
  String get settingsThemePresets => 'Önayarlar';

  @override
  String get settingsSeedColorPickerSystemColorButtonLabel =>
      'SİSTEM RENGİNİ KULLAN';

  @override
  String get settingsUseBlackInDarkThemeTitle => 'Koyu tema';

  @override
  String get settingsUseBlackInDarkThemeTrueDescription =>
      'Siyah renkli koyu tema kullanın';

  @override
  String get settingsUseBlackInDarkThemeFalseDescription =>
      'Gri renkli koyu tema kullanın';

  @override
  String get settingsMiscellaneousTitle => 'Çeşitli';

  @override
  String get settingsDoubleTapExitTitle => 'Çıkmak için iki kez dokunun';

  @override
  String get settingsPhotosTabSortByNameTitle =>
      'Fotoğrafları dosya ismine göre sırala';

  @override
  String get settingsAppLock => 'Uygulama Kilidi';

  @override
  String get settingsAppLockTypeBiometric => 'Biyometrik';

  @override
  String get settingsAppLockTypePin => 'PIN';

  @override
  String get settingsAppLockTypePassword => 'Şifre';

  @override
  String get settingsAppLockDescription =>
      'Eğer etkinleştirilirse, uygulamayı açtığınızda kimlik doğrulamanız istenecektir. Bu özellik sizi gerçek dünyada gerçekleşen saldırılara karşı korumaz.';

  @override
  String get settingsAppLockSetupBiometricFallbackDialogTitle =>
      'Biyometrik kullanılamıyorsa alternatif seçin';

  @override
  String get settingsAppLockSetupPinDialogTitle =>
      'Uygulamanın kilidini açmak için PIN ayarlayın';

  @override
  String get settingsAppLockConfirmPinDialogTitle => 'PIN\'i tekrar girin';

  @override
  String get settingsAppLockSetupPasswordDialogTitle =>
      'Uygulamanın kilidini açmak için şifre ayarlayın';

  @override
  String get settingsAppLockConfirmPasswordDialogTitle =>
      'Şifreyi tekrar girin';

  @override
  String get settingsViewerUseOriginalImageTitle =>
      'Show original image instead of high quality preview in viewer';

  @override
  String get settingsExperimentalTitle => 'Deneysel';

  @override
  String get settingsExperimentalDescription =>
      'Henüz geliştirme aşamasındaki özellikler';

  @override
  String get settingsExpertTitle => 'Gelişmiş';

  @override
  String get settingsExpertWarningText =>
      'Lütfen devam etmeden önce her seçeneğin ne işe yaradığını tam olarak anladığınızdan emin olun';

  @override
  String get settingsClearCacheDatabaseTitle => 'Dosya veritabanını temizle';

  @override
  String get settingsClearCacheDatabaseDescription =>
      'Önbelleğe alınmış dosya bilgilerini temizler ve sunucu ile tekrar senkronize eder';

  @override
  String get settingsClearCacheDatabaseSuccessNotification =>
      'Veritabanı başarıyla temizlendi. Uygulamayı yeniden başlatmanız tavsiye edilir';

  @override
  String get settingsManageTrustedCertificateTitle =>
      'Güvenilen Sertifikaları Yönet';

  @override
  String get settingsUseNewHttpEngine => 'Yeni HTTP işleyiciyi kullan';

  @override
  String get settingsUseNewHttpEngineDescription =>
      'HTTP/2* ve HTTP/3 QUIC* gibi yeni HTTP standartlarını destekleyen Chromium tabanlı HTTP işleyicisi.\n\nLimitler:\nKendinden imzalı sertifikalar tarafımızca yönetilemez. CA sertifikalarınızı çalışmaları için sistem güven deposuna içe aktarmanız gerekir.\n\n* HTTP/2 ve HTTP/3 için HTTPS gereklidir';

  @override
  String get settingsAboutSectionTitle => 'Hakkında';

  @override
  String get settingsVersionTitle => 'Sürüm';

  @override
  String get settingsServerVersionTitle => 'Sunucu';

  @override
  String get settingsSourceCodeTitle => 'Kaynak Kodu';

  @override
  String get settingsBugReportTitle => 'Hata Bildir';

  @override
  String get settingsCaptureLogsTitle => 'Kayıtları İncele';

  @override
  String get settingsCaptureLogsDescription =>
      'Geliştiricilerin hataları teşhis etmesine yardımcı olun';

  @override
  String get settingsTranslatorTitle => 'Çeviren';

  @override
  String get settingsRestartNeededDialog =>
      'Değişiklikleri uygulamak için lütfen uygulamayı yeniden başlatın';

  @override
  String get writePreferenceFailureNotification =>
      'Yapılandırma klasörü değiştirilemedi';

  @override
  String get enableButtonLabel => 'ETKİNLEŞTİR';

  @override
  String get enableButtonLabel2 => 'Enable';

  @override
  String get exifSupportNextcloud28Notes =>
      'Bu işlem uygulama tarafı desteği sunucunuza kurar. Uygulama, Nextcloud tarafından desteklenmeyen dosyaları ve öznitelikleri işleyecektir';

  @override
  String get exifSupportConfirmationDialogTitle2 =>
      'İstemci tarafı EXIF ​​desteğini etkinleştir';

  @override
  String get captureLogDetails =>
      'Bir hata raporuna yönelik günlükleri almak için:\n\n1. Bu ayarı etkinleştirin\n2. Sorunu tekrar yaşayın\n3. Bu ayarı devre dışı bırakın\n4. İndirme klasöründe nc-photos.log dosyasını arayın\n\n*Sorun uygulamanın çökmesine neden oluyorsa günlük kaydı gerçekleştirilemez. Böyle bir durumda farklı yöntemler için lütfen geliştiricilerle iletişime geçin';

  @override
  String get captureLogSuccessNotification => 'Kayıtlar başarıyla kaydedildi';

  @override
  String get doneButtonLabel => 'TAMAMLA';

  @override
  String get nextButtonLabel => 'İLERİ';

  @override
  String get connectButtonLabel => 'BAĞLAN';

  @override
  String get rootPickerSkipConfirmationDialogContent2 =>
      'Tüm dosyalarınız dahil edilecektir. Bu, bellek kullanımını artırabilir ve performansı düşürebilir';

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
  String get detailsTooltip => 'Detaylar';

  @override
  String get downloadTooltip => 'İndir';

  @override
  String get downloadProcessingNotification => 'Dosya indiriliyor';

  @override
  String get downloadSuccessNotification => 'Dosya başarıyla indirildi';

  @override
  String get downloadFailureNotification => 'Dosya indirilemedi';

  @override
  String get nextTooltip => 'İleri';

  @override
  String get previousTooltip => 'Geri';

  @override
  String get webSelectRangeNotification =>
      'Aradakilerin hepsini seçmek için Shift tuşunu basılı tutun ardından + tıklayın';

  @override
  String get mobileSelectRangeNotification =>
      'Aradaki tüm öğeleri seçmek için başka bir öğeye uzun basın';

  @override
  String get updateDateTimeDialogTitle => 'Tarih ve saati düzenle';

  @override
  String get dateSubtitle => 'Tarih';

  @override
  String get timeSubtitle => 'Saat';

  @override
  String get dateYearInputHint => 'Yıl';

  @override
  String get dateMonthInputHint => 'Ay';

  @override
  String get dateDayInputHint => 'Gün';

  @override
  String get timeHourInputHint => 'Saat';

  @override
  String get timeMinuteInputHint => 'Dakika';

  @override
  String get timeSecondInputHint => 'Saniye';

  @override
  String get dateTimeInputInvalid => 'Geçersiz Değer';

  @override
  String get updateDateTimeFailureNotification =>
      'Tarih ve saat değiştirilemedi';

  @override
  String get albumDirPickerHeaderText =>
      'Albümle ilişkilendirilecek klasörleri seçin';

  @override
  String get albumDirPickerSubHeaderText =>
      'Bu albüme yalnızca eklediğiniz klasörlerdeki fotoğraflar dahil edilecek';

  @override
  String get albumDirPickerListEmptyNotification =>
      'Lütfen en az bir klasör seçin';

  @override
  String get importFoldersTooltip => 'Klasörleri içe aktar';

  @override
  String get albumImporterHeaderText => 'Klasörleri albüme ekle';

  @override
  String get albumImporterSubHeaderText =>
      'Önerilen klasörler aşağıda listelenmiştir. Sunucunuzdaki dosya sayısına bağlı olarak tamamlanması biraz zaman alabilir';

  @override
  String get importButtonLabel => 'İÇE AKTAR';

  @override
  String get albumImporterProgressText => 'Klasörler içe aktarılıyor';

  @override
  String get doneButtonTooltip => 'Bitir';

  @override
  String get editTooltip => 'Düzenle';

  @override
  String get editAccountConflictFailureNotification =>
      'Bu ayarlara sahip başka bir hesap zaten mevcut';

  @override
  String get genericProcessingDialogContent => 'Lütfen bekleyin';

  @override
  String get sortTooltip => 'Sırala';

  @override
  String get sortOptionDialogTitle => 'Şuna göre sırala';

  @override
  String get sortOptionTimeAscendingLabel => 'Eskiden yeniye';

  @override
  String get sortOptionTimeDescendingLabel => 'Yeniden eskiye';

  @override
  String get sortOptionFilenameAscendingLabel => 'Dosya ismi';

  @override
  String get sortOptionFilenameDescendingLabel => 'Dosya adı (azalan)';

  @override
  String get sortOptionAlbumNameLabel => 'Albüm İsmi';

  @override
  String get sortOptionAlbumNameDescendingLabel => 'Albüm İsmi (azalan)';

  @override
  String get sortOptionManualLabel => 'Manuel';

  @override
  String get albumEditDragRearrangeNotification =>
      'Bir öğeyi manuel olarak yeniden düzenlemek için uzun basın ve sürükleyin';

  @override
  String get albumAddTextTooltip => 'Yazı Ekle';

  @override
  String get shareTooltip => 'Paylaş';

  @override
  String get shareSelectedEmptyNotification =>
      'Paylaşılacak fotoğrafları seçin';

  @override
  String get shareDownloadingDialogContent => 'İndiriliyor';

  @override
  String get searchTooltip => 'Ara';

  @override
  String get clearTooltip => 'Temizle';

  @override
  String get listNoResultsText => 'Sonuç Yok';

  @override
  String get listEmptyText => 'Boş';

  @override
  String get albumTrashLabel => 'Çöp';

  @override
  String get restoreTooltip => 'Geri Yükle';

  @override
  String restoreSelectedProcessingNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe geri yükleniyor',
      one: '1 öğe geri yükleniyor',
    );
    return '$_temp0';
  }

  @override
  String get restoreSelectedSuccessNotification => 'Tüm öğeler geri yüklendi';

  @override
  String restoreSelectedFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe geri yüklenemedi',
      one: '1 öğe geri yüklenemedi',
    );
    return '$_temp0';
  }

  @override
  String get restoreProcessingNotification => 'Öğe geri yükleniyor';

  @override
  String get restoreSuccessNotification => 'Öğe geri yüklendi';

  @override
  String get restoreFailureNotification => 'Öğe geri yüklenemedi';

  @override
  String get deletePermanentlyTooltip => 'Kalıcı olarak sil';

  @override
  String get deletePermanentlyConfirmationDialogTitle => 'Kalıcı olarak sil';

  @override
  String get deletePermanentlyConfirmationDialogContent =>
      'Seçili öğeler sunucudan kalıcı olarak silinecek.\n\nBu işlem geri alınamaz';

  @override
  String get albumSharedLabel => 'Paylaşılan';

  @override
  String get metadataTaskProcessingNotification =>
      'Görüntü üst verileri arka planda işleniyor';

  @override
  String get configButtonLabel => 'YAPILANDIRMA';

  @override
  String get useAsAlbumCoverTooltip => 'Albüm kapağı olarak kullan';

  @override
  String get helpTooltip => 'Yardım';

  @override
  String get helpButtonLabel => 'YARDIM';

  @override
  String get removeFromAlbumTooltip => 'Albümden Kaldır';

  @override
  String get changelogTitle => 'Değişiklik Günlüğü';

  @override
  String get serverCertErrorDialogTitle => 'Sunucu sertifikası güvenilir değil';

  @override
  String get serverCertErrorDialogContent =>
      'Sunucu saldırıya uğramış olabilir veya birisi bilgilerinizi çalmaya çalışıyor olabilir';

  @override
  String get advancedButtonLabel => 'GELİŞMİŞ';

  @override
  String get whitelistCertDialogTitle =>
      'Bilinmeyen sertifika beyaz listeye alınsın mı?';

  @override
  String whitelistCertDialogContent(Object host, Object fingerprint) {
    return 'Uygulamanın kabul etmesini sağlamak için sertifikayı beyaz listeye ekleyebilirsiniz. UYARI: Bu büyük bir güvenlik riski oluşturur. Sertifikanın sizin tarafınızdan veya güvenilir bir tarafça imzalandığından emin olun\n\nAnabilgisayar: $host\nParmak izi: $fingerprint';
  }

  @override
  String get whitelistCertButtonLabel =>
      'RİSKLERİ KABUL ET VE BEYAZ LİSTEYE EKLE';

  @override
  String get fileSharedByDescription =>
      'Bu kullanıcı tarafından sizinle paylaşıldı';

  @override
  String get emptyTrashbinTooltip => 'Çöpü Boşalt';

  @override
  String get emptyTrashbinConfirmationDialogTitle => 'Çöpü Boşalt';

  @override
  String get emptyTrashbinConfirmationDialogContent =>
      'Tüm öğeler sunucudan kalıcı olarak silinecek.\n\nBu işlem geri alınamaz';

  @override
  String get unsetAlbumCoverTooltip => 'Kapağı kaldır';

  @override
  String get muteTooltip => 'Sesi Kapat';

  @override
  String get unmuteTooltip => 'Sesi Aç';

  @override
  String get collectionPeopleLabel => 'Kişiler';

  @override
  String get slideshowTooltip => 'Slayt Gösterisi';

  @override
  String get slideshowSetupDialogTitle => 'Slayt gösterisini ayarla';

  @override
  String get slideshowSetupDialogDurationTitle => 'Görüntü süresi (DD:SS)';

  @override
  String get slideshowSetupDialogShuffleTitle => 'Karıştır';

  @override
  String get slideshowSetupDialogRepeatTitle => 'Döngü';

  @override
  String get slideshowSetupDialogReverseTitle => 'Tersten';

  @override
  String get linkCopiedNotification => 'Bağlantı kopyalandı';

  @override
  String get shareMethodDialogTitle => 'Paylaş';

  @override
  String get shareMethodPreviewTitle => 'Önizle';

  @override
  String get shareMethodPreviewDescription =>
      'Düşük kaliteli bir önizlemeyi diğer uygulamalarla paylaşın (yalnızca resimlerde desteklenir)';

  @override
  String get shareMethodOriginalFileTitle => 'Orjinal Dosya';

  @override
  String get shareMethodOriginalFileDescription =>
      'Orijinal dosyayı indirin ve diğer uygulamalarla paylaşın';

  @override
  String get shareMethodPublicLinkTitle => 'Herkese açık bağlantı';

  @override
  String get shareMethodPublicLinkDescription =>
      'Sunucuda herkese açık bağlantı oluşturun. Bağlantıya sahip olan herkes dosyaya erişebilir';

  @override
  String get shareMethodPasswordLinkTitle => 'Şifre korumalı bağlantı';

  @override
  String get shareMethodPasswordLinkDescription =>
      'Sunucuda yeni bir parola korumalı bağlantı oluşturun';

  @override
  String get collectionSharingLabel => 'Paylaşılmakta';

  @override
  String fileLastSharedDescription(Object date) {
    return 'Son paylaşım $date tarihinde gerçekleşti';
  }

  @override
  String fileLastSharedByOthersDescription(Object user, Object date) {
    return '$user sizinle $date tarihinde paylaştı';
  }

  @override
  String albumLastSharedByOthersDescription(Object user, Object date) {
    return '$user, $date tarihinde sizinle bir albüm paylaştı';
  }

  @override
  String get sharedWithLabel => 'Paylaşılanlar';

  @override
  String get unshareTooltip => 'Paylaşımı durdur';

  @override
  String get unshareSuccessNotification => 'Paylaşım durduruldu';

  @override
  String get locationLabel => 'Konum';

  @override
  String get multipleFilesLinkShareDialogContent =>
      'Nextcloud üzerinde birden fazla dosya tek paylaşım bağlantısı ile desteklenmemektedir. Uygulama bunun yerine dosyaları yeni bir klasöre KOPYALAYACAK ve bunun yerine klasörü paylaşacaktır.';

  @override
  String get folderNameInputHint => 'Klasör İsmi';

  @override
  String get folderNameInputInvalidEmpty => 'Lütfen klasör ismi girin';

  @override
  String get folderNameInputInvalidCharacters =>
      'Geçersiz karakterler içeriyor';

  @override
  String get createShareProgressText => 'Paylaşım oluşturuluyor';

  @override
  String copyItemsFailureNotification(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count öğe kopyalanamadı',
      one: '1 öğe kopyalanamadı',
    );
    return '$_temp0';
  }

  @override
  String get unshareLinkShareDirDialogTitle => 'Klasörü Sil?';

  @override
  String get unshareLinkShareDirDialogContent =>
      'Bu klasör, uygulama tarafından birden fazla dosyayı bağlantı ile paylaşmak için oluşturuldu. Artık hiç kimse ile paylaşılmıyor, Bu klasörü silmek istiyor musunuz?';

  @override
  String get addToCollectionsViewTooltip => 'Koleksiyonlara Ekle';

  @override
  String get shareAlbumDialogTitle => 'Başka biriyle paylaş';

  @override
  String shareAlbumSuccessWithErrorNotification(Object user) {
    return 'Albüm $user ile paylaşıldı ancak bazı dosyalar paylaşılamadı';
  }

  @override
  String unshareAlbumSuccessWithErrorNotification(Object user) {
    return 'Albümün $user ile paylaşımı durduruldu, ancak bazı dosyaların paylaşımı iptal edilemedi';
  }

  @override
  String get fixSharesTooltip => 'Paylaşımı Düzelt';

  @override
  String get fixTooltip => 'Düzelt';

  @override
  String get fixAllTooltip => 'Tümünü Düzelt';

  @override
  String missingShareDescription(Object user) {
    return '$user ile paylaşılmıyor';
  }

  @override
  String extraShareDescription(Object user) {
    return '$user ile paylaşılıyor';
  }

  @override
  String get defaultButtonLabel => 'VARSAYILAN';

  @override
  String get addUserInputHint => 'Kullanıcı Ekle';

  @override
  String get sharedAlbumInfoDialogTitle => 'Albüm Paylaşımıyla tanışın';

  @override
  String get sharedAlbumInfoDialogContent =>
      'Albüm Paylaşımı----------------------------------------------------------------------------------------------------------, aynı sunucudaki birden fazla kullanıcının aynı albüme erişmesine olanak tanır. Devam etmeden önce lütfen sınırlamaları dikkatlice okuyun';

  @override
  String get learnMoreButtonLabel => 'DAHA FAZLA';

  @override
  String get migrateDatabaseProcessingNotification =>
      'Veritabanı güncelleniyor';

  @override
  String get migrateDatabaseFailureNotification =>
      'Veritabanı güncellemesi başarısız oldu';

  @override
  String memoryAlbumName(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count yıl önce',
      one: '1 yıl önce',
    );
    return '$_temp0';
  }

  @override
  String get homeFolderNotFoundDialogTitle => 'Ana dizin bulunamadı';

  @override
  String get homeFolderNotFoundDialogContent =>
      'Lütfen aşağıda gösterilen WebDAV URL\'sini düzeltin. URL\'yi Nextcloud web arayüzünde bulabilirsiniz.';

  @override
  String get homeFolderInputInvalidEmpty =>
      'Lütfen ana dizininizin adını girin';

  @override
  String get createCollectionTooltip => 'Yeni Koleksiyon';

  @override
  String get createCollectionDialogAlbumLabel2 => 'Uygulama tarafı Albüm';

  @override
  String get createCollectionDialogAlbumDescription2 =>
      'Sadece bu uygulama ile erişilebilen, ekstra özelliklere sahip albüm desteği';

  @override
  String get createCollectionDialogFolderLabel => 'Klasör';

  @override
  String get createCollectionDialogFolderDescription =>
      'Fotoğrafları bir klasör içinde göster';

  @override
  String get collectionFavoritesLabel => 'Favoriler';

  @override
  String get favoriteTooltip => 'Favorilere Ekle';

  @override
  String get favoriteSuccessNotification => 'Favorilere eklendi';

  @override
  String get favoriteFailureNotification => 'Favorilere eklenemedi';

  @override
  String get unfavoriteTooltip => 'Favorilerden Çıkar';

  @override
  String get unfavoriteSuccessNotification => 'Favorilerden çıkarıldı';

  @override
  String get unfavoriteFailureNotification => 'Favorilerden çıkarılamadı';

  @override
  String get createCollectionDialogTagLabel => 'Etiket';

  @override
  String get createCollectionDialogTagDescription =>
      'Fotoğrafları belirli etiketlerle göster';

  @override
  String get addTagInputHint => 'Etiket Ekle';

  @override
  String get tagPickerNoTagSelectedNotification =>
      'Lütfen en az 1 etiket ekleyin';

  @override
  String get backgroundServiceStopping => 'Servis durduruluyor';

  @override
  String get metadataTaskPauseLowBatteryNotification => 'Batarya zayıf';

  @override
  String get enhanceTooltip => 'İyileştir';

  @override
  String get enhanceButtonLabel => 'İYİLEŞTİR';

  @override
  String get enhanceIntroDialogTitle => 'Fotoğrafları iyileştir';

  @override
  String get enhanceIntroDialogDescription =>
      'Fotoğraflarınız cihazınızda yerel olarak işlenir. Varsayılan olarak 2048x1536 boyutundadır. Bu çözünürlüğü Ayarlar\'dan ayarlayabilirsiniz';

  @override
  String get enhanceLowLightTitle => 'Düşük ışık iyileştirmesi';

  @override
  String get enhanceLowLightDescription =>
      'Düşük ışıklı ortamlarda çekilen fotoğraflarınızı parlaklaştırır';

  @override
  String get enhanceLowLightParamBrightnessLabel => 'Parlaklık';

  @override
  String get collectionEditedPhotosLabel => 'Düzenlendi (Yerel)';

  @override
  String get deletePermanentlyLocalConfirmationDialogContent =>
      'Seçilen öğeler bu cihazdan kalıcı olarak silinecek.\n\nBu işlem geri alınamaz';

  @override
  String get enhancePortraitBlurTitle => 'Portre bulanıklığı';

  @override
  String get enhancePortraitBlurDescription =>
      'Fotoğraflarınızın arka planını bulanıklaştırır, portrelerde en iyi sonucu sağlar';

  @override
  String get enhancePortraitBlurParamBlurLabel => 'Parlaklık';

  @override
  String get enhanceSuperResolution4xTitle => 'Süper-çözünürlük (4x)';

  @override
  String get enhanceSuperResolution4xDescription =>
      'Fotoğraflarınızı orijinal çözünürlüğünün 4 katına kadar yükseltin (maksimum çözünürlüğün nasıl uygulandığına ilişkin ayrıntılar için Yardım\'a bakın)';

  @override
  String get enhanceStyleTransferTitle => 'Stil transferi';

  @override
  String get enhanceStyleTransferStyleDialogTitle => 'Bir stil seç';

  @override
  String get enhanceStyleTransferStyleDialogDescription =>
      'Görüntü stilini referans görselden fotoğraflarınıza aktarın';

  @override
  String get enhanceStyleTransferNoStyleSelectedNotification =>
      'Lütfen bir stil seçin';

  @override
  String get enhanceColorPopTitle => 'Renk doygunluğu';

  @override
  String get enhanceColorPopDescription =>
      'Fotoğraflarınızın arka plan doygunluğunu gidererek portrelerde en iyi sonucu alın';

  @override
  String get enhanceGenericParamWeightLabel => 'Ağırlık';

  @override
  String get enhanceRetouchTitle => 'Otomatik iyileştir';

  @override
  String get enhanceRetouchDescription =>
      'Fotoğraflarınıza otomatik olarak iyileştirin, genel rengi ve canlılığı iyileştirin';

  @override
  String get doubleTapExitNotification => 'Çıkmak için tekrar dokunun';

  @override
  String get imageEditDiscardDialogTitle => 'Değişiklikleri sil?';

  @override
  String get imageEditDiscardDialogContent => 'Değişiklikleriniz kaydedilmedi';

  @override
  String get discardButtonLabel => 'İPTAL';

  @override
  String get saveTooltip => 'Kaydet';

  @override
  String get imageEditDownloadDialogTitle => 'Downloading image from server...';

  @override
  String get imageEditProcessDialogTitle => 'Processing image...';

  @override
  String get imageEditSaveDialogTitle => 'Saving result...';

  @override
  String get imageEditColorBrightness => 'Parlaklık';

  @override
  String get imageEditColorContrast => 'Kontrast';

  @override
  String get imageEditColorWhitePoint => 'Beyaz nokta';

  @override
  String get imageEditColorBlackPoint => 'Siyah nokta';

  @override
  String get imageEditColorSaturation => 'Doygunluk';

  @override
  String get imageEditColorWarmth => 'Sıcaklık';

  @override
  String get imageEditColorTint => 'Ton';

  @override
  String get imageEditTitle => 'Değişikliklere göz at';

  @override
  String get imageEditToolbarColorLabel => 'Renk';

  @override
  String get imageEditToolbarTransformLabel => 'Dönüştür';

  @override
  String get imageEditTransformOrientation => 'Yön';

  @override
  String get imageEditTransformOrientationClockwise => 'cw';

  @override
  String get imageEditTransformOrientationCounterclockwise => 'ccw';

  @override
  String get imageEditTransformCrop => 'Kırp';

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
  String get categoriesLabel => 'Kategoriler';

  @override
  String get searchLandingPeopleListEmptyText2 =>
      'Sağlayıcıyı değiştirmek için ayarlara basın veya daha fazla bilgi edinmek için yardıma basın';

  @override
  String get searchLandingCategoryVideosLabel => 'Videolar';

  @override
  String get searchFilterButtonLabel => 'FİLTRELER';

  @override
  String get searchFilterDialogTitle => 'Filtre Ara';

  @override
  String get applyButtonLabel => 'UYGULA';

  @override
  String get searchFilterOptionAnyLabel => 'Herhangi biri';

  @override
  String get searchFilterOptionTrueLabel => 'Doğru';

  @override
  String get searchFilterOptionFalseLabel => 'Yanlış';

  @override
  String get searchFilterTypeLabel => 'Tür';

  @override
  String get searchFilterTypeOptionImageLabel => 'Fotoğraf';

  @override
  String get searchFilterBubbleTypeImageText => 'fotoğraflar';

  @override
  String get searchFilterTypeOptionVideoLabel => 'Video';

  @override
  String get searchFilterBubbleTypeVideoText => 'Videolar';

  @override
  String get searchFilterFavoriteLabel => 'Favori';

  @override
  String get searchFilterBubbleFavoriteTrueText => 'favoriler';

  @override
  String get searchFilterBubbleFavoriteFalseText => 'favoride olmayanlar';

  @override
  String get showAllButtonLabel => 'TÜMÜNÜ GÖSTER';

  @override
  String gpsPlaceText(Object place) {
    return '$place yakını';
  }

  @override
  String get gpsPlaceAboutDialogTitle => 'Yer Hakkında';

  @override
  String get gpsPlaceAboutDialogContent =>
      'Burada gösterilen yer tahminidir ve doğruluğu garanti edilemez. Herhangi bir yere ilişkin görüşlerimizi temsil etmemektedir.';

  @override
  String get collectionPlacesLabel => 'Yerler';

  @override
  String get imageSaveOptionDialogTitle => 'Sonuçların Kaydı';

  @override
  String get imageSaveOptionDialogContent =>
      'Bu ve gelecekte işlenecek görüntülerin nereye kaydedileceğini seçin. Sunucuyu seçtiyseniz ancak uygulama bunu yükleyemediyse cihazınıza kaydedilecektir.';

  @override
  String get imageSaveOptionDialogDeviceButtonLabel => 'CİHAZ';

  @override
  String get imageSaveOptionDialogServerButtonLabel => 'SUNUCU';

  @override
  String get initialSyncMessage =>
      'İlk kurulum için senkronizasyon gerçekleşiyor';

  @override
  String get loopTooltip => 'DÖNGÜ';

  @override
  String get createCollectionFailureNotification => 'Koleksiyon oluşturulamadı';

  @override
  String get addItemToCollectionTooltip => 'Koleksiyona Ekle';

  @override
  String get addItemToCollectionFailureNotification => 'Koleksiyona eklenemedi';

  @override
  String get setCollectionCoverFailureNotification =>
      'Koleksiyon kapağı ayarlanamadı';

  @override
  String get exportCollectionTooltip => 'Dışa Aktar';

  @override
  String get exportCollectionDialogTitle => 'Koleksiyonu Dışa Aktar';

  @override
  String get createCollectionDialogNextcloudAlbumLabel2 =>
      'Sunucu tarafı Albüm';

  @override
  String get createCollectionDialogNextcloudAlbumDescription2 =>
      'Sunucunuzda herhangi bir uygulama ile erişilebilen bir albüm oluşturun';

  @override
  String get removeCollectionsFailedNotification =>
      'Bazı koleksiyonlar kaldırılamadı';

  @override
  String get accountSettingsTooltip => 'Hesap Ayarları';

  @override
  String get contributorsTooltip => 'Katkıda bulunanlar';

  @override
  String get setAsTooltip => 'Ayarla';

  @override
  String deleteAccountConfirmDialogText(Object server) {
    return '$server oturumunuz kapatılıyor';
  }

  @override
  String get appLockUnlockHint => 'Uygulamanın kilidini açın';

  @override
  String get appLockUnlockWrongPassword => 'Yanlış Şifre';

  @override
  String get enabledText => 'Etkin';

  @override
  String get disabledText => 'Devre Dışı';

  @override
  String get trustedCertManagerPageTitle => 'Güvenilen Sertifikalar';

  @override
  String get trustedCertManagerAlreadyTrustedError => 'Zaten güveniliyor';

  @override
  String get trustedCertManagerSelectServer => 'Bir HTTPS sunucu seçin';

  @override
  String get trustedCertManagerNoHttpsServerError =>
      'Kullanılabilir sunucu bulunamadı';

  @override
  String get trustedCertManagerFailedToRemoveCertError =>
      'Sertifika kaldırılırken bir hata oluştu';

  @override
  String get missingVideoThumbnailHelpDialogTitle =>
      'Video önizlemeleriyle ilgili sorun mu yaşıyorsunuz?';

  @override
  String get dontShowAgain => 'Tekrar gösterme';

  @override
  String get mapBrowserDateRangeLabel => 'Tarih aralığı';

  @override
  String get mapBrowserDateRangeThisMonth => 'Bu ay';

  @override
  String get mapBrowserDateRangePrevMonth => 'Önceki ay';

  @override
  String get mapBrowserDateRangeThisYear => 'Bu Yıl';

  @override
  String get mapBrowserDateRangeCustom => 'Özel';

  @override
  String get homeTabMapBrowser => 'Harita';

  @override
  String get mapBrowserSetDefaultDateRangeButton => 'Varsayılan olarak ayarla';

  @override
  String get todayText => 'Bugün';

  @override
  String get livePhotoTooltip => 'Canlı fotoğraf';

  @override
  String get dragAndDropRearrangeButtons =>
      'Düğmeleri yeniden sıralamak için sürükleyin';

  @override
  String get customizeCollectionsNavBarDescription =>
      'Düğmeleri yeniden sıralamak için sürükleyin, yazıyı gizlemek için düğmelere dokunabilirsiniz';

  @override
  String get customizeButtonsUnsupportedWarning => 'Bu buton özelleştirilemez';

  @override
  String get placePickerTitle => 'Bir yer seçin';

  @override
  String get albumAddMapTooltip => 'Konum ekle';

  @override
  String get fileNotFound => 'Dosya bulunamadı';

  @override
  String get signInViaNextcloudLoginFlowV2 =>
      'Nextcloud Flow v2 aracılığıyla giriş yap';

  @override
  String get signInViaUsernamePassword => 'Kullanıcı adı ve şifreyle giriş yap';

  @override
  String get fileOnDevice => 'Cihazda';

  @override
  String get fileOnCloud => 'Bulutta';

  @override
  String get uploadTooltip => 'Yükle';

  @override
  String get uploadFolderPickerTitle => 'Yükle:';

  @override
  String get opOnlySupportRemoteFiles =>
      'Bu özellik yalnızca Nextcloud sunucunuzdaki dosyaları destekler. Seçilen yerel dosyalar yok sayılır.';

  @override
  String get opOnlySupportLocalFiles =>
      'Bu özellik sadece cihazınızdaki yerel dosyaları destekler. Seçilen buluttaki dosyalar yok sayılır.';

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
      'Erişim kimliğiniz doğrulanamadı. Sorun devam ederse lütfen tekrar oturum açın';

  @override
  String get errorDisconnected =>
      'Bağlantı başarısız. Sunucu çevrimdışı olabilir veya cihazınızın bağlantısı kesilmiş olabilir';

  @override
  String get errorLocked =>
      'Dosya sunucuda kilitli. Lütfen daha sonra tekrar deneyiniz';

  @override
  String get errorInvalidBaseUrl =>
      'Bağlantı kurulamıyor. Lütfen adresin Nextcloud sunucunuzun temel URL\'si olduğundan emin olun';

  @override
  String get errorWrongPassword =>
      'Kimlik doğrulaması yapılamıyor. Lütfen kullanıcı adınızı ve şifrenizi tekrar kontrol edin';

  @override
  String get errorServerError =>
      'Bir sunucu hatası oluştu. Lütfen sunucunun doğru kurulduğundan emin olun';

  @override
  String get errorAlbumDowngrade =>
      'Bu uygulamanın daha sonraki bir sürümü tarafından oluşturulduğu için bu albüm değiştirilemiyor. Lütfen uygulamayı güncelleyin ve tekrar deneyin';

  @override
  String get errorNoStoragePermission => 'Depolama erişimi gerekiyor';

  @override
  String get errorServerNoCert =>
      'Sunucu sertifikası bulunamadı. Bunun yerine HTTP denemek ister misiniz?';
}
