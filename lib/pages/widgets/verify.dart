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
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Column(children: <Widget>[
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () {
                signupController.updateProgress(0, false);
                signupController.updatePage(0);
                signupController.pageController.previousPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: size.width / 8,
                    height: size.width / 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(size.width / 25),
                        border: Border.all(
                          color: Colors.grey[850] ?? Colors.transparent,
                          width: 2,
                        )),
                    child: Icon(
                      color: Colors.grey[850],
                      size: 25,
                      Icons.arrow_back_ios_rounded,
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    'Back',
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.grey[850],
                      fontSize: size.width / 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                signupController.pageController.nextPage(
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
                signupController.updatePage(2);
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
