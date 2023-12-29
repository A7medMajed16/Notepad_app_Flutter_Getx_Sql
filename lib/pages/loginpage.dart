// ignore_for_file: avoid_print, unused_local_variable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:rive/rive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trynote/main.dart';

import 'package:trynote/home.dart';
import 'package:trynote/pages/signuppage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> loginFormKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  bool hidPass = true;
  String errorMessage = '';
  String? errorTextEmail;
  String? errorTextPassword;
  StateMachineController? machineController;

  SMIInput<bool>? isChecking;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigSuccess;
  SMIInput<bool>? trigFail;

  bool uploading = false;

  @override
  void initState() {
    sharePrefInt();
    super.initState();
  }

  Future<void> sharePrefInt() async {
    sharepref ??= await SharedPreferences.getInstance();
  }

  Future signingInWithEmail(String email, String pass) async {
    if (mounted) {
      try {
        final credential =
            await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passController.text.trim(),
        );
        if (FirebaseAuth.instance.currentUser!.emailVerified) {
          Get.offAll(const Home());
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
      } on FirebaseAuthException {
        Get.snackbar(
          'Singing In Failed',
          'Email or Password is incorrect',
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
              'Singing In Failed',
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
              'Email or Password is incorrect',
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

  Future signInWithGoogle() async {
    sharepref ??= await SharedPreferences.getInstance();

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
    await FirebaseAuth.instance.signInWithCredential(credential);
    await sharepref!.setString('name', '${googleUser!.displayName}');
    await sharepref!.setString('email', googleUser.email);
    await sharepref!.setString('id', FirebaseAuth.instance.currentUser!.uid);
    sharepref!.setString('url', '');
    CollectionReference user = FirebaseFirestore.instance.collection('users');

    await user.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'name': googleUser.displayName,
      'email': googleUser.email,
      'imagePath': '',
    });
    Get.offAll(const Home());
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
                                controller: _emailController,
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
                                controller: _passController,
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
                                signingInWithEmail(_emailController.text,
                                    _passController.text);
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
                            uploading
                                ? Container(
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
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      child: CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.green[800]!),
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () async {
                                      setState(() {
                                        uploading = true;
                                      });
                                      signInWithGoogle();
                                    },
                                    child: Container(
                                      width: size.width / 6.5,
                                      height: size.width / 6.5,
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
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
