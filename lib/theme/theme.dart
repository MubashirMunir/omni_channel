import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../responsive/sizes.dart';

class AppTheme {

  AppTheme._();
  static const Color iconColor = Color(0xff6B7280);

  // =========================================================
  // RESPONSIVE HELPERS
  // =========================================================

  static double responsiveValue(
      BuildContext context, {
        required double mobile,
        double? tablet,
        double? desktop,
      }) {
    if (Responsive.isDesktop(context)) {
      return desktop ?? tablet ?? mobile;
    }

    if (Responsive.isTablet(context)) {
      return tablet ?? mobile;
    }

    return mobile;
  }

  // =========================================================
  // SIZES
  // =========================================================

  static double appBarTitleSize(BuildContext context) =>
      responsiveValue(
        context,
        mobile: 15,
        tablet: 16,
        desktop: 18,
      );

  static double screenTitleSize(BuildContext context) =>
      responsiveValue(
        context,
        mobile: 22,
        tablet: 24,
        desktop: 28,
      );

  static double sectionTitleSize(BuildContext context) =>
      responsiveValue(
        context,
        mobile: 16,
        tablet: 18,
        desktop: 20,
      );

  static double bodyLargeSize(BuildContext context) =>
      responsiveValue(
        context,
        mobile: 14,
        tablet: 15,
        desktop: 16,
      );

  static double bodyMediumSize(BuildContext context) =>
      responsiveValue(
        context,
        mobile: 12,
        tablet: 13,
        desktop: 14,
      );

  static double bodySmallSize(BuildContext context) =>
      responsiveValue(
        context,
        mobile: 10,
        tablet: 11,
        desktop: 12,
      );

  static double buttonTextSize(BuildContext context) =>
      responsiveValue(
        context,
        mobile: 14,
        tablet: 15,
        desktop: 16,
      );

  static double iconSize(BuildContext context) =>
      responsiveValue(
        context,
        mobile: 20,
        tablet: 22,
        desktop: 24,
      );

  static double toolbarHeight(BuildContext context) =>
      responsiveValue(
        context,
        mobile: 56,
        tablet: 60,
        desktop: 64,
      );

  // =========================================================
  // BORDER RADIUS
  // =========================================================

  static double radiusSM(BuildContext context) =>
      responsiveValue(
        context,
        mobile: 10,
        tablet: 12,
        desktop: 14,
      );

  static double radiusMD(BuildContext context) =>
      responsiveValue(
        context,
        mobile: 14,
        tablet: 16,
        desktop: 18,
      );

  static double radiusLG(BuildContext context) =>
      responsiveValue(
        context,
        mobile: 20,
        tablet: 22,
        desktop: 24,
      );

  // =========================================================
  // COLORS
  // =========================================================

  static const Color primaryColor = Color(0xFF2C5591);
  static const Color secondaryColor = Color(0xFF606A85);
  static const Color tealColor = Color(0xFF0FA3B1);

  static const Color white = Colors.white;
  static const Color black = Colors.black;

  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF182234);

  static const Color errorColor = Color(0xFFDC2626);

  static Color textColor = Colors.black.withOpacity(0.7);

  static const Color hintTextColor = Color(0xFF94A3B8);

  // =========================================================
  // GRADIENTS
  // =========================================================

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryColor,
      tealColor,
    ],
  );

  // =========================================================
  // SHADOWS
  // =========================================================

  static final List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 20,
      offset: const Offset(0, 10),
    ),
  ];

  // =========================================================
  // LIGHT TEXT THEME
  // =========================================================

  static TextTheme lightTextTheme(BuildContext context) {
    return ThemeData.light().textTheme.copyWith(
      // =====================================================
      // TITLES
      // =====================================================

      titleLarge: TextStyle(
        fontSize: screenTitleSize(context),
        fontWeight: FontWeight.w700,
        color: black,
      ),

      titleMedium: TextStyle(
        fontSize: sectionTitleSize(context),
        fontWeight: FontWeight.w600,
        color: black,
      ),


      // =====================================================
      // LABELS
      // =====================================================

      bodyLarge: TextStyle(
        fontSize: bodyLargeSize(context),
        fontWeight: FontWeight.w700,
        color: black,
      ),

      bodyMedium: TextStyle(
        fontSize: bodyMediumSize(context),
        fontWeight: FontWeight.w500,
        color: textColor,
      ),

      bodySmall: TextStyle(
        fontSize: bodySmallSize(context),
        fontWeight: FontWeight.w500,
        color: Colors.grey,
      ),
    );
  }

  // =========================================================
  // DARK TEXT THEME
  // =========================================================

  static TextTheme darkTextTheme(BuildContext context) {
    return ThemeData.dark().textTheme.copyWith(
      titleLarge: TextStyle(
        fontSize: screenTitleSize(context),
        fontWeight: FontWeight.w700,
        color: white,
      ),




      bodyLarge: TextStyle(
        fontSize: bodyLargeSize(context),
        fontWeight: FontWeight.w700,
        color: white,
      ),

      bodyMedium: TextStyle(
        fontSize: bodyMediumSize(context),
        fontWeight: FontWeight.w500,
        color: Colors.white70,
      ),

      bodySmall: TextStyle(
        fontSize: bodySmallSize(context),
        fontWeight: FontWeight.w500,
        color: Colors.white54,
      ),
    );
  }

  // =========================================================
  // LIGHT THEME
  // =========================================================

  static ThemeData lightTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      fontFamily: "Roboto",

      scaffoldBackgroundColor: white,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.light,
      ),

      textTheme: lightTextTheme(context),

      // =====================================================
      // APP BAR
      // =====================================================

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: toolbarHeight(context),

        titleTextStyle: TextStyle(
          fontSize: appBarTitleSize(context),
          fontWeight: FontWeight.w600,
          color: black,
        ),

        iconTheme: IconThemeData(
          size: iconSize(context),
          color: black,
        ),
      ),

      // =====================================================
      // CARD
      // =====================================================

      cardTheme: CardThemeData(
        elevation: 0,
        color: white,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.all(
          responsiveValue(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            radiusMD(context),
          ),
        ),
      ),

      // =====================================================
      // INPUT
      // =====================================================

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: white,

        isDense: true,

        contentPadding: EdgeInsets.symmetric(
          horizontal: responsiveValue(
            context,
            mobile: 14,
            tablet: 16,
            desktop: 18,
          ),
          vertical: responsiveValue(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),

        hintStyle: TextStyle(
          fontSize: bodyMediumSize(context),
          color: hintTextColor,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            radiusSM(context),
          ),
          borderSide: BorderSide(
            color: Colors.grey.shade300,
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            radiusSM(context),
          ),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 1.4,
          ),
        ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            radiusSM(context),
          ),
          borderSide: const BorderSide(
            color: errorColor,
          ),
        ),
      ),

      // =====================================================
      // BUTTON
      // =====================================================

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: white,

          minimumSize: Size(
            double.infinity,
            responsiveValue(
              context,
              mobile: 48,
              tablet: 50,
              desktop: 54,
            ),
          ),

          textStyle: TextStyle(
            fontSize: buttonTextSize(context),
            fontWeight: FontWeight.w700,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              radiusSM(context),
            ),
          ),
        ),
      ),

      // =====================================================
      // ICON
      // =====================================================

      iconTheme: IconThemeData(
        size: iconSize(context),
        color: black,
      ),

      // =====================================================
      // DIVIDER
      // =====================================================

      dividerTheme: DividerThemeData(
        thickness: 0.8,
        color: Colors.grey.shade200,
      ),
    );
  }

  // =========================================================
  // DARK THEME
  // =========================================================

  static ThemeData darkTheme(BuildContext context) {
    return ThemeData(
      useMaterial3: true,

      brightness: Brightness.dark,

      fontFamily: "Roboto",

      scaffoldBackgroundColor: darkBg,

      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: Brightness.dark,
      ),

      textTheme: darkTextTheme(context),

      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        scrolledUnderElevation: 0,
        surfaceTintColor: Colors.transparent,
        toolbarHeight: toolbarHeight(context),

        titleTextStyle: TextStyle(
          fontSize: appBarTitleSize(context),
          fontWeight: FontWeight.w600,
          color: white,
        ),

        iconTheme: IconThemeData(
          size: iconSize(context),
          color: white,
        ),
      ),

      cardTheme: CardThemeData(
        elevation: 0,
        color: darkCard,
        surfaceTintColor: Colors.transparent,
        margin: EdgeInsets.all(
          responsiveValue(
            context,
            mobile: 8,
            tablet: 10,
            desktop: 12,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            radiusMD(context),
          ),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: darkCard,

        isDense: true,

        contentPadding: EdgeInsets.symmetric(
          horizontal: responsiveValue(
            context,
            mobile: 14,
            tablet: 16,
            desktop: 18,
          ),
          vertical: responsiveValue(
            context,
            mobile: 12,
            tablet: 14,
            desktop: 16,
          ),
        ),

        hintStyle: TextStyle(
          fontSize: bodyMediumSize(context),
          color: Colors.white54,
        ),

        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            radiusSM(context),
          ),
          borderSide: BorderSide(
            color: Colors.white.withOpacity(0.08),
          ),
        ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            radiusSM(context),
          ),
          borderSide: const BorderSide(
            color: primaryColor,
            width: 1.4,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: primaryColor,
          foregroundColor: white,

          minimumSize: Size(
            double.infinity,
            responsiveValue(
              context,
              mobile: 48,
              tablet: 50,
              desktop: 54,
            ),
          ),

          textStyle: TextStyle(
            fontSize: buttonTextSize(context),
            fontWeight: FontWeight.w700,
          ),

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              radiusSM(context),
            ),
          ),
        ),
      ),

      iconTheme: IconThemeData(
        size: iconSize(context),
        color: white,
      ),

      dividerTheme: DividerThemeData(
        thickness: 0.8,
        color: Colors.white.withOpacity(0.08),
      ),
    );
  }
}