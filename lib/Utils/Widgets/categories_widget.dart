import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Model/category_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../../Screens/user_panel/singlecategory_product_ screen.dart';
class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance.collection('category').get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        // Error Handling
        if (snapshot.hasError) {
          return const Center(child: Text("Error occurred while loading categories."));
        }

        // Show a loading spinner while waiting for data
        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            height: Get.height / 5,
            child: const Center(child: CircularProgressIndicator()),
          );
        }

        // If no data is available, display a message
        if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
          return SizedBox(
            height: Get.height / 5,
            child: const Center(child: Text("No categories available.")),
          );
        }

        // Data is available; build the list
        return SizedBox(
          height: Get.height / 5,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final categoryData = snapshot.data!.docs[index];

              // Create the CategoriesModel object
              CategoriesModel categoriesModel = CategoriesModel(
                categoryId: categoryData['cId'],
                categoryImg: categoryData['cImage'],
                categoryName: categoryData['cName'],
                createdAt: categoryData['createdAt'],
                updatedAt: categoryData['updatedAt'],
              );

              // Build the UI
              return Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.to(() => SingleCategoryProductScreen(
                      categoryId: categoriesModel.categoryId,
                    )),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: FillImageCard(
                        borderRadius: 20.0,
                        width: Get.width / 4.0,
                        heightImage: Get.height / 12,
                        imageProvider: CachedNetworkImageProvider(
                          categoriesModel.categoryImg,
                        ),
                        title: Center(
                          child: Text(
                            categoriesModel.categoryName,
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
