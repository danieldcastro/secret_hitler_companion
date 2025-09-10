import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:secret_hitler_companion/core/utils/flavors/flavors.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    routeInformationParser: Modular.routeInformationParser,
    routerDelegate: Modular.routerDelegate,
    debugShowCheckedModeBanner: false,
    scrollBehavior: const MaterialScrollBehavior().copyWith(
      dragDevices: {
        PointerDeviceKind.mouse,
        PointerDeviceKind.touch,
        PointerDeviceKind.stylus,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.invertedStylus,
      },
    ),
    supportedLocales: const <Locale>[Locale('pt', 'BR')],

    builder: (context, child) => Material(
      child: Scaffold(
        body: Flavors.isQa
            ? Banner(
                message: 'QA',
                textDirection: TextDirection.ltr,
                location: BannerLocation.topEnd,
                child: child,
              )
            : child,
      ),
    ),
  );
}
