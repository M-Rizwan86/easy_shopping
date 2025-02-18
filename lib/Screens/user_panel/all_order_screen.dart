import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Model/order_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'review_and_rating_screen.dart';

class AllOrderScreen extends StatelessWidget {
  const AllOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Orders"),
      ),
      body: user != null
          ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('orders')
                  .doc(user.uid)
                  .collection('confirmOrders')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return const Center(child: Text(" something Went Wrong"));
                }
                if (!snapshot.hasData) {
                  return const Center(child: Text('Your Cart is Empty'));
                }
                if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final productData = snapshot.data!.docs[index];
                      OrderModel orderModel = OrderModel(
                        productId: productData['productId'],
                        categoryId: productData['categoryId'],
                        productName: productData['productName'],
                        categoryName: productData['categoryName'],
                        salePrice: productData['salePrice'],
                        fullPrice: productData['salePrice'],
                        productImages: productData['productImages'],
                        deliveryTime: productData['deliveryTime'],
                        isSale: productData['isSale'],
                        productDescription: productData['productDescription'],
                        createdAt: productData['createdAt'],
                        updatedAt: productData['updatedAt'],
                        productQuantity: productData['productQuantity'],
                        productTotalPrice: productData['productTotalPrice'],
                        customerId: productData['customerId'],
                        customerName: productData['customerName'],
                        status: productData['status'],
                        customerDeviceToken: productData['customerDeviceToken'],
                        customerPhone: productData['customerPhone'],
                        customerAddress: productData['customerAddress'],
                      );

                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: CachedNetworkImage(
                                  imageUrl: orderModel.productImages.isNotEmpty
                                      ? orderModel.productImages[0]
                                      : 'https://via.placeholder.com/150',
                                  width: Get.width / 4,
                                  height: Get.height / 8,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                              SizedBox(width: Get.width * 0.05),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      orderModel.productName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: Get.height * 0.02),
                                    Row(
                                      children: [
                                        Text(
                                          'Rs: ${orderModel.productTotalPrice}',
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.green,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        SizedBox(
                                            height: Get.height * 0.03,
                                            width: Get.width * 0.1),
                                        orderModel.status == false
                                            ? const Text('Pending..')
                                            : const Text('Delivered..'),
                                        SizedBox(width: Get.width * 0.01),
                                      ],
                                    ),
                                    orderModel.status != false
                                        ? ElevatedButton(
                                            onPressed: () {
                                              Get.to(() =>
                                                  ReviewAndRatingScreen(
                                                      orderModel: orderModel));
                                            },
                                            child: const Text('Review'),
                                          )
                                        : const SizedBox.shrink(),
                                  ],
                                ),
                              ),
                              SizedBox(width: Get.width / 20),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const Text("there is no orders");
              },
            )
          : const Center(child: Text('there is no  order')),
    );
  }
}
