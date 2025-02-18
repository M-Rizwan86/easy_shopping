import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../../Model/category_model.dart';
import 'singlecategory_product_ screen.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories',style: TextStyle(color: AppConstraint.textPrimaryColor),),
        backgroundColor: AppConstraint.primaryColor,
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('category').get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Error"));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 5,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
            return GridView.builder(
              itemCount: snapshot.data!.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 3,
              ),
              itemBuilder: (context, index) {
                final categoryData = snapshot.data!.docs[index];
                CategoriesModel categoriesModel = CategoriesModel(
                  categoryId: categoryData['cId'],
                  categoryImg: categoryData['cImage'],
                  categoryName: categoryData['cName'],
                  createdAt: categoryData['createdAt'],
                  updatedAt: categoryData['updatedAt'],
                );
                return GestureDetector(
                  onTap: ()=>Get.to(()=>SingleCategoryProductScreen(categoryId: categoriesModel.categoryId)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FillImageCard(
                      borderRadius: 20.0,
                      width: Get.width / 2.0,
                      heightImage: Get.height / 7,
                      imageProvider: CachedNetworkImageProvider(categoriesModel.categoryImg),
                      title: Center(
                        child: Text(
                          categoriesModel.categoryName,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text("There is No Category"));
          }
        },
      ),
    );
  }
}
