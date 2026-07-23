import 'package:elite_csr/models/convo_list.dart';
import 'package:elite_csr/views/dashboard/controller.dart';
import 'package:elite_csr/views/dashboard/widgets/useable_list.dart';
import 'package:elite_csr/views/gmail/widgets/list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import '../../../models/gmail_model.dart';
import '../../../responsive/sizes.dart';
import '../../../theme/theme.dart';
import '../../../widgets/input_fileds.dart';
import '../../../widgets/text_widget.dart';
import '../../gmail/controller.dart';
import 'filter_chip.dart';

class ConvoPanel extends StatelessWidget {
  final DashboardController ctrl;

  const ConvoPanel({super.key, required this.ctrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        children: [
          /// HEADER
          Column(
            children: [
              /// LOGO
              Row(
                children: [
                  Image.asset('assets/images/e.png', height: 35.h),

                  SizedBox(width: 5.w),
                  TextWidget(
                    "Elite CRM",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const Spacer(),


                    Obx(() {
                      final selectedConversation =
                          ctrl.convoModel.value;

                      if (selectedConversation == null) {
                        return const SizedBox.shrink();
                      }

                      return assignmentDropdown(
                        context,
                        ctrl: ctrl,
                        conversationId:
                        selectedConversation.id,
                      );
                    })



                ],
              ),

              SizedBox(height: 15.h),

              /// SEARCH
              InputFields(
                controller: TextEditingController(),

                hint: "Search conversations...",
                icon: Icons.search,
              ),
            ],
          ),
          SizedBox(height: 20.h),

          Row(
            children: [
              topTab(
                context,
                text: 'All',
                ctrl: ctrl,
              ),

              SizedBox(width: 10.w),

              topTab(
                context,
                text: 'Unread',
                ctrl: ctrl,
              ),

              SizedBox(width: 10.w),

              topTab(
                context,
                text: 'Assigned',
                ctrl: ctrl,
              ),

              SizedBox(width: 10.w),

              topTab(
                context,
                text: 'Unassigned',
                ctrl: ctrl,
              ),


              /// Selected conversation ka assignment dropdown
            ],
          ),          SizedBox(height: 15.h),

          /// CHANNELS
          Expanded(
            child: ListView(
              children: [
                UseableList<ConversationModel>(
                  title: "WhatsApp",
                  color: Colors.green,
                  icon: 'assets/images/w.png',
                  // count: ctrl.countByPlatform("WhatsApp"),
                  count: 2,
                  data: ctrl.getByPlatform("WhatsApp"),
                  isExpanded: ctrl.expandedList == "WhatsApp",
                  onExpansionChanged: (value) {
                    ctrl.toggleExpandedList("WhatsApp", value);
                  },
                  itemBuilder: (context, item) {
                    return conversationTile(
                      context: context,
                      item: item,
                      color: Colors.green,
                      onTap: () {
                      ctrl.selectConversation(item);
                        ctrl.openChat(item);
                      }
                    );
                  },
                ),

                SizedBox(height: 14.h),

                UseableList<ConversationModel>(
                  title: "Facebook",
                  color: Colors.blue,
                  icon: 'assets/images/facebook.png',
                  count: ctrl.countByPlatform("Facebook"),
                  data: ctrl.getByPlatform("Facebook"),
                  isExpanded: ctrl.expandedList == "Facebook",
                  onExpansionChanged: (value) {
                    ctrl.toggleExpandedList("Facebook", value);
                  },
                  itemBuilder: (context, item) {
                    return conversationTile(
                      context: context,
                      item: item,
                      color: Colors.blue,
                      onTap: () {
                      ctrl.selectConversation(item);
                        ctrl.openChat(item);

                      }
                    );
                  },
                ),

                SizedBox(height: 14.h),

                UseableList<ConversationModel>(
                  title: "Instagram",
                  color: Colors.blue,
                  icon: 'assets/images/instagram.png',
                  count: ctrl.countByPlatform("Instagram"),
                  data: ctrl.getByPlatform("Instagram"),
                  isExpanded: ctrl.expandedList == "Instagram",
                  onExpansionChanged: (value) {
                    ctrl.toggleExpandedList("Instagram", value);
                  },
                  itemBuilder: (context, item) {
                    return conversationTile(
                      context: context,
                      item: item,
                      color: Colors.green,
                      onTap: () {


                      ctrl.selectConversation(item);
                        ctrl.openChat(item);

                      }
                    );
                  },
                ),

                SizedBox(height: 14.h),

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
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
