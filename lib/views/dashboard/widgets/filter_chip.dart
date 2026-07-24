import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../responsive/sizes.dart';
import '../../../theme/theme.dart';
import '../../../widgets/text_widget.dart';

/// Apne controller ka correct path lagao.
import '../controller.dart';

/// ============================================================
/// COMPLETE TOP FILTER + ASSIGNMENT TOOLBAR
/// ============================================================
///
/// Usage:
///
/// topConversationToolbar(
///   context,
///   ctrl: ctrl,
///   conversationId:
///       ctrl.selectedConversation.value?.id,
/// );
///
Widget topConversationToolbar(
    BuildContext context, {
      required DashboardController ctrl,
      String? conversationId,
    }) {
  final bool isMobile =
  Responsive.isMobile(context);

  return Obx(() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      child: isMobile
          ? Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          /// FILTER TABS
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: [
              topTab(
                context,
                text: 'All',
                ctrl: ctrl,
              ),
              topTab(
                context,
                text: 'Unread',
                ctrl: ctrl,
              ),
              topTab(
                context,
                text: 'Assigned',
                ctrl: ctrl,
              ),
              topTab(
                context,
                text: 'Unassigned',
                ctrl: ctrl,
              ),
              topTab(
                context,
                text: 'My Chats',
                ctrl: ctrl,
              ),
              topTab(
                context,
                text: 'Resolved',
                ctrl: ctrl,
              ),
            ],
          ),

          /// Mobile par dropdown next line
          if (conversationId != null) ...[
            const SizedBox(height: 10),

            assignmentDropdown(
              context,
              ctrl: ctrl,
              conversationId:
              conversationId,
            ),
          ],
        ],
      )
          : Row(
        children: [
          /// FILTER TABS
          Expanded(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                topTab(
                  context,
                  text: 'All',
                  ctrl: ctrl,
                ),
                topTab(
                  context,
                  text: 'Unread',
                  ctrl: ctrl,
                ),
                topTab(
                  context,
                  text: 'Assigned',
                  ctrl: ctrl,
                ),
                topTab(
                  context,
                  text: 'Unassigned',
                  ctrl: ctrl,
                ),
                topTab(
                  context,
                  text: 'My Chats',
                  ctrl: ctrl,
                ),
                topTab(
                  context,
                  text: 'Resolved',
                  ctrl: ctrl,
                ),
              ],
            ),
          ),

          /// ASSIGNMENT DROPDOWN
          if (conversationId != null) ...[
            const SizedBox(width: 12),

            assignmentDropdown(
              context,
              ctrl: ctrl,
              conversationId:
              conversationId,
            ),
          ],
        ],
      ),
    );
  });
}

/// ============================================================
/// FILTER TAB CHIP
/// ============================================================

Widget topTab(
    BuildContext context, {
      required String text,
      required DashboardController ctrl,
    }) {
  return Obx(() {
    final bool isMobile =
    Responsive.isMobile(context);

    final bool isTablet =
    Responsive.isTablet(context);

    final bool active =
        ctrl.selectedTab.value == text;

    final int count =
    _getTabCount(
      ctrl: ctrl,
      tab: text,
    );

    return GestureDetector(
      onTap: () {
        ctrl.selectedTab.value = text;

        /// Conversation list GetBuilder mein ho
        /// to usko rebuild karega.
        ctrl.update();
      },
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile
              ? 10
              : isTablet
              ? 14
              : 16,
          vertical: isMobile ? 6 : 8,
        ),
        decoration: BoxDecoration(
          color: active
              ? AppTheme.primaryColor
              : Colors.black,
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color: active
                ? AppTheme.primaryColor
                : Colors.grey.withOpacity(0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextWidget(
              text,
              style: Theme.of(context)
                  .textTheme
                  .labelMedium
                  ?.copyWith(
                color: active
                    ? Colors.white
                    : Colors.grey,
                fontWeight: active
                    ? FontWeight.w600
                    : FontWeight.w400,
              ),
              fontSize: isMobile
                  ? 11
                  : isTablet
                  ? 12
                  : 13,
              fontWeight: active
                  ? FontWeight.w600
                  : FontWeight.w400,
            ),

            const SizedBox(width: 6),

            /// TAB COUNT
            Container(
              constraints:
              const BoxConstraints(
                minWidth: 19,
                minHeight: 19,
              ),
              padding:
              const EdgeInsets.symmetric(
                horizontal: 5,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: active
                    ? Colors.white.withOpacity(
                  0.20,
                )
                    : Colors.white.withOpacity(
                  0.08,
                ),
                borderRadius:
                BorderRadius.circular(20),
              ),
              child: Text(
                count.toString(),
                style: TextStyle(
                  color: active
                      ? Colors.white
                      : Colors.grey,
                  fontSize: 9,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  });
}

/// ============================================================
/// ASSIGNMENT DROPDOWN
/// ============================================================

Widget assignmentDropdown(
    BuildContext context, {
      required DashboardController ctrl,
      required String conversationId,
    }) {
  return Obx(() {
    final int conversationIndex =
    ctrl.conversations.indexWhere(
          (conversation) =>
      conversation.id == conversationId,
    );

    if (conversationIndex == -1) {
      return const SizedBox.shrink();
    }

    final conversation =
    ctrl.conversations[
    conversationIndex];

    final bool isCurrentLoading =
        ctrl.isAssigningConversation.value &&
            ctrl.assigningConversationId.value ==
                conversationId;

    /// Resolved chat par assignment dropdown nahi.
    if (conversation.isResolved) {
      return Container(
        constraints:
        const BoxConstraints(
          minHeight: 39,
        ),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color:
          Colors.green.withOpacity(0.10),
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color:
            Colors.green.withOpacity(0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons
                  .check_circle_outline_rounded,
              color:
              Colors.green.shade700,
              size: 18,
            ),
            const SizedBox(width: 6),
            Text(
              'Resolved',
              style: TextStyle(
                color:
                Colors.green.shade700,
                fontSize: 12,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ],
        ),
      );
    }

    return PopupMenuButton<String>(
      enabled:
      !ctrl.isAssigningConversation.value,
      tooltip: 'Assign conversation',
      position: PopupMenuPosition.under,
      elevation: 8,

      onSelected: (String value) async {
        /// ASSIGN TO ME
        if (value == 'assign_to_me') {
          await ctrl.assignToMe(
            conversationId,
          );

          ctrl.update();
          return;
        }

        /// UNASSIGN
        if (value == 'unassign') {
          await ctrl.unassignConversation(
            conversationId,
          );

          ctrl.update();
          return;
        }

        /// ASSIGN TO SELECTED AGENT
        if (value.startsWith('agent:')) {
          final String rawAgentId =
          value.substring(
            'agent:'.length,
          );

          final int? agentId =
          int.tryParse(rawAgentId);

          if (agentId == null) {
            return;
          }

          await ctrl.assignToAgent(
            conversationId:
            conversationId,
            agentId: agentId,
          );

          ctrl.update();
        }
      },

      itemBuilder: (
          BuildContext context,
          ) {
        final List<
            PopupMenuEntry<String>>
        menuItems = [];

        final int? currentAgentId =
            ctrl.currentAgentId;

        /// ASSIGN TO ME
        if (currentAgentId != null &&
            conversation.assignedAgentId !=
                currentAgentId) {
          menuItems.add(
            PopupMenuItem<String>(
              value: 'assign_to_me',
              child: Row(
                children: [
                  Icon(
                    Icons
                        .person_add_alt_1_rounded,
                    color:
                    AppTheme.primaryColor,
                    size: 19,
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Assign to me',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          );

          menuItems.add(
            const PopupMenuDivider(),
          );
        }

        /// AGENTS LIST
        for (final agent
        in ctrl.activeAgents) {
          final bool isSelected =
              conversation.assignedAgentId ==
                  agent.id;

          menuItems.add(
            PopupMenuItem<String>(
              value: 'agent:${agent.id}',
              child: Row(
                children: [
                  /// AGENT AVATAR
                  Container(
                    width: 32,
                    height: 32,
                    alignment:
                    Alignment.center,
                    decoration:
                    BoxDecoration(
                      color: AppTheme
                          .primaryColor
                          .withOpacity(0.10),
                      shape:
                      BoxShape.circle,
                    ),
                    child: Text(
                      agent.initials,
                      style: TextStyle(
                        color: AppTheme
                            .primaryColor,
                        fontSize: 10,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(width: 10),

                  /// AGENT NAME AND LOAD
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment
                          .start,
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        Text(
                          agent.displayName,
                          maxLines: 1,
                          overflow:
                          TextOverflow
                              .ellipsis,
                          style:
                          const TextStyle(
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${agent.activeChats} active chats',
                          style:
                          const TextStyle(
                            color:
                            Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  /// ONLINE INDICATOR
                  Container(
                    width: 8,
                    height: 8,
                    decoration:
                    BoxDecoration(
                      color: agent.isOnline
                          ? Colors.green
                          : Colors.grey,
                      shape:
                      BoxShape.circle,
                    ),
                  ),

                  /// SELECTED CHECK
                  if (isSelected) ...[
                    const SizedBox(width: 8),
                    const Icon(
                      Icons.check_rounded,
                      size: 18,
                      color: Colors.green,
                    ),
                  ],
                ],
              ),
            ),
          );
        }

        /// UNASSIGN
        if (conversation.hasAssignedAgent) {
          menuItems.add(
            const PopupMenuDivider(),
          );

          menuItems.add(
            const PopupMenuItem<String>(
              value: 'unassign',
              child: Row(
                children: [
                  Icon(
                    Icons
                        .person_remove_alt_1_rounded,
                    size: 19,
                    color: Colors.redAccent,
                  ),
                  SizedBox(width: 10),
                  Text(
                    'Unassign',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return menuItems;
      },

      /// DROPDOWN BUTTON DESIGN
      child: AnimatedContainer(
        duration:
        const Duration(milliseconds: 200),
        constraints:
        const BoxConstraints(
          minHeight: 39,
          maxWidth: 190,
        ),
        padding:
        const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color:
          conversation.hasAssignedAgent
              ? AppTheme.primaryColor
              .withOpacity(0.10)
              : Colors.black,
          borderRadius:
          BorderRadius.circular(20),
          border: Border.all(
            color:
            conversation.hasAssignedAgent
                ? AppTheme.primaryColor
                .withOpacity(0.35)
                : Colors.grey
                .withOpacity(0.25),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isCurrentLoading)
              SizedBox(
                width: 17,
                height: 17,
                child:
                CircularProgressIndicator(
                  strokeWidth: 2,
                  color:
                  AppTheme.primaryColor,
                ),
              )
            else
              Icon(
                conversation.hasAssignedAgent
                    ? Icons
                    .support_agent_rounded
                    : Icons
                    .person_add_alt_1_rounded,
                size: 18,
                color:
                AppTheme.primaryColor,
              ),

            const SizedBox(width: 7),

            Flexible(
              child: Text(
                isCurrentLoading
                    ? 'Assigning...'
                    : conversation
                    .assignedAgentName,
                maxLines: 1,
                overflow:
                TextOverflow.ellipsis,
                style: TextStyle(
                  color:
                  conversation.hasAssignedAgent
                      ? AppTheme
                      .primaryColor
                      : Colors.grey,
                  fontSize: 12,
                  fontWeight:
                  FontWeight.w600,
                ),
              ),
            ),

            const SizedBox(width: 5),

            Icon(
              Icons
                  .keyboard_arrow_down_rounded,
              size: 18,
              color:
              conversation.hasAssignedAgent
                  ? AppTheme.primaryColor
                  : Colors.grey,
            ),
          ],
        ),
      ),
    );
  });
}

/// ============================================================
/// TAB COUNT
/// ============================================================

int _getTabCount({
  required DashboardController ctrl,
  required String tab,
}) {
  final String normalizedTab =
  tab.trim().toLowerCase();

  switch (normalizedTab) {
    case 'unread':
      return ctrl.conversations
          .where(
            (conversation) =>
        conversation.unread > 0,
      )
          .length;

    case 'assigned':
      return ctrl.conversations
          .where(
            (conversation) =>
        conversation.isAssigned,
      )
          .length;

    case 'unassigned':
      return ctrl.conversations
          .where(
            (conversation) =>
        conversation.isUnassigned,
      )
          .length;

    case 'my chats':
      final int? currentAgentId =
          ctrl.currentAgentId;

      if (currentAgentId == null) {
        return 0;
      }

      return ctrl.conversations
          .where(
            (conversation) =>
        conversation.assignedAgentId ==
            currentAgentId,
      )
          .length;

    case 'resolved':
      return ctrl.conversations
          .where(
            (conversation) =>
        conversation.isResolved,
      )
          .length;

    case 'all':
    default:
      return ctrl.conversations.length;
  }
}