import 'package:flutter/material.dart';

extension BreakpointUtils on BoxConstraints {
  bool get isTablet => maxWidth > 730;
  bool get isDesktop => maxWidth > 1200;
  bool get isMobile => !isTablet && !isDesktop;
}

extension HumanReadableName on ThemeMode {
  String get humanReadableName {
    switch (this) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
      default:
        return 'Unknown';
    }
  }
}

extension SerialisedThemeMode on ThemeMode {
  String get serialised {
    switch(this) {
      case ThemeMode.system:
        return 'system';
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
    }
  }
}

extension GetTextThemeFromContext on TextTheme {
  static TextTheme of(BuildContext context) {
    return Theme.of(context).textTheme;
  }
}

extension GetColorSchemeFromContext on ColorScheme {
  static ColorScheme of(BuildContext context) {
    return Theme.of(context).colorScheme;
  }
}