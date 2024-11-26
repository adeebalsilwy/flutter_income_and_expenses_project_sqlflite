import 'package:flutter/material.dart';

class Dimensions {
  late double screenHeight;
  late double screenWidth;

  Dimensions(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
  }

  double get carouselContainer => screenHeight / 3.4;
  double get parentCarouselContainer => screenHeight / 2.7;
  double get carouselTextContainer => screenHeight / 7.9;
  double get height10 => screenHeight / 84.4;
  double get height20 => screenHeight / 40.2;
  double get height5 => screenHeight / 126.6;
  double get paddingLeft20 => screenHeight / 30.0;
  double get width5 => screenWidth / 60.8;
  double get width10 => screenWidth / 41.2;
  double get width20 => screenWidth / 20.6;
  double get fontSize10 => screenHeight / 84.4;
  double get fontSize15 => screenHeight / 53.74;
  double get fontSize20 => screenHeight / 42.2;
  double get fontSize21 => screenHeight / 38.2;
  double get padding7 => screenHeight / 120.2;
  double get radius10 => screenHeight / 84.4;
  double get radius15 => screenHeight / 53.74;
  double get radius20 => screenHeight / 42.2;
  double get iconSizeHeight45 => screenHeight / 18.5;
  double get iconSize17 => screenHeight / 35.2;
  double get iconsize16 => screenHeight / 53.74;
  double get listviewContainer => screenHeight / 7.3;
  double get listviewTextContainer => screenHeight / 9.7;
  double get popularFoodImgSize => screenHeight / 2.41;
  double get bottomHieghtBar => screenHeight / 7.03;
}
