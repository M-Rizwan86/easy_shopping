import 'dart:async';

import 'package:ecommerce_app/Controller/get_user_controller.dart';
import 'package:ecommerce_app/Screens/admin_panel/admin_screen.dart';
import 'package:ecommerce_app/Screens/auth_ui/welcome_screen.dart';
import 'package:ecommerce_app/Screens/user_panel/user_main_screen.dart';
import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      loggedIn(context);
    });
  }

  Future<void> loggedIn(BuildContext context) async {
    final GetUserController getUserController = Get.put(GetUserController());
    if (user != null) {
      var userData = await getUserController.getUserData(user!.uid);
      if (userData[0]['isAdmin']) {
        Get.offAll(() => const AdminScreen());
      } else {
        Get.offAll(() => const MainScreen());
      }
    } else {
      Get.offAll(() => WelcomeScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    // final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppConstraint.primaryColor,
      body: Column(
        children: [
          Container(
            width: Get.width,
            alignment: Alignment.center,
            child: Lottie.asset('assets/images/splash_icon.json'),
          ),
          Container(
            width: Get.width,
            alignment: Alignment.center,
            child: Text(
              AppConstraint.appPoweredBy,
              style: const TextStyle(
                  color: AppConstraint.textPrimaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
    );
  }
}
