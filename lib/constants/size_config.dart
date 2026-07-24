import 'package:flutter/material.dart';

class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockSizeHorizontal = 0;
  static double blockSizeVertical = 0;

  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;

  static void init(BuildContext context) {
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    double designWidth = 390;
    double designHeight = 844;

    blockSizeHorizontal = screenWidth / designWidth;
    blockSizeVertical = screenHeight / designHeight;

    textMultiplier = blockSizeVertical;
    imageSizeMultiplier = blockSizeHorizontal;
    heightMultiplier = blockSizeVertical;
    widthMultiplier = blockSizeHorizontal;
  }

  static heightInputField() => heightMultiplier * 54.0;
  static height4() => heightMultiplier * 4;
  static height137() => heightMultiplier * 137;
  static height5() => heightMultiplier * 5;
  static height6() => heightMultiplier * 6;
  static height8() => heightMultiplier * 8;
  static height10() => heightMultiplier * 10;
  static height12() => heightMultiplier * 12;
  static height15() => heightMultiplier * 15;
  static height16() => heightMultiplier * 16;
  static height18() => heightMultiplier * 18;
  static height20() => heightMultiplier * 20;
  static height25() => heightMultiplier * 25;
  static height22() => heightMultiplier * 22;
  static height24() => heightMultiplier * 24;
  static height26() => heightMultiplier * 26;
  static height30() => heightMultiplier * 30;
  static height32() => heightMultiplier * 32;
  static height54() => heightMultiplier * 51;
  static height91() => heightMultiplier * 91;
  static height60() => heightMultiplier * 60;
  static height83() => heightMultiplier * 75;
  static height40() => heightMultiplier * 40;
  static height110() => heightMultiplier * 110;
  static height375() => heightMultiplier * 365;
  static height244() => heightMultiplier * 244;
  static height250() => heightMultiplier * 270;

  static width4() => widthMultiplier * 4;
  static width5() => widthMultiplier * 5;
  static width8() => widthMultiplier * 8;
  static width6() => widthMultiplier * 6;
  static width10() => widthMultiplier * 10;
  static width12() => widthMultiplier * 12;
  static width15() => widthMultiplier * 15;
  static width18() => widthMultiplier * 18;
  static width16() => widthMultiplier * 16;
  static width20() => widthMultiplier * 20;
  static width24() => widthMultiplier * 24;
  static width28() => widthMultiplier * 28;
  static width30() => widthMultiplier * 30;
  static width32() => widthMultiplier * 32;
  static width40() => widthMultiplier * 40;
  static width231() => widthMultiplier * 340;
  static width110() => widthMultiplier * 110;
  static width80() => widthMultiplier * 80;
  static width70() => widthMultiplier * 70;
  static width60() => widthMultiplier * 60;
  static width50() => widthMultiplier * 50;
  static width161() => widthMultiplier * 161;

  static font8() => textMultiplier * 8;
  static font10() => textMultiplier * 10;
  static font12() => textMultiplier * 12;
  static font14() => textMultiplier * 14;
  static font16() => textMultiplier * 16;
  static font18() => textMultiplier * 18;
  static font20() => textMultiplier * 20;
  static font22() => textMultiplier * 22;
  static font24() => textMultiplier * 24;
  static font28() => textMultiplier * 28;
  static font32() => textMultiplier * 32;
  static font36() => textMultiplier * 36;

  static hPad8() => heightMultiplier * 8;
  static hPad12() => heightMultiplier * 12;
  static hPad14() => heightMultiplier * 14;
  static hPad16() => heightMultiplier * 16;
  static hPad20() => heightMultiplier * 20;
  static hPad24() => heightMultiplier * 24;
  static hPad40() => heightMultiplier * 40;

  static wPad4() => widthMultiplier * 4;
  static wPad8() => widthMultiplier * 8;
  static wPad10() => widthMultiplier * 10;
  static wPad12() => widthMultiplier * 12;
  static wPad16() => widthMultiplier * 16;
  static wPad20() => widthMultiplier * 20;
  static wPad24() => widthMultiplier * 24;
  static wPad28() => widthMultiplier * 28;
  static wPad30() => widthMultiplier * 30;

  static double smallBorderRadius = 6;
  static double borderRadius = 8;
  static double chipBorderRadius = 4;
  static double alertBorderRadius = 16;
  static double dataAlertBorderRadius = 12;
  static double bottomSheetBorderRadius = 20;
  static double bottomAppBarBorderRadius = 12;
  static double borderWidth = 1;
  static double buttonBorderWidth = 1 * heightMultiplier;
  static double stepperBubbleBorderWidth = 1 * heightMultiplier;
  static double textFieldBorderWidth = 1;
  static double shadowBlur = 2;
  static double dividerHeight = 1;
  static double progressBarBorderRadius = 12;
  static double appBarDividerBlurRadius = 4 * heightMultiplier;
  static double appBarDividerSpreadRadius = 1 * heightMultiplier;

  static double appBarHeight = 58 * heightMultiplier;
  static double bottomNavBarHeight = 56 * heightMultiplier;

  static double getKeyboardBottomPadding(BuildContext context) {
    return MediaQuery.of(context).viewInsets.bottom;
  }

  static double getHeightAfterAppBarOnly(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    const double appBarHeight = kToolbarHeight;
    final double statusBarHeight = MediaQuery.of(context).padding.top;

    return (screenHeight - appBarHeight - statusBarHeight);
  }
}
