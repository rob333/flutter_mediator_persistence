import 'package:flutter/widgets.dart';

import 'pages/home_page.dart';
import 'pages/login_page.dart';
import 'var.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => onRootRoute(context),
  'home': (_) => const HomePage(),
};

Widget onRootRoute(BuildContext context) {
  if (loginToken.isEmpty) {
    return LoginPage();
  }
  return const HomePage();
}
