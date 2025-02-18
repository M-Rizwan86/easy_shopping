import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../Controller/forget_password.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final ForgetPasswordController forgetPasswordController = Get.put(ForgetPasswordController());

  TextEditingController emailController = TextEditingController();

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
                    if (email.isEmpty) {
                      Get.snackbar('alert', 'pls fill all the details',
                          backgroundColor: AppConstraint.secondaryColor,
                          colorText: AppConstraint.textPrimaryColor);
                    }
                      else{
                        emailController.clear();
                        String email= emailController.text.trim();
                        forgetPasswordController.resetPassword(email);



                      }

                  },
                  child: const Text(
                    "forget",
                    style: TextStyle(
                        color: AppConstraint.textPrimaryColor, fontSize: 20),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: Get.height / 20,
            ),
          ],
        ),
      );
    });
  }
}
