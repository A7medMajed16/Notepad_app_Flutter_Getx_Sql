import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupController extends GetxController {
  RxString email = ''.obs;
  RxString pass = ''.obs;
  RxInt currentIndex = 0.obs;
  UserCredential? userCredential;
  bool isVerified = false;
  List<RxBool> progress = [
    true.obs,
    false.obs,
    false.obs,
  ];

  @override
  void onInit() {
    // Initialize email and pass
    email = ''.obs;
    pass = ''.obs;
    super.onInit();
  }

  PageController pageController = PageController(
    initialPage: 0,
    viewportFraction: 1.0,
  );

  void updatePage(int newIndex) {
    currentIndex.value = newIndex;
    update();
  }

  void updateEmailPass(String inputEmail, String inputPass) {
    email.value = inputEmail;
    pass.value = inputPass;
  }

  void updateProgress(int pageNumber, bool status) {
    progress[pageNumber].value = status;
    update();
  }

  void clearProgress() {
    email = ''.obs;
    pass = ''.obs;
    progress = [true.obs, false.obs, false.obs];
  }

  void verifyAccountUpdate(bool inputStatus) async {
    isVerified = inputStatus;
    update(); // Simulate verification success
  }
}
