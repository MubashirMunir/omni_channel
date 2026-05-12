import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/AppResource.dart';





class ResponseDialog {
  static showError(String errorMessage, [VoidCallback? onClick]) {
    showDialog(
      context: Get.context!,
      builder: (BuildContext context) {
        return Platform.isAndroid
            ? AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(AppStrings.error),
          content: Text(errorMessage),
          actions: <Widget>[
            TextButton(
              child: Text(AppStrings.ok),
              onPressed: () {
                onClick != null
                    ? onClick()
                    : Navigator.of(context).pop();
              },
            ),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CupertinoAlertDialog(
            title: Text(AppStrings.error),
            content: Text(errorMessage),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  onClick != null
                      ? onClick()
                      : Navigator.of(context).pop();
                },
                child: Text(AppStrings.ok),
              ),
            ],
          ),
        );
      },
    );
  }

  static void showSuccess(String message, [VoidCallback? onClick]) {
    showDialog(
      context: Get.context!,
      barrierDismissible: onClick != null ? false : true,
      builder: (BuildContext context) {
        return Platform.isAndroid
            ? AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          title: Text(AppStrings.success),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text(AppStrings.ok),
              onPressed: () {
                onClick != null
                    ? onClick()
                    : Navigator.of(context).pop();
              },
            ),
          ],
        )
            : ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: CupertinoAlertDialog(
            title: Text(AppStrings.success),
            content: Text(message),
            actions: [
              CupertinoDialogAction(
                isDefaultAction: true,
                onPressed: () {
                  onClick != null
                      ? onClick()
                      : Navigator.of(context).pop();
                },
                child: Text(AppStrings.ok),
              ),
            ],
          ),
        );
      },
    );
  }

}
