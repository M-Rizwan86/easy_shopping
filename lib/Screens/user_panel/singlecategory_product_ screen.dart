import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../../Model/product_model.dart';
import '../../Utils/app_constraint.dart';
import 'cart_screen.dart';
import 'product_detail_screen.dart';

class SingleCategoryProductScreen extends StatelessWidget {
  final String categoryId;
  const SingleCategoryProductScreen({super.key, required  this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Products Screen',style: TextStyle(color: AppConstraint.textPrimaryColor),
        ),
        backgroundColor: AppConstraint.primaryColor,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const CartScreen());
              },
              icon: const Icon(Icons.shopping_cart,color: AppConstraint.textPrimaryColor,))
        ],
      ),
      body: FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').where('cId',isEqualTo: categoryId).get(),
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
                final productData = snapshot.data!.docs[index];
                ProductModel productModel = ProductModel(
                    productId:productData['productId'] ,
                    categoryId: productData['cId'],
                    productName: productData['productName'],
                    categoryName: productData['cName'],
                    salePrice: productData['salePrice'],
                    fullPrice: productData['fullPrice'],
                    productImages: productData['productImages'],
                    deliveryTime: productData['deliveryTime'],
                    isSale: productData['isSale'],
                    productDescription: productData['productDescription'],
                    createdAt: productData['createdAt'],
                    updatedAt: productData['updatedAt']);

                return GestureDetector(
                  onTap: ()=>Get.to(()=>ProductDetailScreen(productModel: productModel)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FillImageCard(
                      borderRadius: 20.0,
                      width: Get.width / 2.0,
                      heightImage: Get.height / 8.7,
                      height:Get.height / 1,
                      imageProvider: CachedNetworkImageProvider(productModel.productImages[0]),
                      title: Center(
                        child: Text(
                          productModel.productName,

                        ),
                      ),
                      footer: Text('  Rs ${productModel.fullPrice}',style: const TextStyle(fontSize: 12)),
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
