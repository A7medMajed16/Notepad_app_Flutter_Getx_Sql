import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  RxInt currentIndex = 0.obs;

  PageController pageController = PageController(initialPage: 0,
      viewportFraction: 1.0,);

  void updatePage(int newIndex) {
    currentIndex.value = newIndex;
    update();
  }
}
