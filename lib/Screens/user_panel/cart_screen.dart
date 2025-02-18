import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Model/cart_model.dart';
import 'package:ecommerce_app/Screens/user_panel/checkout_screen.dart';
import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import '../../Controller/cart_price_controller.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    final CartPriceController cartPriceController = Get.put(CartPriceController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Screen',style: TextStyle(color: AppConstraint.textPrimaryColor),),
        centerTitle: true,
        backgroundColor: AppConstraint.primaryColor,
      ),
      body: user != null ? StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('cart')
            .doc(user!.uid)
            .collection('cartOrders')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong."));
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: AppConstraint.primaryColor,
              ),
            );
          }
          if (snapshot.data != null && snapshot.data!.docs.isNotEmpty) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                final productData = snapshot.data!.docs[index];
                CartModel cartModel = CartModel(
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
                  createdAt: DateTime.now(),
                  updatedAt: DateTime.now(),
                  productQuantity: productData['productQuantity'],
                  productTotalPrice: productData['productTotalPrice'],
                );
                cartPriceController.fetchCartPrice();

                return SwipeActionCell(
                  key: ObjectKey(cartModel.productId),

                  /// this key is necessary
                  trailingActions: [
                    SwipeAction(
                      backgroundRadius: 15,
                      title: "delete",
                      forceAlignmentToBoundary: true,
                      performsFirstActionWithFullSwipe: false,
                      onTap: (CompletionHandler handler) async {
                        FirebaseFirestore.instance
                            .collection('cart')
                            .doc(user.uid)
                            .collection('cartOrders')
                            .doc(cartModel.productId)
                            .delete();
                      },
                    ),
                  ],
                  child: Card(
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
                              imageUrl: cartModel.productImages.isNotEmpty
                                  ? cartModel.productImages[0]
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
                          SizedBox(width: Get.width / 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cartModel.productName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Rs ${cartModel.productTotalPrice}',
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: Get.width / 20),
                          Column(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (cartModel.productQuantity > 0) {
                                    FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(user.uid)
                                        .collection('cartOrders')
                                        .doc(cartModel.productId)
                                        .update({
                                      'productQuantity':
                                          cartModel.productQuantity + 1,
                                      'productTotalPrice': double.parse(
                                              (cartModel.isSale
                                                  ? cartModel.salePrice
                                                  : cartModel.fullPrice)) +
                                          double.parse((cartModel.isSale
                                                  ? cartModel.salePrice
                                                  : cartModel.fullPrice)) *
                                              (cartModel.productQuantity)
                                    });
                                  }
                                },
                                child: const CircleAvatar(
                                  backgroundColor: AppConstraint.secondaryColor,
                                  maxRadius: 15,
                                  child: Icon(
                                    Icons.add,
                                    size: 18,
                                    color: AppConstraint.textPrimaryColor,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                cartModel.productQuantity.toString(),
                                style: const TextStyle(fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: () {
                                  if (cartModel.productQuantity > 1) {
                                    FirebaseFirestore.instance
                                        .collection('cart')
                                        .doc(user.uid)
                                        .collection('cartOrders')
                                        .doc(cartModel.productId)
                                        .update({
                                      'productQuantity':
                                          cartModel.productQuantity - 1,
                                      'productTotalPrice': (double.parse(
                                              cartModel.isSale
                                                  ? cartModel.salePrice
                                                  : cartModel.fullPrice) *
                                          (cartModel.productQuantity - 1))
                                    });
                                  }
                                },
                                child: const CircleAvatar(
                                  backgroundColor: AppConstraint.secondaryColor,
                                  maxRadius: 15,
                                  child: Icon(
                                    Icons.remove,
                                    size: 18,
                                    color: AppConstraint.textPrimaryColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: Text("Your cart is empty."));
        },
      ) : const Center(child: Text('Cart is Empty'),),
      bottomNavigationBar:  user != null ? Container(
        decoration: const BoxDecoration(
          color: AppConstraint.primaryColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(() {
              return Text(
                'Total ${cartPriceController.totalPrice.value.toString()}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppConstraint.textPrimaryColor,
                ),
              );
            },),
            ElevatedButton(
              onPressed: () {
                Get.to(()=>const CheckOutScreen());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
              ),
              child: const Text(
                "Checkout",
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ) : null

    );
  }
}
