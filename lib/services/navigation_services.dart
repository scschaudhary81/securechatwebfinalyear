import 'package:flutter/material.dart';

class NavigationServices {
  static GlobalKey<NavigatorState> navigationKey =
      new GlobalKey<NavigatorState>();

  void popAndNavigateToRoute(String _route) {
    navigationKey.currentState?.popAndPushNamed(_route);
  }

  void navigateToRoute(String _route) {
    navigationKey.currentState?.pushNamed(_route);
  }

  void navigateToPage(Widget _page) {
    navigationKey.currentState
        ?.push(MaterialPageRoute(builder: (ctx) => _page));
  }

  void goBack() {
    navigationKey.currentState?.pop();
  }
}
