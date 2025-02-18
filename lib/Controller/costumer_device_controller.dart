import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../Utils/app_constraint.dart';

Future<String> getDeviceToken()async{
  try{
    String? token = await FirebaseMessaging.instance.getToken();
    if(token != null){
      return token;
    }
    else{
      throw Exception('Error');
    }

  }
      catch(e){
        Get.snackbar('Error', "$e",
            backgroundColor: AppConstraint.secondaryColor,
            colorText: AppConstraint.textPrimaryColor);
        throw Exception('Error');
      }
}