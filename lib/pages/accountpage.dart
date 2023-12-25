import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trynote/main.dart';

import 'package:trynote/data/sqldb.dart';
import 'package:trynote/pages/loginpage.dart';

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final SqlDb sqlDb = SqlDb();
  List<Map<String, dynamic>> account = [];
  TextEditingController userNameController = TextEditingController();
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  final ImagePicker picker = ImagePicker();
  File? file;
  String? url;

  @override
  void initState() {
    super.initState();
  }

  // getData() async {
  //   DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   if (userSnapshot.exists) {
  //     await sharepref!.setString('name', userSnapshot['name']);
  //     await sharepref!.setString('id', userSnapshot['id']);
  //     // Force rebuild after setting shared preferences
  //     setState(() {});
  //   }
  //   Future.delayed(const Duration(seconds: 15));
  // }

  // Future uploadImage(File inputFile) async {
  //   var refStorage = FirebaseStorage.instance
  //       .ref('${FirebaseAuth.instance.currentUser!.uid}/profile.jpg');
  //   await refStorage.putFile(inputFile);
  //   var url = await refStorage.getDownloadURL();
  //   var userId = FirebaseAuth.instance.currentUser!.uid;
  //   var userDoc = users.doc(userId);
  //   await userDoc.update({
  //     'image': url,
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: size.width / 5,
                  height: size.width / 5,
                  child: GestureDetector(
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
                      borderRadius: BorderRadius.circular(50),
                      child: sharepref!.getString('url') != null
                          ? SizedBox(
                              width: size.width / 5,
                              height: size.width / 5,
                              child: Image.network(
                                  "${sharepref!.getString('url')}"),
                            )
                          : Container(
                              width: size.width / 5,
                              height: size.width / 5,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Colors.grey[850] ?? Colors.transparent,
                                  width: 3,
                                ),
                              ),
                              child: Icon(
                                Icons.person_rounded,
                                color: Colors.grey[850],
                                size: 50,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          width: size.width / 1.8,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(
                              "${sharepref!.getString('name')}",
                              style: GoogleFonts.mPlusRounded1c(
                                color: Colors.grey[850],
                                fontSize: 23,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    title: Text(
                                      'Edit username',
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.mPlusRounded1c(
                                        color: Colors.grey[850],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: TextField(
                                      controller: userNameController,
                                      maxLength: 30,
                                      decoration: InputDecoration(
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
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                      cursorColor: Colors.grey[850],
                                      cursorRadius: const Radius.circular(25),
                                      cursorWidth: 2.5,
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      ElevatedButton.icon(
                                        onPressed: () async {
                                          if (userNameController
                                              .text.isNotEmpty) {
                                            // var userId = FirebaseAuth
                                            //     .instance.currentUser!.uid;
                                            // var userDoc = users.doc(userId);
                                            // await userDoc.update({
                                            //   'name': userNameController.text,
                                            // });
                                            // Use update when the document exists, set otherwise
                                            setState(() {
                                              sharepref!.setString('name',
                                                  userNameController.text);
                                            });
                                          }

                                          Get.back();
                                        },
                                        style: ButtonStyle(
                                          shape: MaterialStatePropertyAll(
                                            RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                          ),
                                          backgroundColor:
                                              MaterialStatePropertyAll(
                                                  Colors.grey[850]),
                                        ),
                                        icon: const Icon(
                                          Icons.done_rounded,
                                          color: Colors.white,
                                          size: 20,
                                        ),
                                        label: Text(
                                          'Done',
                                          style: GoogleFonts.mPlusRounded1c(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )
                                    ],
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.edit_rounded,
                            color: Colors.grey[850]!.withOpacity(0.5),
                            size: 20,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      width: size.width / 1.5,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          "${sharepref!.getString('email')}",
                          style: GoogleFonts.mPlusRounded1c(
                            color: Colors.grey[850],
                            fontSize: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: size.width / 2,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Get.offAll(const LoginPage());
                    },
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.red[900]),
                    ),
                    icon: const Icon(
                      Icons.logout_rounded,
                      color: Colors.white,
                      size: 25,
                    ),
                    label: Text(
                      'Log out',
                      style: GoogleFonts.mPlusRounded1c(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
