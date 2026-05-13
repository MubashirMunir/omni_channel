import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AppTheme {
  // =========================================================
  // SIZES
  // =========================================================
  static const double appBarTitleSize = 16;
  static const double screenTitleSize = 24;
  static const double sectionTitleSize = 18;
  static const double bodyLargeSize = 16;
  static const double bodyMediumSize = 14;
  static const double bodySmallSize = 12;
  static const double buttonTextSize = 15;
  static const double inputTextSize = 15;
  static const double hintTextSize = 14;
  static const double iconSize = 22;
  static const double smallIconSize = 20;
  static const double toolbarHeight = 56;
  static const double listTileMinHeight = 56;

  static const double radiusXS = 8;
  static const double radiusSM = 15;
  static const double radiusMD = 10;
  static const double radiusLG = 22;
  static const double radiusXL = 28;

  static const double contentPaddingH = 14;
  static const double contentPaddingV = 12;

  // =========================================================
  // BRAND COLORS
  // =========================================================
  static const Color primaryColor = Color(0xFF2C5591);
  static const Color secondaryColor = Color(0xFF606A85);
  static const Color tealColor = Color(0xFF0FA3B1);

  static const Color cupertinoWhite = Color(0xFFFFFFFF);
  static const Color darkBg = Color(0xFF0F172A);
  static const Color darkCard = Color(0xFF182234);
  static final Color borderColor = Colors.white.withOpacity(0.12);
  static const Color darkBorderColor = Color(0xFF253247);
  static Color textColor = Colors.black.withOpacity(0.65);

  static const Color hintTextColor = Color(0xFF94A3B8);
  static const Color darkHintTextColor = Color(0xFF8B9BB4);

  // static const Color successColor = Color(0xFF16A34A);
  static const Color errorColor = Color(0xFFDC2626);
  static const Color approveColor = Colors.green;
  static const Color warningColor = Color(0xFFF59E0B);

  // =========================================================
  // GRADIENTS
  // =========================================================
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, tealColor],
  );

  static const LinearGradient tealBlueGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, tealColor],
  );

  static const LinearGradient premiumCardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, tealColor],
  );

  static const LinearGradient darkCardGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [primaryColor, tealColor],
  );

  static const LinearGradient successGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, tealColor],
  );

  static const LinearGradient errorGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primaryColor, tealColor],
  );

  static LinearGradient cardGradient(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    return isDarkMode ? darkCardGradient : premiumCardGradient;
  }

  // static LinearGradient statusGradient(BuildContext context, bool isSuccess) {
  //   final isDarkMode = Theme.of(context).brightness == Brightness.dark;
  //
  //   if (isDarkMode) {
  //     return isSuccess
  //         ? const LinearGradient(
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //       colors: [primaryColor, tealColor],
  //
  //     )
  //         : const LinearGradient(
  //             begin: Alignment.topLeft,
  //             end: Alignment.bottomRight,
  //       colors: [primaryColor, tealColor],
  //
  //     );
  //   }
  //
  //   return isSuccess ? successGradient : errorGradient;
  // }

  static LinearGradient getSelectedItemGradient(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return isDarkMode
        ? const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [primaryColor, tealColor],
          )
        : primaryGradient;
  }

  static Color getNavItemBackground(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return isDarkMode
        ? Colors.white.withOpacity(0.08)
        : primaryColor.withOpacity(0.10);
  }

  static Color getTopBorderColor(BuildContext context) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    return theme.dividerTheme.color ??
        (isDarkMode
            ? Colors.white.withOpacity(0.10)
            : Colors.black.withOpacity(0.08));
  }

  static bool isDark(BuildContext context) {
    return Theme.of(context).brightness == Brightness.dark;
  }

  // =========================================================
  // SHADOWS
  // =========================================================
  static final List<BoxShadow> softShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 24,
      spreadRadius: 0,
      offset: const Offset(0, 10),
    ),
    BoxShadow(
      color: Colors.black.withOpacity(0.02),
      blurRadius: 8,
      spreadRadius: 0,
      offset: const Offset(0, 4),
    ),
  ];

  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withOpacity(0.05),
      blurRadius: 30,
      spreadRadius: -2,
      offset: const Offset(0, 14),
    ),
    BoxShadow(
      color: Colors.white.withOpacity(0.7),
      blurRadius: 10,
      spreadRadius: 0,
      offset: const Offset(0, -2),
    ),
  ];

  static final List<BoxShadow> primaryButtonShadow = [
    BoxShadow(
      color: Colors.white.withOpacity(01),
      blurRadius: 20,
      spreadRadius: 0,
      offset: const Offset(0, 10),
    ),
  ];

  // TEXT THEMES
  // =========================================================
  static final TextTheme _lightTextTheme = ThemeData.light().textTheme.copyWith(
    labelLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    labelMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
    labelSmall: TextStyle(
      fontSize: 8.sp,
      fontWeight: FontWeight.w500,
      color: textColor,
    ),
  );
  static final TextTheme _darkTextTheme = ThemeData.dark().textTheme.copyWith(
    labelLarge: TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    labelMedium: TextStyle(
      fontSize: 14.sp,
      fontWeight: FontWeight.w500,
      color: Colors.white,
    ),
    labelSmall: TextStyle(
      fontSize: 8.sp,
      fontWeight: FontWeight.w500,
      color: Color(0xFFB6C2D2),
    ),
  );

  // =========================================================
  // LIGHT THEME
  // =========================================================
  static ThemeData lightTheme = ThemeData(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.black, // your cursor color
      selectionColor: primaryColor.withOpacity(0.3),
      selectionHandleColor: primaryColor,
    ),

    fontFamily: 'Roboto', // ✅ ADD THIS    useMaterial3: true,
    brightness: Brightness.light,
    scaffoldBackgroundColor: cupertinoWhite,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.light,
      primary: primaryColor,
      secondary: tealColor,
      surface: cupertinoWhite,
      error: errorColor,
    ),
    textTheme: _lightTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.black,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      toolbarHeight: toolbarHeight,
      titleTextStyle: TextStyle(
        fontSize: appBarTitleSize,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      iconTheme: IconThemeData(size: iconSize, color: Colors.black),
      actionsIconTheme: IconThemeData(size: iconSize, color: Colors.black),
    ),

    iconTheme: const IconThemeData(size: iconSize, color: Colors.black),
    primaryIconTheme: const IconThemeData(size: iconSize, color: Colors.white),
    cardTheme: CardThemeData(
      color: cupertinoWhite,
      elevation: 0,
      margin: const EdgeInsets.all(8),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMD),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.black,
      minLeadingWidth: 30,
      minTileHeight: listTileMinHeight,
      contentPadding: EdgeInsets.symmetric(
        horizontal: contentPaddingH,
        vertical: 6,
      ),
      titleTextStyle: TextStyle(
        fontSize: bodyLargeSize,
        fontWeight: FontWeight.w600,
        color: Colors.black,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: bodyMediumSize,
        fontWeight: FontWeight.w400,
        color: Colors.black,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: contentPaddingH,
        vertical: contentPaddingV + 2,
      ),
      hintStyle: const TextStyle(
        fontSize: hintTextSize,
        fontWeight: FontWeight.w400,
        color: hintTextColor,
      ),
      labelStyle: const TextStyle(
        fontSize: bodyMediumSize,
        color: secondaryColor,
      ),
      floatingLabelStyle: const TextStyle(
        fontSize: bodyMediumSize,
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),
      prefixIconColor: hintTextColor,
      suffixIconColor: hintTextColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: BorderSide(color: Colors.grey, width: 1.1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: primaryColor, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: errorColor, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: errorColor, width: 1.4),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusMD)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(50),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(
          fontSize: buttonTextSize,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryColor,
        side: BorderSide(color: borderColor),
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        textStyle: const TextStyle(
          fontSize: buttonTextSize,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryColor,
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: const TextStyle(
          fontSize: buttonTextSize,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        textStyle: const TextStyle(
          fontSize: buttonTextSize,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        iconSize: iconSize,
        padding: const EdgeInsets.all(10),
        backgroundColor: Colors.transparent,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      iconSize: 24,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(color: borderColor),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    ),
    radioTheme: const RadioThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    ),
    switchTheme: SwitchThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.black,
      ),
      contentTextStyle: const TextStyle(
        fontSize: bodyMediumSize,
        fontWeight: FontWeight.w400,
        color: Colors.black87,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLG),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 0,
      height: 68,
      indicatorColor: primaryColor.withOpacity(0.10),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      iconTheme: WidgetStateProperty.all(const IconThemeData(size: 24)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      elevation: 8,
      selectedItemColor: primaryColor,
      unselectedItemColor: secondaryColor,
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      selectedIconTheme: IconThemeData(size: 24),
      unselectedIconTheme: IconThemeData(size: 22),
      type: BottomNavigationBarType.fixed,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: primaryColor,
      unselectedLabelColor: secondaryColor,
      indicatorColor: primaryColor,
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      unselectedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.black,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSM),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF1E293B),
      contentTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      actionTextColor: Colors.white,
      behavior: SnackBarBehavior.floating,
    ),
    dividerTheme: const DividerThemeData(
      thickness: 0.8,
      space: 1,
      color: Color(0xFFE8EEF7),
    ),
  );

  // =========================================================
  // DARK THEME
  // =========================================================
  static ThemeData darkTheme = ThemeData(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: Colors.white, // your cursor color
      selectionColor: primaryColor.withOpacity(0.3),
      selectionHandleColor: primaryColor,
    ),
    fontFamily: 'Roboto', // ✅ ADD THIS
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    colorScheme: ColorScheme.fromSeed(
      seedColor: primaryColor,
      brightness: Brightness.dark,
      primary: primaryColor,
      secondary: tealColor,
      surface: darkCard,
      error: errorColor,
    ),
    textTheme: _darkTextTheme,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      toolbarHeight: toolbarHeight,
      titleTextStyle: TextStyle(
        fontFamily: 'Roboto', // ✅ ADD THIS
        fontSize: appBarTitleSize,
        color: Colors.white,
      ),
      iconTheme: IconThemeData(size: iconSize, color: Colors.white),
      actionsIconTheme: IconThemeData(size: iconSize, color: Colors.white),
    ),
    iconTheme: const IconThemeData(size: iconSize, color: Colors.white),
    primaryIconTheme: const IconThemeData(size: iconSize, color: Colors.white),
    cardTheme: CardThemeData(
      color: darkCard,
      elevation: 0,
      margin: const EdgeInsets.all(8),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusMD),
      ),
    ),
    listTileTheme: const ListTileThemeData(
      iconColor: Colors.white,
      minLeadingWidth: 30,
      minTileHeight: listTileMinHeight,
      contentPadding: EdgeInsets.symmetric(
        horizontal: contentPaddingH,
        vertical: 6,
      ),
      titleTextStyle: TextStyle(
        fontSize: bodyLargeSize,
        // fontWeight: FontWeight.w600,
        color: Colors.white,
      ),
      subtitleTextStyle: TextStyle(
        fontSize: bodyMediumSize,
        // fontWeight: FontWeight.w400,
        color: Color(0xFFB6C2D2),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF111827),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: contentPaddingH,
        vertical: contentPaddingV + 2,
      ),
      hintStyle: const TextStyle(
        fontSize: hintTextSize,
        // fontWeight: FontWeight.w400,
        color: darkHintTextColor,
      ),
      labelStyle: const TextStyle(
        fontSize: bodyMediumSize,
        color: Color(0xFFB6C2D2),
      ),
      floatingLabelStyle: const TextStyle(
        fontSize: bodyMediumSize,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      prefixIconColor: darkHintTextColor,
      suffixIconColor: darkHintTextColor,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: darkBorderColor, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: primaryColor, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: errorColor, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radiusMD),
        borderSide: const BorderSide(color: errorColor, width: 1.4),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(radiusMD)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size.fromHeight(50),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
        textStyle: const TextStyle(
          fontSize: buttonTextSize,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
      ),
    ),
    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.white,
        side: const BorderSide(color: darkBorderColor),
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        textStyle: const TextStyle(
          fontSize: buttonTextSize,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        textStyle: const TextStyle(
          fontSize: buttonTextSize,
          fontWeight: FontWeight.w600,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
      ),
    ),
    filledButtonTheme: FilledButtonThemeData(
      style: FilledButton.styleFrom(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        minimumSize: const Size.fromHeight(48),
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        textStyle: const TextStyle(
          fontSize: buttonTextSize,
          fontWeight: FontWeight.w700,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radiusMD),
        ),
      ),
    ),
    iconButtonTheme: IconButtonThemeData(
      style: IconButton.styleFrom(
        iconSize: iconSize,
        padding: const EdgeInsets.all(10),
        backgroundColor: Colors.transparent,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      iconSize: 24,
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
    ),
    checkboxTheme: CheckboxThemeData(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: const BorderSide(color: darkBorderColor),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    ),
    radioTheme: const RadioThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
    ),
    switchTheme: SwitchThemeData(
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: darkCard,
      surfaceTintColor: Colors.transparent,
      titleTextStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      contentTextStyle: const TextStyle(
        fontSize: bodyMediumSize,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusLG),
      ),
    ),
    bottomSheetTheme: const BottomSheetThemeData(
      backgroundColor: Color(0xFF182234),
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: const Color(0xFF101A2B),
      elevation: 0,
      height: 68,
      indicatorColor: Colors.white.withOpacity(0.10),
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      ),
      iconTheme: WidgetStateProperty.all(const IconThemeData(size: 24)),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Color(0xFF101A2B),
      elevation: 8,
      selectedItemColor: Colors.white,
      unselectedItemColor: Color(0xFF8FA0BA),
      selectedLabelStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
      unselectedLabelStyle: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
      ),
      selectedIconTheme: IconThemeData(size: 24),
      unselectedIconTheme: IconThemeData(size: 22),
      type: BottomNavigationBarType.fixed,
    ),
    tabBarTheme: const TabBarThemeData(
      labelColor: Colors.white,
      unselectedLabelColor: Color(0xFFB6C2D2),
      indicatorColor: Colors.white,
      labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
      unselectedLabelStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    ),
    popupMenuTheme: PopupMenuThemeData(
      color: darkCard,
      surfaceTintColor: Colors.transparent,
      textStyle: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radiusSM),
      ),
    ),
    snackBarTheme: const SnackBarThemeData(
      backgroundColor: Color(0xFF1E293B),
      contentTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Colors.white,
      ),
      actionTextColor: Colors.white,
      behavior: SnackBarBehavior.floating,
    ),
    dividerTheme: const DividerThemeData(
      thickness: 0.8,
      space: 1,
      color: Color(0xFF233047),
    ),
  );
}
