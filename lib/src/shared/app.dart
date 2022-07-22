import 'package:basket/src/shared/providers/settings.dart';
import 'package:basket/src/shared/providers/theme.dart';
import 'package:basket/src/shared/router.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/material.dart';

class BasketApp extends StatefulWidget {
  const BasketApp({Key? key}) : super(key: key);

  @override
  State<BasketApp> createState() => _BasketAppState();
}

class _BasketAppState extends State<BasketApp> {
  final settings = ValueNotifier(ThemeSettings(
      sourceColor: const Color(0xFF006970), themeMode: SettingsProvider.themeMode));

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (lightDynamic, darkDynamic) => ThemeProvider(
            settings: settings,
            lightDynamic: lightDynamic,
            darkDynamic: darkDynamic,
            child: NotificationListener<ThemeSettingsChange>(
                onNotification: (notification) {
                  settings.value = notification.settings;
                  return true;
                },
                child: ValueListenableBuilder<ThemeSettings>(
                    valueListenable: settings,
                    builder: (context, value, _) {
                      final theme = ThemeProvider.of(context);
                      return MaterialApp.router(
                        debugShowCheckedModeBanner: false,
                        title: 'Basket',
                        theme: theme.light(settings.value.sourceColor),
                        darkTheme: theme.dark(settings.value.sourceColor),
                        themeMode: theme.themeMode(),
                        routeInformationParser:
                            appRouter.routeInformationParser,
                        routerDelegate: appRouter.routerDelegate,
                        routeInformationProvider:
                            appRouter.routeInformationProvider,
                      );
                    }))));
  }
}
