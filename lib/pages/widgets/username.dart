import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

class Username extends StatefulWidget {
  const Username({super.key});

  @override
  State<Username> createState() => _UsernameState();
}

class _UsernameState extends State<Username> {
  GlobalKey<FormState> formKey = GlobalKey();

  TextEditingController userNameController = TextEditingController();

  String? errorTextUserName;

  final ImagePicker picker = ImagePicker();
  File? file;
  String? url;

  String? validateUserName(String? value) {
    if (value == null || value.isEmpty) {
      return errorTextUserName = 'Please enter Your Name';
    } else {
      return errorTextUserName = null;
    }
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
                                      onTap: () async {
                                        final XFile? image =
                                            await picker.pickImage(
                                                source: ImageSource.gallery);
                                        file = File(image!.path);
                                        setState(() {});
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
                                      onTap: () async {
                                        final XFile? photo =
                                            await picker.pickImage(
                                                source: ImageSource.camera);
                                        file = File(photo!.path);
                                        setState(() {});
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
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(size.width),
                    child: file != null
                        ? Container(
                            width: size.width / 4,
                            height: size.width / 4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(size.width),
                            ),
                            child: Image.file(file!),
                          )
                        : Stack(clipBehavior: Clip.none, children: [
                            SizedBox(
                              width: size.width / 5,
                              height: size.width / 5,
                              child: Icon(
                                Icons.person_rounded,
                                color: Colors.grey[850],
                                size: 50,
                              ),
                            ),
                            Positioned(
                                right: 2,
                                bottom: 5,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.circular(size.width),
                                    border: Border.all(
                                      color: Colors.grey[850] ??
                                          Colors.transparent,
                                      width: 2,
                                    ),
                                    color: Colors.white,
                                  ),
                                  child: Icon(
                                    Icons.add_rounded,
                                    color: Colors.grey[850],
                                    size: 20,
                                  ),
                                ))
                          ]),
                  )),
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
        ],
      ),
    );
  }
}
