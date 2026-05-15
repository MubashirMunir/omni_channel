import 'package:elite_csr/theme/theme.dart';
import 'package:elite_csr/views/dashboard/controller.dart';
import 'package:elite_csr/views/dashboard/widgets/convo_list.dart';
import 'package:elite_csr/views/dashboard/widgets/message_buble.dart';
import 'package:elite_csr/views/dashboard/widgets/profile_panel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../responsive/sizes.dart';

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
              /// CHAT LIST
              ///
              SizedBox(
                width: isMobile
                    ? 0
                    : isTablet
                    ? 320
                    : 380,
                child: ConvoPanel(ctrl: ctrl),
              ),

              /// CENTER CHAT AREA
              Expanded(
                child: Obx(() {
                  final chat = ctrl.selectedConversation.value;

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final double width = constraints.maxWidth;

                      final bool isCompact = width < 600;
                      final bool isMedium = width >= 600 && width < 1024;
                      final bool isLarge = width >= 1024;

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

                      final double avatarRadius = isCompact
                          ? 20
                          : isMedium
                          ? 22
                          : 24;

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
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(
                                          fontSize: titleSize,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.black,
                                        ),
                                  ),

                                  SizedBox(height: isCompact ? 8 : 10),

                                  Text(
                                    "Choose a conversation from your inbox to start messaging.",
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
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

                      final String profile = chat.profile.trim();
                      final String name = chat.name.trim();

                      final String backgroundImage =
                          chat.platform.toLowerCase() == "whatsapp"
                          ? "assets/images/w_bg.png"
                          : chat.platform.toLowerCase() == "instagram"
                          ? "assets/images/insta_bg.png"
                          : chat.platform.toLowerCase() == "facebook"
                          ? "assets/images/messenger_bg.png"
                          : "assets/images/default_bg.png";

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
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.90),
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.black.withOpacity(0.06),
                                    ),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    CircleAvatar(
                                      radius: avatarRadius,
                                      backgroundColor: AppTheme.primaryColor,
                                      backgroundImage: profile.isNotEmpty
                                          ? NetworkImage(profile)
                                          : null,
                                      onBackgroundImageError: profile.isNotEmpty
                                          ? (_, __) {}
                                          : null,
                                      child: profile.isEmpty
                                          ? Text(
                                              name.isNotEmpty
                                                  ? name[0].toUpperCase()
                                                  : "U",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.w700,
                                                    fontSize: isCompact
                                                        ? 12
                                                        : 14,
                                                  ),
                                            )
                                          : null,
                                    ),

                                    SizedBox(width: isCompact ? 10 : 12),

                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            name.isNotEmpty
                                                ? name
                                                : "Unknown User",
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
                                  ],
                                ),
                              ),

                              /// CHAT BUBBLES
                              Expanded(
                                child: ListView.builder(
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
                                      child: MessageBubble(message: msg),
                                    );
                                  },
                                ),
                              ),

                              /// INPUT
                              Container(
                                padding: EdgeInsets.only(
                                  left: horizontalPadding,
                                  right: horizontalPadding,
                                  top: isCompact ? 8 : 10,
                                  bottom: isCompact ? 8 : 12,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.94),
                                  border: Border(
                                    top: BorderSide(
                                      color: Colors.black.withOpacity(0.06),
                                    ),
                                  ),
                                ),
                                child: MessageInput(
                                  controller: ctrl.msgController,
                                  onSend: () {
                                    ctrl.sendMessage();
                                  },
                                ),
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

// class DashboardView extends StatelessWidget {
//   const DashboardView({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetBuilder<DashboardController>(
//       init: DashboardController(),
//       builder: (ctrl) {
//         return Scaffold(
//           resizeToAvoidBottomInset: true,
//           body: LayoutBuilder(
//             builder: (context, constraints) {
//               final sizes = _DashboardSizes.fromWidth(constraints.maxWidth);
//
//               return Obx(() {
//                 final chat = ctrl.selectedConversation.value;
//
//                 /// MOBILE
//                 /// Mobile par agar chat select nahi hai to full convo list.
//                 /// Agar chat select hai to full chat screen with back button.
//                 if (sizes.isMobile) {
//                   if (chat == null) {
//                     return SafeArea(
//                       child: ConvoPanel(ctrl: ctrl),
//                     );
//                   }
//
//                   return _ChatArea(
//                     ctrl: ctrl,
//                     chat: chat,
//                     sizes: sizes,
//                     showBackButton: true,
//                   );
//                 }
//
//                 /// TABLET + WEB
//                 return SafeArea(
//                   child: Row(
//                     children: [
//                       /// LEFT CONVERSATION LIST
//                       SizedBox(
//                         width: sizes.convoPanelWidth,
//                         child: ConvoPanel(ctrl: ctrl),
//                       ),
//
//                       VerticalDivider(
//                         width: 1,
//                         thickness: 1,
//                         color: Theme.of(context).dividerTheme.color,
//                       ),
//
//                       /// CENTER CHAT AREA
//                       Expanded(
//                         child: _ChatArea(
//                           ctrl: ctrl,
//                           chat: chat,
//                           sizes: sizes,
//                           showBackButton: false,
//                         ),
//                       ),
//
//                       /// RIGHT PROFILE PANEL ONLY ON WIDE WEB
//                       if (sizes.showProfilePanel && chat != null) ...[
//                         VerticalDivider(
//                           width: 1,
//                           thickness: 1,
//                           color: Theme.of(context).dividerTheme.color,
//                         ),
//                         SizedBox(
//                           width: sizes.profilePanelWidth,
//                           child:  ProfilePanel(),
//                         ),
//                       ],
//                     ],
//                   ),
//                 );
//               });
//             },
//           ),
//         );
//       },
//     );
//   }
// }
//
// class _ChatArea extends StatelessWidget {
//   const _ChatArea({
//     required this.ctrl,
//     required this.chat,
//     required this.sizes,
//     required this.showBackButton,
//   });
//
//   final DashboardController ctrl;
//   final dynamic chat;
//   final _DashboardSizes sizes;
//   final bool showBackButton;
//
//   @override
//   Widget build(BuildContext context) {
//     if (chat == null) {
//       return _EmptyChatState(sizes: sizes);
//     }
//
//     final String profile = chat.profile.toString().trim();
//     final String name = chat.name.toString().trim();
//     final String platform = chat.platform.toString().toLowerCase().trim();
//
//     final String backgroundImage = platform == "whatsapp"
//         ? "assets/images/w_bg.png"
//         : platform == "instagram"
//         ? "assets/images/insta_bg.png"
//         : platform == "facebook"
//         ? "assets/images/messenger_bg.png"
//         : "assets/images/default_bg.png";
//
//     return Container(
//       decoration: BoxDecoration(
//         image: DecorationImage(
//           image: AssetImage(backgroundImage),
//           fit: BoxFit.cover,
//         ),
//       ),
//       child: Column(
//         children: [
//           _ChatHeader(
//             ctrl: ctrl,
//             name: name,
//             profile: profile,
//             sizes: sizes,
//             showBackButton: showBackButton,
//           ),
//
//           /// MESSAGE LIST
//           Expanded(
//             child: LayoutBuilder(
//               builder: (context, constraints) {
//                 final double listWidth = constraints.maxWidth;
//
//                 final double contentWidth = sizes.isDesktop
//                     ? listWidth.clamp(600.0, 920.0)
//                     : listWidth;
//
//                 return Align(
//                   alignment: Alignment.topCenter,
//                   child: SizedBox(
//                     width: contentWidth,
//                     child: ListView.builder(
//                       keyboardDismissBehavior:
//                       ScrollViewKeyboardDismissBehavior.onDrag,
//                       padding: EdgeInsets.symmetric(
//                         horizontal: sizes.messageHorizontalPadding,
//                         vertical: sizes.messageVerticalPadding,
//                       ),
//                       itemCount: ctrl.messages.length,
//                       itemBuilder: (_, index) {
//                         final msg = ctrl.messages[index];
//
//                         return Padding(
//                           padding: EdgeInsets.only(
//                             bottom: sizes.messageGap,
//                           ),
//                           child: MessageBubble(
//                             message: msg,
//                           ),
//                         );
//                       },
//                     ),
//                   ),
//                 );
//               },
//             ),
//           ),
//
//           /// MESSAGE INPUT
//           _MessageInputWrapper(
//             sizes: sizes,
//             child: MessageInput(
//               controller: ctrl.msgController,
//               onSend: () {
//                 ctrl.sendMessage();
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// class _ChatHeader extends StatelessWidget {
//   const _ChatHeader({
//     required this.ctrl,
//     required this.name,
//     required this.profile,
//     required this.sizes,
//     required this.showBackButton,
//   });
//
//   final DashboardController ctrl;
//   final String name;
//   final String profile;
//   final _DashboardSizes sizes;
//   final bool showBackButton;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final bool isDark = theme.brightness == Brightness.dark;
//
//     final Color surfaceColor = isDark
//         ? const Color(0xFF101A2B).withOpacity(0.92)
//         : Colors.white.withOpacity(0.92);
//
//     final Color titleColor = isDark ? Colors.white : Colors.black;
//     final Color subtitleColor = isDark ? Colors.white70 : Colors.grey.shade600;
//     final Color borderColor =
//     isDark ? Colors.white.withOpacity(0.08) : Colors.black.withOpacity(0.06);
//
//     return ClipRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(
//           sigmaX: 14,
//           sigmaY: 14,
//         ),
//         child: Container(
//           padding: EdgeInsets.symmetric(
//             horizontal: sizes.headerHorizontalPadding,
//             vertical: sizes.headerVerticalPadding,
//           ),
//           decoration: BoxDecoration(
//             color: surfaceColor,
//             border: Border(
//               bottom: BorderSide(
//                 color: borderColor,
//               ),
//             ),
//           ),
//           child: Row(
//             children: [
//               if (showBackButton) ...[
//                 IconButton(
//                   onPressed: () {
//                     ctrl.selectedConversation.value = null;
//                   },
//                   icon: const Icon(Icons.arrow_back_rounded),
//                   tooltip: "Back",
//                   visualDensity: VisualDensity.compact,
//                 ),
//                 SizedBox(width: sizes.smallGap),
//               ],
//
//               CircleAvatar(
//                 radius: sizes.avatarRadius,
//                 backgroundColor: AppTheme.primaryColor,
//                 backgroundImage: profile.isNotEmpty ? NetworkImage(profile) : null,
//                 onBackgroundImageError:
//                 profile.isNotEmpty ? (_, __) {} : null,
//                 child: profile.isEmpty
//                     ? Text(
//                   name.isNotEmpty ? name[0].toUpperCase() : "U",
//                   style: theme.textTheme.bodySmall?.copyWith(
//                     color: Colors.white,
//                     fontSize: sizes.avatarTextSize,
//                     fontWeight: FontWeight.w800,
//                   ),
//                 )
//                     : null,
//               ),
//
//               SizedBox(width: sizes.mediumGap),
//
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name.isNotEmpty ? name : "Unknown User",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: theme.textTheme.bodyMedium?.copyWith(
//                         fontSize: sizes.chatTitleSize,
//                         fontWeight: FontWeight.w800,
//                         color: titleColor,
//                       ),
//                     ),
//                     SizedBox(height: sizes.extraSmallGap),
//                     Text(
//                       "Online",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: theme.textTheme.bodySmall?.copyWith(
//                         fontSize: sizes.chatSubtitleSize,
//                         fontWeight: FontWeight.w500,
//                         color: subtitleColor,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               if (!sizes.isMobile) ...[
//                 SizedBox(width: sizes.mediumGap),
//                 _HeaderIconButton(
//                   icon: Icons.search_rounded,
//                   sizes: sizes,
//                   onTap: () {},
//                 ),
//                 SizedBox(width: sizes.smallGap),
//                 _HeaderIconButton(
//                   icon: Icons.more_vert_rounded,
//                   sizes: sizes,
//                   onTap: () {},
//                 ),
//               ],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _HeaderIconButton extends StatelessWidget {
//   const _HeaderIconButton({
//     required this.icon,
//     required this.sizes,
//     required this.onTap,
//   });
//
//   final IconData icon;
//   final _DashboardSizes sizes;
//   final VoidCallback onTap;
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return InkWell(
//       onTap: onTap,
//       borderRadius: BorderRadius.circular(100),
//       child: Container(
//         height: sizes.headerIconButtonSize,
//         width: sizes.headerIconButtonSize,
//         decoration: BoxDecoration(
//           color: isDark
//               ? Colors.white.withOpacity(0.08)
//               : Colors.black.withOpacity(0.04),
//           shape: BoxShape.circle,
//         ),
//         child: Icon(
//           icon,
//           size: sizes.headerIconSize,
//           color: isDark ? Colors.white : Colors.black87,
//         ),
//       ),
//     );
//   }
// }
//
// class _MessageInputWrapper extends StatelessWidget {
//   const _MessageInputWrapper({
//     required this.sizes,
//     required this.child,
//   });
//
//   final _DashboardSizes sizes;
//   final Widget child;
//
//   @override
//   Widget build(BuildContext context) {
//     final bool isDark = Theme.of(context).brightness == Brightness.dark;
//
//     return ClipRect(
//       child: BackdropFilter(
//         filter: ImageFilter.blur(
//           sigmaX: 14,
//           sigmaY: 14,
//         ),
//         child: Container(
//           padding: EdgeInsets.only(
//             left: sizes.inputHorizontalPadding,
//             right: sizes.inputHorizontalPadding,
//             top: sizes.inputTopPadding,
//             bottom: sizes.inputBottomPadding,
//           ),
//           decoration: BoxDecoration(
//             color: isDark
//                 ? const Color(0xFF101A2B).withOpacity(0.92)
//                 : Colors.white.withOpacity(0.94),
//             border: Border(
//               top: BorderSide(
//                 color: isDark
//                     ? Colors.white.withOpacity(0.08)
//                     : Colors.black.withOpacity(0.06),
//               ),
//             ),
//           ),
//           child: Center(
//             child: ConstrainedBox(
//               constraints: BoxConstraints(
//                 maxWidth: sizes.inputMaxWidth,
//               ),
//               child: child,
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _EmptyChatState extends StatelessWidget {
//   const _EmptyChatState({
//     required this.sizes,
//   });
//
//   final _DashboardSizes sizes;
//
//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final bool isDark = theme.brightness == Brightness.dark;
//
//     return Center(
//       child: SingleChildScrollView(
//         padding: EdgeInsets.symmetric(
//           horizontal: sizes.emptyHorizontalPadding,
//           vertical: sizes.emptyVerticalPadding,
//         ),
//         child: ConstrainedBox(
//           constraints: BoxConstraints(
//             maxWidth: sizes.emptyMaxWidth,
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Image.asset(
//                 "assets/images/box.png",
//                 height: sizes.emptyImageHeight,
//                 fit: BoxFit.contain,
//               ),
//
//               SizedBox(height: sizes.largeGap),
//
//               Text(
//                 "Select a conversation",
//                 textAlign: TextAlign.center,
//                 style: theme.textTheme.labelLarge?.copyWith(
//                   fontSize: sizes.emptyTitleSize,
//                   fontWeight: FontWeight.w800,
//                   color: isDark ? Colors.white : Colors.black,
//                 ),
//               ),
//
//               SizedBox(height: sizes.smallGap),
//
//               Text(
//                 "Choose a conversation from your inbox to start messaging.",
//                 textAlign: TextAlign.center,
//                 style: theme.textTheme.bodySmall?.copyWith(
//                   fontSize: sizes.emptySubtitleSize,
//                   height: 1.5,
//                   color: isDark ? Colors.white70 : Colors.grey.shade600,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class _DashboardSizes {
//   const _DashboardSizes({
//     required this.width,
//     required this.isMobile,
//     required this.isTablet,
//     required this.isDesktop,
//     required this.showProfilePanel,
//     required this.convoPanelWidth,
//     required this.profilePanelWidth,
//     required this.headerHorizontalPadding,
//     required this.headerVerticalPadding,
//     required this.inputHorizontalPadding,
//     required this.inputTopPadding,
//     required this.inputBottomPadding,
//     required this.messageHorizontalPadding,
//     required this.messageVerticalPadding,
//     required this.emptyHorizontalPadding,
//     required this.emptyVerticalPadding,
//     required this.emptyImageHeight,
//     required this.emptyMaxWidth,
//     required this.avatarRadius,
//     required this.avatarTextSize,
//     required this.chatTitleSize,
//     required this.chatSubtitleSize,
//     required this.emptyTitleSize,
//     required this.emptySubtitleSize,
//     required this.headerIconButtonSize,
//     required this.headerIconSize,
//     required this.inputMaxWidth,
//     required this.extraSmallGap,
//     required this.smallGap,
//     required this.mediumGap,
//     required this.largeGap,
//     required this.messageGap,
//   });
//
//   final double width;
//
//   final bool isMobile;
//   final bool isTablet;
//   final bool isDesktop;
//   final bool showProfilePanel;
//
//   final double convoPanelWidth;
//   final double profilePanelWidth;
//
//   final double headerHorizontalPadding;
//   final double headerVerticalPadding;
//
//   final double inputHorizontalPadding;
//   final double inputTopPadding;
//   final double inputBottomPadding;
//
//   final double messageHorizontalPadding;
//   final double messageVerticalPadding;
//
//   final double emptyHorizontalPadding;
//   final double emptyVerticalPadding;
//   final double emptyImageHeight;
//   final double emptyMaxWidth;
//
//   final double avatarRadius;
//   final double avatarTextSize;
//
//   final double chatTitleSize;
//   final double chatSubtitleSize;
//
//   final double emptyTitleSize;
//   final double emptySubtitleSize;
//
//   final double headerIconButtonSize;
//   final double headerIconSize;
//
//   final double inputMaxWidth;
//
//   final double extraSmallGap;
//   final double smallGap;
//   final double mediumGap;
//   final double largeGap;
//   final double messageGap;
//
//   factory _DashboardSizes.fromWidth(double width) {
//     final bool isMobile = width < 700;
//     final bool isTablet = width >= 700 && width < 1200;
//     final bool isDesktop = width >= 1200;
//     final bool showProfilePanel = width >= 1250;
//
//     final double convoPanelWidth = isMobile
//         ? width
//         : isTablet
//         ? (width * 0.36).clamp(280.0, 330.0)
//         : (width * 0.25).clamp(320.0, 390.0);
//
//     final double profilePanelWidth = showProfilePanel
//         ? (width * 0.24).clamp(300.0, 400.0)
//         : 0;
//
//     return _DashboardSizes(
//       width: width,
//
//       isMobile: isMobile,
//       isTablet: isTablet,
//       isDesktop: isDesktop,
//       showProfilePanel: showProfilePanel,
//
//       convoPanelWidth: convoPanelWidth,
//       profilePanelWidth: profilePanelWidth,
//
//       headerHorizontalPadding: isMobile
//           ? 12
//           : isTablet
//           ? 18
//           : 24,
//       headerVerticalPadding: isMobile
//           ? 10
//           : isTablet
//           ? 12
//           : 14,
//
//       inputHorizontalPadding: isMobile
//           ? 10
//           : isTablet
//           ? 18
//           : 24,
//       inputTopPadding: isMobile
//           ? 8
//           : isTablet
//           ? 10
//           : 12,
//       inputBottomPadding: isMobile
//           ? 8
//           : isTablet
//           ? 10
//           : 14,
//
//       messageHorizontalPadding: isMobile
//           ? 10
//           : isTablet
//           ? 18
//           : 24,
//       messageVerticalPadding: isMobile
//           ? 10
//           : isTablet
//           ? 14
//           : 18,
//
//       emptyHorizontalPadding: isMobile
//           ? 20
//           : isTablet
//           ? 32
//           : 40,
//       emptyVerticalPadding: isMobile
//           ? 24
//           : isTablet
//           ? 32
//           : 40,
//       emptyImageHeight: isMobile
//           ? 110
//           : isTablet
//           ? 160
//           : 230,
//       emptyMaxWidth: isMobile
//           ? 320
//           : isTablet
//           ? 440
//           : 540,
//
//       avatarRadius: isMobile
//           ? 19
//           : isTablet
//           ? 22
//           : 24,
//       avatarTextSize: isMobile
//           ? 12
//           : isTablet
//           ? 13
//           : 14,
//
//       chatTitleSize: isMobile
//           ? 14
//           : isTablet
//           ? 15
//           : 16,
//       chatSubtitleSize: isMobile
//           ? 11
//           : isTablet
//           ? 12
//           : 13,
//
//       emptyTitleSize: isMobile
//           ? 16
//           : isTablet
//           ? 18
//           : 20,
//       emptySubtitleSize: isMobile
//           ? 12
//           : isTablet
//           ? 13
//           : 14,
//
//       headerIconButtonSize: isTablet ? 36 : 38,
//       headerIconSize: isTablet ? 18 : 20,
//
//       inputMaxWidth: isDesktop ? 920 : double.infinity,
//
//       extraSmallGap: 3,
//       smallGap: isMobile ? 8 : 10,
//       mediumGap: isMobile ? 10 : 12,
//       largeGap: isMobile ? 18 : 24,
//       messageGap: isMobile ? 8 : 10,
//     );
//   }
// }
