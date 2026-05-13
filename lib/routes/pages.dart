

import 'package:elite_csr/routes/routes.dart';
import 'package:elite_csr/views/side_navbar/view.dart';
import 'package:elite_csr/views/states/view.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';

import '../views/dashboard/view.dart';
import '../views/login/view.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
    ),
    //
    GetPage(
      name: AppRoutes.dashboard,
      page: () => const DashboardView(),
    ),
  GetPage(
      name: AppRoutes.statistics,
      page: () =>  StatisticsView(),
    ),
  GetPage(
      name: AppRoutes.home,
      page: () =>  MainLayoutScreen(),
    ),

    // GetPage(
    //   name: AppRoutes.inbox,
    //   page: () => const InboxView(),
    // ),
    //
    // GetPage(
    //   name: AppRoutes.settings,
    //   page: () => const SettingsView(),
    // ),
  ];
}