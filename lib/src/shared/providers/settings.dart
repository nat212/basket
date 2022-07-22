import 'package:basket/src/shared/extensions.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

class Settings {
  const Settings({
    required this.themeMode,
    required this.autoAddToPantry,
  });

  final ThemeMode themeMode;
  final bool autoAddToPantry;

  Settings copyWith({ThemeMode? themeMode, bool? autoAddToPantry}) {
    return Settings(
        themeMode: themeMode ?? this.themeMode,
        autoAddToPantry: autoAddToPantry ?? this.autoAddToPantry);
  }

  @override
  operator ==(Object other) =>
      identical(this, other) ||
      other is Settings &&
          runtimeType == other.runtimeType &&
          themeMode == other.themeMode && autoAddToPantry == other.autoAddToPantry;

  @override
  int get hashCode => themeMode.hashCode;
}

class SettingsProvider extends ValueNotifier<Settings> {
  static late final SettingsProvider _instance;
  static const _themeModeKey = 'themeMode';
  static const _autoAddToPantryKey = 'autoAddToPantry';

  final Box _box;

  SettingsProvider(this._box, Settings settings) : super(settings);

  static Future<void> initialise() async {
    final box = await Hive.openBox('settings');
    String themeModeStr =
        box.get(_themeModeKey, defaultValue: ThemeMode.system.serialised);
    ThemeMode themeMode =
        ThemeMode.values.firstWhere((mode) => mode.serialised == themeModeStr);
    bool autoAddToPantry = box.get(_autoAddToPantryKey, defaultValue: true);
    final settings = Settings(themeMode: themeMode, autoAddToPantry: autoAddToPantry);
    _instance = SettingsProvider(box, settings);
  }

  static SettingsProvider get instance => _instance;

  static ThemeMode get themeMode => _instance.value.themeMode;
  static bool get autoAddToPantry => _instance.value.autoAddToPantry;

  void setThemeMode(ThemeMode themeMode) {
    _box.put(_themeModeKey, themeMode.serialised);
    value = value.copyWith(themeMode: themeMode);
  }

  void setAutoAddToPantry(bool autoAddToPantry) {
    _box.put(_autoAddToPantryKey, autoAddToPantry);
    value = value.copyWith(autoAddToPantry: autoAddToPantry);
  }
}
