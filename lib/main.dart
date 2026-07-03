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

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ScreenUtilInit(

      designSize: const Size(1440, 1024),

      minTextAdapt: true,

      splitScreenMode: true,

      /// REMOVE THIS
      // useInheritedMediaQuery: true,

      builder: (context, child) {

        return MediaQuery(

          /// FIX WEB TEXT SCALING
          data: MediaQuery.of(context).copyWith(
            textScaler:
            const TextScaler.linear(1),
          ),

          child: GetMaterialApp(

            debugShowCheckedModeBanner: false,

            title: 'Elite CRM',

            theme: AppTheme.lightTheme(context),

            darkTheme: AppTheme.darkTheme(context),

            themeMode: ThemeMode.dark,

            initialRoute: AppRoutes.login,

            getPages: AppPages.pages,
          ),
        );
      },

      /// REMOVE EMPTY SIZEDBOX
      child: Container(),
    );
  }
}