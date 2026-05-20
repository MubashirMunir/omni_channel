import 'package:elite_csr/theme/theme.dart';
import 'package:elite_csr/views/dashboard/controller.dart';
import 'package:elite_csr/views/dashboard/widgets/convo_list.dart';
import 'package:elite_csr/views/dashboard/widgets/message_buble.dart';
import 'package:elite_csr/views/dashboard/widgets/message_input.dart';
import 'package:elite_csr/views/dashboard/widgets/profile_panel.dart';
import 'package:elite_csr/views/gmail/view.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../models/convo_list.dart';
import '../../responsive/sizes.dart';
import '../gmail/controller.dart';
import '../gmail/widgets/gmail_detail_panel.dart';
import '../gmail/widgets/gmail_mail_list.dart';

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
              SizedBox(
                width: isMobile
                    ? 0
                    : isTablet
                    ? 320
                    : 500,
                child: ConvoPanel(ctrl: ctrl),
              ),

              /// CENTER CHAT AREA
              Expanded(
                child: Obx(() {
                  final selectedView = ctrl.selectedCenterView.value;
                  final chat = ctrl.convoModel.value;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final double width = constraints.maxWidth;

                      final bool isCompact = width < 600;
                      final bool isMedium = width >= 600 && width < 1024;

                      final double horizontalPadding = isCompact
                          ? 16
                          : isMedium
                          ? 24
                          : 32;

                      final double verticalPadding = isCompact
                          ? 14
                          : isMedium
                          ? 18
                          : 22;

                      final double emptyImageHeight = isCompact
                          ? 90
                          : isMedium
                          ? 150
                          : 240;

                      final double emptyMaxWidth = isCompact
                          ? 300
                          : isMedium
                          ? 430
                          : 520;

                      final double titleSize = isCompact
                          ? 14
                          : isMedium
                          ? 16
                          : 18;

                      final double subTitleSize = isCompact
                          ? 12
                          : isMedium
                          ? 13
                          : 14;

                      /// Gmail ko sab se pehle check karo
                      if (selectedView == 'Gmail') {
                        return GetBuilder<GmailController>(
                          builder: (gmailCtrl) {
                            return Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: GmailDetailPanel(ctrl: gmailCtrl),
                            );
                          },
                        );
                      }

                      /// Empty state
                      if (chat == null) {
                        return Center(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: verticalPadding,
                            ),
                            child: ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: emptyMaxWidth,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/box.png",
                                    height: emptyImageHeight,
                                    fit: BoxFit.contain,
                                  ),

                                  SizedBox(height: isCompact ? 18 : 24),

                                  Text(
                                    "Select a conversation",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                      fontSize: titleSize,
                                      fontWeight: FontWeight.w700,
                                      color: AppTheme.white.withOpacity(.8),
                                    ),
                                  ),

                                  SizedBox(height: isCompact ? 8 : 10),

                                  Text(
                                    "Choose a conversation from your inbox to start messaging.",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      fontSize: subTitleSize,
                                      color: Colors.grey.shade600,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }

                      final String name = chat.name.trim();

                      final String backgroundImage =
                      chat.platform.toLowerCase() == "whatsapp"
                          ? "assets/images/w_bg.png"
                          : "assets/images/w_bg.png";

                      /// Normal WhatsApp / Facebook / Instagram chat
                      return Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(backgroundImage),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: SafeArea(
                          top: false,
                          child: Column(
                            children: [
                              /// HEADER
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: horizontalPadding,
                                  vertical: isCompact ? 10 : 14,
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24.r,
                                      backgroundColor: AppTheme.primaryColor,
                                      child: chat.profile.isNotEmpty
                                          ? ClipOval(
                                        child: Image.network(
                                          chat.profile,
                                          width: 48.r,
                                          height: 48.r,
                                          fit: BoxFit.cover,
                                          errorBuilder: (
                                              context,
                                              error,
                                              stackTrace,
                                              ) {
                                            return _fallbackAvatar(chat, context);
                                          },
                                        ),
                                      )
                                          : _fallbackAvatar(chat, context),
                                    ),

                                    SizedBox(width: isCompact ? 10 : 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name.isNotEmpty ? name : "Unknown User",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium
                                                ?.copyWith(
                                              fontSize: isCompact ? 13 : 15,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.black,
                                            ),
                                          ),

                                          SizedBox(height: isCompact ? 2 : 4),

                                          Text(
                                            "Online",
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall
                                                ?.copyWith(
                                              fontSize: isCompact ? 11 : 12,
                                              color: Colors.grey.shade600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    const Spacer(),

                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.more_vert),
                                    ),
                                  ],
                                ),
                              ),

                              /// CHAT BUBBLES
                              Expanded(
                                child: ListView.builder(
                                  controller: ctrl.messageScrollController,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: isCompact
                                        ? 10
                                        : isMedium
                                        ? 18
                                        : 28,
                                    vertical: isCompact ? 10 : 16,
                                  ),
                                  itemCount: ctrl.messages.length,
                                  itemBuilder: (_, index) {
                                    final msg = ctrl.messages[index];

                                    return Padding(
                                      padding: EdgeInsets.only(
                                        bottom: isCompact ? 8 : 10,
                                      ),
                                      child: MessageBubble(
                                        message: msg,
                                        platform: chat.platform,
                                      ),
                                    );
                                  },
                                ),
                              ),

                              /// EMOJI
                              Obx(
                                    () => ctrl.showEmojiBoard.value
                                    ? EmojiPicker(
                                  textEditingController: ctrl.msgController,
                                  config: const Config(height: 300),
                                )
                                    : const SizedBox.shrink(),
                              ),

                              /// INPUT
                              MessageInput(
                                controller: ctrl,
                                onSend: () {
                                  ctrl.sendMessage();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
              /// RIGHT PROFILE PANEL
              isMobile
                  ? SizedBox()
                  : isTablet
                  ? SizedBox()
                  : SizedBox(width: 400, child: ProfilePanel()),
            ],
          ),
          // bottomNavigationBar: BottomWidget(),
        );
      },
    );
  }
}

Widget _fallbackAvatar(ConversationModel item, context) {
  return Center(
    child: Text(
      item.name.isNotEmpty ? item.name[0].toUpperCase() : '?',
      style: Theme.of(context).textTheme.bodyMedium,
    ),
  );
}
