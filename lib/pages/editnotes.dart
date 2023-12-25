import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trynote/controller/homecontroller.dart';
import 'package:trynote/data/sqldb.dart';
import 'package:trynote/home.dart';

class EditNote extends StatefulWidget {
  final String title;
  final String content;
  final int id;
  const EditNote(
      {super.key,
      required this.title,
      required this.content,
      required this.id});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  HomeController controller = Get.put(HomeController());
  SqlDb sqlDb = SqlDb();
  GlobalKey<FormState> addNoteFormKey = GlobalKey();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _contentFocusNode = FocusNode();

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
  void initState() {
    titleController.text = widget.title;
    contentController.text = widget.content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.all(7),
            child: MaterialButton(
              color: Colors.grey[850],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              onPressed: () {
                _titleFocusNode.unfocus();
                _contentFocusNode.unfocus();
                Get.back();
              },
              child: const Icon(
                color: Colors.white,
                size: 25,
                Icons.arrow_back_ios_new_rounded,
              ),
            ),
          ),
          title: Text(
            'Edit Note',
            style: GoogleFonts.mPlusRounded1c(
              color: Colors.grey[850],
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
        child: ListView(
          children: <Widget>[
            Form(
              key: addNoteFormKey,
              child: Column(
                children: [
                  TextFormField(
                    focusNode: _titleFocusNode,
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
                            color: Colors.grey[850] ?? Colors.transparent,
                          ),
                          borderRadius: BorderRadius.circular(10)),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    controller: titleController,
                    cursorColor: Colors.grey[850],
                    cursorRadius: const Radius.circular(25),
                    cursorWidth: 2.5,
                    textDirection: determineTextDirection(titleController.text),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    focusNode: _contentFocusNode,
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
                            color: Colors.grey[850] ?? Colors.transparent,
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
                            _titleFocusNode.unfocus();
                            _contentFocusNode.unfocus();
                            Get.offAll(const Home());
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
                            int result = await sqlDb.updateData('''
                            UPDATE notes SET 
                            title = "${titleController.text}", 
                            content = "${contentController.text}"
                            WHERE id = "${widget.id}"
                            ''');
                            if (result > 0) {
                              _titleFocusNode.unfocus();
                              _contentFocusNode.unfocus();
                              Get.find<HomeController>().updatePage(0);
                              Get.offAll(const Home());
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
                            'Edit',
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
    );
  }
}
