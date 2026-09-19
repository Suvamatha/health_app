import 'package:flutter/material.dart';

class AppSpacing {
  AppSpacing._();

  static EdgeInsets screenPadding(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    if (width < 360) {
      return const EdgeInsets.all(16);
    } else if (width < 420) {
      return const EdgeInsets.all(20);
    } else {
      return const EdgeInsets.all(24);
    }
  }
}