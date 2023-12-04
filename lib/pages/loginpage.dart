// ignore_for_file: avoid_print, unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:rive/rive.dart';
import 'package:trynote/auth/logincontroller.dart';
import 'package:trynote/home.dart';
import 'package:trynote/pages/signuppage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginController controller = Get.put(LoginController());
  GlobalKey<FormState> loginFormKey = GlobalKey();
  TextEditingController emailController = TextEditingController();
  TextEditingController passController = TextEditingController();
  bool hidPass = true;
  String errorMessage = '';
  String? errorTextEmail;
  String? errorTextPassword;
  StateMachineController? machineController;

  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  Future signingInWithEmail(String email, String pass) async {
    if (mounted) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passController.text.trim(),
        );
        Get.offAll(const Home());
      } on FirebaseAuthException catch (e) {
        print('===============');
        print(e);

        if (e.code == 'user-not-found') {
          setState(() {
            errorMessage = 'No user found for that email.';
          });
        } else if (e.code == 'wrong-password') {
          setState(() {
            errorMessage = 'Wrong password provided for that user.';
          });
        }
      } catch (e) {
        print('Unexpected Error: $e');
      }
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
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

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return errorTextPassword = 'Please enter Your Name';
    } else {
      return errorTextPassword = null;
    }
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
          'Login',
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
                  SizedBox(
                    width: size.width / 2,
                    height: size.width / 2,
                    child: ClipOval(
                      child: RiveAnimation.asset(
                        'assets/login_animated_character.riv',
                        fit: BoxFit.cover,
                        stateMachines: const ["Login Machine"],
                        onInit: (artboard) {
                          machineController =
                              StateMachineController.fromArtboard(
                                  artboard, "Login Machine");
                          artboard.addController(machineController!);
                          isChecking =
                              machineController?.findInput("isChecking");
                          isHandsUp = machineController?.findInput("isHandsUp");
                          trigSuccess =
                              machineController?.findInput("trigSuccess");
                          trigFail = machineController?.findInput("trigFail");
                        },
                      ),
                    ),
                  ),
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
                          key: loginFormKey,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
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
                                onChanged: (value) {
                                  if (isHandsUp != null) {
                                    isHandsUp!.change(false);
                                  }
                                  if (isChecking == null) return;

                                  isChecking!.change(true);
                                },
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
                                onChanged: (value) {
                                  if (isChecking != null) {
                                    isChecking!.change(false);
                                  }
                                  if (isHandsUp == null) return;

                                  isHandsUp!.change(true);
                                },
                                cursorColor: Colors.grey[850],
                                cursorRadius: const Radius.circular(25),
                                cursorWidth: 2.5,
                              ),
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
                              if (loginFormKey.currentState!.validate()) {
                                signingInWithEmail(
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
                              'Sing In',
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
                          "if you don't have account",
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
                            onPressed: () {
                              Get.to(const SignUpPage());
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
                              'Sign Up',
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
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: size.width,
                              height: 5,
                              decoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  borderRadius: BorderRadius.circular(50)),
                            ),
                            Container(
                              color: Colors.white,
                              width: 30,
                              child: Center(
                                child: Text(
                                  'Or',
                                  style: GoogleFonts.mPlusRounded1c(
                                    color: Colors.grey[850],
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Sign in with   ',
                              style: GoogleFonts.mPlusRounded1c(
                                color: Colors.grey[850],
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () async {
                                signInWithGoogle();
                              },
                              child: Container(
                                width: size.width / 6.5,
                                height: size.width / 6.5,
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey[400] ??
                                            Colors.transparent,
                                        blurRadius: 10,
                                        spreadRadius: 2,
                                      ),
                                    ]),
                                child: SvgPicture.asset(
                                  'assets/google-icon-logo-svgrepo-com.svg',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 10,
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