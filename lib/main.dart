import 'package:elite_csr/routes/pages.dart';
import 'package:elite_csr/routes/routes.dart';
import 'package:elite_csr/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

void main() {

  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

///
/// GLOBAL RESPONSIVE HELPERS
///
class Responsive {

  static double width(BuildContext context) =>
      MediaQuery.of(context).size.width;

  static double height(BuildContext context) =>
      MediaQuery.of(context).size.height;

  static bool isMobile(BuildContext context) =>
      width(context) < 700;

  static bool isTablet(BuildContext context) =>
      width(context) >= 700 &&
          width(context) < 1100;

  static bool isDesktop(BuildContext context) =>
      width(context) >= 1100;

  /// Dynamic width
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

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(

      /// YOUR FIGMA DESIGN SIZE
      designSize: const Size(1440, 1024),

      /// IMPORTANT FOR WEB
      minTextAdapt: true,

      /// IMPORTANT FOR WEB
      splitScreenMode: true,

      /// IMPORTANT FIX
      useInheritedMediaQuery: true,

      builder: (_, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Elite CRM',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.system,
          /// ROUTES
          initialRoute: AppRoutes.home,
          getPages: AppPages.pages,
          builder: (context, widget) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler:
                const TextScaler.linear(1.0),
              ),
              child: widget!,
            );
          },
        );
      },
      /// IMPORTANT
      child: const SizedBox(),
    );
  }
}