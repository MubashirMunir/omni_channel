import 'package:get/get.dart';

class SideController extends GetxController {
  /// Main pages: Home, Statistics, Setting
  final RxInt selectedIndex = 0.obs;

  /// Selected social channel
  final RxString selectedChannel = "".obs;

  /// Conversation list visible hai ya nahi
  final RxBool showConversationList = false.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
  }

  /// Social icon click par call hoga
  void openChannel(String channel) {
    selectedChannel.value = channel;
    showConversationList.value = true;

    /// Dashboard/Home page show karo
    selectedIndex.value = 0;
  }

  /// List close karne ke liye
  void closeChannel() {
    selectedChannel.value = "";
    showConversationList.value = false;
  }

  bool isChannelSelected(String channel) {
    return selectedChannel.value == channel;
  }
}