import 'package:ecommerce_app/Controller/get_user_controller.dart';
import 'package:ecommerce_app/Screens/admin_panel/admin_screen.dart';
import 'package:ecommerce_app/Screens/auth_ui/signup_screen.dart';
import 'package:ecommerce_app/Screens/auth_ui/forget_password.dart';
import 'package:ecommerce_app/Screens/user_panel/user_main_screen.dart';
import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Controller/google_signin_controller.dart';
import '../../Controller/signin_controller.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final SignInController signInController = Get.put(SignInController());
  final GetUserController getUserController = Get.put(GetUserController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstraint.secondaryColor,
          title: const Text(
            "Ecommerce",
            style: TextStyle(color: AppConstraint.textPrimaryColor),
          ),
          centerTitle: true,
        ),
        body: Column(
          children: [
            Column(
              children: [
                isKeyboardVisible
                    ? const SizedBox.shrink()
                    : Lottie.asset('assets/images/splash_icon.json',
                        height: Get.height / 2.3)
              ],
            ),
            Container(
                width: Get.width,
                margin: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: TextFormField(
                    controller: emailController,
                    cursorColor: AppConstraint.primaryColor,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                        label: const Text('Email'),
                        prefixIcon: const Icon(Icons.email),
                        contentPadding:
                            const EdgeInsets.only(top: 2.0, left: 8.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                )),
            Obx(
              () => Container(
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: passwordController,
                      cursorColor: AppConstraint.primaryColor,
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: signInController.isPasswordvisible.value,
                      decoration: InputDecoration(
                          label: const Text('Password'),
                          prefixIcon: const Icon(Icons.password),
                          suffixIcon: GestureDetector(
                              onTap: signInController.isPasswordvisible.toggle,
                              child: signInController.isPasswordvisible.value
                                  ? const Icon(CupertinoIcons.eye_slash_fill)
                                  : const Icon(CupertinoIcons.eye_fill)),
                          contentPadding:
                              const EdgeInsets.only(top: 2.0, left: 8.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  )),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              alignment: Alignment.centerRight,
              child: GestureDetector(
                onTap: () {
                  Get.to(() => const ForgetPasswordScreen());
                },
                child: const Text(
                  "Forget Password?",
                  style: TextStyle(
                      fontSize: 14,
                      color: AppConstraint.secondaryColor,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 20,
            ),
            Material(
              child: Container(
                width: Get.width / 2,
                height: Get.height / 18,
                decoration: BoxDecoration(
                    color: AppConstraint.primaryColor,
                    borderRadius: BorderRadius.circular(20.0)),
                child: TextButton(
                  onPressed: () async {
                    String email = emailController.text.trim();
                    String password = passwordController.text;
                    if (email.isEmpty || password.isEmpty) {
                      Get.snackbar('Alert', 'pls fill all the details',
                          backgroundColor: AppConstraint.secondaryColor,
                          colorText: AppConstraint.textPrimaryColor);
                    } else {
                      UserCredential? userCredential =
                          await signInController.signInMethod(email, password);
                      var userData = await getUserController.getUserData(userCredential!.user!.uid);
                      if (userCredential != null) {
                        if (userCredential.user!.emailVerified) {
                          if (userData.isNotEmpty && userData[0]['isAdmin'] == true) {
                            Get.offAll(() => const AdminScreen());

                            Get.snackbar('Success', "Admin Login Successfully",
                                backgroundColor: AppConstraint.secondaryColor,
                                colorText: AppConstraint.textPrimaryColor);
                          } else if (userData.isNotEmpty) {
                            Get.offAll(() => const MainScreen());
                          } else {
                            Get.snackbar('Error', "No user data found",
                                backgroundColor: AppConstraint.secondaryColor,
                                colorText: AppConstraint.textPrimaryColor);
                          }
                        } else {
                          Get.snackbar(
                              'Verification Error', "Please verify your Email",
                              backgroundColor: AppConstraint.secondaryColor,
                              colorText: AppConstraint.textPrimaryColor);
                        }
                      } else {
                        Get.snackbar('Error', "Please try again",
                            backgroundColor: AppConstraint.secondaryColor,
                            colorText: AppConstraint.textPrimaryColor);
                      }

                    }
                  },
                  child: const Text(
                    "sign in",
                    style: TextStyle(
                        color: AppConstraint.textPrimaryColor, fontSize: 20),
                  ),
                ),
              ),
            ),

            SizedBox(
              height: Get.height / 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Don't Have an Account?" ,
                  style: TextStyle(
                    color: AppConstraint.primaryColor,
                  ),
                ),
                InkWell(
                  onTap: () {
                    Get.to(() => SignupScreen());
                  },
                  child: const Text(
                    " Create one",
                    style: TextStyle(
                        color: AppConstraint.primaryColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    });
  }
}
