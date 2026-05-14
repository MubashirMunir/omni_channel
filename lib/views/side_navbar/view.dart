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

  @override
  Widget build(BuildContext context) {

    /// FIX FOR WEB TEXT SCALING
    final textScale =
    MediaQuery.of(context).textScaler.scale(1);

    return MediaQuery(

      /// THIS PREVENTS INITIAL WEB TEXT BUG
      data: MediaQuery.of(context).copyWith(
        textScaler: const TextScaler.linear(1),
      ),

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

                    ...List.generate(
                      icons.length,
                          (index) {

                        final isActive =
                            controller
                                .selectedIndex
                                .value ==
                                index;

                        return GestureDetector(
                          onTap: () {
                            controller.changeIndex(
                              index,
                            );
                          },

                          child: Container(
                            margin:
                            EdgeInsets.symmetric(
                              vertical:
                              8 * textScale,
                            ),

                            height: 50 * textScale,
                            width: 50 * textScale,

                            decoration: BoxDecoration(
                              color: isActive
                                  ? Colors.blue
                                  .withOpacity(.15)
                                  : Colors.transparent,

                              borderRadius:
                              BorderRadius.circular(
                                14 * textScale,
                              ),
                            ),

                            child: Icon(
                              icons[index],

                              size: 22 * textScale,

                              color: isActive
                                  ? Colors.blue
                                  : Colors.grey,
                            ),
                          ),
                        );
                      },
                    ),

                    const Spacer(),

                    IconButton(
                      onPressed: () {},

                      icon: Icon(
                        Icons.logout,
                        size: 22 * textScale,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// BODY
            Expanded(
              child: Obx(
                    () => IndexedStack(
                  index:
                  controller.selectedIndex.value,

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