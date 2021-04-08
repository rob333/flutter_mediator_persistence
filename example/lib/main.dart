import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/json_decode_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_mediator_persistence/mediator.dart';

import 'route.dart';
import 'theme.dart';
import 'var.dart';

Future<void> main() async {
  //* Step1: initialize the persistent store.
  await globalPersistInit();

  runApp(
    //* Step2: Create the host with `globalHost`
    //* at the top of the widget tree.
    globalHost(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return themeIdx.consume(
      () => MaterialApp(
        title: 'Login to REST server example',
        debugShowCheckedModeBanner: false,
        theme: themeData(themeIdx.value),
        // home: LoginPage(),
        // initialRoute: ,
        routes: routes,
        localizationsDelegates: [
          FlutterI18nDelegate(
            translationLoader: FileTranslationLoader(
              forcedLocale: Locale(locale.value),
              // useCountryCode: true,
              fallbackFile: DefaultLocale,
              basePath: 'assets/flutter_i18n',
              decodeStrategies: [JsonDecodeStrategy()],
            ),
            missingTranslationHandler: (key, locale) {
              print(
                  '--- Missing Key: $key, languageCode: ${locale!.languageCode}');
            },
          ),
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
      ),
    );
  }
}
