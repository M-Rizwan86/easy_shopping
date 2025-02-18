import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Model/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import 'get_device_token_controller.dart';

class SignUpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  var isPasswordvisible = false.obs;
  final GetDeviceTokenController getDeviceTokenController =
      Get.put(GetDeviceTokenController());

  Future<UserCredential?> signUpMethod(
    String userName,
    String userEmail,
    String userPassword,
    String userPhone,
    String userCity,
    String userDeviceToken,
  ) async {
    try {
      EasyLoading.show(status: "pleade wait");
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
              email: userEmail, password: userPassword);

      await userCredential.user!.sendEmailVerification();
      UserModel userModel = UserModel(
          uId: userCredential.user!.uid,
          username: userName,
          email: userEmail,
          phone: userPhone,
          userImg: '',
          userDeviceToken: getDeviceTokenController.deviceToken.toString(),
          country: '',
          userAddress: '',
          street: '',
          isAdmin: false,
          isActive: true,
          createdOn: DateTime.now(),
          city: userCity);
      firestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userModel.toMap());
      EasyLoading.dismiss();
      return userCredential;
    } on FirebaseAuthException catch (e) {
      EasyLoading.dismiss();
      Get.snackbar('Error', '$e');
    }
    return null;
  }
}
