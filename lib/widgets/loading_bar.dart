import 'dart:io' show Platform;

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../general_controller/GeneralController.dart';



class AppLoading extends StatelessWidget {
  const AppLoading({Key? key, this.message}) : super(key: key);
  final String? message;

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        backgroundColor: Colors.black54,
        body: Center(
          child: Stack(
            alignment: Alignment.center,
            children: [
              // 🔹 Image (center)
              Container(
                width: 45,

                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'assets/images/e.png', // 👈 apni image path lagao

                  ),
                ),
              ),

              // 🔹 Circular loader (image ke upar)
              SizedBox(
                width: 40,
                height: 40,
                child: (!kIsWeb && Platform.isAndroid) || kIsWeb
                    ? CircularProgressIndicator(
                  strokeCap: StrokeCap.round, // 👈 ye line add karo

                  strokeWidth: 4,
                  color: Colors.white, // ye mask ke liye white hi rahega
                )

                    : const CupertinoActivityIndicator(

                  radius: 22,
                  color: Colors.white,

                ),
              ),
            ],
          ),
        ),
      );

  }
}


class AppLoadingWidget {
  static GetBuilder<GeneralController> loadingBar() {
    return GetBuilder<GeneralController>(

      builder: (controller) {
        return controller.loaderCheck ? AppLoading() : const Offstage();
      },
    );
  }
}




