import 'dart:ui';
import 'package:flutter/material.dart';
import '../../core/app_export.dart';

LightCodeColors get appTheme => ThemeHelper().themeColor();

ThemeData get theme => ThemeHelper().themeData();

class ThemeHelper {
  var _appTheme = PrefUtils().getThemeData();

  Map<String, LightCodeColors> _supportedCustomColor = {
    'lightCode': LightCodeColors()
  };

  LightCodeColors _getThemeColors() {
    return _supportedCustomColor[_appTheme] ?? LightCodeColors();
  }

  ThemeData _getThemeData() {
    var generatedColorScheme = ColorScheme.fromSeed(seedColor: Colors.blue);

    // Tùy chỉnh ColorScheme bằng cách sử dụng copyWith để điều chỉnh các màu cụ thể
    var customColorScheme = generatedColorScheme.copyWith(
        // secondaryContainer: Color(0xFF6C757D),
        // onPrimary: Colors.white,
        onPrimaryContainer: Colors.blue[900],
        // background: Color(0xFFFFFFFF)  // Màu nền tùy chỉnh
        );

    return ThemeData(
      useMaterial3: true,
      colorScheme: customColorScheme,
    );
  }

  LightCodeColors themeColor() => _getThemeColors();

  ThemeData themeData() => _getThemeData();
}

class LightCodeColors {
  get blue700 => Colors.blue[700];

  get blue900 => Colors.blue[900];

  get black => Colors.black;

  get white => Colors.white;

  get gray => Colors.grey[700];

  get bg_gray => Colors.grey[100];
}
