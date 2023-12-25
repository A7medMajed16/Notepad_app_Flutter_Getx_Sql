import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trynote/controller/signupcontroller.dart';
import 'package:trynote/pages/loginpage.dart';

class EmailPass extends StatefulWidget {
  const EmailPass({super.key});

  @override
  State<EmailPass> createState() => _EmailPassState();
}

class _EmailPassState extends State<EmailPass> {
  GlobalKey<FormState> formKey = GlobalKey();
  SignupController signupController = Get.put(SignupController());

  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();

  String? errorTextEmail;
  String? errorTextSubmitPassword;
  String? errorTextPassword;

  bool hidPass = true;
  bool hidConfirmPass = true;

  Future signUpAccount(String emailAddress, String password) async {
    if (mounted) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        signupController.updateEmailPass(emailAddress, password);
        signupController.pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        signupController.updatePage(signupController.currentIndex.value + 1);
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password' && mounted) {
          setState(() {
            errorTextPassword = 'The password is weak.';
          });
        } else if (e.code == 'email-already-in-use' && mounted) {
          setState(() {
            errorTextEmail = 'The account already exists for that email.';
          });
        }
      } catch (e) {
        Get.snackbar(
          'Singing Up Failed',
          e.toString(),
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
              'Singing Up Failed',
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
              e.toString(),
              style: GoogleFonts.mPlusRounded1c(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
      }
    }
  }

  // Validator for password
  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return errorTextPassword = 'Please enter a password';
    }
    if (value.length < 6) {
      return errorTextPassword = 'Password should be at least 6 characters';
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return errorTextEmail = 'Please enter an email address';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

    if (!emailRegex.hasMatch(value)) {
      return errorTextEmail = 'Please enter a valid email address';
    }

    return null;
  }

// Validator for password
  String? validateSubmitPassword(String? value) {
    if (value == null || value.isEmpty) {
      return errorTextSubmitPassword = 'Please enter a password again';
    }
    if (confirmPassController.text != passController.text) {
      return errorTextSubmitPassword = 'Submitpassword must equal the password';
    }
    if (confirmPassController.text == passController.text) {
      return errorTextSubmitPassword = null;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  validator: validateEmail,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.email_rounded,
                    ),
                    hintText: 'Email',
                    label: Text(
                      'Email',
                      style: GoogleFonts.mPlusRounded1c(
                        color: Colors.grey[850],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.5,
                          color: Colors.grey[850] ?? Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    errorText: errorTextEmail,
                    errorStyle: GoogleFonts.mPlusRounded1c(
                      color: Colors.red[900],
                      fontSize: 14,
                    ),
                  ),
                  cursorColor: Colors.grey[850],
                  cursorRadius: const Radius.circular(25),
                  cursorWidth: 2.5,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: hidPass,
                  controller: passController,
                  validator: validatePassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_rounded,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidPass = !hidPass;
                        });
                      },
                      icon: Icon(
                        hidPass == true
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                    ),
                    hintText: 'Password',
                    label: Text(
                      'Password',
                      style: GoogleFonts.mPlusRounded1c(
                        color: Colors.grey[850],
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.5,
                          color: Colors.grey[850] ?? Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    errorText: errorTextPassword,
                    errorStyle: GoogleFonts.mPlusRounded1c(
                      color: Colors.red[900],
                      fontSize: 14,
                    ),
                  ),
                  cursorColor: Colors.grey[850],
                  cursorRadius: const Radius.circular(25),
                  cursorWidth: 2.5,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  obscureText: hidConfirmPass,
                  controller: confirmPassController,
                  validator: validateSubmitPassword,
                  decoration: InputDecoration(
                    prefixIcon: const Icon(
                      Icons.lock_reset_rounded,
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          hidConfirmPass = !hidConfirmPass;
                        });
                      },
                      icon: Icon(
                        hidConfirmPass == true
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                      ),
                    ),
                    hintText: 'Confirm Password',
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          width: 2.5,
                          color: Colors.grey[850] ?? Colors.transparent,
                        ),
                        borderRadius: BorderRadius.circular(10)),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)),
                    errorText: errorTextSubmitPassword,
                    errorStyle: GoogleFonts.mPlusRounded1c(
                      color: Colors.red[900],
                      fontSize: 14,
                    ),
                  ),
                  cursorColor: Colors.grey[850],
                  cursorRadius: const Radius.circular(25),
                  cursorWidth: 2.5,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  signupController.updatePage(0);
                  signupController.clearProgress();
                  Get.offAll(const LoginPage());
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
                      'Cancel',
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
                  signupController.updatePage(1);
                  signupController.updateProgress(0, true);
                  // if (formKey.currentState!.validate()) {
                  //   signUpAccount(emailController.text, passController.text);
                  // }
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
                            borderRadius:
                                BorderRadius.circular(size.width / 25)),
                        child: const Icon(
                          color: Colors.white,
                          size: 25,
                          Icons.navigate_next_rounded,
                        )),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
