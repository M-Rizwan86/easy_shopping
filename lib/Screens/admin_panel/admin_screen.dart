import 'package:ecommerce_app/Utils/app_constraint.dart';
import 'package:flutter/material.dart';

import '../../Utils/Widgets/appbar_drawer.dart';

class AdminScreen extends StatelessWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dash Board"),centerTitle: true,backgroundColor: AppConstraint.primaryColor,
      ),
      drawer: const AppBarDrawer(),
    );
  }
}
