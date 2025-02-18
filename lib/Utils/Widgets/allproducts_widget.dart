import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Model/product_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

import '../../Screens/user_panel/product_detail_screen.dart';


class AllproductsWidget extends StatelessWidget {
  const AllproductsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapshot.data!.docs.isEmpty || !snapshot.hasData || snapshot.data == null ) {
            return const Center(
              child: Text("There is No Product"),
            );
          }
          return SizedBox(
            height: Get.height / 2,
            child:GridView.builder(
              itemCount: snapshot.data!.docs.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 3,
              ),
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                ProductModel productModel = ProductModel(
                    productId: productData['productId'],
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
                return Row(
                  children: [
                    GestureDetector(
                      onTap: (){
                        Get.to(()=> ProductDetailScreen(productModel: productModel,));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 2.5,
                            height:Get.height / 3 ,
                            heightImage: Get.height / 8,
                            imageProvider: CachedNetworkImageProvider(
                                productModel.productImages[0]),
                            title: Center(
                                child: Text(
                                  productModel.productName,
                                  style: const TextStyle(fontSize: 14),
                                )),
                            footer: Text('Rs ${productModel.fullPrice}', style: const TextStyle(fontSize: 12),),
                          ),
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
          );
        });
  }
}
