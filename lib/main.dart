import 'package:flutter/material.dart';

import './screens/products_overview_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trés Chic Shop',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ProductOverviewScreen(),
    );
  }
}

