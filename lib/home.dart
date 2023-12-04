import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:trynote/controller/homecontroller.dart';
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

  @override
  void initState() {
    super.initState();
    // Initialize the page controller
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
              fontStyle: FontStyle.italic,
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
          margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          height: size.width * .155,
          decoration: BoxDecoration(
            color: Colors.grey[850],
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.15),
                blurRadius: 30,
                offset: const Offset(0, 10),
              ),
            ],
            borderRadius: BorderRadius.circular(50),
          ),
          child: ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            padding: EdgeInsets.symmetric(horizontal: size.width * .024),
            itemBuilder: (context, index) => InkWell(
              onTap: () {
                controller.pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: FutureBuilder(
                  future: Future.delayed(Duration.zero),
                  builder: (context, snapshot) {
                    if (controller.pageController.positions.isNotEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.fastLinearToSlowEaseIn,
                            margin: EdgeInsets.only(
                              bottom: index ==
                                      controller.pageController.page?.round()
                                  ? 0
                                  : size.width * .029,
                              right: size.width * .0422,
                              left: size.width * .0422,
                            ),
                            width: size.width * .128,
                            height: index == controller.currentIndex.value
                                ? size.width * .014
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
                            size: size.width * .076,
                            color: index == controller.currentIndex.value
                                ? const Color(0xff00ADB5)
                                : Colors.white54,
                          ),
                          SizedBox(height: size.width * .03),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
