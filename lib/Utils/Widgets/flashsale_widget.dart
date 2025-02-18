import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Model/product_model.dart';
import 'package:ecommerce_app/Screens/user_panel/product_detail_screen.dart';
import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_card/image_card.dart';

class FlashSaleWidget extends StatelessWidget {
  const FlashSaleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: FirebaseFirestore.instance.collection('products').where('isSale',isEqualTo: true).get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Error occurred while fetching products."),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox(
              height: Get.height / 5,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if (!snapshot.hasData || snapshot.data == null || snapshot.data!.docs.isEmpty) {
            return SizedBox(
              height: Get.height / 5,
              child: const Center(
                child: Text("There are no products on sale."),
              ),
            );
          }

            return SizedBox(
              height: Get.height / 5,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
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
                  return Row(
                    children: [
                      GestureDetector(
                        onTap: ()=>Get.to(()=>ProductDetailScreen(productModel: productModel)),
                        child: Padding(padding: const EdgeInsets.all(10.0),
                          child: FillImageCard(
                            borderRadius: 20.0,
                            width: Get.width / 4.0,
                            heightImage: Get.height / 12,
                            imageProvider: CachedNetworkImageProvider(
                                productModel.productImages[0]),
                            title: Center(child: Text(
                              productModel.productName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 14),)),
                            footer: Row(
                              children: [
                                const Text('Rs ',style: TextStyle(fontSize: 12 )),
                                Text(productModel.salePrice,style: const TextStyle(fontSize: 12)),
                                const SizedBox(width: 5),
                                Text(productModel.fullPrice,style: const TextStyle(fontSize: 10,decoration: TextDecoration.lineThrough ,color: AppConstraint.primaryColor),)
                              ],
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                },),
            );

        }

    );
  }
}
