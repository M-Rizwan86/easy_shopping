import 'package:ecommerce_app/Screens/auth_ui/signin_screen.dart';
import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:get/get.dart';
import '../../Controller/signup_controller.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  final SignUpController signUpController = Get.put(SignUpController());
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return KeyboardVisibilityBuilder(builder: (context, isKeyboardVisible) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppConstraint.primaryColor,
          title: const Text(
            "Ecommerce",
            style: TextStyle(color: AppConstraint.textPrimaryColor),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 20,
              ),
              const Text(
                "Welcome to My Screen",
                style: TextStyle(color: AppConstraint.primaryColor),
              ),
              Container(
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: nameController,
                      cursorColor: AppConstraint.primaryColor,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          label: const Text('Username'),
                          prefixIcon: const Icon(Icons.person),
                          contentPadding:
                              const EdgeInsets.only(top: 2.0, left: 8.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  )),
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
              Container(
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: phoneController,
                      cursorColor: AppConstraint.primaryColor,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          label: const Text('phone'),
                          prefixIcon: const Icon(Icons.phone),
                          contentPadding:
                              const EdgeInsets.only(top: 2.0, left: 8.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0))),
                    ),
                  )),
              Container(
                  width: Get.width,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: cityController,
                      cursorColor: AppConstraint.primaryColor,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          label: const Text('city'),
                          prefixIcon: const Icon(Icons.location_pin),
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
                        keyboardType: TextInputType.emailAddress,
                        obscureText: signUpController.isPasswordvisible.value,
                        decoration: InputDecoration(
                            label: const Text('Password'),
                            suffixIcon: GestureDetector(
                                onTap:
                                    signUpController.isPasswordvisible.toggle,
                                child:
                                    signUpController.isPasswordvisible.value
                                        ? const Icon(
                                            CupertinoIcons.eye_fill,
                                            color: AppConstraint.primaryColor,
                                          )
                                        : const Icon(
                                            CupertinoIcons.eye_slash_fill,
                                            color: AppConstraint.primaryColor,
                                          )),
                            prefixIcon: const Icon(Icons.password),
                            contentPadding:
                                const EdgeInsets.only(top: 2.0, left: 8.0),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0))),
                      ),
                    )),
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
                    onPressed: () async{
                      String name = nameController.text.trim();
                      String email = emailController.text.trim();
                      String password = passwordController.text.trim();
                      String city = cityController.text.trim();
                      String phone = phoneController.text.trim();
                      String deviceToken = '';
                      if(name.isEmpty || email.isEmpty || password.isEmpty || phone.isEmpty || city.isEmpty){
                        Get.snackbar('Alert', 'Please fill all the Fields',
                            backgroundColor: AppConstraint.secondaryColor,
                            colorText: AppConstraint.textPrimaryColor);
                      }else {
                        UserCredential? userCredential = await signUpController
                            .signUpMethod(
                            name, email, password, phone, city, deviceToken);
                        if (userCredential != null) {
                          Get.snackbar(
                              'Verification email sent', 'check your email');


                          FirebaseAuth.instance.signOut();
                          Get.offAll(() => const SignInScreen());
                        }
                      }
                    },
                    child: const Text(
                      "SIGN UP",
                      style: TextStyle(
                          color: AppConstraint.textPrimaryColor,
                          fontSize: 20),
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
                    "Have an Account? ",
                    style: TextStyle(
                      color: AppConstraint.primaryColor,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const SignInScreen());
                    },
                    child: const Text(
                      "sign in",
                      style: TextStyle(
                          color: AppConstraint.primaryColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    });
  }
}
