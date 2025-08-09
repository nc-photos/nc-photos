part of 'service.dart';

/// Access localized string out of the main isolate
@npLog
class _L10n {
  _L10n._();

  factory _L10n() => _inst;

  Future<void> init() async {
    try {
      final locale = language_util.getSelectedLocale();
      if (locale == null) {
        _l10n = await _queryL10n();
      } else {
        _l10n = lookupAppLocalizations(locale);
      }
    } catch (e, stackTrace) {
      _log.shout("[init] Uncaught exception", e, stackTrace);
      _l10n = AppLocalizationsEn();
    }
  }

  static AppLocalizations global() => _L10n()._l10n;

  Future<AppLocalizations> _queryL10n() async {
    try {
      final locale = await Devicelocale.currentAsLocale;
      return lookupAppLocalizations(locale!);
    } on FlutterError catch (_) {
      // unsupported locale, use default (en)
      return AppLocalizationsEn();
    } catch (e, stackTrace) {
      _log.shout(
        "[_queryL10n] Failed while lookupAppLocalizations",
        e,
        stackTrace,
      );
      return AppLocalizationsEn();
    }
  }

  late AppLocalizations _l10n;

  static final _inst = _L10n._();
}
