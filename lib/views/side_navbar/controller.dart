import 'package:get/get.dart';

class SideController extends GetxController {

  RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {

    selectedIndex.value = index;
  }

  String expandedList = "";
  String selectedView = "Dashboard";

  bool get isSelected => selectedView == "Gmail";
  bool get isGmailExpanded => expandedList == "Gmail";

  void toggleExpandedList(String platform, bool value) {
    if (value) {
      expandedList = platform;
    } else if (expandedList == platform) {
      expandedList = "";
    }

    update();
  }

  void openGmail() {
    selectedView = "Gmail";
    expandedList = "Gmail";

    update();
  }

  void onGmailButtonPressed() {
    final bool alreadyOpen = expandedList == "Gmail";

    if (alreadyOpen) {
      expandedList = "";
      selectedView = "Dashboard";
    } else {
      expandedList = "Gmail";
      selectedView = "Gmail";
    }

    update();
  }


}