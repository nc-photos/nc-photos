import 'package:flutter/material.dart';
import 'package:np_common/localized_string.dart';
import 'package:np_common/object_util.dart';
import 'package:np_geocoder/np_geocoder.dart';
import 'package:np_geocoder/src/l10n/country_localizations_en.dart';

/// Convert a ISO 3166-1 alpha-2 code into country name
String? alpha2CodeToNameOfLocale(String cc, Locale locale) {
  CountryLocalizations l;
  try {
    l = lookupCountryLocalizations(locale);
  } catch (_) {
    l = CountryLocalizationsEn();
  }
  return _alpha2CodeToName(cc, l);
}

String? alpha2CodeToNameOf(String cc, BuildContext context) {
  return CountryLocalizations.of(context)?.let((l) => _alpha2CodeToName(cc, l));
}

LocalizedString? alpha2CodeToLocalizedName(String cc) {
  final results = <String, String>{};
  for (final l in CountryLocalizations.supportedLocales) {
    final cl = lookupCountryLocalizations(l);
    final name = _alpha2CodeToName(cc, cl);
    if (name == null) {
      continue;
    }
    if (l.scriptCode != null) {
      results["${l.languageCode}-${l.scriptCode!.toLowerCase()}"] = name;
    } else {
      results[l.languageCode] = name;
    }
  }
  return results.isNotEmpty ? LocalizedString(results) : null;
}

String? localizedNameToAlpha2Code(LocalizedString str) {
  final l = CountryLocalizationsEn();
  final s = str.en;
  if (s == l.ccAd) {
    return "AD";
  } else if (s == l.ccAe) {
    return "AE";
  } else if (s == l.ccAf) {
    return "AF";
  } else if (s == l.ccAg) {
    return "AG";
  } else if (s == l.ccAi) {
    return "AI";
  } else if (s == l.ccAl) {
    return "AL";
  } else if (s == l.ccAm) {
    return "AM";
  } else if (s == l.ccAo) {
    return "AO";
  } else if (s == l.ccAq) {
    return "AQ";
  } else if (s == l.ccAr) {
    return "AR";
  } else if (s == l.ccAs) {
    return "AS";
  } else if (s == l.ccAt) {
    return "AT";
  } else if (s == l.ccAu) {
    return "AU";
  } else if (s == l.ccAw) {
    return "AW";
  } else if (s == l.ccAx) {
    return "AX";
  } else if (s == l.ccAz) {
    return "AZ";
  } else if (s == l.ccBa) {
    return "BA";
  } else if (s == l.ccBb) {
    return "BB";
  } else if (s == l.ccBd) {
    return "BD";
  } else if (s == l.ccBe) {
    return "BE";
  } else if (s == l.ccBf) {
    return "BF";
  } else if (s == l.ccBg) {
    return "BG";
  } else if (s == l.ccBh) {
    return "BH";
  } else if (s == l.ccBi) {
    return "BI";
  } else if (s == l.ccBj) {
    return "BJ";
  } else if (s == l.ccBl) {
    return "BL";
  } else if (s == l.ccBm) {
    return "BM";
  } else if (s == l.ccBn) {
    return "BN";
  } else if (s == l.ccBo) {
    return "BO";
  } else if (s == l.ccBq) {
    return "BQ";
  } else if (s == l.ccBr) {
    return "BR";
  } else if (s == l.ccBs) {
    return "BS";
  } else if (s == l.ccBt) {
    return "BT";
  } else if (s == l.ccBv) {
    return "BV";
  } else if (s == l.ccBw) {
    return "BW";
  } else if (s == l.ccBy) {
    return "BY";
  } else if (s == l.ccBz) {
    return "BZ";
  } else if (s == l.ccCa) {
    return "CA";
  } else if (s == l.ccCc) {
    return "CC";
  } else if (s == l.ccCd) {
    return "CD";
  } else if (s == l.ccCf) {
    return "CF";
  } else if (s == l.ccCg) {
    return "CG";
  } else if (s == l.ccCh) {
    return "CH";
  } else if (s == l.ccCi) {
    return "CI";
  } else if (s == l.ccCk) {
    return "CK";
  } else if (s == l.ccCl) {
    return "CL";
  } else if (s == l.ccCm) {
    return "CM";
  } else if (s == l.ccCn) {
    return "CN";
  } else if (s == l.ccCo) {
    return "CO";
  } else if (s == l.ccCr) {
    return "CR";
  } else if (s == l.ccCu) {
    return "CU";
  } else if (s == l.ccCv) {
    return "CV";
  } else if (s == l.ccCw) {
    return "CW";
  } else if (s == l.ccCx) {
    return "CX";
  } else if (s == l.ccCy) {
    return "CY";
  } else if (s == l.ccCz) {
    return "CZ";
  } else if (s == l.ccDe) {
    return "DE";
  } else if (s == l.ccDj) {
    return "DJ";
  } else if (s == l.ccDk) {
    return "DK";
  } else if (s == l.ccDm) {
    return "DM";
  } else if (s == l.ccDo) {
    return "DO";
  } else if (s == l.ccDz) {
    return "DZ";
  } else if (s == l.ccEc) {
    return "EC";
  } else if (s == l.ccEe) {
    return "EE";
  } else if (s == l.ccEg) {
    return "EG";
  } else if (s == l.ccEh) {
    return "EH";
  } else if (s == l.ccEr) {
    return "ER";
  } else if (s == l.ccEs) {
    return "ES";
  } else if (s == l.ccEt) {
    return "ET";
  } else if (s == l.ccFi) {
    return "FI";
  } else if (s == l.ccFj) {
    return "FJ";
  } else if (s == l.ccFk) {
    return "FK";
  } else if (s == l.ccFm) {
    return "FM";
  } else if (s == l.ccFo) {
    return "FO";
  } else if (s == l.ccFr) {
    return "FR";
  } else if (s == l.ccGa) {
    return "GA";
  } else if (s == l.ccGb) {
    return "GB";
  } else if (s == l.ccGd) {
    return "GD";
  } else if (s == l.ccGe) {
    return "GE";
  } else if (s == l.ccGf) {
    return "GF";
  } else if (s == l.ccGg) {
    return "GG";
  } else if (s == l.ccGh) {
    return "GH";
  } else if (s == l.ccGi) {
    return "GI";
  } else if (s == l.ccGl) {
    return "GL";
  } else if (s == l.ccGm) {
    return "GM";
  } else if (s == l.ccGn) {
    return "GN";
  } else if (s == l.ccGp) {
    return "GP";
  } else if (s == l.ccGq) {
    return "GQ";
  } else if (s == l.ccGr) {
    return "GR";
  } else if (s == l.ccGs) {
    return "GS";
  } else if (s == l.ccGt) {
    return "GT";
  } else if (s == l.ccGu) {
    return "GU";
  } else if (s == l.ccGw) {
    return "GW";
  } else if (s == l.ccGy) {
    return "GY";
  } else if (s == l.ccHk) {
    return "HK";
  } else if (s == l.ccHm) {
    return "HM";
  } else if (s == l.ccHn) {
    return "HN";
  } else if (s == l.ccHr) {
    return "HR";
  } else if (s == l.ccHt) {
    return "HT";
  } else if (s == l.ccHu) {
    return "HU";
  } else if (s == l.ccId) {
    return "ID";
  } else if (s == l.ccIe) {
    return "IE";
  } else if (s == l.ccIl) {
    return "IL";
  } else if (s == l.ccIm) {
    return "IM";
  } else if (s == l.ccIn) {
    return "IN";
  } else if (s == l.ccIo) {
    return "IO";
  } else if (s == l.ccIq) {
    return "IQ";
  } else if (s == l.ccIr) {
    return "IR";
  } else if (s == l.ccIs) {
    return "IS";
  } else if (s == l.ccIt) {
    return "IT";
  } else if (s == l.ccJe) {
    return "JE";
  } else if (s == l.ccJm) {
    return "JM";
  } else if (s == l.ccJo) {
    return "JO";
  } else if (s == l.ccJp) {
    return "JP";
  } else if (s == l.ccKe) {
    return "KE";
  } else if (s == l.ccKg) {
    return "KG";
  } else if (s == l.ccKh) {
    return "KH";
  } else if (s == l.ccKi) {
    return "KI";
  } else if (s == l.ccKm) {
    return "KM";
  } else if (s == l.ccKn) {
    return "KN";
  } else if (s == l.ccKp) {
    return "KP";
  } else if (s == l.ccKr) {
    return "KR";
  } else if (s == l.ccKw) {
    return "KW";
  } else if (s == l.ccKy) {
    return "KY";
  } else if (s == l.ccKz) {
    return "KZ";
  } else if (s == l.ccLa) {
    return "LA";
  } else if (s == l.ccLb) {
    return "LB";
  } else if (s == l.ccLc) {
    return "LC";
  } else if (s == l.ccLi) {
    return "LI";
  } else if (s == l.ccLk) {
    return "LK";
  } else if (s == l.ccLr) {
    return "LR";
  } else if (s == l.ccLs) {
    return "LS";
  } else if (s == l.ccLt) {
    return "LT";
  } else if (s == l.ccLu) {
    return "LU";
  } else if (s == l.ccLv) {
    return "LV";
  } else if (s == l.ccLy) {
    return "LY";
  } else if (s == l.ccMa) {
    return "MA";
  } else if (s == l.ccMc) {
    return "MC";
  } else if (s == l.ccMd) {
    return "MD";
  } else if (s == l.ccMe) {
    return "ME";
  } else if (s == l.ccMf) {
    return "MF";
  } else if (s == l.ccMg) {
    return "MG";
  } else if (s == l.ccMh) {
    return "MH";
  } else if (s == l.ccMk) {
    return "MK";
  } else if (s == l.ccMl) {
    return "ML";
  } else if (s == l.ccMm) {
    return "MM";
  } else if (s == l.ccMn) {
    return "MN";
  } else if (s == l.ccMo) {
    return "MO";
  } else if (s == l.ccMp) {
    return "MP";
  } else if (s == l.ccMq) {
    return "MQ";
  } else if (s == l.ccMr) {
    return "MR";
  } else if (s == l.ccMs) {
    return "MS";
  } else if (s == l.ccMt) {
    return "MT";
  } else if (s == l.ccMu) {
    return "MU";
  } else if (s == l.ccMv) {
    return "MV";
  } else if (s == l.ccMw) {
    return "MW";
  } else if (s == l.ccMx) {
    return "MX";
  } else if (s == l.ccMy) {
    return "MY";
  } else if (s == l.ccMz) {
    return "MZ";
  } else if (s == l.ccNa) {
    return "NA";
  } else if (s == l.ccNc) {
    return "NC";
  } else if (s == l.ccNe) {
    return "NE";
  } else if (s == l.ccNf) {
    return "NF";
  } else if (s == l.ccNg) {
    return "NG";
  } else if (s == l.ccNi) {
    return "NI";
  } else if (s == l.ccNl) {
    return "NL";
  } else if (s == l.ccNo) {
    return "NO";
  } else if (s == l.ccNp) {
    return "NP";
  } else if (s == l.ccNr) {
    return "NR";
  } else if (s == l.ccNu) {
    return "NU";
  } else if (s == l.ccNz) {
    return "NZ";
  } else if (s == l.ccOm) {
    return "OM";
  } else if (s == l.ccPa) {
    return "PA";
  } else if (s == l.ccPe) {
    return "PE";
  } else if (s == l.ccPf) {
    return "PF";
  } else if (s == l.ccPg) {
    return "PG";
  } else if (s == l.ccPh) {
    return "PH";
  } else if (s == l.ccPk) {
    return "PK";
  } else if (s == l.ccPl) {
    return "PL";
  } else if (s == l.ccPm) {
    return "PM";
  } else if (s == l.ccPn) {
    return "PN";
  } else if (s == l.ccPr) {
    return "PR";
  } else if (s == l.ccPs) {
    return "PS";
  } else if (s == l.ccPt) {
    return "PT";
  } else if (s == l.ccPw) {
    return "PW";
  } else if (s == l.ccPy) {
    return "PY";
  } else if (s == l.ccQa) {
    return "QA";
  } else if (s == l.ccRe) {
    return "RE";
  } else if (s == l.ccRo) {
    return "RO";
  } else if (s == l.ccRs) {
    return "RS";
  } else if (s == l.ccRu) {
    return "RU";
  } else if (s == l.ccRw) {
    return "RW";
  } else if (s == l.ccSa) {
    return "SA";
  } else if (s == l.ccSb) {
    return "SB";
  } else if (s == l.ccSc) {
    return "SC";
  } else if (s == l.ccSd) {
    return "SD";
  } else if (s == l.ccSe) {
    return "SE";
  } else if (s == l.ccSg) {
    return "SG";
  } else if (s == l.ccSh) {
    return "SH";
  } else if (s == l.ccSi) {
    return "SI";
  } else if (s == l.ccSj) {
    return "SJ";
  } else if (s == l.ccSk) {
    return "SK";
  } else if (s == l.ccSl) {
    return "SL";
  } else if (s == l.ccSm) {
    return "SM";
  } else if (s == l.ccSn) {
    return "SN";
  } else if (s == l.ccSo) {
    return "SO";
  } else if (s == l.ccSr) {
    return "SR";
  } else if (s == l.ccSs) {
    return "SS";
  } else if (s == l.ccSt) {
    return "ST";
  } else if (s == l.ccSv) {
    return "SV";
  } else if (s == l.ccSx) {
    return "SX";
  } else if (s == l.ccSy) {
    return "SY";
  } else if (s == l.ccSz) {
    return "SZ";
  } else if (s == l.ccTc) {
    return "TC";
  } else if (s == l.ccTd) {
    return "TD";
  } else if (s == l.ccTf) {
    return "TF";
  } else if (s == l.ccTg) {
    return "TG";
  } else if (s == l.ccTh) {
    return "TH";
  } else if (s == l.ccTj) {
    return "TJ";
  } else if (s == l.ccTk) {
    return "TK";
  } else if (s == l.ccTl) {
    return "TL";
  } else if (s == l.ccTm) {
    return "TM";
  } else if (s == l.ccTn) {
    return "TN";
  } else if (s == l.ccTo) {
    return "TO";
  } else if (s == l.ccTr) {
    return "TR";
  } else if (s == l.ccTt) {
    return "TT";
  } else if (s == l.ccTv) {
    return "TV";
  } else if (s == l.ccTw) {
    return "TW";
  } else if (s == l.ccTz) {
    return "TZ";
  } else if (s == l.ccUa) {
    return "UA";
  } else if (s == l.ccUg) {
    return "UG";
  } else if (s == l.ccUm) {
    return "UM";
  } else if (s == l.ccUs) {
    return "US";
  } else if (s == l.ccUy) {
    return "UY";
  } else if (s == l.ccUz) {
    return "UZ";
  } else if (s == l.ccVa) {
    return "VA";
  } else if (s == l.ccVc) {
    return "VC";
  } else if (s == l.ccVe) {
    return "VE";
  } else if (s == l.ccVg) {
    return "VG";
  } else if (s == l.ccVi) {
    return "VI";
  } else if (s == l.ccVn) {
    return "VN";
  } else if (s == l.ccVu) {
    return "VU";
  } else if (s == l.ccWf) {
    return "WF";
  } else if (s == l.ccWs) {
    return "WS";
  } else if (s == l.ccYe) {
    return "YE";
  } else if (s == l.ccYt) {
    return "YT";
  } else if (s == l.ccZa) {
    return "ZA";
  } else if (s == l.ccZm) {
    return "ZM";
  } else if (s == l.ccZw) {
    return "ZW";
  } else {
    return null;
  }
}

String? _alpha2CodeToName(String cc, CountryLocalizations l) {
  return switch (cc.toUpperCase()) {
    "AD" => l.ccAd,
    "AE" => l.ccAe,
    "AF" => l.ccAf,
    "AG" => l.ccAg,
    "AI" => l.ccAi,
    "AL" => l.ccAl,
    "AM" => l.ccAm,
    "AO" => l.ccAo,
    "AQ" => l.ccAq,
    "AR" => l.ccAr,
    "AS" => l.ccAs,
    "AT" => l.ccAt,
    "AU" => l.ccAu,
    "AW" => l.ccAw,
    "AX" => l.ccAx,
    "AZ" => l.ccAz,
    "BA" => l.ccBa,
    "BB" => l.ccBb,
    "BD" => l.ccBd,
    "BE" => l.ccBe,
    "BF" => l.ccBf,
    "BG" => l.ccBg,
    "BH" => l.ccBh,
    "BI" => l.ccBi,
    "BJ" => l.ccBj,
    "BL" => l.ccBl,
    "BM" => l.ccBm,
    "BN" => l.ccBn,
    "BO" => l.ccBo,
    "BQ" => l.ccBq,
    "BR" => l.ccBr,
    "BS" => l.ccBs,
    "BT" => l.ccBt,
    "BV" => l.ccBv,
    "BW" => l.ccBw,
    "BY" => l.ccBy,
    "BZ" => l.ccBz,
    "CA" => l.ccCa,
    "CC" => l.ccCc,
    "CD" => l.ccCd,
    "CF" => l.ccCf,
    "CG" => l.ccCg,
    "CH" => l.ccCh,
    "CI" => l.ccCi,
    "CK" => l.ccCk,
    "CL" => l.ccCl,
    "CM" => l.ccCm,
    "CN" => l.ccCn,
    "CO" => l.ccCo,
    "CR" => l.ccCr,
    "CU" => l.ccCu,
    "CV" => l.ccCv,
    "CW" => l.ccCw,
    "CX" => l.ccCx,
    "CY" => l.ccCy,
    "CZ" => l.ccCz,
    "DE" => l.ccDe,
    "DJ" => l.ccDj,
    "DK" => l.ccDk,
    "DM" => l.ccDm,
    "DO" => l.ccDo,
    "DZ" => l.ccDz,
    "EC" => l.ccEc,
    "EE" => l.ccEe,
    "EG" => l.ccEg,
    "EH" => l.ccEh,
    "ER" => l.ccEr,
    "ES" => l.ccEs,
    "ET" => l.ccEt,
    "FI" => l.ccFi,
    "FJ" => l.ccFj,
    "FK" => l.ccFk,
    "FM" => l.ccFm,
    "FO" => l.ccFo,
    "FR" => l.ccFr,
    "GA" => l.ccGa,
    "GB" => l.ccGb,
    "GD" => l.ccGd,
    "GE" => l.ccGe,
    "GF" => l.ccGf,
    "GG" => l.ccGg,
    "GH" => l.ccGh,
    "GI" => l.ccGi,
    "GL" => l.ccGl,
    "GM" => l.ccGm,
    "GN" => l.ccGn,
    "GP" => l.ccGp,
    "GQ" => l.ccGq,
    "GR" => l.ccGr,
    "GS" => l.ccGs,
    "GT" => l.ccGt,
    "GU" => l.ccGu,
    "GW" => l.ccGw,
    "GY" => l.ccGy,
    "HK" => l.ccHk,
    "HM" => l.ccHm,
    "HN" => l.ccHn,
    "HR" => l.ccHr,
    "HT" => l.ccHt,
    "HU" => l.ccHu,
    "ID" => l.ccId,
    "IE" => l.ccIe,
    "IL" => l.ccIl,
    "IM" => l.ccIm,
    "IN" => l.ccIn,
    "IO" => l.ccIo,
    "IQ" => l.ccIq,
    "IR" => l.ccIr,
    "IS" => l.ccIs,
    "IT" => l.ccIt,
    "JE" => l.ccJe,
    "JM" => l.ccJm,
    "JO" => l.ccJo,
    "JP" => l.ccJp,
    "KE" => l.ccKe,
    "KG" => l.ccKg,
    "KH" => l.ccKh,
    "KI" => l.ccKi,
    "KM" => l.ccKm,
    "KN" => l.ccKn,
    "KP" => l.ccKp,
    "KR" => l.ccKr,
    "KW" => l.ccKw,
    "KY" => l.ccKy,
    "KZ" => l.ccKz,
    "LA" => l.ccLa,
    "LB" => l.ccLb,
    "LC" => l.ccLc,
    "LI" => l.ccLi,
    "LK" => l.ccLk,
    "LR" => l.ccLr,
    "LS" => l.ccLs,
    "LT" => l.ccLt,
    "LU" => l.ccLu,
    "LV" => l.ccLv,
    "LY" => l.ccLy,
    "MA" => l.ccMa,
    "MC" => l.ccMc,
    "MD" => l.ccMd,
    "ME" => l.ccMe,
    "MF" => l.ccMf,
    "MG" => l.ccMg,
    "MH" => l.ccMh,
    "MK" => l.ccMk,
    "ML" => l.ccMl,
    "MM" => l.ccMm,
    "MN" => l.ccMn,
    "MO" => l.ccMo,
    "MP" => l.ccMp,
    "MQ" => l.ccMq,
    "MR" => l.ccMr,
    "MS" => l.ccMs,
    "MT" => l.ccMt,
    "MU" => l.ccMu,
    "MV" => l.ccMv,
    "MW" => l.ccMw,
    "MX" => l.ccMx,
    "MY" => l.ccMy,
    "MZ" => l.ccMz,
    "NA" => l.ccNa,
    "NC" => l.ccNc,
    "NE" => l.ccNe,
    "NF" => l.ccNf,
    "NG" => l.ccNg,
    "NI" => l.ccNi,
    "NL" => l.ccNl,
    "NO" => l.ccNo,
    "NP" => l.ccNp,
    "NR" => l.ccNr,
    "NU" => l.ccNu,
    "NZ" => l.ccNz,
    "OM" => l.ccOm,
    "PA" => l.ccPa,
    "PE" => l.ccPe,
    "PF" => l.ccPf,
    "PG" => l.ccPg,
    "PH" => l.ccPh,
    "PK" => l.ccPk,
    "PL" => l.ccPl,
    "PM" => l.ccPm,
    "PN" => l.ccPn,
    "PR" => l.ccPr,
    "PS" => l.ccPs,
    "PT" => l.ccPt,
    "PW" => l.ccPw,
    "PY" => l.ccPy,
    "QA" => l.ccQa,
    "RE" => l.ccRe,
    "RO" => l.ccRo,
    "RS" => l.ccRs,
    "RU" => l.ccRu,
    "RW" => l.ccRw,
    "SA" => l.ccSa,
    "SB" => l.ccSb,
    "SC" => l.ccSc,
    "SD" => l.ccSd,
    "SE" => l.ccSe,
    "SG" => l.ccSg,
    "SH" => l.ccSh,
    "SI" => l.ccSi,
    "SJ" => l.ccSj,
    "SK" => l.ccSk,
    "SL" => l.ccSl,
    "SM" => l.ccSm,
    "SN" => l.ccSn,
    "SO" => l.ccSo,
    "SR" => l.ccSr,
    "SS" => l.ccSs,
    "ST" => l.ccSt,
    "SV" => l.ccSv,
    "SX" => l.ccSx,
    "SY" => l.ccSy,
    "SZ" => l.ccSz,
    "TC" => l.ccTc,
    "TD" => l.ccTd,
    "TF" => l.ccTf,
    "TG" => l.ccTg,
    "TH" => l.ccTh,
    "TJ" => l.ccTj,
    "TK" => l.ccTk,
    "TL" => l.ccTl,
    "TM" => l.ccTm,
    "TN" => l.ccTn,
    "TO" => l.ccTo,
    "TR" => l.ccTr,
    "TT" => l.ccTt,
    "TV" => l.ccTv,
    "TW" => l.ccTw,
    "TZ" => l.ccTz,
    "UA" => l.ccUa,
    "UG" => l.ccUg,
    "UM" => l.ccUm,
    "US" => l.ccUs,
    "UY" => l.ccUy,
    "UZ" => l.ccUz,
    "VA" => l.ccVa,
    "VC" => l.ccVc,
    "VE" => l.ccVe,
    "VG" => l.ccVg,
    "VI" => l.ccVi,
    "VN" => l.ccVn,
    "VU" => l.ccVu,
    "WF" => l.ccWf,
    "WS" => l.ccWs,
    "YE" => l.ccYe,
    "YT" => l.ccYt,
    "ZA" => l.ccZa,
    "ZM" => l.ccZm,
    "ZW" => l.ccZw,
    _ => null,
  };
}
