import 'package:elite_csr/theme/theme.dart';
import 'package:elite_csr/views/dashboard/controller.dart';
import 'package:elite_csr/views/dashboard/widgets/convo_list.dart';
import 'package:elite_csr/views/dashboard/widgets/instagram_input.dart';
import 'package:elite_csr/views/dashboard/widgets/message_buble.dart';
import 'package:elite_csr/views/dashboard/widgets/message_input.dart';
import 'package:elite_csr/views/dashboard/widgets/messanger_input.dart';
import 'package:elite_csr/views/dashboard/widgets/profile_panel.dart';
import 'package:elite_csr/views/dashboard/widgets/reciever_profile_header.dart';
import 'package:elite_csr/views/gmail/gmail_center_view.dart';
import 'package:emoji_picker_flutter/emoji_picker_flutter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../responsive/sizes.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = Responsive.isMobile(context);
    final bool isTablet = Responsive.isTablet(context);

    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (DashboardController ctrl) {
        return   Scaffold(
          body: Obx(() {
            final bool isGmail =
                ctrl.selectedCenterView.value.toLowerCase() == 'gmail';

            /// GMAIL MODE:
            /// Sirf existing sidebar + complete Gmail view
            if (isGmail) {
              return Row(
                children: [
                  /// EXISTING APP SIDEBAR
                  SizedBox(
                    width: isMobile ? 0 : 400,
                    child: ConvoPanel(ctrl: ctrl),
                  ),

                  /// COMPLETE GMAIL VIEW
                  Expanded(
                    child: GmailCenterView(
                      accountName: 'Elite CSR',
                      accountEmail: 'support@elitecsr.com',
                    ),
                  ),
                ],
              );
            }

            /// NORMAL CHAT MODE
            return Row(
              children: [
                /// EXISTING APP SIDEBAR
                SizedBox(
                  width: isMobile ? 0 : 400,
                  child: ConvoPanel(ctrl: ctrl),
                ),

                /// NORMAL CHAT CENTER
                Expanded(
                  child: Obx(() {
                    final chat = ctrl.convoModel.value;

                    return LayoutBuilder(
                      builder: (
                          BuildContext context,
                          BoxConstraints constraints,
                          ) {
                        final double width = constraints.maxWidth;

                        final bool isCompact = width < 600;
                        final bool isMedium =
                            width >= 600 && width < 1024;

                        final double horizontalPadding =
                        isCompact ? 16 : (isMedium ? 24 : 32);

                        final double verticalPadding =
                        isCompact ? 14 : (isMedium ? 18 : 22);

                        final double emptyImageHeight =
                        isCompact ? 90 : (isMedium ? 150 : 240);

                        final double emptyMaxWidth =
                        isCompact ? 300 : (isMedium ? 430 : 520);

                        final double titleSize =
                        isCompact ? 14 : (isMedium ? 16 : 18);

                        final double subTitleSize =
                        isCompact ? 12 : (isMedium ? 13 : 14);

                        /// EMPTY CHAT STATE
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
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      'assets/images/box.png',
                                      height: emptyImageHeight,
                                      fit: BoxFit.contain,
                                    ),

                                    SizedBox(
                                      height: isCompact ? 18 : 24,
                                    ),

                                    Text(
                                      'Select a conversation',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelLarge
                                          ?.copyWith(
                                        fontSize: titleSize,
                                        fontWeight: FontWeight.w700,
                                        color:
                                        AppTheme.white.withOpacity(.8),
                                      ),
                                    ),

                                    SizedBox(
                                      height: isCompact ? 8 : 10,
                                    ),

                                    Text(
                                      'Choose a conversation from your inbox '
                                          'to start messaging.',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                        fontSize: subTitleSize,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
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
                        final String platform =
                        chat.platform.toLowerCase();

                        final String backgroundImage =
                        platform == 'whatsapp'
                            ? 'assets/images/w_bg.png'
                            : 'assets/images/bgfb.jpg';

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
                                OmniChannelProfileHeader(
                                  name: name,
                                  primaryColor: Colors.white,
                                ),

                                Expanded(
                                  child: ListView.builder(
                                    controller:
                                    ctrl.messageScrollController,
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isCompact
                                          ? 10
                                          : (isMedium ? 18 : 28),
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

                                Obx(
                                      () => ctrl.showEmojiBoard.value
                                      ? EmojiPicker(
                                    textEditingController:
                                    ctrl.msgController,
                                    config: const Config(
                                      height: 300,
                                    ),
                                  )
                                      : const SizedBox.shrink(),
                                ),

                                if (platform == 'whatsapp')
                                  MessageInput(
                                    controller: ctrl,
                                    onSend: ctrl.sendMessage,
                                  )
                                else if (platform == 'messenger' ||
                                    platform == 'facebook')
                                  MessengerMessageInput(
                                    controller: ctrl,
                                    onSend: ctrl.sendMessage,
                                  )
                                else if (platform == 'instagram')
                                    InstagramMessageInput(
                                      controller: ctrl,
                                      onSend: ctrl.sendMessage,
                                    )
                                  else
                                    MessageInput(
                                      controller: ctrl,
                                      onSend: ctrl.sendMessage,
                                    ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ),

                /// PROFILE PANEL SIRF NORMAL CHAT MEIN
                if (!isMobile && !isTablet)
                    SizedBox(
                    width: 400,
                    child: ProfilePanel(),
                  ),
              ],
            );
          }),
        );
      },
    );
  }
}