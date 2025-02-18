import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class GetUserController extends GetxController{
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<QueryDocumentSnapshot<Object?>>> getUserData(String uId) async {
   final QuerySnapshot userData= await firestore.collection('users').where('uId',isEqualTo:uId ).get();
   return userData.docs;
  }
}