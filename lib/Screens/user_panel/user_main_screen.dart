import 'package:ecommerce_app/Screens/user_panel/categories_screen.dart';
import 'package:ecommerce_app/Utils/Widgets/allproducts_widget.dart';
import 'package:ecommerce_app/Utils/Widgets/categories_widget.dart';
import 'package:ecommerce_app/Utils/Widgets/slider_widget.dart';
import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../Utils/Widgets/appbar_drawer.dart';
import '../../Utils/Widgets/flashsale_widget.dart';
import 'all_products_screen.dart';
import 'allflashsale_product_screen.dart';
import 'cart_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  GoogleSignIn googleSignIn = GoogleSignIn();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppBarDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "E-Commerce App",
          style: TextStyle(
            color: AppConstraint.textPrimaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        backgroundColor: AppConstraint.primaryColor,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppConstraint.textPrimaryColor),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(() => const CartScreen());
            },
            icon: const Icon(Icons.shopping_cart),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            // Banner Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: BannerWidget(),
              ),
            ),

            // Categories Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Categories',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const CategoriesScreen());
                    },
                    child: const Text(
                      'See More >',
                      style: TextStyle(
                        color: AppConstraint.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const CategoriesWidget(),

            // Flash Sale Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Flash Sale',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const FlashSaleProductsScreen());
                    },
                    child: const Text(
                      'See More >',
                      style: TextStyle(
                        color: AppConstraint.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: const ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: FlashSaleWidget(),
              ),
            ),

            // All Products Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Products',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.to(() => const AllProductScreen());
                    },
                    child: const Text(
                      'See More >',
                      style: TextStyle(
                        color: AppConstraint.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            const AllproductsWidget(),
          ],
        ),
      ),
    );
  }
}
