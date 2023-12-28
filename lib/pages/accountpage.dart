import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

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
  String url = '';

  @override
  void initState() {
    final email = sharepref?.getString('email') ??
        FirebaseAuth.instance.currentUser?.email ??
        'No email';
    setState(() {
      sharepref?.setString('email', email);
    });

    super.initState();
  }

  Future<void> updateProfile(String newName, String newUrl) async {
    if (sharepref!.getString('name') == null) {
      CollectionReference user = FirebaseFirestore.instance.collection('users');
      await user.doc(FirebaseAuth.instance.currentUser!.uid).set({
        'name': newName,
        'email': FirebaseAuth.instance.currentUser!.email,
        'imagePath': newUrl,
      });
      setState(() {
        sharepref?.setString('name', newName);
        sharepref?.setString('url', newUrl);
      });
    } else {
      DocumentReference documentReference = FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid);
      documentReference.update({'name': newName, 'imagePath': newUrl});
    }
  }

  Future getImageFromCamera() async {
    final XFile? imageCamera =
        await picker.pickImage(source: ImageSource.camera);
    if (imageCamera != null) {
      file = File(imageCamera.path);
    }
    setState(() {});
  }

  Future getImageFromGallery() async {
    final XFile? imageGallery =
        await picker.pickImage(source: ImageSource.gallery);
    if (imageGallery != null) {
      file = File(imageGallery.path);
    }
    setState(() {});
  }

  Future uploadImage() async {
    var refStorage = FirebaseStorage.instance
        .ref('${FirebaseAuth.instance.currentUser!.uid}/profilePicture.jpg');
    await refStorage.putFile(file!);
    url = await refStorage.getDownloadURL();
    setState(() {});
  }

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
                ClipRRect(
                  borderRadius: BorderRadius.circular(50),
                  child: sharepref!.getString('url') != ''
                      ? SizedBox(
                          width: size.width / 5,
                          height: size.width / 5,
                          child: CachedNetworkImage(
                            imageUrl: sharepref!.getString('url')!,
                            placeholder: (context, url) =>
                                CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  Colors.grey[850]!),
                            ),
                            errorWidget: (context, url, error) => Icon(
                              Icons.error,
                              color: Colors.grey[850],
                              size: 50,
                            ),
                          ),
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
                              sharepref!.getString('name') ?? "No name",
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
                            userNameController.text =
                                sharepref!.getString('name')!;
                            file = null;
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 15),
                                    title: Text(
                                      'Edit profile',
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.mPlusRounded1c(
                                        color: Colors.grey[850],
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    content: StatefulBuilder(
                                      builder: (BuildContext context,
                                              StateSetter setState) =>
                                          Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          GestureDetector(
                                            onTap: () {
                                              showDialog(
                                                  context: context,
                                                  builder: (context) {
                                                    return AlertDialog(
                                                      title: Text(
                                                        'Pick profile picture from:',
                                                        textAlign:
                                                            TextAlign.start,
                                                        style: GoogleFonts
                                                            .mPlusRounded1c(
                                                          color:
                                                              Colors.grey[850],
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                      content:
                                                          SingleChildScrollView(
                                                        scrollDirection:
                                                            Axis.horizontal,
                                                        child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  await getImageFromGallery(); // Wait for image selection
                                                                  Get.back();
                                                                  setState(
                                                                      () {}); // Update UI after image is selected
                                                                },
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .folder_rounded,
                                                                      color: Colors
                                                                              .grey[
                                                                          850],
                                                                      size: 60,
                                                                    ),
                                                                    Text(
                                                                      'Files',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: GoogleFonts
                                                                          .mPlusRounded1c(
                                                                        color: Colors
                                                                            .grey[850],
                                                                        fontSize:
                                                                            16,
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                width: 50,
                                                              ),
                                                              GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  await getImageFromCamera();
                                                                  Get.back();
                                                                  setState(
                                                                      () {}); // Update UI after image is selected
                                                                },
                                                                child: Column(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .min,
                                                                  children: [
                                                                    Icon(
                                                                      Icons
                                                                          .camera_rounded,
                                                                      color: Colors
                                                                              .grey[
                                                                          850],
                                                                      size: 60,
                                                                    ),
                                                                    Text(
                                                                      'Camera',
                                                                      textAlign:
                                                                          TextAlign
                                                                              .center,
                                                                      style: GoogleFonts
                                                                          .mPlusRounded1c(
                                                                        color: Colors
                                                                            .grey[850],
                                                                        fontSize:
                                                                            16,
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
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: sharepref!
                                                          .getString('url') !=
                                                      ''
                                                  ? SizedBox(
                                                      width: size.width / 5,
                                                      height: size.width / 5,
                                                      child: file == null
                                                          ? CachedNetworkImage(
                                                              imageUrl: sharepref!
                                                                  .getString(
                                                                      'url')!,
                                                              placeholder: (context,
                                                                      url) =>
                                                                  CircularProgressIndicator(
                                                                valueColor:
                                                                    AlwaysStoppedAnimation<
                                                                        Color>(Colors
                                                                            .grey[
                                                                        850]!),
                                                              ),
                                                              errorWidget:
                                                                  (context, url,
                                                                          error) =>
                                                                      Icon(
                                                                Icons.error,
                                                                color: Colors
                                                                    .grey[850],
                                                                size: 50,
                                                              ),
                                                            )
                                                          : Image.file(file!),
                                                    )
                                                  : Container(
                                                      width: size.width / 5,
                                                      height: size.width / 5,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        border: Border.all(
                                                          color: Colors
                                                                  .grey[850] ??
                                                              Colors
                                                                  .transparent,
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
                                          const SizedBox(
                                            height: 20,
                                          ),
                                          TextFormField(
                                            controller: userNameController,
                                            decoration: InputDecoration(
                                              prefixIcon: const Icon(
                                                Icons.person_rounded,
                                              ),
                                              hintText: 'User Name',
                                              label: Text(
                                                'User Name',
                                                style:
                                                    GoogleFonts.mPlusRounded1c(
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
                                                      BorderRadius.circular(
                                                          10)),
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
                                            ),
                                            cursorColor: Colors.grey[850],
                                            cursorRadius:
                                                const Radius.circular(25),
                                            cursorWidth: 2.5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    actionsAlignment: MainAxisAlignment.center,
                                    actions: [
                                      SizedBox(
                                        height: size.height / 18,
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            if (file != null) {
                                              await uploadImage();
                                              await updateProfile(
                                                  userNameController.text, url);
                                              setState(() {
                                                sharepref!.setString('name',
                                                    userNameController.text);
                                                sharepref!
                                                    .setString('url', url);
                                              });
                                            }
                                            Get.back();
                                          },
                                          style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll(
                                              Colors.grey[850],
                                            ),
                                            shape: MaterialStatePropertyAll(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        size.width / 28),
                                              ),
                                            ),
                                          ),
                                          icon: const Icon(
                                            color: Colors.white,
                                            size: 25,
                                            Icons.navigate_next_rounded,
                                          ),
                                          label: Text(
                                            'Done',
                                            style: GoogleFonts.mPlusRounded1c(
                                              color: Colors.white,
                                              fontSize: size.width / 15,
                                              fontWeight: FontWeight.bold,
                                            ),
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
                          sharepref?.getString('email') ?? 'No email',
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
                  height: size.height / 18,
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      sharepref!.remove('id');
                      sharepref!.remove('name');
                      sharepref!.remove('email');
                      sharepref!.remove('url');
                      await FirebaseAuth.instance.signOut();
                      Get.offAll(const LoginPage());
                    },
                    style: ButtonStyle(
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(size.width / 40)),
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
