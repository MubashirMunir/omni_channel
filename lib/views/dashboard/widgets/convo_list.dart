import 'package:elite_csr/views/dashboard/controller.dart';
import 'package:elite_csr/views/dashboard/widgets/useable_list.dart';
 import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../widgets/input_fileds.dart';
import '../../../widgets/text_widget.dart';
import '../../gmail/controller.dart';
import '../../side_navbar/controller.dart';
import 'filter_chip.dart';

class ConvoPanel extends StatefulWidget {
  final DashboardController ctrl;

  const ConvoPanel({
    super.key,
    required this.ctrl,
  });

  @override
  State<ConvoPanel> createState() => _ConvoPanelState();
}

class _ConvoPanelState extends State<ConvoPanel> {
  /// Existing sidebar controller
  final SideController sideCtrl = Get.find<SideController>();

  /// Search controller ko har build par recreate nahi karna
  final TextEditingController searchController =
  TextEditingController();

  DashboardController get ctrl => widget.ctrl;

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          /// CRM logo, title and assignment dropdown
          _buildHeader(context),

          SizedBox(height: 20.h),

          /// Conversation filters
          _buildFilterTabs(context),

          SizedBox(height: 15.h),

          /// Selected social channel or Gmail list
          Expanded(
            child: Obx(
                  () {
                if (!sideCtrl.showConversationList.value) {
                  return const Center(
                    child: Text(
                      "Select a channel to see chats",
                    ),
                  );
                }

                final String channel =
                    sideCtrl.selectedChannel.value;

                // if (channel == "Gmail") {
                //   return _buildGmailConversationList();
                // }

                return _buildSocialConversationList(
                  context: context,
                  platform: channel,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// Top logo, CRM title, assignment dropdown and search field
  Widget _buildHeader(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/e.png',
              height: 35.h,
            ),

            SizedBox(width: 5.w),

            TextWidget(
              "Elite CRM",
              style: Theme.of(context).textTheme.bodyLarge,
            ),

            const Spacer(),

            /// Dropdown sirf selected conversation par show hoga
            Obx(
                  () {
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
              },
            ),
          ],
        ),

        SizedBox(height: 15.h),
        InputFields(
          controller: searchController,
          hint: "Search conversations...",
          icon: Icons.search,
        ),
      ],
    );
  }

  /// All, Unread, Assigned and Unassigned filters
  Widget _buildFilterTabs(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          topTab(
            context,
            text: "All",
            ctrl: ctrl,
          ),
          SizedBox(width: 10.w),
          topTab(
            context,
            text: "Unread",
            ctrl: ctrl,
          ),
          SizedBox(width: 10.w),
          topTab(
            context,
            text: "Assigned",
            ctrl: ctrl,
          ),
          SizedBox(width: 10.w),
          topTab(
            context,
            text: "Unassigned",
            ctrl: ctrl,
          ),
        ],
      ),
    );
  }

  /// Gmail messages list
  // Widget _buildGmailConversationList() {
  //   return GetBuilder<GmailController>(
  //     builder: (gmailCtrl) {
  //       final emails = gmailCtrl.filteredEmails;
  //
  //       return Column(
  //         children: [
  //           _buildListHeader(
  //             title: "Gmail",
  //             count: emails.length,
  //           ),
  //
  //           const Divider(height: 1),
  //
  //           Expanded(
  //             child: emails.isEmpty
  //                 ? const Center(
  //               child: Text(
  //                 "No Gmail messages",
  //               ),
  //             )
  //                 : ListView.builder(
  //               itemCount: emails.length,
  //               itemBuilder: (context, index) {
  //                 final mail = emails[index];
  //
  //                 return MailListTile(
  //                   mail: mail,
  //
  //                   /// Highlight currently selected email
  //                   selected:
  //                   gmailCtrl.selectedEmail ==
  //                       mail,
  //
  //                   onStarTap: () {
  //                     gmailCtrl.toggleStar(mail);
  //                   },
  //
  //                   onTap: () {
  //                     gmailCtrl.selectEmail(mail);
  //
  //                     /// Open Gmail detail panel
  //                     ctrl.openGmail();
  //                   },
  //                 );
  //               },
  //             ),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  /// WhatsApp, Facebook or Instagram conversation list
  Widget _buildSocialConversationList({
    required BuildContext context,
    required String platform,
  }) {
    final conversations =
    ctrl.getByPlatform(platform);

    final Color platformColor =
    _getPlatformColor(platform);

    return Column(
      children: [
        _buildListHeader(
          title: platform,
          count: conversations.length,
        ),

        const Divider(height: 1),

        Expanded(
          child: conversations.isEmpty
              ? Center(
            child: Text(
              "No $platform conversations",
            ),
          )
              : ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
            itemCount: conversations.length,
            itemBuilder: (context, index) {
              final item =
              conversations[index];

              return conversationTile(
                context: context,
                item: item,
                color: platformColor,
                onTap: () {
                  /// Save selected conversation
                  ctrl.selectConversation(item);

                  /// Open selected chat
                  ctrl.openChat(item);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Shared header for Gmail and social-media lists
  Widget _buildListHeader({
    required String title,
    required int count,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          /// Number of conversations/messages
          Text(count.toString()),

          const SizedBox(width: 6),

          /// Hide conversation panel
          IconButton(
            tooltip: "Close",
            onPressed: sideCtrl.closeChannel,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );
  }

  /// Return each platform's theme color
  Color _getPlatformColor(String platform) {
    switch (platform) {
      case "WhatsApp":
        return Colors.green;

      case "Facebook":
        return Colors.blue;

      case "Instagram":
        return Colors.purple;

      default:
        return Colors.grey;
    }
  }
}