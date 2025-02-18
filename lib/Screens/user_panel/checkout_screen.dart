import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Model/cart_model.dart';
import 'package:ecommerce_app/Screens/user_panel/cart_screen.dart';
import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';
import 'package:get/get.dart';

import '../../Controller/cart_price_controller.dart';
import '../../Controller/costumer_device_controller.dart';
import '../../Services/place_order_services.dart';

class CheckOutScreen extends StatelessWidget {
  const CheckOutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();
    final TextEditingController addressController = TextEditingController();
    User? user = FirebaseAuth.instance.currentUser;
    final CartPriceController cartPriceController =
        Get.put(CartPriceController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout Screen',
          style: TextStyle(color: AppConstraint.textPrimaryColor),
        ),
        centerTitle: true,
        backgroundColor: AppConstraint.primaryColor,
      ),
      body: StreamBuilder(
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
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15),
            topRight: Radius.circular(15),
          ),
        ),
        height: Get.height * 0.12,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Obx(
              () {
                return Text(
                  'Total : ${cartPriceController.totalPrice} Rs',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                Get.bottomSheet(
                  SingleChildScrollView(
                    child: Container(
                      height: Get.height * 0.55,
                      decoration: const BoxDecoration(
                        color: AppConstraint.textPrimaryColor,
                        borderRadius: BorderRadius.only(
                            topRight: Radius.circular(30),
                            topLeft: Radius.circular(30)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: Column(
                          children: [
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Name',
                              ),
                              controller: nameController,
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Phone',
                              ),
                              controller: phoneController,
                            ),
                            const SizedBox(height: 16.0),
                            TextField(
                              decoration: const InputDecoration(
                                labelText: 'Address',
                              ),
                              controller: addressController,
                            ),
                            SizedBox(
                              height: Get.height * 0.06,
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                String customerName =
                                    nameController.text.trim();
                                String customerPhone =
                                    phoneController.text.trim();
                                String customerAddress =
                                    addressController.text.trim();
                                String customerDeviceToken =
                                    await getDeviceToken();
                                if (customerName.isNotEmpty ||
                                    customerAddress.isNotEmpty ||
                                    customerPhone.isNotEmpty) {
                                  placeOrder(
                                      context: context,
                                      name: customerName,
                                      phone: customerPhone,
                                      token: customerDeviceToken,
                                      address: customerAddress);
                                  Get.off(const CartScreen());
                                  cartPriceController.totalPrice;
                                } else {
                                  Get.snackbar(
                                      'Error', 'All fields are required',
                                      backgroundColor:
                                          AppConstraint.secondaryColor,
                                      snackPosition: SnackPosition.BOTTOM,
                                      colorText:
                                          AppConstraint.textPrimaryColor);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppConstraint.primaryColor,
                              ),
                              child: const Text(
                                'Place Order',
                                style: TextStyle(
                                    color: AppConstraint.textPrimaryColor),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstraint.primaryColor,
                padding: const EdgeInsets.symmetric(
                    horizontal: 24.0, vertical: 12.0),
              ),
              child: const Text("Confirm Order",
                  style: TextStyle(color: AppConstraint.textPrimaryColor)),
            ),
          ],
        ),
      ),
    );
  }
}
