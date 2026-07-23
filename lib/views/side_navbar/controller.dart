import 'package:get/get.dart';

import '../../models/convo_list.dart';

class SideController extends GetxController {
  /// Main screen/sidebar navigation
  final RxInt selectedIndex = 0.obs;

  /// Selected social channel
  final RxString selectedChannel = "WhatsApp".obs;

  /// Expanded list
  final RxString expandedList = "".obs;

  /// Center panel view
  final RxString selectedView = "Chat".obs;

  /// Conversations
  final RxList<ConversationModel> conversations =
      <ConversationModel>[].obs;

  /// Selected conversation
  final Rxn<ConversationModel> selectedConversation =
  Rxn<ConversationModel>();

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  /// Sidebar social icon button click
  void changeChannel(String channel) {
    selectedChannel.value = channel;

    final bool shouldExpand =
        expandedList.value != channel;

    toggleExpandedList(
      channel,
      shouldExpand,
    );

    /// Dashboard page open
    selectedIndex.value = 0;
  }

  /// ExpansionTile ya sidebar icon se expand/collapse
  void toggleExpandedList(
      String channel,
      bool value,
      ) {
    if (value) {
      selectedChannel.value = channel;
      expandedList.value = channel;
    } else if (expandedList.value == channel) {
      expandedList.value = "";
    }
  }

  bool isExpanded(String channel) {
    return expandedList.value == channel;
  }

  bool isChannelSelected(String channel) {
    return selectedChannel.value == channel;
  }

  List<ConversationModel> getByPlatform(
      String platform,
      ) {
    return conversations.where((item) {
      return item.platform == platform;
    }).toList();
  }

  int countByPlatform(String platform) {
    return getByPlatform(platform).length;
  }

  void selectConversation(
      ConversationModel item,
      ) {
    selectedConversation.value = item;
  }

  void openChat(
      ConversationModel item,
      ) {
    selectedConversation.value = item;
    selectedView.value = "Chat";
  }

  void openGmail() {
    selectedView.value = "Gmail";
  }
}