import 'package:elite_csr/theme/theme.dart';
import 'package:elite_csr/views/dashboard/controller.dart';
import 'package:elite_csr/views/dashboard/view.dart';
import 'package:elite_csr/views/states/view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../models/gmail_model.dart';
import '../dashboard/widgets/useable_list.dart';
import '../gmail/controller.dart';
import '../gmail/widgets/list_tile.dart';
import '../setting/view.dart';
import 'controller.dart';

class MainLayoutScreen extends StatelessWidget {
  MainLayoutScreen({super.key});

  final controller = Get.put(SideController());
  final ctrl = Get.put(DashboardController());

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
              width: 80,

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

                          height: 60,
                          width: 60,

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
                        IconButton(onPressed: (){
                          GetBuilder<GmailController>(
                            init: GmailController(),
                            builder: (gmailCtrl) {
                              return UseableList<GmailMessageModel>(
                                title: "Gmail",
                                color: Colors.yellow,
                                icon: 'assets/images/gmail.png',
                                count: gmailCtrl.filteredEmails.length,
                                data: gmailCtrl.filteredEmails,
                                isExpanded: ctrl.expandedList == "Gmail",
                                onExpansionChanged: (value) {
                                  ctrl.toggleExpandedList("Gmail", value);
                                },
                                itemBuilder: (context, mail) {
                                  return MailListTile(
                                    mail: mail,
                                    selected: ctrl.isSelected,
                                    onStarTap: () {
                                      gmailCtrl.toggleStar(mail);},
                                    onTap: () {
                                      gmailCtrl.selectEmail(mail);
                                      ctrl.openGmail();
                                      gmailCtrl.update();
                                      /// yahan agar center/detail panel change karwana hai
                                      /// to apne dashboard controller me Gmail selected view bhi set kar do
                                      /// ctrl.changePlatform("Gmail");
                                    },
                                  );
                                },
                              );
                            },
                          );



                        }, icon: Image.asset('assets/images/gmail.png',height: 30,)),
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
