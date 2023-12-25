import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:trynote/controller/signupcontroller.dart';
import 'package:trynote/pages/loginpage.dart';
import 'package:trynote/pages/widgets/emailpassword.dart';
import 'package:trynote/pages/widgets/username.dart';
import 'package:trynote/pages/widgets/verify.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  SignupController signupController =
      Get.put(SignupController(), permanent: true);

  TextEditingController userNameController = TextEditingController();

  String? errorTextUserName;

  bool hidPass = true;
  bool hidConfirmPass = true;

  final ImagePicker picker = ImagePicker();
  File? file;
  String? url;
  // List of pages to display
  List<Widget> pages = [
    const EmailPass(),
    const Verify(),
    const Username(),
  ];

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              signupController.clearProgress();
              signupController.updatePage(0);
              Get.offAll(const LoginPage());
            },
            icon: Icon(
              color: Colors.grey[850],
              size: 30,
              Icons.arrow_back_ios_new_rounded,
            )),
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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: size.height / 99,
                child: GetBuilder<SignupController>(
                  builder: (signupController) => ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (context, index) {
                      return Container(
                        width: size.width / 4,
                        height: size.height / 100,
                        decoration: BoxDecoration(
                          color: signupController.progress[index].value == true
                              ? Colors.green[800]
                              : Colors.grey[850]!.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(25),
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return SizedBox(
                        width: size.width / 10,
                      );
                    },
                    itemCount: signupController.progress.length,
                  ),
                ),
              ),
              SizedBox(
                height: size.height / 50,
              ),
              SizedBox(
                height: size.height / 2,
                child: PageView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: pages.length,
                  controller: signupController.pageController,
                  onPageChanged: (index) {
                    index++;

                    signupController.updatePage(index);
                  },
                  itemBuilder: (context, index) {
                    return pages[signupController.currentIndex.value];
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
