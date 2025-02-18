import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../Utils/app_constraint.dart';

class GetDeviceTokenController extends GetxController{
  String? deviceToken;


  void onInint() {
    super.onInit();
    getDeviceToken();

  }
  Future<void> getDeviceToken()async{
    try{
      String? token = await FirebaseMessaging.instance.getToken();
      if(token != null){
        deviceToken=token;
        update();
      }
    }catch(e){
  Get.snackbar('Error', "$e",
  backgroundColor: AppConstraint.secondaryColor,
  colorText: AppConstraint.textPrimaryColor);
  }

  }
}