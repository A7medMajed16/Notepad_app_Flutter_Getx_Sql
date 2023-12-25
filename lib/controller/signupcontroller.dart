import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  RxString? email;
  RxString? pass;
  RxInt currentIndex = 0.obs;

  List<RxBool> progress = [
    false.obs,
    false.obs,
    false.obs,
  ];

  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
  );

  void updatePage(int newIndex) {
    currentIndex.value = newIndex;
    update();
  }

  void updateEmailPass(String inputEmail, String inputPass) {
    email!.value = inputEmail;
    pass!.value = inputPass;
  }

  void updateProgress(int pageNumber, bool status) {
    progress[pageNumber].value = status;
    update();
  }

  void clearProgress() {
    pass = null;
    progress = [false.obs, false.obs, false.obs];
  }
}
