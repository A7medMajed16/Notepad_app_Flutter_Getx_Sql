import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trynote/auth/logincontroller.dart';
import 'package:trynote/data/sqldb.dart';
import 'package:trynote/pages/loginpage.dart';




class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  LoginController loginController = Get.put(LoginController());
  final SqlDb sqlDb = SqlDb();
  List<Map<String, dynamic>> account = [];


  @override
  void initState() {
    //readData(loginController.email!.value);
    super.initState();
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
                SizedBox(
                  width: size.width / 5,
                  height: size.width / 5,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Container(
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
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Ahmed Maged',
                      style: GoogleFonts.mPlusRounded1c(
                        color: Colors.grey[850],
                        fontSize: 23,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'ahmedbark129@gmail.com',
                      style: GoogleFonts.mPlusRounded1c(
                        color: Colors.grey[850],
                        fontSize: 18,
                      ),
                    )
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
