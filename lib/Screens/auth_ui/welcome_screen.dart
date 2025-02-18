import 'package:ecommerce_app/Controller/google_signin_controller.dart';
import 'package:ecommerce_app/Screens/auth_ui/signin_screen.dart';
import 'package:ecommerce_app/Screens/user_panel/user_main_screen.dart';
import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class WelcomeScreen extends StatelessWidget {
  WelcomeScreen({super.key});
  final GoogleSignInController _googleSignInController =GoogleSignInController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppConstraint.primaryColor,
        elevation: 0,
        title: const Text(
          'Welcome',
          style: TextStyle(color: AppConstraint.textPrimaryColor),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            color: AppConstraint.primaryColor,
            width: Get.width,
            height: Get.height / 2,
            child: Lottie.asset('assets/images/splash_icon.json'),
          ),
          SizedBox(
            height: Get.height / 30,
          ),
          Material(
            child: Container(
              width: Get.width / 1.2,
              height: Get.height / 12,
              decoration: BoxDecoration(
                  color: AppConstraint.primaryColor,
                  borderRadius: BorderRadius.circular(20.0)),
              child: TextButton.icon(
                icon: Image.asset(
                  'assets/images/google_icon.png',
                  width: Get.width / 12,
                  height: Get.height / 12,
                ),
                onPressed: () {
                  _googleSignInController.signInWithGoogle();
                },
                label: const Text(
                  "Sign in With Google",
                  style: TextStyle(color: AppConstraint.textPrimaryColor),
                ),
              ),
            ),
          ),
           SizedBox(
            height: Get.height / 30,
          ),
          Material(
            child: Container(
              width: Get.width / 1.2,
              height: Get.height / 12,
              decoration: BoxDecoration(
                  color: AppConstraint.primaryColor,
                  borderRadius: BorderRadius.circular(20.0)),
              child: TextButton.icon(
                icon: Icon(
                  Icons.email,
                  size: Get.height / 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.to(()=> const SignInScreen());
                },
                label: const Text(
                  "Sign in With Email",
                  style: TextStyle(color: AppConstraint.textPrimaryColor),
                ),
              ),
            ),
          ),
          SizedBox(
            height: Get.height / 30,
          ),
          Material(
            child: Container(
              width: Get.width / 1.2,
              height: Get.height / 12,
              decoration: BoxDecoration(
                  color: AppConstraint.primaryColor,
                  borderRadius: BorderRadius.circular(20.0)),
              child: TextButton.icon(
                icon: Icon(
                  Icons.email,
                  size: Get.height / 40,
                  color: Colors.white,
                ),
                onPressed: () {
                  Get.to(()=> const MainScreen());
                },
                label: const Text(
                  "Continue As Guest",
                  style: TextStyle(color: AppConstraint.textPrimaryColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
