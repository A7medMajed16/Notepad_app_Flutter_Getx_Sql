import 'package:get/get.dart';

class LoginController extends GetxController {
  String userName='Ahmed';
  String email='Ahmed maged';

  void updateUserName(String inputUsername) {
    userName = inputUsername;
  }
  void updateEmail(String inputEmail) {
    email = inputEmail;
  }
}
