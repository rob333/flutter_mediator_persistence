import 'package:flutter/material.dart';

import 'pages/components/bottom_navigation_controller.dart';
import 'pages/home_page.dart';
import 'pages/list_page.dart';
import 'pages/locale_page.dart';
import 'pages/login_page.dart';
import 'pages/scroll_page.dart';
import 'var.dart';

final Map<String, WidgetBuilder> routes = {
  '/': (context) => onRootRoute(context),
};

Widget onRootRoute(BuildContext context) {
  if (loginToken.isEmpty) {
    return LoginPage();
  }

  return BottomNavigationWidget(
    pages: navPages,
    bottomNavItems: bottomNavItems,
    selectedColor: Colors.amber[800]!,
    backgroundColor: Colors.black54.withOpacity(0.5),
    selectedIndex: 0,
  );
}

final bottomNavItems = [
  const BottomNavigationBarItem(
    label: 'Int',
    icon: Icon(Icons.lightbulb_outline),
    activeIcon: Icon(Icons.library_books),
    backgroundColor: Color.fromARGB(0xFF, 0xBD, 0xBD, 0xBD),
  ),
  const BottomNavigationBarItem(
    label: 'List',
    icon: Icon(Icons.new_releases),
    activeIcon: Icon(Icons.payment),
    backgroundColor: Color.fromARGB(0xFF, 0xBD, 0xBD, 0xBD),
  ),
  const BottomNavigationBarItem(
    label: 'Locale',
    icon: Icon(Icons.local_cafe),
    activeIcon: Icon(Icons.local_cafe_outlined),
    backgroundColor: Color.fromARGB(0xFF, 0xBD, 0xBD, 0xBD),
  ),
  const BottomNavigationBarItem(
    label: 'Scroll',
    icon: Icon(Icons.info_outline),
    activeIcon: Icon(Icons.inbox),
    backgroundColor: Color.fromARGB(0xFF, 0xBD, 0xBD, 0xBD),
  ),
];
final navPages = [
  const HomePage(),
  const ListPage(),
  const LocalePage(),
  const ScrollPage(),
];
