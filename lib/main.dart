import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_detail_screen.dart';
import './providers/products.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      // best to use create when potential for adding new
      // instanses of objects
      create: (ctx) => Products(),
      child: MaterialApp(
          title: 'Trés Chic Shop',
          theme: ThemeData(
              primarySwatch: Colors.purple,
              accentColor: Colors.pink[100],
              fontFamily: 'Lato'),
          home: ProductOverviewScreen(),
          routes: {
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          }),
    );
  }
}
