import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class LoginController extends GetxController{
TextEditingController emailController = TextEditingController();
TextEditingController passwordController = TextEditingController();
bool isObscure = true;


void login(){

  Get.toNamed('/home');
}



}