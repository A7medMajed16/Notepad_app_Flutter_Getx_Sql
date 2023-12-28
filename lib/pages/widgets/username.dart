import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trynote/controller/signupcontroller.dart';
import 'package:trynote/pages/loginpage.dart';

class Username extends StatefulWidget {
  const Username({super.key});

  @override
  State<Username> createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController userNameController = TextEditingController();
  SignupController signupController = Get.put(SignupController());
  CollectionReference user = FirebaseFirestore.instance.collection('users');

  String? errorTextUserName;

  final ImagePicker picker = ImagePicker();
  File? file;
  String url = '';

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return errorTextUserName = 'Please enter Your Name';
    } else {
      return errorTextUserName = null;
    }
  }

  Future<void> addUser(String name, String email, String imagePath) async {
    // Call the user's CollectionReference to add a new user
    await user.doc(FirebaseAuth.instance.currentUser!.uid).set({
      'name': name,
      'email': email,
      'imagePath': imagePath,
    });
    Get.snackbar(
      'DOne',
      'Email created successfully',
      duration: const Duration(seconds: 5),
      icon: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: const Icon(
          Icons.done_rounded,
          size: 40,
          color: Colors.green,
        ),
      ),
      dismissDirection: DismissDirection.horizontal,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.grey[850]!.withOpacity(0.7),
      titleText: Padding(
        padding: const EdgeInsets.only(left: 10),
        child: Text(
          'DOne',
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
          'Email created successfully',
          style: GoogleFonts.mPlusRounded1c(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Future getImageFromCamera() async {
    final XFile? imageCamera =
        await picker.pickImage(source: ImageSource.camera);
    if (imageCamera != null) {
      file = File(imageCamera.path);
    }
    uploadImage();
    setState(() {});
  }

  Future getImageFromGallery() async {
    final XFile? imageGallery =
        await picker.pickImage(source: ImageSource.gallery);
    if (imageGallery != null) {
      file = File(imageGallery.path);
    }
    uploadImage();
    setState(() {});
  }

  Future uploadImage() async {
    var refStorage = FirebaseStorage.instance
        .ref('${FirebaseAuth.instance.currentUser!.uid}/profilePicture.jpg');
    await refStorage.putFile(file!);
    url = await refStorage.getDownloadURL();
  }

  @override
  void dispose() {
    userNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Column(
            children: [
              GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Pick profile picture from:',
                            textAlign: TextAlign.start,
                            style: GoogleFonts.mPlusRounded1c(
                              color: Colors.grey[850],
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          content: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      getImageFromGallery();
                                      Get.back();
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.folder_rounded,
                                          color: Colors.grey[850],
                                          size: 60,
                                        ),
                                        Text(
                                          'Files',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.mPlusRounded1c(
                                            color: Colors.grey[850],
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      getImageFromCamera();
                                      Get.back();
                                    },
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.camera_rounded,
                                          color: Colors.grey[850],
                                          size: 60,
                                        ),
                                        Text(
                                          'Camera',
                                          textAlign: TextAlign.center,
                                          style: GoogleFonts.mPlusRounded1c(
                                            color: Colors.grey[850],
                                            fontSize: 16,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ]),
                          ),
                        );
                      });
                },
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(size.width),
                      child: file != null
                          ? Container(
                              width: size.width / 3.5,
                              height: size.width / 3.5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(size.width),
                              ),
                              child: Image.file(file!),
                            )
                          : Container(
                              width: size.width / 3.5,
                              height: size.width / 3.5,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey[850] ?? Colors.transparent,
                                  width: 3,
                                ),
                                borderRadius: BorderRadius.circular(size.width),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                color: Colors.grey[850],
                                size: size.width / 5,
                              ),
                            ),
                    ),
                    Positioned(
                      right: 5,
                      bottom: 5,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(size.width),
                          border: Border.all(
                            color: Colors.grey[850] ?? Colors.transparent,
                            width: 2,
                          ),
                          color: Colors.white,
                        ),
                        child: Icon(
                          Icons.add_rounded,
                          color: Colors.grey[850],
                          size: size.width / 16,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: TextFormField(
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
                          color: Colors.grey[850] ?? Colors.transparent,
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
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    addUser(userNameController.text,
                        signupController.email.value, url);
                    Get.offAll(const LoginPage());
                  }
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Done',
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
                          borderRadius: BorderRadius.circular(size.width / 25),
                        ),
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
        ],
      ),
    );
  }
}
