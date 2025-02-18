import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Model/cart_model.dart';
import 'package:ecommerce_app/Model/product_model.dart';
import 'package:ecommerce_app/Model/review_model.dart';
import 'package:ecommerce_app/Screens/auth_ui/welcome_screen.dart';
import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../Controller/catculate_avgrating_controller.dart';
import 'cart_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel productModel;

  const ProductDetailScreen({super.key, required this.productModel});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    CalculateAvgRatingController calculateAvgRatingController =
        Get.put(CalculateAvgRatingController(widget.productModel.productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Detail'),
        centerTitle: true,
        backgroundColor: AppConstraint.primaryColor,
        actions: [
          IconButton(
              onPressed: () {
                Get.to(() => const CartScreen());
              },
              icon: const Icon(
                Icons.shopping_cart,
                color: AppConstraint.textPrimaryColor,
              ))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CarouselSlider(
                items: widget.productModel.productImages
                    .map((imageUrls) => ClipRRect(
                          borderRadius: BorderRadius.circular(10.0),
                          child: CachedNetworkImage(
                            imageUrl: imageUrls,
                            fit: BoxFit.cover,
                            width: Get.width - 10,
                            placeholder: (context, url) => const ColoredBox(
                              color: Colors.white,
                              child: Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          ),
                        ))
                    .toList(),
                options: CarouselOptions(
                  scrollDirection: Axis.horizontal,
                  autoPlay: true,
                  aspectRatio: 2.5,
                  viewportFraction: 1,
                )),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Text(
                          widget.productModel.productName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        )),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                        alignment: Alignment.topLeft,
                        child: Row(
                          children: [
                            Text(
                              'Rs : ${widget.productModel.isSale ? widget.productModel.salePrice : widget.productModel.fullPrice}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 15),
                            ),
                            SizedBox(
                              width: Get.width * 0.5,
                            ),
                            // const Text('Rating'),

                            Obx(() {
                              return Row(
                                children: [
                                  RatingBar.builder(
                                    initialRating: double.parse(
                                        calculateAvgRatingController
                                            .averageRating.value
                                            .toString()),
                                    glow: true,
                                    ignoreGestures: true,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 1,
                                    itemSize: 25,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 5.0),
                                    itemBuilder: (context, _) => const Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                    ),
                                    onRatingUpdate: (value) {},
                                  ),
                                  Text(
                                    calculateAvgRatingController
                                        .averageRating.value
                                        .toString(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              );
                            }),
                          ],
                        )),


                    const SizedBox(
                      height: 5,
                    ),
                    const Row(
                      children: [
                        Text(
                          'Description :',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    Text(widget.productModel.productDescription),
                    SizedBox(
                      height: Get.height * 0.07,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            sendWhatsApp(productModel: widget.productModel);
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor: AppConstraint.primaryColor),
                          child: const Text(
                            'WhatsApp',
                            style: TextStyle(
                                color: AppConstraint.textPrimaryColor),
                          ),
                        ),
                        user != null
                            ? ElevatedButton(
                                onPressed: () async {
                                  await addToCart(uId: user!.uid);
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppConstraint.primaryColor),
                                child: const Text(
                                  'Add To Cart',
                                  style: TextStyle(
                                      color: AppConstraint.textPrimaryColor),
                                ),
                              )
                            : ElevatedButton(
                                onPressed: () async {
                                  Get.dialog(
                                    AlertDialog(
                                      title: const Text('Sign In'),
                                      content: const Text(
                                          'Sign In to continue shopping'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Get.back(),
                                          // Closes the dialog
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            // Perform action here
                                            Get.to(() => WelcomeScreen());
                                          },
                                          child: const Text('Sign In'),
                                        ),
                                      ],
                                    ),
                                    barrierDismissible:
                                        false, // Prevents closing by tapping outside
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        AppConstraint.primaryColor),
                                child: const Text(
                                  'Add to cart',
                                  style: TextStyle(
                                      color: AppConstraint.textPrimaryColor),
                                ),
                              )
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Reviews  &  FeedBacks",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('products')
                  .doc(widget.productModel.productId)
                  .collection('reviews')
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasError) {
                  return const Center(child: Text("Error"));
                }
                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text("The Product has no Review"));
                }

                return ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final reviewData = snapshot.data!.docs[index];
                    ReviewModel reviewModel = ReviewModel(
                        customerName: reviewData['customerName'],
                        customerPhone: reviewData['customerPhone'],
                        customerDeviceToken: reviewData['customerDeviceToken'],
                        customerId: reviewData['customerId'],
                        feedback: reviewData['feedback'],
                        rating: reviewData['rating'],
                        createdAt: DateTime.now());
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 5,
                        child: ListTile(
                          title: Row(
                            children: [
                              Text('   ${index + 1} :'),
                              SizedBox(
                                width: Get.width * 0.08,
                              ),
                              Text(
                                reviewModel.customerName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              SizedBox(
                                width: Get.width * 0.4,
                              ),
                              Text(
                                reviewModel.rating,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text('${reviewModel.feedback}'),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
    );
  }

  Future<void> addToCart(

      {required String uId, int quantityIncrement = 1}) async {
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('cart')
        .doc(uId)
        .collection('cartOrders')
        .doc(widget.productModel.productId.toString());
    DocumentSnapshot snapshot = await documentReference.get();
    try {
      EasyLoading.show();
      if (snapshot.exists) {
        int productQuantity = snapshot['productQuantity'];
        int updateQuantity = productQuantity + quantityIncrement;
        double totalPrice = double.parse(widget.productModel.isSale
                ? widget.productModel.salePrice
                : widget.productModel.fullPrice) *
            updateQuantity;
        await documentReference.update({
          'productQuantity': updateQuantity,
          'productTotalPrice': totalPrice,
        }).then((onValue){Get.snackbar(
        'Success',
        'Cart Updated Successfully',colorText: Colors.white,
        duration: const Duration(seconds: 1),
        onTap: (snack) {
        Get.to(const CartScreen());
        },
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.lightGreen,
        );});
        EasyLoading.dismiss();
      } else {
        EasyLoading.show();
        await FirebaseFirestore.instance.collection('cart').doc(uId).set({
          'uId': uId,
          'createdAt': DateTime.now(),
        });
        CartModel cartModel = CartModel(
            productId: widget.productModel.productId,
            categoryId: widget.productModel.categoryId,
            productName: widget.productModel.productName,
            categoryName: widget.productModel.categoryName,
            salePrice: widget.productModel.salePrice,
            fullPrice: widget.productModel.fullPrice,
            productImages: widget.productModel.productImages,
            deliveryTime: widget.productModel.deliveryTime,
            isSale: widget.productModel.isSale,
            productDescription: widget.productModel.productDescription,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            productQuantity: 1,
            productTotalPrice: double.parse(widget.productModel.isSale
                ? widget.productModel.salePrice
                : widget.productModel.fullPrice));
        await documentReference.set(cartModel.toMap()).then((onValue){
          Get.snackbar(
            'Success',
            'added to cart successfully',colorText: Colors.white,
            duration: const Duration(seconds: 1),
            onTap: (snack) {
              Get.to(const CartScreen());
            },
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.lightGreen,
          );
        });
        EasyLoading.dismiss();

      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> sendWhatsApp({required ProductModel productModel}) async {
    const number = "+923104500041";
    final message =
        "Hi i want to buy ${productModel.productName}   \n Id is:${productModel.productId}";
    final url = "https://wa.me/$number?text=${Uri.encodeComponent(message)}";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
