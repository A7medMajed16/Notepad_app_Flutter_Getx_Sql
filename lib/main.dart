import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:trynote/auth/loginmiddleware.dart';
import 'package:trynote/home.dart';
import 'package:trynote/pages/addnote.dart';
import 'package:trynote/pages/loginpage.dart';

SharedPreferences? sharepref;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
  sharepref = await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  // ignore: use_key_in_widget_constructors
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
        textSelectionTheme: TextSelectionThemeData(
          selectionColor: Colors.grey,
          selectionHandleColor: Colors.grey[850],
        ),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: "/Login",
      getPages: [
        GetPage(
            name: '/Login',
            page: () => const LoginPage(),
            middlewares: [AuthMiddleWare()]),
        GetPage(name: '/Home', page: () => const Home()),
        GetPage(name: '/AddNote', page: () => const AddNote()),
      ],
    );
  }
}
