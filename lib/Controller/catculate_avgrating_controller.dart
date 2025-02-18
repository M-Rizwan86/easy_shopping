import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class CalculateAvgRatingController extends GetxController {
  late final String productId;
  RxDouble averageRating = 0.0.obs;

  CalculateAvgRatingController(this.productId);

  @override
  void onInit() {
    super.onInit();
    CalculateAvgRatng();
  }

  Future<void> CalculateAvgRatng() async {
    FirebaseFirestore.instance
        .collection('products')
        .doc(productId)
        .collection('reviews')
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        double totalRating = 0.0;
        int reviewCount = 0;
        for (var doc in snapshot.docs) {
          final ratingAsString = doc['rating'] as String;
          final rating = double.tryParse(ratingAsString);
          if (rating != null) {
            totalRating += rating;
            reviewCount++;
          }
        }
        if(reviewCount != 0 ){
          averageRating.value = totalRating/reviewCount;}
        else{
          averageRating.value = 0.0;
        }


        }
      else{
        averageRating.value = 0.0;
      }
        }
    );
    }
}