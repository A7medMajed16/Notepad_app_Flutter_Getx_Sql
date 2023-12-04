import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  TextEditingController confirmPassController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  String errorMessage = '';
  String? errorTextPassword;
  String? errorTextUserName;
  String? errorTextEmail;
  String? errorTextSubmitPassword;

  bool hidPass = true;
  bool hidConfirmPass = true;

  Future signUpAccount(String emailAddress, String password) async {
    if (mounted) {
      try {
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailAddress,
          password: password,
        );
        // Clear the error message on successful sign-up
        if (mounted) {
          setState(() {
            errorMessage = '';
          });
        }
        Get.back();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password' && mounted) {
          setState(() {
            errorTextPassword = 'The password is weak.';
          });
        } else if (e.code == 'email-already-in-use' && mounted) {
          setState(() {
            errorTextEmail = 'The account already exists for that email.';
          });
        } else if (mounted) {
          setState(() {
            errorMessage = e.message ?? 'An unknown error occurred.';
          });
        }
      } catch (e) {
        if (mounted) {
          setState(() {
            errorMessage = e.toString();
          });
        }
      }
    }
  }

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return errorTextUserName = 'Please enter Your Name';
    } else {
      return errorTextUserName = null;
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
  void dispose() {
    passController.dispose();
    emailController.dispose();
    userNameController.dispose();
    confirmPassController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Sign Up',
          style: GoogleFonts.mPlusRounded1c(
            color: Colors.grey[850],
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      body: SizedBox(
        height: size.height,
        width: size.width,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          errorMessage,
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.red[900],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Form(
                          key: formKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextFormField(
                                controller: userNameController,
                                validator: validateUserName,
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(
                                    Icons.person_rounded,
                                  ),
                                  hintText: 'User Name',
                                  label: Text(
                                    'User Name',
                                    style: GoogleFonts.mPlusRounded1c(
                                      color: Colors.grey[850],
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        width: 2.5,
                                        color: Colors.grey[850] ??
                                            Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  errorText: errorTextUserName,
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
                                        color: Colors.grey[850] ??
                                            Colors.transparent,
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
                                        color: Colors.grey[850] ??
                                            Colors.transparent,
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
                                        color: Colors.grey[850] ??
                                            Colors.transparent,
                                      ),
                                      borderRadius: BorderRadius.circular(10)),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10)),
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
                        SizedBox(
                          width: size.width,
                          height: size.width / 8,
                          child: ElevatedButton(
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                signUpAccount(
                                    emailController.text, passController.text);
                              }
                            },
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              backgroundColor:
                                  MaterialStatePropertyAll(Colors.grey[850]),
                            ),
                            child: Text(
                              'Sing Up',
                              style: GoogleFonts.mPlusRounded1c(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                          "I have account",
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.grey[850],
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        SizedBox(
                          width: size.width,
                          height: size.width / 8,
                          child: ElevatedButton(
                            onPressed: () async {
                              await signUpAccount(
                                  emailController.text, passController.text);
                              Get.back();
                            },
                            style: ButtonStyle(
                              shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    side: BorderSide(
                                        color: Colors.grey[850] ??
                                            Colors.transparent),
                                    borderRadius: BorderRadius.circular(10)),
                              ),
                              backgroundColor:
                                  const MaterialStatePropertyAll(Colors.white),
                            ),
                            child: Text(
                              'Sign In',
                              style: GoogleFonts.mPlusRounded1c(
                                color: Colors.grey[850],
                                fontSize: 25,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
