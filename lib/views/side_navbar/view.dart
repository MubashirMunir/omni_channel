import 'package:elite_csr/theme/theme.dart';
import 'package:elite_csr/views/dashboard/controller.dart';
import 'package:elite_csr/views/dashboard/view.dart';
import 'package:elite_csr/views/gmail/controller.dart';
import 'package:elite_csr/views/setting/view.dart';
import 'package:elite_csr/views/side_navbar/widgets/btn.dart' hide SocialChannelButton;
import 'package:elite_csr/views/states/view.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../dashboard/widgets/useable_list.dart';
import 'controller.dart';

class MainLayoutScreen extends StatelessWidget {
  MainLayoutScreen({super.key});

  /// Sidebar navigation controller
  final SideController controller = Get.put(SideController());

  /// Conversations controller
  final DashboardController dashboardCtrl = Get.put(DashboardController());

  /// Gmail controller
  final GmailController gmailCtrl = Get.put(GmailController());

  /// IndexedStack mein 3 screens hain,
  /// isliye icons bhi 3 hain.
  final List<IconData> icons = const [
    Icons.chat,
    Icons.bar_chart,
    Icons.settings,
  ];

  final List<String> labels = const ['Home', 'Statistics', 'Setting'];

  @override
  Widget build(BuildContext context) {
    final double textScale = MediaQuery.of(context).textScaler.scale(1);

    return MediaQuery(
      data: MediaQuery.of(
        context,
      ).copyWith(textScaler: const TextScaler.linear(1)),
      child: Scaffold(
        body: Row(
          children: [
            /// SIDEBAR
            Container(
              width: 82,
              decoration: BoxDecoration(
                border: Border(right: BorderSide(color: Colors.grey.shade300)),
              ),
              child: Column(
                children: [
                  /// Scrollable icons
                  Expanded(
                    child: SingleChildScrollView(
                      child: GetBuilder<DashboardController>(
                        builder: (dashboardCtrl) {
                          return Obx(
                            () => Column(
                              children: [
                                SizedBox(height: 20 * textScale),

                                /// Main navigation
                                ...List.generate(icons.length, (index) {
                                  final bool isActive =
                                      controller.selectedIndex.value == index;

                                  return GestureDetector(
                                    onTap: () {
                                      FocusManager.instance.primaryFocus
                                          ?.unfocus();

                                      controller.changeIndex(index);
                                    },
                                    child: Container(
                                      margin: EdgeInsets.symmetric(
                                        vertical: 8 * textScale,
                                      ),
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        color: isActive
                                            ? Colors.blue.withOpacity(0.15)
                                            : Colors.transparent,
                                        borderRadius: BorderRadius.circular(
                                          AppTheme.radiusSM(context),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            icons[index],
                                            size: 20 * textScale,
                                            color: isActive
                                                ? Colors.blue
                                                : Colors.grey,
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            labels[index],
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodySmall,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),

                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  child: Divider(),
                                ),

                                /// WhatsApp
                                SocialChannelButton(
                                  title: "WhatsApp",
                                  icon: "assets/images/w.png",
                                  color: Colors.green,
                                  count: dashboardCtrl.countByPlatform(
                                    "WhatsApp",
                                  ),
                                  isSelected: controller.isChannelSelected(
                                    "WhatsApp",
                                  ),
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();

                                    controller.openChannel("WhatsApp");
                                  },
                                ),

                                const SizedBox(height: 10),

                                /// Facebook
                                SocialChannelButton(
                                  title: "Facebook",
                                  icon: "assets/images/facebook.png",
                                  color: Colors.blue,
                                  count: dashboardCtrl.countByPlatform(
                                    "Facebook",
                                  ),
                                  isSelected: controller.isChannelSelected(
                                    "Facebook",
                                  ),
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();

                                    controller.openChannel("Facebook");
                                  },
                                ),

                                const SizedBox(height: 10),

                                /// Instagram
                                SocialChannelButton(
                                  title: "Instagram",
                                  icon: "assets/images/instagram.png",
                                  color: Colors.purple,
                                  count: dashboardCtrl.countByPlatform(
                                    "Instagram",
                                  ),
                                  isSelected: controller.isChannelSelected(
                                    "Instagram",
                                  ),
                                  onPressed: () {
                                    FocusManager.instance.primaryFocus
                                        ?.unfocus();

                                    controller.openChannel("Instagram");
                                  },
                                ),

                                const SizedBox(height: 10),

                                /// Gmail
                                GetBuilder<GmailController>(
                                  builder: (gmailCtrl) {
                                    return SocialChannelButton(
                                      title: "Gmail",
                                      icon: "assets/images/gmail.png",
                                      color: Colors.red,
                                      count: dashboardCtrl.countByPlatform('Gmail'),
                                      isSelected: controller.isChannelSelected(
                                        "Gmail",
                                      ),
                                      onPressed: () {

                                        FocusManager.instance.primaryFocus?.unfocus();

                                        dashboardCtrl.openGmailCenter();
                                      },
                                    );
                                  },
                                ),

                                const SizedBox(height: 20),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),

                  /// Bottom buttons
                  IconButton(
                    tooltip: "Collapse sidebar",
                    onPressed: () {
                      // Sidebar collapse logic baad mein.
                    },
                    icon: const Icon(
                      Icons.arrow_forward_ios,
                      size: 18,
                      color: Colors.grey,
                    ),
                  ),

                  IconButton(
                    tooltip: "Logout",
                    onPressed: () {
                      Get.offAllNamed('/login');
                    },
                    icon: const Icon(Icons.logout, color: Colors.grey),
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),

            /// BODY
            Expanded(
              child: Obx(
                () => IndexedStack(
                  index: controller.selectedIndex.value,
                  children: const [
                    DashboardView(), // index 0
                    StatisticsView(), // index 1
                    SettingsView(), // index 2
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
