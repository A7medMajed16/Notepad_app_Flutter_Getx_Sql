import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:trynote/controller/homecontroller.dart';
import 'package:trynote/main.dart';
import 'package:trynote/pages/accountpage.dart';
import 'package:trynote/pages/addnote.dart';
import 'package:trynote/pages/favoritepage.dart';
import 'package:trynote/pages/homepage.dart';

class Home extends StatefulWidget {
  // ignore: use_key_in_widget_constructors
  const Home({Key? key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // List of icons for bottom navigation
  List<IconData> listOfIcons = [
    Icons.home_rounded,
    Icons.favorite_rounded,
    Icons.add_circle,
    Icons.person_rounded,
  ];

  // List of pages to display
  List<Widget> pages = [
    const HomePage(),
    const FavoritePage(),
    const AddNote(),
    const AccountPage(),
  ];

  // Titles for app bar
  List<String> appBar = ['Notes', 'Favorites', 'Add note', 'Account'];
  Map<String, dynamic> data = {};

  @override
  void initState() {
    if (sharepref != null &&
        sharepref!.getString('id') != FirebaseAuth.instance.currentUser!.uid) {
      getServerData();
    }
    super.initState();
    // Initialize the page controller
  }

  Future<void> getServerData() async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid);
    await documentReference.get().then((value) {
      data = value.data() as Map<String, dynamic>;
      sharepref!.setString('name', data['name']);
      sharepref!.setString('url', data['imagePath']);
      sharepref!.setString('email', data['email']);
      sharepref!.setString('id', FirebaseAuth.instance.currentUser!.uid);
    });
  }

  @override
  Widget build(BuildContext context) {
    // Get the screen size
    Size size = MediaQuery.of(context).size;

    return GetBuilder(
      init: HomeController(),
      builder: (controller) => Scaffold(
        extendBody: true,
        appBar: AppBar(
          elevation: 0,
          centerTitle: true,
          title: Text(
            appBar[controller.currentIndex.value],
            style: GoogleFonts.mPlusRounded1c(
              color: Colors.grey[850],
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: PageView.builder(
          controller: controller.pageController,
          itemCount: pages.length,
          onPageChanged: (index) {
            controller.updatePage(index);
          },
          itemBuilder: (context, index) {
            return pages[index];
          },
        ),
        bottomNavigationBar: Container(
          margin: const EdgeInsets.only(bottom: 15, left: 10, right: 10),
          padding: const EdgeInsets.only(left: 10),
          height: size.width * 0.155,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(4, (index) {
                return InkWell(
                  onTap: () {
                    controller.pageController.animateToPage(
                      index,
                      duration: const Duration(milliseconds: 500),
                      curve: Curves.easeInOut,
                    );
                  },
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        margin: EdgeInsets.only(
                          bottom: index == controller.currentIndex.value
                              ? 0
                              : size.width * 0.029,
                          right: size.width * 0.0422,
                          left: size.width * 0.0422,
                        ),
                        width: size.width * 0.128,
                        height: index == controller.currentIndex.value
                            ? size.width * 0.014
                            : 0,
                        decoration: const BoxDecoration(
                          color: Color(0xff00ADB5),
                          borderRadius: BorderRadius.vertical(
                            bottom: Radius.circular(10),
                          ),
                        ),
                      ),
                      Icon(
                        listOfIcons[index],
                        size: size.width * 0.076,
                        color: index == controller.currentIndex.value
                            ? const Color(0xff00ADB5)
                            : Colors.white54,
                      ),
                      SizedBox(height: size.width * 0.03),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
