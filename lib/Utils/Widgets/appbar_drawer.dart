import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/Screens/user_panel/all_order_screen.dart';
import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Screens/auth_ui/welcome_screen.dart';
import '../../Screens/user_panel/user_main_screen.dart';

class AppBarDrawer extends StatelessWidget {
  const AppBarDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    double screenWidth = MediaQuery.of(context).size.width;
    CollectionReference userData =
        FirebaseFirestore.instance.collection('users');

    return Padding(
      padding: EdgeInsets.only(top: Get.height / 25),
      child: Drawer(
        child: Column(
          children: [
            user != null
                ? FutureBuilder<DocumentSnapshot>(
                    future: userData.doc(user.uid).get(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      // Waiting state
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const UserAccountsDrawerHeader(
                          currentAccountPicture:
                              CircleAvatar(child: Icon(Icons.person)),
                          accountEmail:
                              Center(child: CircularProgressIndicator()),
                          accountName:
                              Center(child: CircularProgressIndicator()),
                        );
                      }

                      // Error state
                      else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      }
                      // Data available
                      else {
                        Map<String, dynamic> data =
                            snapshot.data!.data() as Map<String, dynamic>? ??
                                {};

                        // Handle case where data might be incomplete
                        String username = data['username'];
                        String email = data['email'];
                        return UserAccountsDrawerHeader(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppConstraint.primaryColor,
                                AppConstraint.secondaryColor
                              ],
                            ),
                          ),
                          accountName: Text(
                            username,
                            style: TextStyle(
                                fontSize:
                                    screenWidth * 0.05), // Scaled font size
                          ),
                          accountEmail: Text(
                            email,
                            style: TextStyle(
                                fontSize:
                                    screenWidth * 0.04), // Scaled font size
                          ),
                          currentAccountPicture: const CircleAvatar(
                            child: Icon(Icons.person),
                          ),
                        );
                      }
                    },
                  )
                : UserAccountsDrawerHeader(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppConstraint.primaryColor,
                          AppConstraint.secondaryColor
                        ],
                      ),
                    ),
                    accountName: Text(
                      '   \n  Guest',
                      style: TextStyle(
                          fontSize: screenWidth * 0.05), // Scaled font size
                    ),
                    accountEmail: Text(
                      '',
                      style: TextStyle(
                          fontSize: screenWidth * 0.04), // Scaled font size
                    ),
                    currentAccountPicture: const CircleAvatar(
                      child: Icon(Icons.person),
                    ),
                  ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const MainScreen(),
                    ));
              },
              child: const ListTile(
                leading: Icon(Icons.home),
                title: Text('Home'),
              ),
            ),
            const ListTile(
              leading: Icon(Icons.person),
              title: Text('User'),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.to(() => const AllOrderScreen());
                  },
                  child: const Text('Orders')),
            ),
            const ListTile(
              leading: Icon(Icons.production_quantity_limits),
              title: Text('Product'),
            ),
            const ListTile(
              leading: Icon(Icons.contact_support_rounded),
              title: Text('Contact Us'),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: user != null
                  ? GestureDetector(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        Get.to(() => WelcomeScreen());
                      },
                      child: const Text(
                        'Logout',
                        style: TextStyle(color: AppConstraint.primaryColor),
                      ),
                    )
                  : GestureDetector(
                      onTap: () => Get.to(() => WelcomeScreen()),
                      child: const Text(
                        'Sign In',
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> getUsername() async {
    await FirebaseFirestore.instance
        .collection('users') // Replace 'users' with your collection name
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }
}
