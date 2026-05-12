
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'btn.dart'; // Timer ke liye

class DialogueBox {
  static void show(String message, {bool isSuccess = true}) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),

            Image.asset(
              isSuccess
                  ? 'assets/images/ok.png'
                  : 'assets/images/warning.png',
              height: 50,
            ),

            const SizedBox(height: 5),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Get.textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 10),

            /// ONLY show button on success
            if (isSuccess)
              SizedBox(
                width: Get.width * 0.5,
                child: CustomButton(
                  onPressed: () => Get.back(),
                  text: "OK",
                ),
              ),

            const SizedBox(height: 10),
          ],
        ),
      ),
    );

    /// AUTO CLOSE ONLY FOR FAILURE
    if (!isSuccess) {
      Future.delayed(const Duration(seconds: 2), () {
        if (Get.isDialogOpen ?? false) {
          Get.back();
        }
      });
    }
  }
}