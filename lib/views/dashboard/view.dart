import 'package:elite_csr/views/dashboard/controller.dart';
import 'package:elite_csr/views/dashboard/widgets/convo_list.dart';
import 'package:elite_csr/views/dashboard/widgets/message_buble.dart';
import 'package:elite_csr/views/dashboard/widgets/profile_panel.dart';
import 'package:elite_csr/views/dashboard/widgets/side_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../main.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);

    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (ctrl) {
        return Scaffold(
          body: Row(
            children: [
              /// LEFT ICON SIDEBAR
              if (!isMobile) SideBar(),

              /// CHAT LIST
              SizedBox(
                width: isMobile
                    ? 100.w
                    : isTablet
                    ? 320.w
                    : 340.w,
                child: ConvoPanel(ctrl: ctrl),
              ),

              /// CENTER CHAT AREA
              if (!isMobile)
                // how to show conversation inbox buble messages here
                Expanded(
                  child: Obx(() {
                    final chat = ctrl.selectedConversation.value;
                    if (chat == null) {
                      return Center(
                        child: Text(
                          "Select a conversation",
                          style: Theme.of(
                            context,
                          ).textTheme.labelLarge?.copyWith(),
                        ),
                      );
                    }
                    return Column(
                      children: [
                        /// HEADER
                        Container(
                          padding: EdgeInsets.all(16),

                          child: Row(
                            children: [
                              CircleAvatar(),

                              SizedBox(width: 10),

                              Text(
                                chat.name,
                                style: Theme.of(
                                  context,
                                ).textTheme.labelMedium?.copyWith(),
                              ),
                            ],
                          ),
                        ),

                        /// CHAT BUBBLES
                        ///
                        Expanded(
                          child: ListView.builder(
                            reverse: false,
                            padding: EdgeInsets.all(16),
                            itemCount: ctrl.messages.length,
                            itemBuilder: (_, index) {
                              final msg = ctrl.messages[index];
                              return MessageBubble(message: msg);
                            },
                          ),
                        ),

                        MessageInput(
                          controller: ctrl.msgController,
                          onSend: () {
                            ctrl.sendMessage();
                          },
                        ),
                      ],
                    );
                  }),
                ),

              /// RIGHT PROFILE PANEL
              if (!isMobile)
                SizedBox(
                  width: isMobile
                      ? 80
                      : isTablet
                      ? 300.w
                      : 380.w,
                  child: ProfilePanel(),
                ),
            ],
          ),
          // bottomNavigationBar: BottomWidget(),
        );
      },
    );
  }
}
