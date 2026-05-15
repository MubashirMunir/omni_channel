import 'package:flutter/material.dart';

class Responsive {
  Responsive._();

  static double width(BuildContext context) {
    return MediaQuery.sizeOf(context).width;
  }

  static double height(BuildContext context) {
    return MediaQuery.sizeOf(context).height;
  }

  static bool isMobile(BuildContext context) {
    return width(context) < 700;
  }

  static bool isTablet(BuildContext context) {
    return width(context) >= 700 && width(context) < 1200;
  }

  static bool isDesktop(BuildContext context) {
    return width(context) >= 1200;
  }

  static double value({
    required BuildContext context,
    required double mobile,
    double? tablet,
    double? desktop,
  }) {
    if (isMobile(context)) {
      return mobile;
    }

    if (isTablet(context)) {
      return tablet ?? mobile;
    }

    return desktop ?? tablet ?? mobile;
  }
}