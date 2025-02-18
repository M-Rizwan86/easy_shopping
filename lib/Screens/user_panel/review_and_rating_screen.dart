import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Model/review_model.dart';
import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';

class ReviewAndRatingScreen extends StatefulWidget {
  final dynamic orderModel;

  const ReviewAndRatingScreen({super.key, required this.orderModel});

  @override
  State<ReviewAndRatingScreen> createState() => _ReviewAndRatingScreenState();
}

class _ReviewAndRatingScreenState extends State<ReviewAndRatingScreen> {
  final TextEditingController reviewController = TextEditingController();
  double productRating = 3.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review And Rating'),
        centerTitle: true,
        backgroundColor: AppConstraint.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'How would you rate this product?',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 8.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  productRating = rating;
                });
              },
            ),
            const SizedBox(height: 30),
            const Text(
              'Your Feedback',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: reviewController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                hintText: 'Write your feedback here...',
                hintStyle: TextStyle(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                String rating = productRating.toString();
                String feedback = reviewController.text.trim();
                ReviewModel reviewModel = ReviewModel(
                  customerName: widget.orderModel.customerName,
                  customerPhone: widget.orderModel.customerPhone,
                  customerDeviceToken: widget.orderModel.customerDeviceToken,
                  customerId: widget.orderModel.customerId,
                  feedback: feedback,
                  rating: rating,
                  createdAt: DateTime.now(),
                );
                FirebaseFirestore.instance
                    .collection('products')
                    .doc(widget.orderModel.productId)
                    .collection('reviews')
                    .doc(widget.orderModel.customerId)
                    .set(reviewModel.toMap())
                    .then((_) {
                  Get.snackbar(
                    'Success',
                    'Thank you for your feedback!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.green,
                    colorText: Colors.white,
                  );
                  Navigator.pop(context);
                }).catchError((error) {
                  Get.snackbar(
                    'Error',
                    'Failed to submit feedback. Please try again.',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstraint.primaryColor,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              ),
              child: const Text(
                'Submit',
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
