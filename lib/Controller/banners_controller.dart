

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BannersController extends GetxController{
  RxList<String> bannerUrls = RxList<String>([]);
  @override
  void onInit(){
    super.onInit();
    fetchBanners();
  }
  Future<void> fetchBanners() async {
    try{
      QuerySnapshot snapshot =await FirebaseFirestore.instance.collection('banners').get();
      if(snapshot.docs.isNotEmpty){
        bannerUrls.value = snapshot.docs.map((doc)=>doc['bannerUrl'] as String).toList();
      }

    }catch(e){
      print("error $e");

    }
    return null;
  }

}