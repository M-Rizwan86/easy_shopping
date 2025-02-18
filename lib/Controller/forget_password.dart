import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Screens/auth_ui/signin_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../Utils/app_constraint.dart';

class ForgetPasswordController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> resetPassword(String userEmail) async {
    try {
      EasyLoading.show(status: "pleade wait");
      await _auth.sendPasswordResetEmail(email: userEmail);
      Get.snackbar(
          'Email Sent Successfully', 'Password reset email sent to $userEmail',
          backgroundColor: AppConstraint.secondaryColor,
          colorText: AppConstraint.textPrimaryColor);
      Get.offAll(const SignInScreen());

      EasyLoading.dismiss();
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Error', '$e');
    }
  }
}
