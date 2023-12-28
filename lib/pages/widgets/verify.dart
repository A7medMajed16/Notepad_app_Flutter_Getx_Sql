import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trynote/controller/signupcontroller.dart';

class Verify extends StatefulWidget {
  const Verify({super.key});

  @override
  State<Verify> createState() => _VerifyState();
}

class _VerifyState extends State<Verify> {
  SignupController signupController = Get.put(SignupController());

  @override
  void initState() {
    super.initState();
    checkEmailVerification();
  }

  void checkEmailVerification() async {
    signupController.userCredential =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: signupController.email.value,
      password: signupController.pass.value,
    );
    // Create a periodic timer that runs every 2 seconds
    Timer.periodic(const Duration(seconds: 2), (timer) async {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Check if the email is verified
        await user
            .reload(); // Reload user data to get the latest emailVerified status
        user = FirebaseAuth.instance.currentUser; // Get the user data again
        if (user!.emailVerified) {
          timer.cancel(); // Stop the timer since email is verified
          signupController.updateProgress(2, true);
          signupController.updatePage(2);
          signupController.pageController.nextPage(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(children: <Widget>[
        SizedBox(
          height: size.height / 3,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width / 1.1,
                  child: Text(
                    'We have sent a verification link to your email address',
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.clip,
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.grey[850],
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Icon(
                  Icons.verified,
                  size: size.width / 8,
                  // ignore: unrelated_type_equality_checks
                  color: const Color(0xff00ADB5),
                )
              ],
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () async {
                signupController.userCredential =
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                  email: signupController.email.value,
                  password: signupController.pass.value,
                );
                if (FirebaseAuth.instance.currentUser!.emailVerified) {
                  signupController.updateProgress(2, true);
                  signupController.updatePage(2);
                  signupController.pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                } else {
                  Get.snackbar(
                    'Verify your account',
                    'Pleas check your mail',
                    duration: const Duration(seconds: 5),
                    icon: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: const Icon(
                        Icons.error,
                        size: 40,
                        color: Colors.red,
                      ),
                    ),
                    dismissDirection: DismissDirection.horizontal,
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.grey[850]!.withOpacity(0.7),
                    titleText: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Verify your account',
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    messageText: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: Text(
                        'Pleas check your mail',
                        style: GoogleFonts.mPlusRounded1c(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                }
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Next',
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.grey[850],
                      fontSize: size.width / 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Container(
                      width: size.width / 8,
                      height: size.width / 8,
                      decoration: BoxDecoration(
                          color: Colors.grey[850],
                          borderRadius: BorderRadius.circular(size.width / 25)),
                      child: const Icon(
                        color: Colors.white,
                        size: 25,
                        Icons.navigate_next_rounded,
                      )),
                ],
              ),
            )
          ],
        ),
      ]),
    );
  }
}
