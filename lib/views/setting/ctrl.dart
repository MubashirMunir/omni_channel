import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// ===============================================
/// SETTINGS CONTROLLER
/// ===============================================

class SettingsController extends GetxController {
  int selectedMenu = 0;

  bool darkMode = true;
  bool notifications = true;
  bool autoReply = false;
  bool aiAssistant = true;

  void changeMenu(int index) {
    selectedMenu = index;
    update();
  }

  void toggleDark(bool value) {
    darkMode = value;
    update();
  }

  void toggleNotifications(bool value) {
    notifications = value;
    update();
  }

  void toggleAutoReply(bool value) {
    autoReply = value;
    update();
  }

  void toggleAI(bool value) {
    aiAssistant = value;
    update();
  }
}
