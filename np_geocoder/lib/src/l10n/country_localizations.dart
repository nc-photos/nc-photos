import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'country_localizations_ca.dart';
import 'country_localizations_cs.dart';
import 'country_localizations_de.dart';
import 'country_localizations_el.dart';
import 'country_localizations_en.dart';
import 'country_localizations_es.dart';
import 'country_localizations_fi.dart';
import 'country_localizations_fr.dart';
import 'country_localizations_it.dart';
import 'country_localizations_ja.dart';
import 'country_localizations_nl.dart';
import 'country_localizations_pl.dart';
import 'country_localizations_pt.dart';
import 'country_localizations_ru.dart';
import 'country_localizations_sk.dart';
import 'country_localizations_tr.dart';
import 'country_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of CountryLocalizations
/// returned by `CountryLocalizations.of(context)`.
///
/// Applications need to include `CountryLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/country_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: CountryLocalizations.localizationsDelegates,
///   supportedLocales: CountryLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the CountryLocalizations.supportedLocales
/// property.
abstract class CountryLocalizations {
  CountryLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static CountryLocalizations? of(BuildContext context) {
    return Localizations.of<CountryLocalizations>(context, CountryLocalizations);
  }

  static const LocalizationsDelegate<CountryLocalizations> delegate = _CountryLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ca'),
    Locale('cs'),
    Locale('de'),
    Locale('el'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('it'),
    Locale('ja'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ru'),
    Locale('sk'),
    Locale('tr'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant')
  ];

  /// No description provided for @ccAd.
  ///
  /// In en, this message translates to:
  /// **'Andorra'**
  String get ccAd;

  /// No description provided for @ccAe.
  ///
  /// In en, this message translates to:
  /// **'United Arab Emirates'**
  String get ccAe;

  /// No description provided for @ccAf.
  ///
  /// In en, this message translates to:
  /// **'Afghanistan'**
  String get ccAf;

  /// No description provided for @ccAg.
  ///
  /// In en, this message translates to:
  /// **'Antigua & Barbuda'**
  String get ccAg;

  /// No description provided for @ccAi.
  ///
  /// In en, this message translates to:
  /// **'Anguilla'**
  String get ccAi;

  /// No description provided for @ccAl.
  ///
  /// In en, this message translates to:
  /// **'Albania'**
  String get ccAl;

  /// No description provided for @ccAm.
  ///
  /// In en, this message translates to:
  /// **'Armenia'**
  String get ccAm;

  /// No description provided for @ccAo.
  ///
  /// In en, this message translates to:
  /// **'Angola'**
  String get ccAo;

  /// No description provided for @ccAq.
  ///
  /// In en, this message translates to:
  /// **'Antarctica'**
  String get ccAq;

  /// No description provided for @ccAr.
  ///
  /// In en, this message translates to:
  /// **'Argentina'**
  String get ccAr;

  /// No description provided for @ccAs.
  ///
  /// In en, this message translates to:
  /// **'American Samoa'**
  String get ccAs;

  /// No description provided for @ccAt.
  ///
  /// In en, this message translates to:
  /// **'Austria'**
  String get ccAt;

  /// No description provided for @ccAu.
  ///
  /// In en, this message translates to:
  /// **'Australia'**
  String get ccAu;

  /// No description provided for @ccAw.
  ///
  /// In en, this message translates to:
  /// **'Aruba'**
  String get ccAw;

  /// No description provided for @ccAx.
  ///
  /// In en, this message translates to:
  /// **'Åland Islands'**
  String get ccAx;

  /// No description provided for @ccAz.
  ///
  /// In en, this message translates to:
  /// **'Azerbaijan'**
  String get ccAz;

  /// No description provided for @ccBa.
  ///
  /// In en, this message translates to:
  /// **'Bosnia'**
  String get ccBa;

  /// No description provided for @ccBb.
  ///
  /// In en, this message translates to:
  /// **'Barbados'**
  String get ccBb;

  /// No description provided for @ccBd.
  ///
  /// In en, this message translates to:
  /// **'Bangladesh'**
  String get ccBd;

  /// No description provided for @ccBe.
  ///
  /// In en, this message translates to:
  /// **'Belgium'**
  String get ccBe;

  /// No description provided for @ccBf.
  ///
  /// In en, this message translates to:
  /// **'Burkina Faso'**
  String get ccBf;

  /// No description provided for @ccBg.
  ///
  /// In en, this message translates to:
  /// **'Bulgaria'**
  String get ccBg;

  /// No description provided for @ccBh.
  ///
  /// In en, this message translates to:
  /// **'Bahrain'**
  String get ccBh;

  /// No description provided for @ccBi.
  ///
  /// In en, this message translates to:
  /// **'Burundi'**
  String get ccBi;

  /// No description provided for @ccBj.
  ///
  /// In en, this message translates to:
  /// **'Benin'**
  String get ccBj;

  /// No description provided for @ccBl.
  ///
  /// In en, this message translates to:
  /// **'St. Barthélemy'**
  String get ccBl;

  /// No description provided for @ccBm.
  ///
  /// In en, this message translates to:
  /// **'Bermuda'**
  String get ccBm;

  /// No description provided for @ccBn.
  ///
  /// In en, this message translates to:
  /// **'Brunei'**
  String get ccBn;

  /// No description provided for @ccBo.
  ///
  /// In en, this message translates to:
  /// **'Bolivia'**
  String get ccBo;

  /// No description provided for @ccBq.
  ///
  /// In en, this message translates to:
  /// **'Caribbean Netherlands'**
  String get ccBq;

  /// No description provided for @ccBr.
  ///
  /// In en, this message translates to:
  /// **'Brazil'**
  String get ccBr;

  /// No description provided for @ccBs.
  ///
  /// In en, this message translates to:
  /// **'Bahamas'**
  String get ccBs;

  /// No description provided for @ccBt.
  ///
  /// In en, this message translates to:
  /// **'Bhutan'**
  String get ccBt;

  /// No description provided for @ccBv.
  ///
  /// In en, this message translates to:
  /// **'Bouvet Island'**
  String get ccBv;

  /// No description provided for @ccBw.
  ///
  /// In en, this message translates to:
  /// **'Botswana'**
  String get ccBw;

  /// No description provided for @ccBy.
  ///
  /// In en, this message translates to:
  /// **'Belarus'**
  String get ccBy;

  /// No description provided for @ccBz.
  ///
  /// In en, this message translates to:
  /// **'Belize'**
  String get ccBz;

  /// No description provided for @ccCa.
  ///
  /// In en, this message translates to:
  /// **'Canada'**
  String get ccCa;

  /// No description provided for @ccCc.
  ///
  /// In en, this message translates to:
  /// **'Cocos Islands'**
  String get ccCc;

  /// No description provided for @ccCd.
  ///
  /// In en, this message translates to:
  /// **'Congo - Kinshasa'**
  String get ccCd;

  /// No description provided for @ccCf.
  ///
  /// In en, this message translates to:
  /// **'Central African Republic'**
  String get ccCf;

  /// No description provided for @ccCg.
  ///
  /// In en, this message translates to:
  /// **'Congo - Brazzaville'**
  String get ccCg;

  /// No description provided for @ccCh.
  ///
  /// In en, this message translates to:
  /// **'Switzerland'**
  String get ccCh;

  /// No description provided for @ccCi.
  ///
  /// In en, this message translates to:
  /// **'Côte d’Ivoire'**
  String get ccCi;

  /// No description provided for @ccCk.
  ///
  /// In en, this message translates to:
  /// **'Cook Islands'**
  String get ccCk;

  /// No description provided for @ccCl.
  ///
  /// In en, this message translates to:
  /// **'Chile'**
  String get ccCl;

  /// No description provided for @ccCm.
  ///
  /// In en, this message translates to:
  /// **'Cameroon'**
  String get ccCm;

  /// No description provided for @ccCn.
  ///
  /// In en, this message translates to:
  /// **'China'**
  String get ccCn;

  /// No description provided for @ccCo.
  ///
  /// In en, this message translates to:
  /// **'Colombia'**
  String get ccCo;

  /// No description provided for @ccCr.
  ///
  /// In en, this message translates to:
  /// **'Costa Rica'**
  String get ccCr;

  /// No description provided for @ccCu.
  ///
  /// In en, this message translates to:
  /// **'Cuba'**
  String get ccCu;

  /// No description provided for @ccCv.
  ///
  /// In en, this message translates to:
  /// **'Cape Verde'**
  String get ccCv;

  /// No description provided for @ccCw.
  ///
  /// In en, this message translates to:
  /// **'Curaçao'**
  String get ccCw;

  /// No description provided for @ccCx.
  ///
  /// In en, this message translates to:
  /// **'Christmas Island'**
  String get ccCx;

  /// No description provided for @ccCy.
  ///
  /// In en, this message translates to:
  /// **'Cyprus'**
  String get ccCy;

  /// No description provided for @ccCz.
  ///
  /// In en, this message translates to:
  /// **'Czechia'**
  String get ccCz;

  /// No description provided for @ccDe.
  ///
  /// In en, this message translates to:
  /// **'Germany'**
  String get ccDe;

  /// No description provided for @ccDj.
  ///
  /// In en, this message translates to:
  /// **'Djibouti'**
  String get ccDj;

  /// No description provided for @ccDk.
  ///
  /// In en, this message translates to:
  /// **'Denmark'**
  String get ccDk;

  /// No description provided for @ccDm.
  ///
  /// In en, this message translates to:
  /// **'Dominica'**
  String get ccDm;

  /// No description provided for @ccDo.
  ///
  /// In en, this message translates to:
  /// **'Dominican Republic'**
  String get ccDo;

  /// No description provided for @ccDz.
  ///
  /// In en, this message translates to:
  /// **'Algeria'**
  String get ccDz;

  /// No description provided for @ccEc.
  ///
  /// In en, this message translates to:
  /// **'Ecuador'**
  String get ccEc;

  /// No description provided for @ccEe.
  ///
  /// In en, this message translates to:
  /// **'Estonia'**
  String get ccEe;

  /// No description provided for @ccEg.
  ///
  /// In en, this message translates to:
  /// **'Egypt'**
  String get ccEg;

  /// No description provided for @ccEh.
  ///
  /// In en, this message translates to:
  /// **'Western Sahara'**
  String get ccEh;

  /// No description provided for @ccEr.
  ///
  /// In en, this message translates to:
  /// **'Eritrea'**
  String get ccEr;

  /// No description provided for @ccEs.
  ///
  /// In en, this message translates to:
  /// **'Spain'**
  String get ccEs;

  /// No description provided for @ccEt.
  ///
  /// In en, this message translates to:
  /// **'Ethiopia'**
  String get ccEt;

  /// No description provided for @ccFi.
  ///
  /// In en, this message translates to:
  /// **'Finland'**
  String get ccFi;

  /// No description provided for @ccFj.
  ///
  /// In en, this message translates to:
  /// **'Fiji'**
  String get ccFj;

  /// No description provided for @ccFk.
  ///
  /// In en, this message translates to:
  /// **'Falkland Islands'**
  String get ccFk;

  /// No description provided for @ccFm.
  ///
  /// In en, this message translates to:
  /// **'Micronesia'**
  String get ccFm;

  /// No description provided for @ccFo.
  ///
  /// In en, this message translates to:
  /// **'Faroe Islands'**
  String get ccFo;

  /// No description provided for @ccFr.
  ///
  /// In en, this message translates to:
  /// **'France'**
  String get ccFr;

  /// No description provided for @ccGa.
  ///
  /// In en, this message translates to:
  /// **'Gabon'**
  String get ccGa;

  /// No description provided for @ccGb.
  ///
  /// In en, this message translates to:
  /// **'UK'**
  String get ccGb;

  /// No description provided for @ccGd.
  ///
  /// In en, this message translates to:
  /// **'Grenada'**
  String get ccGd;

  /// No description provided for @ccGe.
  ///
  /// In en, this message translates to:
  /// **'Georgia'**
  String get ccGe;

  /// No description provided for @ccGf.
  ///
  /// In en, this message translates to:
  /// **'French Guiana'**
  String get ccGf;

  /// No description provided for @ccGg.
  ///
  /// In en, this message translates to:
  /// **'Guernsey'**
  String get ccGg;

  /// No description provided for @ccGh.
  ///
  /// In en, this message translates to:
  /// **'Ghana'**
  String get ccGh;

  /// No description provided for @ccGi.
  ///
  /// In en, this message translates to:
  /// **'Gibraltar'**
  String get ccGi;

  /// No description provided for @ccGl.
  ///
  /// In en, this message translates to:
  /// **'Greenland'**
  String get ccGl;

  /// No description provided for @ccGm.
  ///
  /// In en, this message translates to:
  /// **'Gambia'**
  String get ccGm;

  /// No description provided for @ccGn.
  ///
  /// In en, this message translates to:
  /// **'Guinea'**
  String get ccGn;

  /// No description provided for @ccGp.
  ///
  /// In en, this message translates to:
  /// **'Guadeloupe'**
  String get ccGp;

  /// No description provided for @ccGq.
  ///
  /// In en, this message translates to:
  /// **'Equatorial Guinea'**
  String get ccGq;

  /// No description provided for @ccGr.
  ///
  /// In en, this message translates to:
  /// **'Greece'**
  String get ccGr;

  /// No description provided for @ccGs.
  ///
  /// In en, this message translates to:
  /// **'South Georgia & South Sandwich Islands'**
  String get ccGs;

  /// No description provided for @ccGt.
  ///
  /// In en, this message translates to:
  /// **'Guatemala'**
  String get ccGt;

  /// No description provided for @ccGu.
  ///
  /// In en, this message translates to:
  /// **'Guam'**
  String get ccGu;

  /// No description provided for @ccGw.
  ///
  /// In en, this message translates to:
  /// **'Guinea-Bissau'**
  String get ccGw;

  /// No description provided for @ccGy.
  ///
  /// In en, this message translates to:
  /// **'Guyana'**
  String get ccGy;

  /// No description provided for @ccHk.
  ///
  /// In en, this message translates to:
  /// **'Hong Kong'**
  String get ccHk;

  /// No description provided for @ccHm.
  ///
  /// In en, this message translates to:
  /// **'Heard & McDonald Islands'**
  String get ccHm;

  /// No description provided for @ccHn.
  ///
  /// In en, this message translates to:
  /// **'Honduras'**
  String get ccHn;

  /// No description provided for @ccHr.
  ///
  /// In en, this message translates to:
  /// **'Croatia'**
  String get ccHr;

  /// No description provided for @ccHt.
  ///
  /// In en, this message translates to:
  /// **'Haiti'**
  String get ccHt;

  /// No description provided for @ccHu.
  ///
  /// In en, this message translates to:
  /// **'Hungary'**
  String get ccHu;

  /// No description provided for @ccId.
  ///
  /// In en, this message translates to:
  /// **'Indonesia'**
  String get ccId;

  /// No description provided for @ccIe.
  ///
  /// In en, this message translates to:
  /// **'Ireland'**
  String get ccIe;

  /// No description provided for @ccIl.
  ///
  /// In en, this message translates to:
  /// **'Israel'**
  String get ccIl;

  /// No description provided for @ccIm.
  ///
  /// In en, this message translates to:
  /// **'Isle of Man'**
  String get ccIm;

  /// No description provided for @ccIn.
  ///
  /// In en, this message translates to:
  /// **'India'**
  String get ccIn;

  /// No description provided for @ccIo.
  ///
  /// In en, this message translates to:
  /// **'British Indian Ocean Territory'**
  String get ccIo;

  /// No description provided for @ccIq.
  ///
  /// In en, this message translates to:
  /// **'Iraq'**
  String get ccIq;

  /// No description provided for @ccIr.
  ///
  /// In en, this message translates to:
  /// **'Iran'**
  String get ccIr;

  /// No description provided for @ccIs.
  ///
  /// In en, this message translates to:
  /// **'Iceland'**
  String get ccIs;

  /// No description provided for @ccIt.
  ///
  /// In en, this message translates to:
  /// **'Italy'**
  String get ccIt;

  /// No description provided for @ccJe.
  ///
  /// In en, this message translates to:
  /// **'Jersey'**
  String get ccJe;

  /// No description provided for @ccJm.
  ///
  /// In en, this message translates to:
  /// **'Jamaica'**
  String get ccJm;

  /// No description provided for @ccJo.
  ///
  /// In en, this message translates to:
  /// **'Jordan'**
  String get ccJo;

  /// No description provided for @ccJp.
  ///
  /// In en, this message translates to:
  /// **'Japan'**
  String get ccJp;

  /// No description provided for @ccKe.
  ///
  /// In en, this message translates to:
  /// **'Kenya'**
  String get ccKe;

  /// No description provided for @ccKg.
  ///
  /// In en, this message translates to:
  /// **'Kyrgyzstan'**
  String get ccKg;

  /// No description provided for @ccKh.
  ///
  /// In en, this message translates to:
  /// **'Cambodia'**
  String get ccKh;

  /// No description provided for @ccKi.
  ///
  /// In en, this message translates to:
  /// **'Kiribati'**
  String get ccKi;

  /// No description provided for @ccKm.
  ///
  /// In en, this message translates to:
  /// **'Comoros'**
  String get ccKm;

  /// No description provided for @ccKn.
  ///
  /// In en, this message translates to:
  /// **'St. Kitts & Nevis'**
  String get ccKn;

  /// No description provided for @ccKp.
  ///
  /// In en, this message translates to:
  /// **'North Korea'**
  String get ccKp;

  /// No description provided for @ccKr.
  ///
  /// In en, this message translates to:
  /// **'South Korea'**
  String get ccKr;

  /// No description provided for @ccKw.
  ///
  /// In en, this message translates to:
  /// **'Kuwait'**
  String get ccKw;

  /// No description provided for @ccKy.
  ///
  /// In en, this message translates to:
  /// **'Cayman Islands'**
  String get ccKy;

  /// No description provided for @ccKz.
  ///
  /// In en, this message translates to:
  /// **'Kazakhstan'**
  String get ccKz;

  /// No description provided for @ccLa.
  ///
  /// In en, this message translates to:
  /// **'Laos'**
  String get ccLa;

  /// No description provided for @ccLb.
  ///
  /// In en, this message translates to:
  /// **'Lebanon'**
  String get ccLb;

  /// No description provided for @ccLc.
  ///
  /// In en, this message translates to:
  /// **'St. Lucia'**
  String get ccLc;

  /// No description provided for @ccLi.
  ///
  /// In en, this message translates to:
  /// **'Liechtenstein'**
  String get ccLi;

  /// No description provided for @ccLk.
  ///
  /// In en, this message translates to:
  /// **'Sri Lanka'**
  String get ccLk;

  /// No description provided for @ccLr.
  ///
  /// In en, this message translates to:
  /// **'Liberia'**
  String get ccLr;

  /// No description provided for @ccLs.
  ///
  /// In en, this message translates to:
  /// **'Lesotho'**
  String get ccLs;

  /// No description provided for @ccLt.
  ///
  /// In en, this message translates to:
  /// **'Lithuania'**
  String get ccLt;

  /// No description provided for @ccLu.
  ///
  /// In en, this message translates to:
  /// **'Luxembourg'**
  String get ccLu;

  /// No description provided for @ccLv.
  ///
  /// In en, this message translates to:
  /// **'Latvia'**
  String get ccLv;

  /// No description provided for @ccLy.
  ///
  /// In en, this message translates to:
  /// **'Libya'**
  String get ccLy;

  /// No description provided for @ccMa.
  ///
  /// In en, this message translates to:
  /// **'Morocco'**
  String get ccMa;

  /// No description provided for @ccMc.
  ///
  /// In en, this message translates to:
  /// **'Monaco'**
  String get ccMc;

  /// No description provided for @ccMd.
  ///
  /// In en, this message translates to:
  /// **'Moldova'**
  String get ccMd;

  /// No description provided for @ccMe.
  ///
  /// In en, this message translates to:
  /// **'Montenegro'**
  String get ccMe;

  /// No description provided for @ccMf.
  ///
  /// In en, this message translates to:
  /// **'St. Martin'**
  String get ccMf;

  /// No description provided for @ccMg.
  ///
  /// In en, this message translates to:
  /// **'Madagascar'**
  String get ccMg;

  /// No description provided for @ccMh.
  ///
  /// In en, this message translates to:
  /// **'Marshall Islands'**
  String get ccMh;

  /// No description provided for @ccMk.
  ///
  /// In en, this message translates to:
  /// **'North Macedonia'**
  String get ccMk;

  /// No description provided for @ccMl.
  ///
  /// In en, this message translates to:
  /// **'Mali'**
  String get ccMl;

  /// No description provided for @ccMm.
  ///
  /// In en, this message translates to:
  /// **'Myanmar'**
  String get ccMm;

  /// No description provided for @ccMn.
  ///
  /// In en, this message translates to:
  /// **'Mongolia'**
  String get ccMn;

  /// No description provided for @ccMo.
  ///
  /// In en, this message translates to:
  /// **'Macao'**
  String get ccMo;

  /// No description provided for @ccMp.
  ///
  /// In en, this message translates to:
  /// **'Northern Mariana Islands'**
  String get ccMp;

  /// No description provided for @ccMq.
  ///
  /// In en, this message translates to:
  /// **'Martinique'**
  String get ccMq;

  /// No description provided for @ccMr.
  ///
  /// In en, this message translates to:
  /// **'Mauritania'**
  String get ccMr;

  /// No description provided for @ccMs.
  ///
  /// In en, this message translates to:
  /// **'Montserrat'**
  String get ccMs;

  /// No description provided for @ccMt.
  ///
  /// In en, this message translates to:
  /// **'Malta'**
  String get ccMt;

  /// No description provided for @ccMu.
  ///
  /// In en, this message translates to:
  /// **'Mauritius'**
  String get ccMu;

  /// No description provided for @ccMv.
  ///
  /// In en, this message translates to:
  /// **'Maldives'**
  String get ccMv;

  /// No description provided for @ccMw.
  ///
  /// In en, this message translates to:
  /// **'Malawi'**
  String get ccMw;

  /// No description provided for @ccMx.
  ///
  /// In en, this message translates to:
  /// **'Mexico'**
  String get ccMx;

  /// No description provided for @ccMy.
  ///
  /// In en, this message translates to:
  /// **'Malaysia'**
  String get ccMy;

  /// No description provided for @ccMz.
  ///
  /// In en, this message translates to:
  /// **'Mozambique'**
  String get ccMz;

  /// No description provided for @ccNa.
  ///
  /// In en, this message translates to:
  /// **'Namibia'**
  String get ccNa;

  /// No description provided for @ccNc.
  ///
  /// In en, this message translates to:
  /// **'New Caledonia'**
  String get ccNc;

  /// No description provided for @ccNe.
  ///
  /// In en, this message translates to:
  /// **'Niger'**
  String get ccNe;

  /// No description provided for @ccNf.
  ///
  /// In en, this message translates to:
  /// **'Norfolk Island'**
  String get ccNf;

  /// No description provided for @ccNg.
  ///
  /// In en, this message translates to:
  /// **'Nigeria'**
  String get ccNg;

  /// No description provided for @ccNi.
  ///
  /// In en, this message translates to:
  /// **'Nicaragua'**
  String get ccNi;

  /// No description provided for @ccNl.
  ///
  /// In en, this message translates to:
  /// **'Netherlands'**
  String get ccNl;

  /// No description provided for @ccNo.
  ///
  /// In en, this message translates to:
  /// **'Norway'**
  String get ccNo;

  /// No description provided for @ccNp.
  ///
  /// In en, this message translates to:
  /// **'Nepal'**
  String get ccNp;

  /// No description provided for @ccNr.
  ///
  /// In en, this message translates to:
  /// **'Nauru'**
  String get ccNr;

  /// No description provided for @ccNu.
  ///
  /// In en, this message translates to:
  /// **'Niue'**
  String get ccNu;

  /// No description provided for @ccNz.
  ///
  /// In en, this message translates to:
  /// **'New Zealand'**
  String get ccNz;

  /// No description provided for @ccOm.
  ///
  /// In en, this message translates to:
  /// **'Oman'**
  String get ccOm;

  /// No description provided for @ccPa.
  ///
  /// In en, this message translates to:
  /// **'Panama'**
  String get ccPa;

  /// No description provided for @ccPe.
  ///
  /// In en, this message translates to:
  /// **'Peru'**
  String get ccPe;

  /// No description provided for @ccPf.
  ///
  /// In en, this message translates to:
  /// **'French Polynesia'**
  String get ccPf;

  /// No description provided for @ccPg.
  ///
  /// In en, this message translates to:
  /// **'Papua New Guinea'**
  String get ccPg;

  /// No description provided for @ccPh.
  ///
  /// In en, this message translates to:
  /// **'Philippines'**
  String get ccPh;

  /// No description provided for @ccPk.
  ///
  /// In en, this message translates to:
  /// **'Pakistan'**
  String get ccPk;

  /// No description provided for @ccPl.
  ///
  /// In en, this message translates to:
  /// **'Poland'**
  String get ccPl;

  /// No description provided for @ccPm.
  ///
  /// In en, this message translates to:
  /// **'St. Pierre & Miquelon'**
  String get ccPm;

  /// No description provided for @ccPn.
  ///
  /// In en, this message translates to:
  /// **'Pitcairn'**
  String get ccPn;

  /// No description provided for @ccPr.
  ///
  /// In en, this message translates to:
  /// **'Puerto Rico'**
  String get ccPr;

  /// No description provided for @ccPs.
  ///
  /// In en, this message translates to:
  /// **'Palestine'**
  String get ccPs;

  /// No description provided for @ccPt.
  ///
  /// In en, this message translates to:
  /// **'Portugal'**
  String get ccPt;

  /// No description provided for @ccPw.
  ///
  /// In en, this message translates to:
  /// **'Palau'**
  String get ccPw;

  /// No description provided for @ccPy.
  ///
  /// In en, this message translates to:
  /// **'Paraguay'**
  String get ccPy;

  /// No description provided for @ccQa.
  ///
  /// In en, this message translates to:
  /// **'Qatar'**
  String get ccQa;

  /// No description provided for @ccRe.
  ///
  /// In en, this message translates to:
  /// **'Réunion'**
  String get ccRe;

  /// No description provided for @ccRo.
  ///
  /// In en, this message translates to:
  /// **'Romania'**
  String get ccRo;

  /// No description provided for @ccRs.
  ///
  /// In en, this message translates to:
  /// **'Serbia'**
  String get ccRs;

  /// No description provided for @ccRu.
  ///
  /// In en, this message translates to:
  /// **'Russia'**
  String get ccRu;

  /// No description provided for @ccRw.
  ///
  /// In en, this message translates to:
  /// **'Rwanda'**
  String get ccRw;

  /// No description provided for @ccSa.
  ///
  /// In en, this message translates to:
  /// **'Saudi Arabia'**
  String get ccSa;

  /// No description provided for @ccSb.
  ///
  /// In en, this message translates to:
  /// **'Solomon Islands'**
  String get ccSb;

  /// No description provided for @ccSc.
  ///
  /// In en, this message translates to:
  /// **'Seychelles'**
  String get ccSc;

  /// No description provided for @ccSd.
  ///
  /// In en, this message translates to:
  /// **'Sudan'**
  String get ccSd;

  /// No description provided for @ccSe.
  ///
  /// In en, this message translates to:
  /// **'Sweden'**
  String get ccSe;

  /// No description provided for @ccSg.
  ///
  /// In en, this message translates to:
  /// **'Singapore'**
  String get ccSg;

  /// No description provided for @ccSh.
  ///
  /// In en, this message translates to:
  /// **'St. Helena'**
  String get ccSh;

  /// No description provided for @ccSi.
  ///
  /// In en, this message translates to:
  /// **'Slovenia'**
  String get ccSi;

  /// No description provided for @ccSj.
  ///
  /// In en, this message translates to:
  /// **'Svalbard & Jan Mayen'**
  String get ccSj;

  /// No description provided for @ccSk.
  ///
  /// In en, this message translates to:
  /// **'Slovakia'**
  String get ccSk;

  /// No description provided for @ccSl.
  ///
  /// In en, this message translates to:
  /// **'Sierra Leone'**
  String get ccSl;

  /// No description provided for @ccSm.
  ///
  /// In en, this message translates to:
  /// **'San Marino'**
  String get ccSm;

  /// No description provided for @ccSn.
  ///
  /// In en, this message translates to:
  /// **'Senegal'**
  String get ccSn;

  /// No description provided for @ccSo.
  ///
  /// In en, this message translates to:
  /// **'Somalia'**
  String get ccSo;

  /// No description provided for @ccSr.
  ///
  /// In en, this message translates to:
  /// **'Suriname'**
  String get ccSr;

  /// No description provided for @ccSs.
  ///
  /// In en, this message translates to:
  /// **'South Sudan'**
  String get ccSs;

  /// No description provided for @ccSt.
  ///
  /// In en, this message translates to:
  /// **'São Tomé & Príncipe'**
  String get ccSt;

  /// No description provided for @ccSv.
  ///
  /// In en, this message translates to:
  /// **'El Salvador'**
  String get ccSv;

  /// No description provided for @ccSx.
  ///
  /// In en, this message translates to:
  /// **'Sint Maarten'**
  String get ccSx;

  /// No description provided for @ccSy.
  ///
  /// In en, this message translates to:
  /// **'Syria'**
  String get ccSy;

  /// No description provided for @ccSz.
  ///
  /// In en, this message translates to:
  /// **'Eswatini'**
  String get ccSz;

  /// No description provided for @ccTc.
  ///
  /// In en, this message translates to:
  /// **'Turks & Caicos Islands'**
  String get ccTc;

  /// No description provided for @ccTd.
  ///
  /// In en, this message translates to:
  /// **'Chad'**
  String get ccTd;

  /// No description provided for @ccTf.
  ///
  /// In en, this message translates to:
  /// **'French Southern Territories'**
  String get ccTf;

  /// No description provided for @ccTg.
  ///
  /// In en, this message translates to:
  /// **'Togo'**
  String get ccTg;

  /// No description provided for @ccTh.
  ///
  /// In en, this message translates to:
  /// **'Thailand'**
  String get ccTh;

  /// No description provided for @ccTj.
  ///
  /// In en, this message translates to:
  /// **'Tajikistan'**
  String get ccTj;

  /// No description provided for @ccTk.
  ///
  /// In en, this message translates to:
  /// **'Tokelau'**
  String get ccTk;

  /// No description provided for @ccTl.
  ///
  /// In en, this message translates to:
  /// **'Timor-Leste'**
  String get ccTl;

  /// No description provided for @ccTm.
  ///
  /// In en, this message translates to:
  /// **'Turkmenistan'**
  String get ccTm;

  /// No description provided for @ccTn.
  ///
  /// In en, this message translates to:
  /// **'Tunisia'**
  String get ccTn;

  /// No description provided for @ccTo.
  ///
  /// In en, this message translates to:
  /// **'Tonga'**
  String get ccTo;

  /// No description provided for @ccTr.
  ///
  /// In en, this message translates to:
  /// **'Türkiye'**
  String get ccTr;

  /// No description provided for @ccTt.
  ///
  /// In en, this message translates to:
  /// **'Trinidad & Tobago'**
  String get ccTt;

  /// No description provided for @ccTv.
  ///
  /// In en, this message translates to:
  /// **'Tuvalu'**
  String get ccTv;

  /// No description provided for @ccTw.
  ///
  /// In en, this message translates to:
  /// **'Taiwan'**
  String get ccTw;

  /// No description provided for @ccTz.
  ///
  /// In en, this message translates to:
  /// **'Tanzania'**
  String get ccTz;

  /// No description provided for @ccUa.
  ///
  /// In en, this message translates to:
  /// **'Ukraine'**
  String get ccUa;

  /// No description provided for @ccUg.
  ///
  /// In en, this message translates to:
  /// **'Uganda'**
  String get ccUg;

  /// No description provided for @ccUm.
  ///
  /// In en, this message translates to:
  /// **'U.S. Outlying Islands'**
  String get ccUm;

  /// No description provided for @ccUs.
  ///
  /// In en, this message translates to:
  /// **'US'**
  String get ccUs;

  /// No description provided for @ccUy.
  ///
  /// In en, this message translates to:
  /// **'Uruguay'**
  String get ccUy;

  /// No description provided for @ccUz.
  ///
  /// In en, this message translates to:
  /// **'Uzbekistan'**
  String get ccUz;

  /// No description provided for @ccVa.
  ///
  /// In en, this message translates to:
  /// **'Vatican City'**
  String get ccVa;

  /// No description provided for @ccVc.
  ///
  /// In en, this message translates to:
  /// **'St. Vincent & Grenadines'**
  String get ccVc;

  /// No description provided for @ccVe.
  ///
  /// In en, this message translates to:
  /// **'Venezuela'**
  String get ccVe;

  /// No description provided for @ccVg.
  ///
  /// In en, this message translates to:
  /// **'British Virgin Islands'**
  String get ccVg;

  /// No description provided for @ccVi.
  ///
  /// In en, this message translates to:
  /// **'U.S. Virgin Islands'**
  String get ccVi;

  /// No description provided for @ccVn.
  ///
  /// In en, this message translates to:
  /// **'Vietnam'**
  String get ccVn;

  /// No description provided for @ccVu.
  ///
  /// In en, this message translates to:
  /// **'Vanuatu'**
  String get ccVu;

  /// No description provided for @ccWf.
  ///
  /// In en, this message translates to:
  /// **'Wallis & Futuna'**
  String get ccWf;

  /// No description provided for @ccWs.
  ///
  /// In en, this message translates to:
  /// **'Samoa'**
  String get ccWs;

  /// No description provided for @ccYe.
  ///
  /// In en, this message translates to:
  /// **'Yemen'**
  String get ccYe;

  /// No description provided for @ccYt.
  ///
  /// In en, this message translates to:
  /// **'Mayotte'**
  String get ccYt;

  /// No description provided for @ccZa.
  ///
  /// In en, this message translates to:
  /// **'South Africa'**
  String get ccZa;

  /// No description provided for @ccZm.
  ///
  /// In en, this message translates to:
  /// **'Zambia'**
  String get ccZm;

  /// No description provided for @ccZw.
  ///
  /// In en, this message translates to:
  /// **'Zimbabwe'**
  String get ccZw;
}

class _CountryLocalizationsDelegate extends LocalizationsDelegate<CountryLocalizations> {
  const _CountryLocalizationsDelegate();

  @override
  Future<CountryLocalizations> load(Locale locale) {
    return SynchronousFuture<CountryLocalizations>(lookupCountryLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['ca', 'cs', 'de', 'el', 'en', 'es', 'fi', 'fr', 'it', 'ja', 'nl', 'pl', 'pt', 'ru', 'sk', 'tr', 'zh'].contains(locale.languageCode);

  @override
  bool shouldReload(_CountryLocalizationsDelegate old) => false;
}

CountryLocalizations lookupCountryLocalizations(Locale locale) {

  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh': {
  switch (locale.scriptCode) {
    case 'Hant': return CountryLocalizationsZhHant();
   }
  break;
   }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca': return CountryLocalizationsCa();
    case 'cs': return CountryLocalizationsCs();
    case 'de': return CountryLocalizationsDe();
    case 'el': return CountryLocalizationsEl();
    case 'en': return CountryLocalizationsEn();
    case 'es': return CountryLocalizationsEs();
    case 'fi': return CountryLocalizationsFi();
    case 'fr': return CountryLocalizationsFr();
    case 'it': return CountryLocalizationsIt();
    case 'ja': return CountryLocalizationsJa();
    case 'nl': return CountryLocalizationsNl();
    case 'pl': return CountryLocalizationsPl();
    case 'pt': return CountryLocalizationsPt();
    case 'ru': return CountryLocalizationsRu();
    case 'sk': return CountryLocalizationsSk();
    case 'tr': return CountryLocalizationsTr();
    case 'zh': return CountryLocalizationsZh();
  }

  throw FlutterError(
    'CountryLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
