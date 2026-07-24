import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:get/get.dart';

import '../constants/AppResource.dart';
import '../general_controller/GeneralController.dart';
 import '../widgets/SuspendedUserDialog.dart';

enum ErrorTitle { suspended }

setCustomHeader(Dio dio, String key, String value) {
  dio.options.headers[key] = value;
}

setLanguageHeader(Dio dio, String key, String value) {
  dio.options.headers[key] = value;
}

setAcceptHeader(Dio dio) {
  // dio.options.headers['Accept'] = 'application/json';
  dio.options.headers['Accept'] = '*/*';
}

setContentHeader(Dio dio) {
  dio.options.headers['Content-Type'] = 'application/json';
}

setBasicAuthHeader(Dio dio) {
  String username = 'hamza.hafeez28@yahoo.com';
  String password = 'aA12345@';
  String basicAuth =
      'Basic ${base64Encode(utf8.encode('$username:$password'))}';
  dio.options.headers['authorization'] = basicAuth;
}

suspendedUserHandle(var response) {
  List<String> title = [];
  List<String> errors = [];
  if (response['errors'] != null) {
    title = List<String>.from(response['errors'].map((x) => x["title"]));
    errors = List<String>.from(response['errors'].map((x) => x["detail"]));
    if (errors.isNotEmpty && title[0] == ErrorTitle.suspended.name) {
      Get.dialog(
          SuspendedUserDialog(
              onPressed: () {
                // NotificationsSubscription.fcmUnSubscribe(
                //     topic: NotificationTopics.shypie.name);
                Get.find<GeneralController>().box.erase();
                // Get.offAll( LoginView());
              },
              message: errors[0]),
          barrierDismissible: false);
      return;
    }
    Get.dialog(
        SuspendedUserDialog(
            onPressed: () {
              // NotificationsSubscription.fcmUnSubscribe(
              //     topic: NotificationTopics.shypie.name);
              Get.find<GeneralController>().box.erase();
              // Get.offAll( LoginView());
            },
            message: AppStrings.session_expired),
        barrierDismissible: false);
  }
  return;

}