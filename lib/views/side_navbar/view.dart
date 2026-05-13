import 'package:elite_csr/views/dashboard/view.dart';
import 'package:elite_csr/views/states/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller.dart';


class MainLayoutScreen extends StatelessWidget {

  MainLayoutScreen({super.key});

  final  controller =
  Get.put(SideController());

  final List<IconData> icons = [

    Icons.chat,

    Icons.people,

    Icons.bar_chart,

    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Row(

        children: [

          /// SIDEBAR
          Container(

            width: 70,
            color: Colors.white,

            child: Obx(() => Column(

              children: [

                const SizedBox(height: 20),

                ...List.generate(
                    icons.length,
                        (index) {

                      final isActive =
                          controller.selectedIndex.value
                              == index;

                      return GestureDetector(

                        onTap: () {

                          controller.changeIndex(index);
                        },

                        child: Container(

                          margin:
                          const EdgeInsets.symmetric(
                            vertical: 8,
                          ),

                          height: 50,
                          width: 50,

                          decoration: BoxDecoration(

                            color: isActive
                                ? Colors.blue.withOpacity(.15)
                                : Colors.transparent,

                            borderRadius:
                            BorderRadius.circular(14),
                          ),

                          child: Icon(

                            icons[index],

                            color: isActive
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      );
                    }),
              ],
            )),
          ),

          /// BODY
          Expanded(

            child: Obx(() => IndexedStack(

              index:
              controller.selectedIndex.value,

              children: const [

                DashboardView(),

                StatisticsView(),


              ],
            )),
          ),
        ],
      ),
    );
  }
}