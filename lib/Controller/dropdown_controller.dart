import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class CategoriesController extends GetxController {
  var categories = <Map<String, dynamic>>[].obs; // Observable list of categories

  // Fetch categories from Firebase
  Future<void> fetchCategories() async {
    try {
      var snapshot = await FirebaseFirestore.instance.collection('category').get();
      categories.clear();
      for (var doc in snapshot.docs) {
        categories.add({
          'id': doc.id,
          'name': doc['cName'],
          'imageUrl': doc['cImage'], // Assuming 'imageUrl' is the field in Firestore
        });
      }
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }
}
