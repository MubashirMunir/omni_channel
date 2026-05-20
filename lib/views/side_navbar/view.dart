import 'package:elite_csr/theme/theme.dart';
import 'package:elite_csr/views/dashboard/view.dart';
import 'package:elite_csr/views/states/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../setting/view.dart';
import 'controller.dart';

class MainLayoutScreen extends StatelessWidget {
  MainLayoutScreen({super.key});

  final controller = Get.put(SideController());

  final List<IconData> icons = [
    Icons.chat,
    Icons.people,
    Icons.bar_chart,
    Icons.settings,
  ];
  final List<String> labels = ['Home', 'Statistics', 'Analytics', 'Setting','cghfgh'];

  @override
  Widget build(BuildContext context) {
    /// FIX FOR WEB TEXT SCALING
    final textScale = MediaQuery.of(context).textScaler.scale(1);

    return MediaQuery(
      /// THIS PREVENTS INITIAL WEB TEXT BUG
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(1)),

      child: Scaffold(
        body: Row(
          children: [
            /// SIDEBAR
            SizedBox(
              width: 70,

              child: Obx(
                () => Column(
                  children: [
                    SizedBox(height: 20 * textScale),

                    ...List.generate(icons.length, (index) {
                      final isActive = controller.selectedIndex.value == index;

                      return GestureDetector(
                        onTap: () {
                          controller.changeIndex(index);
                        },

                        child: Container(
                          margin: EdgeInsets.symmetric(vertical: 8 * textScale),

                          height: 55,
                          width: 50,

                          decoration: BoxDecoration(
                            color: isActive
                                ? Colors.blue.withOpacity(.15)
                                : Colors.transparent,

                            borderRadius: BorderRadius.circular(
                              AppTheme.radiusSM(context),
                            ),
                          ),

                          child: Column(
                            spacing: 2,
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,

                            children: [
                              Icon(
                                icons[index],

                                size: 20 * textScale,

                                color: isActive ? Colors.blue : Colors.grey,
                              ),

                              Text(
                                labels[index],
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      );
                    }),

                    const Spacer(),

                    IconButton(
                      onPressed: () {
                        bool left = true;
                        left = !left;
                      },
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.grey),
                    ),
                    IconButton(
                      onPressed: () {
                        Get.offAllNamed('/login');
                      },
                      icon: Icon(Icons.logout, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            /// BODY
            Expanded(
              child: Obx(
                () => IndexedStack(
                  index: controller.selectedIndex.value,

                  children: const [
                    DashboardView(),

                    StatisticsView(),
                    SettingsView(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
