import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:nttcs/localization/en_us/en_us_translations.dart';
import 'package:nttcs/localization/vi/vi_translations.dart';
import '../core/app_export.dart';

extension LocalizationExtension on String {
  String get tr => AppLocatization.of().getString(this);
}

class AppLocatization {
  Locale locale;

  AppLocatization(this.locale);

  static final Map<String, Map<String, String>> _localizedValues = {
    'vi': vi,
    'en': enUs,
  };

  static AppLocatization of() {
    return Localizations.of(
        NavigatorService.navigatorKey.currentContext!, AppLocatization);
  }

  static List<String> languages() => _localizedValues.keys.toList();

  String getString(String text) =>
      _localizedValues[locale.languageCode]![text] ?? text;
}

class AppLocalizationDelegate extends LocalizationsDelegate<AppLocatization> {
  const AppLocalizationDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppLocatization.languages().contains(locale.languageCode);

  @override
  Future<AppLocatization> load(Locale locale) {
    return SynchronousFuture<AppLocatization>(AppLocatization(locale));
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocatization> old) =>
      false;
}
