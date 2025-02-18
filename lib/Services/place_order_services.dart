import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

import '../Model/order_model.dart';
import 'generate_orderid_service.dart';

void placeOrder({
  required BuildContext context,
  required String name,
  required String phone,
  required String token,
  required String address,
}) async {
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    Get.snackbar('Error', 'User not logged in');
    return;
  }

  try {
    EasyLoading.show();

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('cart')
        .doc(user.uid)
        .collection('cartOrders')
        .get();

    List<DocumentSnapshot> documents = querySnapshot.docs;

    for (final doc in documents) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String orderId = generateId();

      OrderModel orderModel = OrderModel(
        productId: data['productId'],
        categoryId: data['categoryId'],
        productName: data['productName'],
        categoryName: data['categoryName'],
        salePrice: data['salePrice'],
        fullPrice: data['fullPrice'], // Fixed pricing issue
        productImages: data['productImages'],
        deliveryTime: data['deliveryTime'],
        isSale: data['isSale'],
        productDescription: data['productDescription'],
        createdAt: DateTime.now(),
        updatedAt: data['updatedAt'],
        productQuantity: data['productQuantity'],
        productTotalPrice: data['productTotalPrice'],
        customerAddress: address,
        customerDeviceToken: token,
        customerId: user.uid,
        status: false,
        customerName: name,
        customerPhone: phone,
      );

      // Save order with a unique ID
      await FirebaseFirestore.instance
          .collection('orders')
          .doc(user.uid) // Use orderId instead of user.uid
          .set({
        'Uid': user.uid,
        'orderId': orderId,
        'customerName': name,
        'customerAddress': address,
        'customerPhone': phone,
        'customerDeviceToken': token,
        'orderStatus': false,
        'createdAt': DateTime.now(),
      });

      // Save confirmed order separately
      await FirebaseFirestore.instance.collection('orders').doc(user.uid)
          .collection('confirmOrders')
          .doc(orderId)
          .set(orderModel.toMap());

      // Remove item from cart
      await FirebaseFirestore.instance
          .collection('cart')
          .doc(user.uid)
          .collection('cartOrders')
          .doc(orderModel.productId)
          .delete();
    }

    Get.snackbar('Order Confirmed', 'Thank you for your order');
  } catch (e) {
    Get.snackbar('Error', e.toString());
  } finally {
    EasyLoading.dismiss(); // Ensures loading is dismissed even if an error occurs
  }
}
