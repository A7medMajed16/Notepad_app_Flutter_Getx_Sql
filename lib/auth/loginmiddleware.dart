// ignore: implementation_imports
import 'package:flutter/src/widgets/navigator.dart';
import 'package:get/get.dart';
import 'package:trynote/main.dart';





class AuthMiddleWare extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    if (sharepref!.getString('id') != null) {
      return const RouteSettings(name: '/Home');
    }
    return null;
  }
}
