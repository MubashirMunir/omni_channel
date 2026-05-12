import 'dart:async';
import 'dart:developer';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../constants/AppResource.dart';
import '../constants/keys.dart';
import '../models/login_model.dart';
import '../widgets/dialog.dart';

class GeneralController extends GetxController {
  ///-------------------------------------------
  var userModel = LoginModel();
  LoginModel? userData;
  ///-------------------------------------------
  GetStorage box = GetStorage();
  Color primaryColor = Color(0xFF2C5591);
  var isDarkMode = false.obs;
  ThemeMode get themeMode => isDarkMode.value ? ThemeMode.dark : ThemeMode.light;

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(themeMode);
    update();
  }


  ///-------------------------------internet-check
  bool internetChecker = true;
  var unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    // Retrieve the user model from storage
    if (box.hasData(AppKeys.user)) {
      userModel = LoginModel.fromJson(box.read(AppKeys.user));
      // log("UserModel loaded from storage: ${use()}");
    }
  }

  changeInternetCheckerState(bool value) {
    internetChecker = value;
    update();
  }

  ///----internet-settings-------------
  String connectionStatus = 'Unknown';
  final Connectivity connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? connectivitySubscription;
  bool internetCheck = true;
  bool errorBoxShow = false;

  //---------internet-checker-functions----------------------

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initConnectivity() async {
    ConnectivityResult? result;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      result = (await connectivity.checkConnectivity()) as ConnectivityResult?;
      update();
    } on PlatformException catch (e) {
      log(e.toString());
    }
    log('updateConnectionStatus');
    return updateConnectionStatus(result!);
  }

  Future<void> updateConnectionStatus(ConnectivityResult result) async {
    log('updateConnectionStatus  $result');
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.none:
        connectionStatus = result.toString();
        if (result != ConnectivityResult.none) {
          internetCheck = true;
          // Get.find<SplashScreenLogic>().timer();
        } else {
          internetCheck = false;
          ResponseDialog.showError(AppStrings.checkInternet);
          log('InternetOFF');
        }
        update();
        break;
      default:
        connectionStatus = 'Failed to get connectivity.';
        update();
        break;
    }
  }

  ///------------------------------App Direction Check
  bool isDirectionRTL(BuildContext context) {
    final TextDirection currentDirection = Directionality.of(context);
    final bool isRTL = currentDirection == TextDirection.rtl;
    return isRTL;
  }

  ///------------------------------- loader-check
  bool loaderCheck = false;
  String? message;

  changeLoaderCheck(bool value, {String? message}) {
    loaderCheck = value;
    this.message = message;
    update();
  }

  ///------------------------------- Server-check
  bool serverCheck = true;

  changeServerCheck(bool value) {
    serverCheck = value;
    update();
  }

  void logout() {
    // Token remove kar diya
    box.remove(AppKeys.authToken);

    // Login screen pe bhej diya
    // Get.offAll(() => LoginView());
  }

  logoutHandle(bool responseCheck, Map<String, dynamic> response) {
    if (responseCheck) {
      print("logoutHandle:${response}");
      // Clear user-related data from the controller
      Get.snackbar(AppStrings.success, response['message']);
      // NotificationsSubscription.fcmUnSubscribe(topic:userModel?.sId);
      manageLogout();
      return;
    }
    // Error handling
    List<String> errors = [];
    // Check if errors is an array
    if (response['errors'] != null) {
      if (response['errors'] is List) {
        errors = List<String>.from(response['errors'].map((x) => x["detail"]));
      }
    }
    // Check if there's a single error object
    if (response['error'] != null) {
      errors.add(response['error']['detail']);
    }
    if (errors.isNotEmpty) {
      ResponseDialog.showError(errors[0]);
    }
  }

  void manageLogout() {
    userModel = LoginModel();
    box.remove(AppKeys.authToken);
    box.remove(AppKeys.user);
    // Get.offAll(LoginView());
  }
}

class ThemeController extends GetxController {
  final _storage = GetStorage();
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    // load saved theme
    isDarkMode.value = _storage.read('isDarkMode') ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    _storage.write('isDarkMode', isDarkMode.value);
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    update();
  }

  void setThemeMode(ThemeMode mode) {
    isDarkMode.value = (mode == ThemeMode.dark);
    _storage.write('isDarkMode', isDarkMode.value);
    Get.changeThemeMode(mode);
  }
}
