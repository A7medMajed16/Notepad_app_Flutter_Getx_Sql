import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:trynote/controller/homecontroller.dart';
import 'package:trynote/data/sqldb.dart';




class AddNote extends StatefulWidget {
  const AddNote({super.key});
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> addNoteFormKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void initState() {
    titleController.addListener(updateTextDirection);
    contentController.addListener(updateTextDirection);
    super.initState();
  }

  TextDirection determineTextDirection(String text) {
    bool isArabic = RegExp(
            r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\uFB50-\uFDFF\uFE70-\uFEFF]')
        .hasMatch(text);

    return isArabic ? TextDirection.rtl : TextDirection.ltr;
  }

  void updateTextDirection() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: HomeController(),
        builder: (controller) => Scaffold(
              appBar: AppBar(
                  leading: Padding(
                    padding: const EdgeInsets.all(7),
                    child: MaterialButton(
                      color: Colors.grey[850],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {
                        Get.find<HomeController>().updatePage(0);
                        controller.pageController.jumpToPage(0);
                      },
                      child: const Icon(
                        color: Colors.white,
                        size: 25,
                        Icons.arrow_back_ios_new_rounded,
                      ),
                    ),
                  ),
                  title: Text(
                    'Add Note',
                    style: GoogleFonts.mPlusRounded1c(
                      color: Colors.grey[850],
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
              body: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                child: ListView(
                  children: <Widget>[
                    Form(
                      key: addNoteFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Note title',
                              label: Text(
                                'Title',
                                style: GoogleFonts.mPlusRounded1c(
                                  color: Colors.grey[850],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2.5,
                                    color:
                                        Colors.grey[850] ?? Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            controller: titleController,
                            cursorColor: Colors.grey[850],
                            cursorRadius: const Radius.circular(25),
                            cursorWidth: 2.5,
                            textDirection:
                                determineTextDirection(titleController.text),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              label: Text(
                                'Content',
                                style: GoogleFonts.mPlusRounded1c(
                                  color: Colors.grey[850],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              hintText: 'Note content',
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    width: 2.5,
                                    color:
                                        Colors.grey[850] ?? Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.circular(10)),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                            controller: contentController,
                            cursorColor: Colors.grey[850],
                            cursorRadius: const Radius.circular(25),
                            cursorWidth: 2.5,
                            maxLines: null,
                            textDirection:
                                determineTextDirection(contentController.text),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.find<HomeController>().updatePage(0);
                                    controller.pageController.jumpToPage(0);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          side: BorderSide(
                                              color: Colors.grey[850] ??
                                                  Colors.transparent),
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    backgroundColor:
                                        const MaterialStatePropertyAll(
                                            Colors.white),
                                  ),
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.mPlusRounded1c(
                                      color: Colors.grey[850],
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () async {
                                    int result = await sqlDb.insertData('''
                            INSERT INTO notes (title,content)
                            VALUES ("${titleController.text}","${contentController.text}")
                            ''');
                                    if (result > 0) {
                                      Get.find<HomeController>().updatePage(0);
                                      controller.pageController.jumpToPage(0);
                                    }
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                      RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10)),
                                    ),
                                    backgroundColor: MaterialStatePropertyAll(
                                        Colors.grey[850]),
                                  ),
                                  child: Text(
                                    'Add',
                                    style: GoogleFonts.mPlusRounded1c(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }
}
